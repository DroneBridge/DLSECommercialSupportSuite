"""Qt session state and process management for the serial batch flasher."""

from __future__ import annotations

import json
import os
import signal
import sys
import tempfile
from datetime import datetime
from pathlib import Path
from typing import Any
from uuid import uuid4

import serial.tools.list_ports
from PySide6.QtCore import QAbstractListModel, QModelIndex, QObject, Property, QProcess, QProcessEnvironment, QSettings, QSortFilterProxyModel, QTimer, Qt, QUrl, Signal, Slot
from PySide6.QtMultimedia import QSoundEffect

from dlse_cli_utils import resolve_resource_path, validate_activation_token
from ui.serial_worker import redact


class SerialResultModel(QAbstractListModel):
    """Incremental session rows exposed to a virtualized QML ListView."""

    def __init__(self, parent: QObject | None = None) -> None:
        """Create an empty model owned by ``parent``; return None."""
        super().__init__(parent)
        self.rows: list[dict[str, Any]] = []

    def roleNames(self) -> dict[int, bytes]:
        """Return the record role containing each row's safe display fields."""
        return {Qt.UserRole + 1: b'record'}

    def rowCount(self, parent: QModelIndex = QModelIndex()) -> int:
        """Return the number of session rows, or zero for child indexes."""
        return 0 if parent.isValid() else len(self.rows)

    def data(self, index: QModelIndex, role: int = Qt.DisplayRole) -> Any:
        """Return a copy of a display record, or None for invalid indexes/roles."""
        if index.isValid() and 0 <= index.row() < len(self.rows) and role == Qt.UserRole + 1:
            return dict(self.rows[index.row()])
        return None

    def append(self, port: str) -> int:
        """Insert a queued row for ``port`` and return its stable row number."""
        number = len(self.rows)
        self.beginInsertRows(QModelIndex(), number, number)
        self.rows.append({'port': port, 'chip': '', 'index': '', 'ip': '', 'activation_key': '', 'hostname': '', 'ap': '', 'stage': 'Queued', 'outcome': 'queued'})
        self.endInsertRows()
        return number

    def update(self, number: int, values: dict[str, Any]) -> None:
        """Update known display fields, including the requested activation key.

        Ignore unknown row indexes and fields; tokens and license payloads are
        never model fields. Return None without writing diagnostics.
        """
        if 0 <= number < len(self.rows):
            self.rows[number].update({key: value for key, value in values.items() if key in self.rows[number]})
            self.dataChanged.emit(self.index(number), self.index(number), [Qt.UserRole + 1])

    def clear(self) -> None:
        """Reset all rows at the beginning of a confirmed new session."""
        self.beginResetModel()
        self.rows.clear()
        self.endResetModel()


class SerialBoardFilterModel(QSortFilterProxyModel):
    """Split live session rows from completed outcomes without copying records."""

    def __init__(self, source: SerialResultModel, completed: bool, parent: QObject | None = None) -> None:
        """Filter ``source`` for live or completed rows; return None."""
        super().__init__(parent)
        self.completed = completed
        self.setSourceModel(source)
        self.setFilterRole(Qt.UserRole + 1)

    def filterAcceptsRow(self, source_row: int, source_parent: QModelIndex) -> bool:
        """Return whether the source row belongs to this outcome group."""
        record = self.sourceModel().data(self.sourceModel().index(source_row, 0, source_parent), Qt.UserRole + 1)
        return (record['outcome'] in {'success', 'failed', 'skipped'}) == self.completed


class SerialController(QObject):
    """Own serial detection, setup validation, one-board queue and safe stopping."""

    changed = Signal()
    stopped = Signal()

    def __init__(self, fleet: Any, parent: QObject | None = None) -> None:
        """Create idle state beside ``fleet``; no serial/network operation is started."""
        super().__init__(parent)
        self.fleet = fleet
        self.settings = QSettings('DroneBridge', 'DLSECommercialSupportSuite')
        self.result_model = SerialResultModel(self)
        self.connected_model = SerialBoardFilterModel(self.result_model, False, self)
        self.completed_model = SerialBoardFilterModel(self.result_model, True, self)
        self._sounds: dict[str, QSoundEffect] = {}
        self._state = 'setup'
        self._activity = 'Choose firmware and settings to prepare a batch.'
        self._history: list[str] = []
        self._releases: list[dict] = []
        self._review: dict = {}
        self._config: dict = {}
        self._secrets: list[str] = []
        self._process: QProcess | None = None
        self._response: dict | None = None
        self._error = ''
        self._buffer = b''
        self._action = ''
        self._armed = False
        self._stop_requested = False
        self._known: dict = {}
        self._queue: list[dict] = []
        self._current: dict | None = None
        self._failed: dict | None = None
        self._processed_keys: set[str] = set()
        self._session_dir: tempfile.TemporaryDirectory | None = None
        self._job_dir: tempfile.TemporaryDirectory | None = None
        self._stage = ''
        self._flash_started = False
        self._log_path = ''
        self.poll_timer = QTimer(self)
        self.poll_timer.setInterval(1000)
        self.poll_timer.timeout.connect(self.pollPorts)
        self.initialize_timer = QTimer(self)
        self.initialize_timer.setSingleShot(True)
        self.initialize_timer.setInterval(2000)
        self.initialize_timer.timeout.connect(self._start_device)
        self.deadline_timer = QTimer(self)
        self.deadline_timer.setSingleShot(True)
        self.deadline_timer.timeout.connect(self._deadline)

    @Property(str, notify=changed)
    def state(self) -> str:
        """Return setup, review, monitoring, paused, stopping or stopped state."""
        return self._state

    @Property(str, notify=changed)
    def activity(self) -> str:
        """Return the current human-readable operation or waiting message."""
        return self._activity

    @Property(bool, notify=changed)
    def busy(self) -> bool:
        """Return whether a process or port initialization is currently active."""
        return self._process is not None or self.initialize_timer.isActive()

    @Property(bool, notify=changed)
    def armed(self) -> bool:
        """Return whether the session owns its configuration and queue."""
        return self._armed

    @Property(bool, notify=changed)
    def locked(self) -> bool:
        """Return whether setup inputs must be disabled."""
        return self._armed or self.busy

    @Property('QVariantList', notify=changed)
    def history(self) -> list[str]:
        """Return the latest 200 sanitized timestamped activity lines."""
        return list(self._history)

    @Property(str, notify=changed)
    def logPath(self) -> str:
        """Return the session diagnostic log path, or empty before first activity."""
        return self._log_path

    @Property('QVariantList', notify=changed)
    def releases(self) -> list[dict]:
        """Return release-picker options without private worker metadata."""
        return [{key: value for key, value in option.items() if key != 'release'} for option in self._releases]

    @Property('QVariantMap', notify=changed)
    def review(self) -> dict:
        """Return the resolved release, preview assignments and schema warnings."""
        return dict(self._review)

    @Property('QVariantMap', notify=changed)
    def counts(self) -> dict[str, int]:
        """Return successful, failed, skipped and queued row counts."""
        return {name: sum(row['outcome'] == name for row in self.result_model.rows) for name in ('success', 'failed', 'skipped', 'queued')}

    @Property(bool, notify=changed)
    def skipRequiresConfirmation(self) -> bool:
        """Return whether skipping the failed board must reserve its index."""
        return bool(self._failed and self._failed.get('flash_started'))

    @Property(bool, notify=changed)
    def canRetry(self) -> bool:
        """Return whether a failed board is available for an explicit retry or skip."""
        return bool(self._failed and self._armed and not self.busy and self._state == 'paused')

    @Property('QVariantMap', notify=changed)
    def preferences(self) -> dict:
        """Read non-secret defaults, safely repairing malformed stored numbers."""
        def number(key: str, default: int) -> int:
            """Read a nonnegative stored integer, falling back on malformed values."""
            try:
                value = int(self.settings.value('serial/' + key, default))
                return value if value >= 0 else default
            except (TypeError, ValueError):
                return default
        mode = str(self.settings.value('serial/mode', 'activated'))
        return {'release': str(self.settings.value('serial/release', '')), 'settings': str(self.settings.value('serial/settings', '')), 'index': number('index', 0), 'baud': number('baud', 460800) or 460800, 'mode': mode if mode in {'activated', 'evaluation', 'offline'} else 'activated'}

    @staticmethod
    def _path(value: str) -> str:
        """Normalize a local path/file URL, rejecting non-file URLs with ValueError."""
        url = QUrl(value)
        if url.isLocalFile():
            return str(Path(url.toLocalFile()).resolve())
        if '://' in value:
            raise ValueError('Choose a local file or folder.')
        return str(Path(value).resolve()) if value.strip() else ''

    def _message(self, message: str) -> None:
        """Publish and append safe timestamped diagnostics; tolerate log I/O failures."""
        safe = redact(message, self._secrets + [os.environ.get('DRONEBRIDGE_SECRET_TOKEN', '')])
        self._activity = safe
        line = datetime.now().strftime('%H:%M:%S') + '  ' + safe
        self._history = (self._history + [line])[-200:]
        try:
            if not self._log_path:
                folder = Path('logs').resolve()
                folder.mkdir(parents=True, exist_ok=True)
                self._log_path = str(folder / f'dlse_serial_ui_{datetime.now():%Y%m%d_%H%M%S}_{uuid4().hex[:8]}.log')
            with Path(self._log_path).open('a', encoding='utf-8') as output:
                output.write(line + '\n')
        except OSError:
            self._log_path = ''
        self.changed.emit()

    @Slot(str)
    def refreshReleases(self, token: str) -> None:
        """List releases asynchronously using a session token; reject overlapping jobs."""
        if self.locked:
            return
        self.invalidateReview()
        token = token.strip() or os.environ.get('DRONEBRIDGE_SECRET_TOKEN', '')
        self._secrets.append(token)
        self._launch({'action': 'list', 'token': token})

    @Slot(str, str, str, str, str, str, str)
    def prepare(self, release: str, settings: str, index: str, baud: str, mode: str, token: str, option_id: str) -> None:
        """Validate inputs and prepare a review; allow tokenless permanent recovery.

        ``release``/``settings`` are local paths, ``option_id`` selects a cached
        or online release, and ``index``/``baud`` are numeric strings. Mode
        ``none`` skips license installation; online licensing and account
        downloads still require ``token``. Invalid inputs are reported in setup
        without starting device work; return None.
        """
        if self.locked:
            return
        self._review = {}
        self._state = 'setup'
        try:
            token = token.strip() or os.environ.get('DRONEBRIDGE_SECRET_TOKEN', '')
            self._secrets.append(token)
            if mode not in {'activated', 'evaluation', 'offline', 'none'}:
                raise ValueError('Choose a valid license mode.')
            if mode == 'evaluation' or (mode == 'activated' and token):
                token = validate_activation_token(token)
            if int(index) < 0 or not 0 < int(baud) <= 4_000_000:
                raise ValueError('Index must be nonnegative; baud must be between 1 and 4000000.')
            option = next((item for item in self._releases if item['id'] == option_id), None) if option_id else None
            if option_id and option is None:
                raise ValueError('Refresh releases and choose a current release.')
            if option and option['source'] == 'online':
                token = validate_activation_token(token)
            if not option and not release.strip():
                raise ValueError('Choose a firmware release folder or refresh and select a DLSE online release.')
            self._cleanup()
            self._session_dir = tempfile.TemporaryDirectory(prefix='dlse_serial_session_')
            self._config = {'release': self._path(release), 'settings': self._path(settings), 'index': int(index), 'baud': int(baud), 'mode': mode, 'token': token}
            self._launch({'action': 'prepare', **self._config, 'option': option, 'output_dir': self._session_dir.name})
        except (ValueError, OSError) as exc:
            self._message(str(exc))

    @Slot()
    def invalidateReview(self) -> None:
        """Clear a previous review when unlocked inputs change; return None."""
        if not self.locked and self._state == 'review':
            self._review = {}
            self._state = 'setup'
            self.changed.emit()

    @Slot()
    def arm(self) -> None:
        """Confirm reviewed inputs and snapshot existing ports; report enumeration failures."""
        if self._state != 'review' or self.busy:
            return
        if self.fleet.activeOperation:
            self._message('Wait for the active fleet operation to finish before starting serial monitoring.')
            return
        try:
            self._known = self._ports()
        except Exception:
            self._message('Could not enumerate serial ports. Check OS serial permissions.')
            return
        self.result_model.clear()
        self._queue.clear()
        self._processed_keys.clear()
        self._failed = None
        self._armed = True
        self._stop_requested = False
        self._state = 'monitoring'
        for key in ('release', 'settings', 'index', 'baud', 'mode'):
            self.settings.setValue('serial/' + key, self._config[key])
        self.poll_timer.start()
        self._message('Waiting for a new serial connection. Reconnect any already-connected board.')

    @staticmethod
    def _ports() -> dict:
        """Return port fingerprints without opening devices; OS errors propagate."""
        return {port.device: (port.serial_number, port.vid, port.pid, port.location) for port in serial.tools.list_ports.comports()}

    @Slot()
    def pollPorts(self) -> None:
        """Queue new connections, drop stale entries and start work if not paused."""
        if not self._armed or self._stop_requested:
            return
        try:
            current = self._ports()
        except Exception:
            self._state = 'paused'
            self._message('Serial port enumeration failed. Stop and check OS permissions before restarting.')
            return
        for entry in list(self._queue):
            if current.get(entry['port']) != entry['fingerprint']:
                self._queue.remove(entry)
                self.result_model.update(entry['row'], {'outcome': 'skipped', 'stage': 'Disconnected before processing'})
        for port in sorted(current):
            if port not in self._known or current[port] != self._known[port]:
                self._queue.append({'port': port, 'fingerprint': current[port], 'row': self.result_model.append(port)})
        self._known = current
        self._advance()
        self.changed.emit()

    def _advance(self) -> None:
        """Initialize the next queued board unless paused, stopping or already active."""
        if self.busy or self._current or self._state != 'monitoring':
            return
        if not self._queue:
            if 'Waiting for a new serial connection' not in self._activity:
                self._message(f"Waiting for a new serial connection · next index {self._config['index']}.")
            return
        self._current = self._queue.pop(0)
        self._current['index'] = self._config['index']
        self.result_model.update(self._current['row'], {'index': self._config['index'], 'outcome': 'active', 'stage': 'Initializing'})
        self.initialize_timer.start()
        self._message(f"{self._current['port']} · index {self._config['index']}: Initializing serial connection (two seconds)")

    def _start_device(self) -> None:
        """Recheck port presence and run one board after initialization; skip stale ports."""
        if not self._current or not self._armed or self._stop_requested:
            return
        try:
            present = self._ports().get(self._current['port']) == self._current['fingerprint']
        except Exception:
            present = False
        if not present:
            self.result_model.update(self._current['row'], {'outcome': 'skipped', 'stage': 'Disconnected before processing'})
            self._current = None
            self._advance()
            return
        self._flash_started = False
        self._launch({'action': 'device', **self._config, 'port': self._current['port'], 'processed_keys': list(self._processed_keys)})

    @Slot()
    def retry(self) -> None:
        """Retry the paused board at its retained index; revalidate its connection."""
        if not self._failed or self.busy or self._stop_requested:
            return
        entry = self._failed
        try:
            ports = self._ports()
            if entry['port'] not in ports:
                raise ValueError('Reconnect the failed board to the same port before retrying.')
            entry['fingerprint'] = ports[entry['port']]
        except Exception:
            self._message('Reconnect the failed board to the same port before retrying.')
            return
        # Carry the activation key to prevent retrying a different board on a reused port.
        self._config['retry_key'] = entry.get('activation_key', '')
        self._queue = [queued for queued in self._queue if queued['port'] != entry['port'] or self._cancel_row(queued)]
        self._failed = None
        self._current = entry
        self._state = 'monitoring'
        self.result_model.update(entry['row'], {'outcome': 'active', 'stage': 'Initializing retry'})
        self.initialize_timer.start()
        self._message(f"{entry['port']} · index {entry['index']}: Initializing explicit retry")

    def _cancel_row(self, entry: dict) -> bool:
        """Mark a removed queue entry skipped; return False for filtering."""
        self.result_model.update(entry['row'], {'outcome': 'skipped', 'stage': 'Replaced by explicit retry'})
        return False

    @Slot(bool)
    def skip(self, confirmed: bool = False) -> None:
        """Skip a paused board; require ``confirmed`` to reserve a possibly written index."""
        if not self._failed or self.busy or (self.skipRequiresConfirmation and not confirmed):
            return
        if self.skipRequiresConfirmation:
            self._increment_index()
        self.result_model.update(self._failed['row'], {'outcome': 'skipped', 'stage': 'Skipped by operator'})
        self._failed = None
        self._config.pop('retry_key', None)
        self._state = 'monitoring'
        self._message('Failed board skipped. Monitoring resumed.')
        self._advance()

    @Slot()
    def stop(self) -> None:
        """Stop arrivals and queued work, allowing the current device process to finish."""
        self._stop_requested = True
        self.poll_timer.stop()
        for entry in self._queue:
            self.result_model.update(entry['row'], {'outcome': 'skipped', 'stage': 'Cancelled while queued'})
        self._queue.clear()
        if self.initialize_timer.isActive():
            self.initialize_timer.stop()
            if self._current:
                self.result_model.update(self._current['row'], {'outcome': 'skipped', 'stage': 'Cancelled before processing'})
            self._current = None
        if self._process:
            self._state = 'stopping'
            self._message('Stopping: the active board/job is finishing; queued boards will not be processed.')
        else:
            self._end_session()

    def _increment_index(self) -> None:
        """Advance and persist the next index after success or confirmed reservation."""
        self._config['index'] += 1
        self.settings.setValue('serial/index', self._config['index'])

    def _launch(self, request: dict) -> None:
        """Start one isolated JSON worker; secrets travel only through stdin."""
        try:
            self._job_dir = tempfile.TemporaryDirectory(prefix='dlse_serial_job_')
        except OSError:
            self._message('Could not create the serial worker temporary directory.')
            if self._current:
                self._failed = self._current
                self._state = 'paused'
                self.result_model.update(self._current['row'], {'outcome': 'failed', 'stage': 'Could not start worker'})
                self._current = None
            return
        request = {**request, 'work_dir': self._job_dir.name}
        process = QProcess(self)
        self._process = process
        self._action = request['action']
        self._response = None
        self._error = ''
        self._buffer = b''
        self._stage = ''
        self._flash_started = False
        if request['action'] != 'device':
            self._stop_requested = False
        environment = QProcessEnvironment.systemEnvironment()
        environment.insert('PYTHONUNBUFFERED', '1')
        environment.insert('PYTHONUTF8', '1')
        # Source checkouts and installed packages work independently of operational cwd.
        source_root = str(Path(__file__).resolve().parents[1])
        environment.insert('PYTHONPATH', source_root + os.pathsep + environment.value('PYTHONPATH', ''))
        process.setProcessEnvironment(environment)
        executable = Path(sys.executable)
        if executable.name.lower() == 'pythonw.exe' and executable.with_name('python.exe').is_file():
            executable = executable.with_name('python.exe')
        process.started.connect(lambda: (process.write((json.dumps(request) + '\n').encode('utf-8')), process.closeWriteChannel()))
        process.readyReadStandardOutput.connect(self._read_events)
        process.readyReadStandardError.connect(lambda: process.readAllStandardError())
        process.finished.connect(self._finished)
        process.errorOccurred.connect(self._process_error)
        self.deadline_timer.start(120_000)
        self._message('Starting isolated serial worker…')
        process.start(str(executable), ['-m', 'ui.serial_worker'])

    def _read_events(self) -> None:
        """Decode bounded worker lines and publish stage/log/result updates.

        Device activation keys are retained for the requested results display
        and registered for log redaction. Invalid protocol terminates the worker
        with a diagnostic; return None.
        """
        if not self._process:
            return
        self._buffer += bytes(self._process.readAllStandardOutput())
        if len(self._buffer) > 1_048_576:
            self._error = 'Serial worker returned an oversized protocol message.'
            self._kill_process_tree()
            return
        while b'\n' in self._buffer:
            line, self._buffer = self._buffer.split(b'\n', 1)
            try:
                event = json.loads(line)
                kind = event['event']
                if kind == 'stage':
                    self._stage = event['stage']
                    self._flash_started |= self._stage == 'flash'
                    self.deadline_timer.start(int(event['timeout']) * 1000)
                    if self._current:
                        self.result_model.update(self._current['row'], {'stage': event['message']})
                    self._message(event['message'])
                elif kind == 'secret':
                    self._secrets.append(event['value'])
                    if self._current:
                        self._current['activation_key'] = event['value']
                        self.result_model.update(self._current['row'], {'activation_key': event['value']})
                elif kind == 'details' and self._current:
                    self.result_model.update(self._current['row'], {key: value for key, value in event.items() if key != 'event'})
                elif kind == 'log':
                    # Diagnostics go to history without replacing the current named stage.
                    activity = self._activity
                    self._message(event['message'])
                    self._activity = activity
                    self.changed.emit()
                elif kind == 'result':
                    self._response = event['payload']
                elif kind == 'error':
                    self._error = event['message']
                else:
                    raise ValueError('Unexpected worker event.')
            except (ValueError, KeyError, TypeError):
                self._error = 'Invalid serial worker protocol.'
                self._kill_process_tree()
                return

    def _process_error(self, error: QProcess.ProcessError) -> None:
        """Complete failed startup; crashes are handled by the normal finished signal."""
        if error == QProcess.FailedToStart:
            self._error = 'Could not start the serial worker. Check the Python installation.'
            self._finished(1, QProcess.NormalExit)

    def _finished(self, code: int, status: QProcess.ExitStatus) -> None:
        """Consume worker exit/result, update outcomes, play a cue and advance or pause.

        ``code`` and ``status`` identify failed workers. Device failures stay
        paused for operator action; sound failures never affect flashing. Return None.
        """
        if not self._process:
            return
        self._read_events()
        process = self._process
        self._process = None
        process.deleteLater()
        self.deadline_timer.stop()
        if self._job_dir:
            try:
                self._job_dir.cleanup()
                self._job_dir = None
            except OSError:
                self._message('Temporary worker files could not be removed; check filesystem permissions.')
        response = self._response
        error = self._error or (f'Worker exited unexpectedly during {self._stage or "startup"}.' if code or status != QProcess.NormalExit or response is None else '')
        if self._action == 'device' and self._current:
            result = response if response is not None and not error else {'outcome': 'failed', 'message': error, 'flash_started': self._flash_started}
            result['message'] = redact(result.get('message', 'Device operation finished.'), self._secrets)
            row = self._current['row']
            self.result_model.update(row, result)
            self._current.update(result)
            self._play_result_sound(result['outcome'])
            if result['outcome'] == 'success':
                self._processed_keys.add(result['activation_key'])
                self._increment_index()
                self._config.pop('retry_key', None)
            elif result['outcome'] == 'failed':
                self._failed = self._current
                self._state = 'paused'
            self._message(f"{self._current['port']} · index {self._current['index']}: {result.get('message', result['outcome'])}" + (' Session paused; retry or skip this board.' if result['outcome'] == 'failed' else ''))
            self._current = None
        elif error:
            self._state = 'setup'
            self._message(error)
        elif self._action == 'list':
            self._releases = response['options']
            self._message('Release list ready: ' + response['status'])
        elif self._action == 'prepare':
            self._config.update({'release': response['release'], 'template': response['template']})
            self._review = {**response, 'settings': self._config['settings'] or 'Release defaults', 'mode': self._config['mode'], 'baud': self._config['baud'], 'index': self._config['index']}
            self._state = 'review'
            self._message('Review ready. Confirm the release, assignments and warnings before monitoring.')
        if self._stop_requested:
            self._end_session()
        else:
            self._advance()
            self.changed.emit()

    def _play_result_sound(self, outcome: str) -> None:
        """Play the original success/failure WAV asynchronously for ``outcome``.

        Skipped boards are silent. Missing resources or unavailable audio are
        best effort and never change the board's result; return None.
        """
        filenames = {'success': 'new-notification-011-364050.wav', 'failed': 'system-notification-04-206493.wav'}
        if outcome not in filenames:
            return
        try:
            if outcome not in self._sounds:
                path = resolve_resource_path(Path('resources') / filenames[outcome])
                if path is None:
                    return
                sound = QSoundEffect(self)
                sound.setSource(QUrl.fromLocalFile(str(path)))
                sound.setVolume(0.7)
                self._sounds[outcome] = sound
            self._sounds[outcome].play()
        except Exception:
            pass

    def _deadline(self) -> None:
        """Fail a hung stage and terminate owned descendants without automatic retries."""
        self._error = f'Deadline exceeded during {self._stage or "startup"}.'
        if self._flash_started:
            self._error += ' Board may be partially programmed.'
        self._message(self._error)
        self._kill_process_tree()

    def _kill_process_tree(self) -> None:
        """Kill this worker's POSIX process group or Windows job-owned descendants."""
        if not self._process:
            return
        if os.name != 'nt':
            try:
                pid = self._process.processId()
                if os.getpgid(pid) == pid:
                    os.killpg(pid, signal.SIGKILL)
            except (OSError, ProcessLookupError):
                pass
        self._process.kill()  # Windows job closes with its owner and kills descendants.

    def _end_session(self) -> None:
        """Return to an unarmed stopped state and release temporary configuration."""
        self._armed = False
        self._state = 'stopped'
        self._failed = None
        self._review = {}
        self._config.pop('token', None)
        self._cleanup()
        self._message('Stopped. No serial ports are being monitored.')
        self.stopped.emit()

    def _cleanup(self) -> None:
        """Remove the controller-owned template directory after work finishes."""
        if self._session_dir:
            self._session_dir.cleanup()
            self._session_dir = None
