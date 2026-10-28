"""Mocked serial pipeline, session state, process and QML regression coverage."""

import base64
import ctypes
import json
import os
import struct
import sys
import tempfile
import time
import unittest
from contextlib import ExitStack
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import Mock, patch

os.environ.setdefault('QT_QPA_PLATFORM', 'offscreen')
os.environ.setdefault('QTWEBENGINE_DISABLE_SANDBOX', '1')

from PySide6.QtCore import QMetaObject, QProcess, QSettings, Qt
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickItem
from PySide6.QtTest import QTest

from ui import serial_backend as backend
from ui.app import create_engine
from ui.serial_controller import SerialController
from ui.serial_worker import redact


CSV = 'key,type,encoding,value\nsettings,namespace,,\nip_sta,data,string,192.168.1.99\nip_sta_netmsk,data,string,255.255.255.0\nwifi_hostname,data,string,Drone99\nssid_ap,data,string,AP99\n'
KEY = base64.b64encode(struct.pack('<6sBH', b'\x01\x02\x03\x04\x05\x06', 5, 1)).decode()


def make_release(root: Path) -> Path:
    """Create small deterministic fake releases in ``root``; return its path."""
    root.mkdir(parents=True, exist_ok=True)
    (root / 'db_show_params.csv').write_text(CSV, encoding='utf-8')
    for name in ('esp32c3_generic', 'esp32c5_generic', 'esp32c6_generic'):
        folder = root / name
        folder.mkdir()
        (folder / 'flash_args.txt').write_text('0x0 bootloader.bin 0x8000 partition-table.bin 0x20000 db_esp32.bin 0x300000 www.bin')
        for file in ('bootloader.bin', 'partition-table.bin', 'db_esp32.bin', 'www.bin'):
            (folder / file).write_bytes(b'fixture')
    return root


class TestSerialBackend(unittest.TestCase):
    """Validate preparation and all destructive-operation boundaries without hardware."""

    def setUp(self):
        """Create fake firmware, settings and licenses with a mocked logger."""
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.release = make_release(self.root / 'release')
        self.template = self.root / 'template.csv'
        self.template.write_text(CSV)
        self.license = self.root / 'test.dlselic'
        self.license.write_bytes(b'fake-license')
        self.binary = self.root / 'settings.bin'
        self.binary.write_bytes(bytes(0x6000))
        self.config = {'release': str(self.release), 'template': str(self.template), 'port': 'COM42', 'baud': 460800, 'index': 18, 'mode': 'activated', 'token': 'test-token'}
        self.events = []
        self.stack = ExitStack()
        self.addCleanup(self.stack.close)
        self.stack.enter_context(patch.object(backend.db, 'DBLogger', return_value=Mock()))
        self.stack.enter_context(patch.object(backend.db, 'DLSE_LICENSE_FOLDER', str(self.root / 'cache')))
        self.chip = self.stack.enter_context(patch.object(backend.db, 'db_get_esp32_chip_id', return_value=5))
        self.key = self.stack.enter_context(patch.object(backend.db, 'db_get_activation_key', return_value=KEY))
        self.server = self.stack.enter_context(patch.object(backend.db, 'db_is_dlse_lic_server_available', return_value=True))
        self.request = self.stack.enter_context(patch.object(backend.db, 'db_api_request_license_file', return_value=str(self.license)))
        self.cache = self.stack.enter_context(patch.object(backend.db, 'db_get_dlse_lic_from_local_storage', return_value=None))
        self.recover = self.stack.enter_context(patch.object(backend.db, 'db_get_dlse_lic_via_serial', return_value=str(self.license)))
        self.validate = self.stack.enter_context(patch.object(backend.db, 'db_dlse_validate_license', return_value=(True, {'license_type': 2})))
        self.generate = self.stack.enter_context(patch.object(backend.db, 'db_parameters_generate_binary', return_value=str(self.binary)))
        self.flash = self.stack.enter_context(patch.object(backend.db, 'db_flash_binaries', return_value=True))

    def run_device(self):
        """Run the mocked device pipeline in the fixture directory; return its result."""
        return backend.process_device(self.config, self.root, self.events.append)

    def test_success_stages_assignments_and_backup(self):
        """Success includes real indexed settings, matching validation and permanent backup."""
        result = self.run_device()
        self.assertEqual('success', result['outcome'])
        self.assertEqual(('192.168.1.18', 'Drone18', 'AP18'), (result['ip'], result['hostname'], result['ap']))
        self.assertEqual(['identify', 'activation_key', 'license', 'license', 'validate_license', 'settings', 'embed', 'nvs', 'map', 'recheck', 'flash', 'complete'], [event['stage'] for event in self.events if event['event'] == 'stage'])
        self.validate.assert_called_once_with(str(self.license), match_activation_key=KEY)
        self.assertTrue((self.root / 'cache' / (KEY.replace('/', '_') + '.dlselic')).exists())
        self.assertEqual(CSV, self.template.read_text())

    def test_offline_mode_never_contacts_server_and_recovers(self):
        """Offline recovery without a token only uses cache or serial backup."""
        self.config.update(mode='offline', token='')
        self.assertEqual('success', self.run_device()['outcome'])
        self.server.assert_not_called()
        self.request.assert_not_called()
        self.recover.assert_called_once_with('COM42', 460800)

    def test_offline_cached_license_skips_serial_recovery(self):
        """A valid matching cached permanent license is reused before reading the board."""
        self.config['mode'] = 'offline'
        self.cache.return_value = str(self.license)
        self.assertEqual('success', self.run_device()['outcome'])
        self.recover.assert_not_called()

    def test_server_unavailable_activated_uses_recovery(self):
        """Permanent activation recovers automatically without a token when offline."""
        self.config['token'] = ''
        self.server.return_value = False
        self.assertEqual('success', self.run_device()['outcome'])
        self.request.assert_not_called()
        self.recover.assert_called_once()

    def test_online_activation_without_token_stops_before_flashing(self):
        """Tokenless preparation never permits anonymous online activation or flashing."""
        self.config['token'] = ''
        self.assertEqual('failed', self.run_device()['outcome'])
        self.request.assert_not_called()
        self.recover.assert_not_called()
        self.flash.assert_not_called()

    def test_without_licensing_skips_license_helpers_and_strips_template_payload(self):
        """No-license mode generates NVS without a license or any licensing operation."""
        original = CSV + 'license,namespace,,\ndb_lic_key,data,base64,ZmFrZS1saWNlbnNl\n'
        self.template.write_text(original)
        self.config.update(mode='none', token='')
        with patch.object(backend.db, 'db_embed_license_in_settings_csv') as embed:
            result = self.run_device()
        self.assertEqual('success', result['outcome'])
        self.assertIn('without a license', result['message'])
        for helper in (self.server, self.request, self.cache, self.recover, self.validate, embed):
            helper.assert_not_called()
        generated_csv = Path(self.generate.call_args.args[0])
        rows = backend.read_settings(generated_csv)
        self.assertFalse(any(row['key'] in {'license', 'db_lic_key'} for row in rows))
        self.assertEqual('192.168.1.18', result['ip'])
        self.assertEqual(KEY, result['activation_key'])
        self.assertEqual(original, self.template.read_text())
        self.assertFalse((self.root / 'cache').exists())
        self.flash.assert_called_once()

    def test_supported_chip_ids_have_display_names(self):
        """Each supported numeric chip ID resolves to the ESP32-Cx display name."""
        for chip in backend.db.DLSESupportedChips:
            with self.subTest(chip=chip):
                self.chip.return_value = chip.value
                self.key.return_value = base64.b64encode(struct.pack('<6sBH', b'\x01\x02\x03\x04\x05\x06', chip.value, 1)).decode()
                result = self.run_device()
                self.assertEqual('success', result['outcome'])
                self.assertEqual(chip.name.replace('ESP32', 'ESP32-'), result['chip'])

    def test_online_license_failure_does_not_fall_back(self):
        """A reachable server rejecting a request does not silently switch license policy."""
        self.request.return_value = None
        self.assertEqual('failed', self.run_device()['outcome'])
        self.recover.assert_not_called()
        self.flash.assert_not_called()

    def test_evaluation_validity_and_no_permanent_cache(self):
        """Evaluation requests 60 days and never publishes licenses to permanent cache."""
        self.config['mode'] = 'evaluation'
        self.validate.return_value = (True, {'license_type': 1, 'valid_till': time.time() + 60})
        self.assertEqual('success', self.run_device()['outcome'])
        self.assertEqual(60, self.request.call_args.kwargs['_validity_days'])
        self.assertFalse((self.root / 'cache').exists())

    def test_evaluation_offline_expired_and_wrong_type_are_rejected(self):
        """Evaluation rejects offline, expired and permanent-license responses before flashing."""
        self.config['mode'] = 'evaluation'
        self.server.return_value = False
        self.assertEqual('failed', self.run_device()['outcome'])
        self.recover.assert_not_called()
        self.server.return_value = True
        for info in ({'license_type': 1, 'valid_till': 1}, {'license_type': 2}):
            self.validate.return_value = (True, info)
            self.assertEqual('failed', self.run_device()['outcome'])
        self.flash.assert_not_called()

    def test_invalid_validation_tuple_is_not_truthy_success(self):
        """The validator's false tuple must stop flashing, despite tuple truthiness."""
        self.validate.return_value = (False, {'license_type': 2})
        self.assertEqual('failed', self.run_device()['outcome'])
        self.flash.assert_not_called()

    def test_chip_key_duplicate_and_identity_failures(self):
        """Unsupported, duplicate, malformed and replaced boards never reach flashing."""
        self.chip.return_value = 99
        self.assertEqual('skipped', self.run_device()['outcome'])
        self.chip.return_value = None
        self.assertEqual('failed', self.run_device()['outcome'])
        self.chip.return_value = 5
        self.key.return_value = 'malformed'
        self.assertEqual('failed', self.run_device()['outcome'])
        self.key.return_value = KEY
        self.config['processed_keys'] = [KEY]
        self.assertEqual('skipped', self.run_device()['outcome'])
        self.config['processed_keys'] = []
        self.config['retry_key'] = 'different-key'
        self.assertEqual('failed', self.run_device()['outcome'])
        self.config.pop('retry_key')
        self.chip.side_effect = [5, 23]
        self.assertEqual('failed', self.run_device()['outcome'])
        self.flash.assert_not_called()

    def test_settings_nvs_and_false_flash_results(self):
        """Preparation failures prevent writing; a false flash result remains a failure."""
        self.generate.return_value = None
        result = self.run_device()
        self.assertEqual('failed', result['outcome'])
        self.assertFalse(result['flash_started'])
        self.flash.assert_not_called()
        self.generate.return_value = str(self.binary)
        self.flash.return_value = False
        result = self.run_device()
        self.assertEqual('failed', result['outcome'])
        self.assertTrue(result['flash_started'])

    def test_csv_schema_validation(self):
        """Reject empty CSVs, malformed rows, duplicate keys, missing namespaces and bad values."""
        for value in ('', 'key,value\na,b\n', 'key,type,encoding,value\nx,data,string,value\n', CSV + 'ssid_ap,data,string,duplicate\n', CSV + 'bad,data,u8,999\n', CSV + 'bad,data,u8,abc\n', CSV + 'bad,data,unknown,value\n', CSV + 'bad,data,string,value,extra\n'):
            with self.subTest(csv=value):
                self.template.write_text(value)
                with self.assertRaises(ValueError):
                    backend.read_settings(self.template)

    def test_quoted_password_survives_legacy_license_embedding(self):
        """Comma/hash/quote characters in a password survive every CSV preparation step."""
        self.template.write_text(CSV + 'wifi_pass,data,string,"abc,#xyz""123"\n', encoding='utf-8')
        self.assertEqual('success', self.run_device()['outcome'])
        values = {row['key']: row['value'] for row in backend.read_settings(self.root / 'device.csv')}
        self.assertEqual('abc,#xyz"123', values['wifi_pass'])

    def test_missing_binary_empty_flash_map_and_overlaps(self):
        """Validate actual referenced files and refuse empty or overlapping flash layouts."""
        backend.validate_release(self.release)
        args = self.release / 'esp32c3_generic' / 'flash_args.txt'
        original = args.read_text()
        for content in ('', original + ' 0x25000 missing.bin', original.replace('0x20000', '0x9000')):
            args.write_text(content)
            with self.assertRaises(ValueError):
                backend.validate_release(self.release)

    def test_preview_handles_blank_ip_and_rejects_exhaustion(self):
        """Preview uses existing assignment semantics without modifying the template."""
        assignment = backend.assign_settings(self.template, 18, self.root / 'preview.csv')
        self.assertEqual('Drone18', assignment['hostname'])
        self.assertEqual(CSV, self.template.read_text())
        for index in (-1, 0, 255, 256):
            with self.assertRaises(ValueError):
                backend.assign_settings(self.template, index, self.root / 'preview.csv')
        self.template.write_text(CSV.replace('192.168.1.99', ''))
        self.assertEqual('', backend.assign_settings(self.template, 256, self.root / 'preview.csv')['ip'])

    def test_schema_warnings_and_original_files_preserved(self):
        """A merge reports defaults/obsolete keys and preserves both input files."""
        source = self.root / 'user.csv'
        contents = CSV.replace('ssid_ap,data,string,AP99\n', 'obsolete,data,string,value\n')
        source.write_text(contents)
        with patch('tempfile.tempdir', self.temp.name):
            merged, warnings = backend.prepare_settings({'release': str(self.release), 'settings': str(source)}, self.root)
        self.assertTrue(merged.is_file())
        self.assertEqual(2, len(warnings))
        self.assertEqual(contents, source.read_text())
        self.assertEqual(CSV, (self.release / 'db_show_params.csv').read_text())


class TestSerialController(unittest.TestCase):
    """Verify queue state and QML navigation with isolated settings and fake ports."""

    @classmethod
    def setUpClass(cls):
        """Create the shared offscreen GUI application without contacting hardware."""
        cls.app = QGuiApplication.instance() or QGuiApplication([])

    def setUp(self):
        """Construct a controller using temporary settings and an inert fleet."""
        sounds = patch('ui.serial_controller.QSoundEffect')
        self.sound_factory = sounds.start()
        self.addCleanup(sounds.stop)
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.settings = QSettings(str(Path(self.temp.name) / 'settings.ini'), QSettings.IniFormat)
        with patch('ui.serial_controller.QSettings', return_value=self.settings):
            self.controller = SerialController(SimpleNamespace(activeOperation=''))
        self.controller._log_path = str(Path(self.temp.name) / 'serial.log')
        self.controller._config = {'index': 18, 'baud': 460800, 'mode': 'offline', 'release': 'release', 'settings': '', 'template': 'template'}
        self.controller._state = 'review'
        self.ports = {}
        self.controller._ports = lambda: dict(self.ports)
        self.jobs = []
        self.controller._launch = self.jobs.append
        self.addCleanup(self.controller.poll_timer.stop)
        self.addCleanup(self.controller.initialize_timer.stop)

    def test_initial_index_default_and_saved_value(self):
        """A fresh setup starts at one; an explicitly saved next index survives."""
        self.assertEqual(1, self.controller.preferences['index'])
        self.settings.setValue('serial/index', 0)
        self.assertEqual(0, self.controller.preferences['index'])
        self.settings.setValue('serial/index', 19)
        self.assertEqual(19, self.controller.preferences['index'])

    def test_initial_ports_excluded_new_arrivals_sorted_and_stale_removed(self):
        """Only arrivals after arming enter the sequential queue; stale ports are skipped."""
        self.ports = {'COM1': ('old',)}
        self.controller.arm()
        self.controller.pollPorts()
        self.assertEqual([], self.controller.result_model.rows)
        self.ports.update({'COM3': ('3',), 'COM2': ('2',)})
        self.controller.pollPorts()
        self.assertEqual('COM2', self.controller._current['port'])
        self.assertEqual('COM3', self.controller._queue[0]['port'])
        self.assertTrue(self.controller.busy)
        self.assertIn('Initializing', self.controller.activity)
        self.ports.pop('COM3')
        self.controller.pollPorts()
        self.assertEqual([], self.controller._queue)
        self.controller.initialize_timer.stop()
        self.controller._start_device()
        self.assertEqual('COM2', self.jobs[0]['port'])

    def test_same_port_reconnect_and_stale_initialization(self):
        """Disconnected initial ports become new arrivals on reconnect, then recheck presence."""
        self.ports = {'COM1': ('one',)}
        self.controller.arm()
        self.ports = {}
        self.controller.pollPorts()
        self.ports = {'COM1': ('one',)}
        self.controller.pollPorts()
        self.ports = {}
        self.controller.initialize_timer.stop()
        self.controller._start_device()
        self.assertEqual([], self.jobs)
        self.assertEqual(1, self.controller.counts['skipped'])

    def test_stop_drops_queue_and_initialization(self):
        """Stopping before device work discards arrivals and releases the session."""
        self.controller.arm()
        self.ports = {'COM1': ('1',), 'COM2': ('2',)}
        self.controller.pollPorts()
        self.controller.stop()
        self.assertFalse(self.controller.armed)
        self.assertFalse(self.controller.busy)
        self.assertEqual('stopped', self.controller.state)
        self.assertEqual(2, self.controller.counts['skipped'])
        self.assertEqual([], self.jobs)

    def finish_device(self, result):
        """Feed a simulated finished child result into the actual completion handler."""
        self.controller.initialize_timer.stop()
        self.controller._process = Mock()
        self.controller._read_events = Mock()
        self.controller._action = 'device'
        self.controller._response = result
        self.controller._finished(0, QProcess.NormalExit)

    def test_success_advances_and_persists_index(self):
        """A verified flash increments the next index and registers its activation key."""
        self.controller.arm()
        self.ports = {'COM1': ('one',)}
        self.controller.pollPorts()
        self.finish_device({'outcome': 'success', 'activation_key': KEY, 'message': 'Done', 'index': 18})
        self.assertEqual(19, self.controller.preferences['index'])
        self.assertIn(KEY, self.controller._processed_keys)
        self.assertEqual(1, self.controller.counts['success'])

    def test_board_tables_follow_outcomes_and_retry_without_duplicate_rows(self):
        """Separate live/results models track failure, retry and success on one row."""
        live = self.controller.connected_model
        completed = self.controller.completed_model
        self.controller.arm()
        self.ports = {'COM1': ('one',), 'COM2': ('two',)}
        self.controller.pollPorts()
        self.assertEqual((2, 0), (live.rowCount(), completed.rowCount()))
        self.finish_device({'outcome': 'failed', 'flash_started': False, 'message': 'Read failed', 'index': 18})
        self.assertEqual((1, 1), (live.rowCount(), completed.rowCount()))
        self.assertEqual(18, completed.data(completed.index(0, 0), Qt.UserRole + 1)['index'])
        self.controller.retry()
        self.assertEqual((2, 0), (live.rowCount(), completed.rowCount()))
        self.finish_device({'outcome': 'success', 'activation_key': KEY, 'message': 'Done', 'index': 18})
        self.assertEqual((1, 1), (live.rowCount(), completed.rowCount()))
        self.controller.stop()
        self.assertEqual((0, 2), (live.rowCount(), completed.rowCount()))
        self.assertEqual(['success', 'skipped'], [completed.data(completed.index(i, 0), Qt.UserRole + 1)['outcome'] for i in range(2)])
        self.controller.result_model.clear()
        self.assertEqual((0, 0), (live.rowCount(), completed.rowCount()))

    def test_permanent_recovery_preparation_allows_missing_token(self):
        """Local permanent recovery can reach validation without online credentials."""
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            self.controller.prepare('release', '', '18', '460800', 'activated', '', '')
        self.assertEqual('prepare', self.jobs[0]['action'])
        self.assertEqual('activated', self.jobs[0]['mode'])
        self.assertEqual('', self.jobs[0]['token'])
        self.controller._cleanup()

    def test_online_release_preparation_still_requires_token(self):
        """Removing the offline mode selector must not allow anonymous downloads."""
        self.controller._releases = [{'id': 'account-release', 'source': 'online'}]
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            self.controller.prepare('', '', '18', '460800', 'activated', '', 'account-release')
        self.assertEqual([], self.jobs)
        self.assertIn('token', self.controller.activity)

    def test_without_licensing_preparation_needs_no_token(self):
        """No-license mode passes through preflight without requiring activation credentials."""
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            self.controller.prepare('release', '', '0', '460800', 'none', '', '')
        self.assertEqual('none', self.jobs[0]['mode'])
        self.assertEqual(0, self.jobs[0]['index'])
        self.controller._cleanup()

    def test_original_notification_sounds_are_nonblocking_and_skips_are_silent(self):
        """Success/failure use the original WAVs via cached async Qt sound effects."""
        success, failed = Mock(), Mock()
        self.sound_factory.side_effect = [success, failed]
        for outcome in ('success', 'success', 'failed', 'skipped'):
            self.controller._play_result_sound(outcome)
        self.assertEqual(2, self.sound_factory.call_count)
        self.assertTrue(success.setSource.call_args.args[0].toLocalFile().endswith('new-notification-011-364050.wav'))
        self.assertTrue(failed.setSource.call_args.args[0].toLocalFile().endswith('system-notification-04-206493.wav'))
        self.assertEqual(2, success.play.call_count)
        failed.play.assert_called_once()

    def test_result_key_is_visible_but_secrets_stay_out_of_history(self):
        """Results expose the requested device key, while diagnostics still redact it."""
        self.controller.arm()
        self.ports = {'COM1': ('one',)}
        self.controller.pollPorts()
        self.controller._secrets.append(KEY)
        self.finish_device({'outcome': 'success', 'activation_key': KEY, 'ip': '192.168.1.18', 'chip': 'ESP32-C3', 'message': 'Done ' + KEY, 'index': 18})
        row = self.controller.completed_model.data(self.controller.completed_model.index(0, 0), Qt.UserRole + 1)
        self.assertEqual(KEY, row['activation_key'])
        self.assertEqual('192.168.1.18', row['ip'])
        self.assertEqual('ESP32-C3', row['chip'])
        self.assertNotIn(KEY, '\n'.join(self.controller.history))
        self.assertNotIn(KEY, Path(self.controller.logPath).read_text())
        self.controller.result_model.update(0, {'token': 'private', 'license_payload': 'private'})
        self.assertNotIn('token', self.controller.result_model.rows[0])
        self.assertNotIn('license_payload', self.controller.result_model.rows[0])

    def test_failure_pause_retry_and_confirmed_reservation(self):
        """Failures retain the index; only an explicitly confirmed partial-write skip reserves it."""
        self.controller.arm()
        self.ports = {'COM1': ('one',)}
        self.controller.pollPorts()
        self.finish_device({'outcome': 'failed', 'flash_started': True, 'activation_key': KEY, 'message': 'Failed', 'index': 18})
        self.assertEqual('paused', self.controller.state)
        self.assertEqual(18, self.controller._config['index'])
        self.controller.skip(False)
        self.assertEqual('paused', self.controller.state)
        self.controller.retry()
        self.assertEqual(KEY, self.controller._config['retry_key'])
        self.assertEqual(18, self.controller._current['index'])
        self.finish_device({'outcome': 'failed', 'flash_started': True, 'activation_key': KEY, 'message': 'Failed', 'index': 18})
        self.controller.skip(True)
        self.assertEqual(19, self.controller._config['index'])
        self.assertEqual('monitoring', self.controller.state)

    def test_stop_finishes_active_board(self):
        """Stop does not kill a running board and waits for its completed result."""
        self.controller.arm()
        self.ports = {'COM1': ('one',)}
        self.controller.pollPorts()
        self.controller.initialize_timer.stop()
        self.controller._process = Mock()
        self.controller.stop()
        self.assertEqual('stopping', self.controller.state)
        self.assertIn('finishing', self.controller.activity)
        self.controller._process.kill.assert_not_called()
        self.finish_device({'outcome': 'success', 'activation_key': KEY, 'message': 'Done', 'index': 18})
        self.assertEqual('stopped', self.controller.state)
        self.assertEqual(19, self.controller.preferences['index'])

    def test_offline_input_and_secret_redaction(self):
        """Offline preparation needs no token, and diagnostics/persistence never expose tokens."""
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            self.controller.prepare('release', '', '18', '460800', 'offline', '', '')
        self.assertEqual('prepare', self.jobs[0]['action'])
        self.controller._cleanup()
        self.controller._secrets = ['private-token', KEY]
        self.controller._message('Error: private-token ' + KEY)
        self.assertNotIn('private-token', self.controller.activity)
        self.assertNotIn(KEY, Path(self.controller.logPath).read_text())
        self.assertFalse(any('token' in key for key in self.settings.allKeys()))
        self.assertNotIn('payload', redact('Response: secret payload', []))

    def test_active_fleet_operation_blocks_arming(self):
        """Arming fails while an existing destructive fleet operation is active."""
        self.controller.fleet.activeOperation = 'ota'
        self.controller.arm()
        self.assertFalse(self.controller.armed)
        self.assertIn('fleet operation', self.controller.activity)

    def test_deadline_reports_partial_flash_and_kills_owned_process(self):
        """A timed-out flash remains a failure and requests child-tree termination."""
        self.controller._process = Mock()
        self.controller._stage = 'flash'
        self.controller._flash_started = True
        self.controller._kill_process_tree = Mock()
        self.controller._deadline()
        self.assertIn('partially programmed', self.controller._error)
        self.controller._kill_process_tree.assert_called_once()

    def test_protocol_updates_activity_details_and_rejects_malformed_input(self):
        """Stage events drive live state while logs retain the named stage activity."""
        row = self.controller.result_model.append('COM1')
        self.controller._current = {'row': row, 'port': 'COM1', 'index': 18}
        self.controller._process = Mock()
        events = [{'event': 'stage', 'stage': 'flash', 'message': 'Flashing COM1', 'timeout': 600}, {'event': 'log', 'message': 'Starting write'}, {'event': 'details', 'chip': 'ESP32C3'}, {'event': 'secret', 'value': KEY}]
        self.controller._process.readAllStandardOutput.return_value = ('\n'.join(json.dumps(event) for event in events) + '\n').encode()
        self.controller._read_events()
        self.assertEqual('Flashing COM1', self.controller.activity)
        self.assertTrue(self.controller._flash_started)
        self.assertEqual('ESP32C3', self.controller.result_model.rows[row]['chip'])
        self.controller._process.readAllStandardOutput.return_value = b'not json\n'
        self.controller._kill_process_tree = Mock()
        self.controller._read_events()
        self.assertIn('protocol', self.controller._error)
        self.controller._kill_process_tree.assert_called_once()
        self.controller.deadline_timer.stop()

    def wait_process(self, serial, seconds=20):
        """Pump GUI events until the real worker ends; fail after a bounded timeout."""
        deadline = time.monotonic() + seconds
        while serial.busy and time.monotonic() < deadline:
            self.app.processEvents()
            time.sleep(0.01)
        if serial.busy:
            serial._kill_process_tree()
            self.fail('Serial worker did not finish within test deadline.')

    def test_serial_layout_defaults_status_and_baud_selection(self):
        """Render both window sizes and verify live status, layout and submitted UI values."""
        self.settings.setValue('serial/baud', 123456)
        self.settings.setValue('serial/mode', 'evaluation')
        with patch('ui.controller.QSettings', return_value=self.settings), patch('ui.serial_controller.QSettings', return_value=self.settings), patch('ui.controller.QTimer.singleShot'):
            engine, fleet = create_engine()
        for timer in (fleet.license_timer, fleet.scan_timer, fleet.stats_timer, fleet.unifi_timer):
            timer.stop()
        root = engine.rootObjects()[0]
        self.addCleanup(root.close)
        self.addCleanup(engine.deleteLater)
        QTest.qWait(50)
        card = root.findChild(QQuickItem, 'serialFlasherButton')
        direct = root.findChild(QQuickItem, 'directStandaloneButton')
        monitoring = root.findChild(QQuickItem, 'monitoringModeButton')
        self.assertAlmostEqual(direct.width() + monitoring.width() + 16, card.width())
        self.assertAlmostEqual(monitoring.height() / 2, card.height())
        QMetaObject.invokeMethod(root.findChild(object, 'startScreen'), 'serialFlasherRequested', Qt.DirectConnection)
        QTest.qWait(50)
        serial = engine.serial_controller
        self.assertEqual(1, root.findChild(object, 'serialReleaseSource').property('currentIndex'))
        serial._releases = [{'id': 'fixture', 'source': 'cached', 'label': '[cached] releases/2026-09-24_long_release_name'}]
        serial.changed.emit()
        release_picker = root.findChild(QQuickItem, 'serialReleasePicker')
        popup = root.findChild(object, 'serialReleasePopup')
        popup.open()
        QTest.qWait(50)
        self.assertGreater(popup.property('width'), release_picker.width())
        self.assertEqual(640, popup.property('width'))
        popup.close()
        baud = root.findChild(object, 'serialBaudSelector')
        self.assertEqual(5, baud.property('count'))
        self.assertEqual('460800', baud.property('currentText'))
        index_picker = root.findChild(object, 'serialIndexField')
        self.assertEqual(0, index_picker.property('from'))
        self.assertEqual(1, index_picker.property('value'))
        self.assertTrue(index_picker.property('editable'))
        license_toggle = root.findChild(object, 'serialLicenseToggle')
        self.assertTrue(license_toggle.property('checked'))
        self.assertIsNone(root.findChild(object, 'serialState'))
        self.assertIsNone(root.findChild(object, 'serialLicenseMode'))
        self.assertEqual('Check and Validate Configuration', root.findChild(object, 'serialPrepareButton').property('text'))
        release_source = root.findChild(object, 'serialReleaseSource')
        release_source.setProperty('currentIndex', 0)
        self.app.processEvents()
        self.assertTrue(root.findChild(QQuickItem, 'serialReleaseField').isVisible())
        release_source.setProperty('currentIndex', 1)
        settings_source = root.findChild(object, 'serialSettingsSource')
        settings_source.setProperty('currentIndex', 1)
        self.app.processEvents()
        self.assertTrue(root.findChild(QQuickItem, 'serialSettingsField').isVisible())
        settings_source.setProperty('currentIndex', 0)
        QMetaObject.invokeMethod(root.findChild(object, 'serialLicenseDetailsButton'), 'clicked', Qt.DirectConnection)
        self.app.processEvents()
        self.assertTrue(root.findChild(object, 'serialLicenseDetailsDialog').property('opened'))
        root.findChild(object, 'serialLicenseDetailsDialog').close()
        for status in ('online', 'offline', 'checking'):
            fleet._license_status = status
            fleet.stateChanged.emit()
            self.app.processEvents()
            self.assertIn('Checking' if status == 'checking' else status.title(), root.findChild(object, 'serialLicenseStatus').property('text'))
        for width, height in ((1298, 804), (1180, 720)):
            root.setWidth(width)
            root.setHeight(height)
            QTest.qWait(50)
            self.assertLessEqual(popup.property('width') + release_picker.mapToScene(release_picker.boundingRect().topLeft()).x(), width)
            connected = root.findChild(QQuickItem, 'serialConnectedPanel')
            completed = root.findChild(QQuickItem, 'serialCompletedPanel')
            history = root.findChild(QQuickItem, 'serialHistoryPanel')
            self.assertGreaterEqual(history.height(), 120)
            self.assertGreaterEqual(completed.height(), 120)
            self.assertAlmostEqual(history.height(), completed.height(), delta=1)
            self.assertGreaterEqual(completed.height(), connected.height())
            self.assertLessEqual(history.y() + history.height(), history.parentItem().height() + 1)
            self.assertGreater(root.findChild(QQuickItem, 'serialSettingsPanel').width(), 500)
        root.setWidth(1298)
        root.setHeight(804)
        QTest.qWait(50)
        initial_results_height, initial_history_height = completed.height(), history.height()
        root.setHeight(1004)
        QTest.qWait(50)
        self.assertAlmostEqual(completed.height() - initial_results_height, 100, delta=1)
        self.assertAlmostEqual(history.height() - initial_history_height, 100, delta=1)
        root.setHeight(720)
        serial._state = 'paused'
        serial.changed.emit()
        QTest.qWait(50)
        self.assertGreaterEqual(completed.height(), 120)
        self.assertGreaterEqual(history.height(), 120)
        self.assertLessEqual(history.y() + history.height(), history.parentItem().height() + 1)
        serial._state = 'setup'
        serial.changed.emit()
        # UI always submits permanent activation, including with old evaluation preferences.
        serial._releases = [{'id': 'cached-release', 'source': 'cached', 'label': 'Fixture release'}]
        serial.changed.emit()
        baud.setProperty('currentIndex', 0)
        submitted = []
        serial._launch = submitted.append
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            QMetaObject.invokeMethod(root.findChild(object, 'serialFlasherScreen'), 'prepareReview', Qt.DirectConnection)
        self.assertEqual('activated', submitted[0]['mode'])
        self.assertEqual(115200, submitted[0]['baud'])
        license_toggle.setProperty('checked', False)
        self.app.processEvents()
        self.assertTrue(root.findChild(QQuickItem, 'serialNoLicenseWarning').isVisible())
        arm_dialog = root.findChild(object, 'serialArmDialog')
        arm_dialog.open()
        self.app.processEvents()
        self.assertTrue(root.findChild(QQuickItem, 'serialArmNoLicenseWarning').isVisible())
        arm_dialog.close()
        index_picker.setProperty('value', 0)
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            QMetaObject.invokeMethod(root.findChild(object, 'serialFlasherScreen'), 'prepareReview', Qt.DirectConnection)
        self.assertEqual('none', submitted[1]['mode'])
        self.assertEqual(0, submitted[1]['index'])
        serial._cleanup()

    def test_real_worker_preflight_protocol_and_qml_navigation(self):
        """Run only file preparation in a real worker and verify the guided QML page."""
        release = make_release(Path(self.temp.name) / 'release')
        with patch('ui.controller.QSettings', return_value=self.settings), patch('ui.serial_controller.QSettings', return_value=self.settings), patch('ui.controller.QTimer.singleShot'):
            engine, fleet = create_engine()
        serial = engine.serial_controller
        serial._log_path = str(Path(self.temp.name) / 'worker.log')
        for timer in (fleet.license_timer, fleet.scan_timer, fleet.stats_timer, fleet.unifi_timer):
            timer.stop()
        self.assertTrue(engine.rootObjects())
        root = engine.rootObjects()[0]
        start = root.findChild(object, 'startScreen')
        self.assertTrue(QMetaObject.invokeMethod(start, 'serialFlasherRequested', Qt.DirectConnection))
        self.app.processEvents()
        self.assertTrue(root.findChild(object, 'serialFlasherScreen').property('visible'))
        self.assertIsNotNone(root.findChild(object, 'serialActivity'))
        self.assertIsNotNone(root.findChild(object, 'serialResults'))
        with patch.dict(os.environ, {'DRONEBRIDGE_SECRET_TOKEN': ''}):
            serial.prepare(str(release), '', '18', '460800', 'offline', '', '')
        self.wait_process(serial)
        self.assertEqual('review', serial.state, serial.activity)
        self.assertEqual('192.168.1.18', serial.review['previews'][0]['ip'])
        self.assertIn('Merging settings', '\n'.join(serial.history))
        self.assertEqual(CSV, (release / 'db_show_params.csv').read_text())
        self.assertTrue(Path(serial.review['template']).is_file())
        QTest.qWait(100)
        setup_scroll = root.findChild(QQuickItem, 'serialSetupScroll')
        self.assertGreater(setup_scroll.property('contentItem').property('contentY'), 0)
        self.assertTrue(QMetaObject.invokeMethod(root.findChild(object, 'serialFlasherScreen'), 'backRequested', Qt.DirectConnection))
        self.app.processEvents()
        self.assertFalse(root.findChild(object, 'serialFlasherScreen').property('visible'))
        self.assertEqual('stopped', serial.state)
        root.close()
        engine.deleteLater()
        self.app.processEvents()

    def test_deadline_reaps_real_descendants_and_temporary_files(self):
        """A real hung helper and its child are both reaped, with parent-owned file cleanup."""
        serial = self.controller
        serial._armed = True
        serial._state = 'monitoring'
        row = serial.result_model.append('TEST')
        serial._current = {'port': 'TEST', 'row': row, 'index': 18}
        serial._action = 'device'
        serial._job_dir = tempfile.TemporaryDirectory(dir=self.temp.name)
        job_path = Path(serial._job_dir.name)
        (job_path / 'sensitive.csv').write_text('private worker artifact')
        pid_path = Path(self.temp.name) / 'child.pid'
        script = (
            'import json,subprocess,sys,time; from pathlib import Path; '
            'from ui.serial_worker import contain_process; handle=contain_process(); '
            'child=subprocess.Popen([sys.executable,"-c","import time; time.sleep(60)"]); '
            'Path(sys.argv[1]).write_text(str(child.pid)); '
            'print(json.dumps({"event":"stage","stage":"flash","message":"Test helper waiting","timeout":1}),flush=True); '
            'time.sleep(60)'
        )
        process = QProcess(serial)
        serial._process = process
        process.readyReadStandardOutput.connect(serial._read_events)
        process.finished.connect(serial._finished)
        process.start(sys.executable, ['-c', script, str(pid_path)])
        self.wait_process(serial)
        self.assertTrue(pid_path.exists())
        child_pid = int(pid_path.read_text())
        if os.name == 'nt':
            from ctypes import wintypes
            kernel = ctypes.WinDLL('kernel32', use_last_error=True)
            kernel.OpenProcess.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
            kernel.OpenProcess.restype = wintypes.HANDLE
            kernel.GetExitCodeProcess.argtypes = [wintypes.HANDLE, ctypes.POINTER(wintypes.DWORD)]
            kernel.CloseHandle.argtypes = [wintypes.HANDLE]
            handle = kernel.OpenProcess(0x1000, False, child_pid)
            if handle:
                code = wintypes.DWORD()
                self.assertTrue(kernel.GetExitCodeProcess(handle, ctypes.byref(code)))
                kernel.CloseHandle(handle)
                self.assertNotEqual(259, code.value, 'Timed-out worker child is still active.')
        else:
            with self.assertRaises(ProcessLookupError):
                os.kill(child_pid, 0)
        self.assertFalse(job_path.exists())
        self.assertEqual('paused', serial.state)
        self.assertTrue(serial.skipRequiresConfirmation)

    def test_qml_confirmation_back_and_close_wait_for_active_worker(self):
        """Navigation and window close require Stop and leave, then wait for completion."""
        with patch('ui.controller.QSettings', return_value=self.settings), patch('ui.serial_controller.QSettings', return_value=self.settings), patch('ui.controller.QTimer.singleShot'):
            engine, fleet = create_engine()
        for timer in (fleet.license_timer, fleet.scan_timer, fleet.stats_timer, fleet.unifi_timer):
            timer.stop()
        root = engine.rootObjects()[0]
        serial = engine.serial_controller
        serial._log_path = str(Path(self.temp.name) / 'navigation.log')
        serial._config = dict(self.controller._config)
        serial._armed = True
        serial._state = 'monitoring'
        row = serial.result_model.append('TEST')
        serial._current = {'port': 'TEST', 'row': row, 'index': 18}
        serial._process = Mock()
        serial._action = 'device'
        serial._read_events = Mock()
        serial.changed.emit()
        QMetaObject.invokeMethod(root.findChild(object, 'startScreen'), 'serialFlasherRequested', Qt.DirectConnection)
        self.app.processEvents()
        self.assertFalse(root.findChild(object, 'serialPrepareButton').property('enabled'))
        self.assertTrue(root.findChild(object, 'serialBusyIndicator').property('running'))
        QMetaObject.invokeMethod(root.findChild(object, 'serialBackButton'), 'clicked', Qt.DirectConnection)
        self.app.processEvents()
        self.assertTrue(root.findChild(object, 'leaveSerialDialog').property('opened'))
        root.findChild(object, 'leaveSerialDialog').close()
        root.close()
        self.app.processEvents()
        self.assertTrue(root.property('visible'))
        self.assertTrue(root.findChild(object, 'leaveSerialDialog').property('opened'))
        QMetaObject.invokeMethod(root.findChild(object, 'serialStopAndLeaveButton'), 'clicked', Qt.DirectConnection)
        self.assertEqual('stopping', serial.state)
        self.assertTrue(root.property('visible'))
        serial._response = {'outcome': 'success', 'message': 'Done', 'index': 18, 'activation_key': KEY}
        serial._finished(0, QProcess.NormalExit)
        self.app.processEvents()
        self.assertFalse(root.property('visible'))
        self.assertEqual('stopped', serial.state)
        engine.deleteLater()
        self.app.processEvents()


if __name__ == '__main__':
    unittest.main()
