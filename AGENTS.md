# AGENTS.md

Guidance for coding agents working in this repository.

## Repository Overview

This repository contains the DroneBridge DLSE Commercial Support Suite. It is a Python 3.10+ toolkit for managing DroneBridge DLSE ESP32 devices through serial flashing, HTTP APIs, OTA updates, license handling, NVS partition generation, and MAVLink-based discovery.

Important areas:

- `DroneBridgeCommercialSupportSuite.py`: main importable support library.
- `batch_install_dlse_allinone.py`: serial batch flashing, configuration, and activation workflow.
- `batch_ota_update_allinone.py`: OTA firmware update workflow.
- `batch_ota_license_activation.py`: OTA license activation workflow.
- `example_esp32_*.py`: focused examples for library functions.
- `test/`: tests and CSV fixtures for the main suite.
- `nvs_partition_tool/`: local NVS helper implementation and tests.
- `api_definition/openapi_definition.yaml`: Wi-Fi API definition.
- `resources/`: bundled keys and audio resources.
- `received_licenses/`, `logs/`, release folders, and `my_parameters/`: local operational data. Treat these as environment/user data unless a task explicitly targets them.

## Environment

- Python requirement: `>=3.10`.
- Install the project from the repository root with:

```bash
python -m pip install -e .
```

- Runtime dependencies are declared in `pyproject.toml`: `requests`, `esptool`, `tqdm`, `cryptography`, `mavsdk`, and `pymavlink`.
- Some scripts also use serial tooling such as `serial.tools.list_ports`; verify the local environment before changing serial workflows.

## Verification

Prefer the narrowest meaningful test command for the code touched.

Common checks from the repository root:

```bash
python -m unittest discover -s test -p "Test*.py"
```

For NVS partition tool changes:

```bash
python -m pytest nvs_partition_tool
```

When a change touches hardware, serial flashing, OTA, licensing, or network discovery, unit tests alone are not enough. Add or update tests around parsing, validation, error handling, and command construction where possible, and clearly document any manual hardware validation that could not be run.

## Coding Standards

- Follow the existing Python style and keep changes scoped to the requested behavior.
- Every new or modified function must have a docstring that explains purpose, important arguments, return value, and relevant failure behavior.
- Keep public helper functions typed where practical. Preserve existing names and call patterns unless the task explicitly includes an API cleanup.
- Prefer `pathlib.Path` for new filesystem logic unless the surrounding code strongly uses `os.path`.
- Keep user-facing scripts readable and operationally explicit. Avoid hiding risky hardware operations behind surprising abstractions.
- Do not commit generated logs, local license files, firmware binaries, IDE metadata, virtual environments, or local parameter exports unless explicitly requested.

## How to communicate with the ESP32

The ESP32 has a HTTP API that is documented in `api_definition/openapi_definition.yaml`.
The ESP32 has a MAVLink interface that can receive commands and send telemetry. It is accessible through UDP (default port 14550) or TCP (default port 5760). Port numbers must be configurable since the user can change them on the ESP32. The ESP32 accepts broadcast UDP and unicast UCP messages.

## Documentation Focus

Put specific focus on documentation quality for all implementation work:

- Update `README.md`, examples, inline comments, or this file when behavior, commands, assumptions, or operational risks change.
- Explain prerequisites for scripts that need ESP32 devices, serial ports, Wi-Fi access points, DroneBridge credentials, firmware release folders, or Skybrush Live to be stopped.
- Document default values, retry counts, timeouts, expected file layouts, and fallback behavior.
- Keep example commands syntactically correct and copy-pasteable.
- When changing API-facing code, keep `api_definition/openapi_definition.yaml` in sync if the behavior it describes changes.

## Robustness Requirements

Implementations should be hardened for real field use. In particular:

- Use bounded retries with backoff for transient network, serial, OTA, and file-transfer operations.
- Always set timeouts for HTTP, socket, subprocess, and serial operations where the underlying API supports it.
- Validate paths, release folder contents, CSV schema, chip IDs, activation keys, license files, and response payloads before acting on them.
- Handle edge cases explicitly: missing files, empty CSVs, malformed rows, unsupported chips, unavailable license server, interrupted uploads, partial downloads, duplicate devices, stale serial ports, and user cancellation.
- Avoid destructive operations unless the code has first confirmed the exact target and failure consequences are acceptable.
- Log enough context through `DBLogger` or the surrounding script logger to debug failures without exposing full secrets or tokens.
- Mask sensitive values in logs. Do not print full license tokens, private keys, activation secrets, or license payloads unless explicitly required for a test fixture.
- Prefer returning structured status or `None`/`False` consistently over raising broad exceptions from user-facing batch workflows, unless the existing API contract expects exceptions.

## Hardware and Network Safety

- Do not run flashing, OTA update, license activation, subnet scanning, or serial-port monitoring scripts without explicit user intent.
- Treat ESP32 firmware release directories as external artifacts. Do not edit binary release contents unless the task specifically targets them.
- For batch workflows, preserve safety checks that prevent license loss, wrong-chip flashing, or updating devices outside the selected target version.
- Keep prompts and confirmation steps for operations that affect multiple devices.

## Git and Local Data

- The worktree may contain user changes. Inspect status before editing and do not revert unrelated changes.
- Preserve existing local operational directories and files such as `logs/`, `received_licenses/`, firmware release folders, and `my_parameters/`.
- If adding fixtures, keep them small, deterministic, and free of real secrets.

