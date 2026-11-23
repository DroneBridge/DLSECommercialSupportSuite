"""Private JSON-lines process entry point for serial UI jobs (not a CLI flasher)."""

from __future__ import annotations

import ctypes
import json
import os
import sys
import tempfile
from dataclasses import asdict
from pathlib import Path
from urllib.parse import quote

from ui import serial_backend as backend


def redact(message: str, secrets: list[str]) -> str:
    """Return bounded diagnostics with secrets and server response bodies removed."""
    if 'response:' in message.lower():
        return 'License server response body omitted.'
    for secret in secrets:
        if secret:
            message = message.replace(secret, '[redacted]').replace(quote(secret, safe=''), '[redacted]')
    return message[:2000]


def contain_process() -> object | None:
    """Contain worker descendants for deadline cleanup; raise if Windows setup fails.

    Returns the Windows job handle, held until process exit, or None on POSIX.
    POSIX workers become session leaders so the controller can kill their group.
    """
    if os.name != 'nt':
        os.setsid()
        return None
    from ctypes import wintypes

    class BasicLimits(ctypes.Structure):
        """Windows JOB_OBJECT_BASIC_LIMIT_INFORMATION layout."""
        _fields_ = [('process_time', ctypes.c_int64), ('job_time', ctypes.c_int64), ('flags', wintypes.DWORD), ('min_working', ctypes.c_size_t), ('max_working', ctypes.c_size_t), ('active', wintypes.DWORD), ('affinity', ctypes.c_size_t), ('priority', wintypes.DWORD), ('scheduling', wintypes.DWORD)]

    class IoCounters(ctypes.Structure):
        """Windows IO_COUNTERS layout."""
        _fields_ = [(name, ctypes.c_uint64) for name in ('read_ops', 'write_ops', 'other_ops', 'read_bytes', 'write_bytes', 'other_bytes')]

    class ExtendedLimits(ctypes.Structure):
        """Windows JOB_OBJECT_EXTENDED_LIMIT_INFORMATION layout."""
        _fields_ = [('basic', BasicLimits), ('io', IoCounters), ('process_memory', ctypes.c_size_t), ('job_memory', ctypes.c_size_t), ('peak_process', ctypes.c_size_t), ('peak_job', ctypes.c_size_t)]

    kernel = ctypes.WinDLL('kernel32', use_last_error=True)
    kernel.CreateJobObjectW.argtypes = [ctypes.c_void_p, wintypes.LPCWSTR]
    kernel.CreateJobObjectW.restype = wintypes.HANDLE
    kernel.SetInformationJobObject.argtypes = [wintypes.HANDLE, ctypes.c_int, ctypes.c_void_p, wintypes.DWORD]
    kernel.SetInformationJobObject.restype = wintypes.BOOL
    kernel.GetCurrentProcess.restype = wintypes.HANDLE
    kernel.AssignProcessToJobObject.argtypes = [wintypes.HANDLE, wintypes.HANDLE]
    kernel.AssignProcessToJobObject.restype = wintypes.BOOL
    kernel.CloseHandle.argtypes = [wintypes.HANDLE]
    job = kernel.CreateJobObjectW(None, None)
    limits = ExtendedLimits()
    limits.basic.flags = 0x2000  # JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
    if not job or not kernel.SetInformationJobObject(job, 9, ctypes.byref(limits), ctypes.sizeof(limits)) or not kernel.AssignProcessToJobObject(job, kernel.GetCurrentProcess()):
        error = ctypes.get_last_error()
        if job:
            kernel.CloseHandle(job)
        raise OSError(error, 'Could not contain serial worker processes.')
    return job


def run_job(request: dict, work: Path, emit) -> dict:
    """Execute a list, preparation or device request; return its structured result.

    Requests are internal UI configuration. Errors propagate to main, which
    emits a sanitized failure. Hardware is contacted only for device requests.
    """
    action = request['action']
    if action in {'list', 'prepare'}:
        from ui.workers import OtaReleaseListWorker, OtaReleaseResolveWorker
        captured, errors = [], []
        if action == 'list':
            emit({'event': 'stage', 'stage': 'releases', 'message': 'Loading cached and account releases', 'timeout': 180})
            worker = OtaReleaseListWorker(request.get('token', ''))
        elif request.get('option'):
            option = dict(request['option'])
            if 'release' in option:
                option['release'] = backend.db.DBDLSERelease(**option['release'])
            emit({'event': 'stage', 'stage': 'download', 'message': 'Downloading firmware release' if option['source'] == 'online' else 'Resolving cached release', 'timeout': 900})
            worker = OtaReleaseResolveWorker(option, request.get('token', ''))
        else:
            worker = None
        if worker:
            worker.signals.finished.connect(captured.append)
            worker.signals.error.connect(errors.append)
            worker.run()
            if errors or not captured:
                raise ValueError(errors[0] if errors else 'Release worker returned no result.')
            if action == 'list':
                payload = captured[0]
                for option in payload['options']:
                    if 'release' in option:
                        option['release'] = asdict(option['release'])
                return payload
            request['release'] = captured[0]['release_path']
    if action == 'prepare':
        emit({'event': 'stage', 'stage': 'validate', 'message': 'Validating release binaries and settings CSV', 'timeout': 60})
        template, warnings = backend.prepare_settings(request, work, emit)
        previews = []
        for index in range(int(request['index']), int(request['index']) + 3):
            try:
                previews.append(backend.assign_settings(template, index, work / f'preview_{index}.csv'))
            except ValueError as exc:
                if not previews:
                    raise
                warnings.append(f'Index {index}: {exc}')
                break
        # Only the validated template is retained in the controller's session directory.
        import shutil
        output = Path(request['output_dir']) / 'template.csv'
        shutil.copyfile(template, output)
        return {'release': str(Path(request['release']).resolve()), 'template': str(output), 'previews': previews, 'warnings': warnings}
    if action == 'device':
        return backend.process_device(request, work, emit)
    if action != 'list':
        raise ValueError('Unknown serial worker request.')
    raise ValueError('Release listing failed.')


def main() -> int:
    """Read one stdin request and emit safe JSON events; return zero or failure.

    Library and subprocess stdout/stderr are discarded to prevent unstructured
    secrets from escaping. Library diagnostics use a worker-local logger sink.
    """
    protocol = os.fdopen(os.dup(sys.stdout.fileno()), 'w', encoding='utf-8', buffering=1)
    with open(os.devnull, 'w') as sink:
        os.dup2(sink.fileno(), 1)
        os.dup2(sink.fileno(), 2)
    secrets: list[str] = []

    def emit(event: dict) -> None:
        """Write one protocol event, registering secrets before diagnostics; return None."""
        if event.get('event') == 'secret':
            secrets.append(event['value'])
        for field in ('message', 'status'):
            if field in event:
                event[field] = redact(str(event[field]), secrets)
        if event.get('event') == 'result' and isinstance(event.get('payload'), dict):
            payload = event['payload']
            if 'message' in payload:
                payload['message'] = redact(str(payload['message']), secrets)
        protocol.write(json.dumps(event, ensure_ascii=True) + '\n')
        protocol.flush()

    try:
        request = json.loads(sys.stdin.buffer.readline(1_048_576))
        secrets.extend([request.get('token', ''), os.environ.get('DRONEBRIDGE_SECRET_TOKEN', '')])
        _job_handle = contain_process()
        with tempfile.TemporaryDirectory(prefix='dlse_serial_', dir=request['work_dir']) as directory:
            # Scope legacy helpers' fixed filenames to this child process only.
            tempfile.tempdir = directory
            logger = backend.db.DBLogger()
            logger.log = lambda message, *args: emit({'event': 'log', 'message': redact(str(message), secrets)})
            result = run_job(request, Path(directory), emit)
            emit({'event': 'result', 'payload': result})
        return 0
    except Exception as exc:
        emit({'event': 'error', 'message': str(exc)})
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
