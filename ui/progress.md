# Fleet Manager QML Progress

Last updated: 2026-10-13

## QML Foundation

- [x] Replace the QWidget/QMainWindow shell with `QGuiApplication` and `QQmlApplicationEngine`.
- [x] Keep `python -m ui` as the public application entry point.
- [x] Use `App.qml` to navigate between `Start.qml` and `MainScreen.qml`.
- [x] Initialize Qt WebEngine Quick and lazily instantiate the device browser.
- [x] Remove Python-created widgets, dialogs, stylesheets, and delegates.
- [x] Package all QML, exported assets, design tokens, icons, and fonts.

## Figma Design

- [x] Refactor the exported fixed layouts into responsive desktop QML.
- [x] Preserve the exported colors, spacing, typography, assets, and dense fleet layout.
- [x] Align main-screen primary, secondary, muted, status, and control text colors with the updated reference.
- [x] Reserve link blue for genuine hyperlinks instead of operational buttons and IP values.
- [x] Add hover, pressed, disabled, focus, keyboard, validation, and busy states.
- [x] Keep Direct Standalone active; show Skybrush and Network Manager as future features and expose UniFi AP observations in Fleet Manager.
- [x] Use QML-owned operational dialogs and Qt Quick file/folder pickers.

## Fleet Inventory

- [x] Expose named QML roles for complete device, REST, selection, and operation state.
- [x] Preserve activation-key, MAC, then IP identity precedence.
- [x] Support incremental MAVLink and HTTP discovery with bounded concurrency.
- [x] Prevent overlapping scans and persist scan methods, ranges, ports, timeouts, and refresh rate.
- [x] Run MAVLink and HTTP discovery concurrently and merge results into the retained fleet.
- [x] Poll retained device statistics with a two-second target and bounded, non-overlapping rounds.
- [x] Mark devices offline after the configured consecutive stats-failure threshold.
- [x] Configure, disable, and independently monitor background stats polling.
- [x] Show separate discovery and stats polling states in the footer.
- [x] Apply a reboot grace period before offline failure counting resumes.
- [x] Support 5,000-device inventory, table filtering, and matrix projection.

## Fleet Views

- [x] Implement virtualized QML table and matrix views.
- [x] Search all cached fields and sort projected table columns.
- [x] Persist visible columns with the required default data columns, including AP-measured RSSI.
- [x] Expose UniFi AP Wi-Fi standard, RX/TX rates, sampled live throughput, and optional signal-balance values as configurable columns.
- [x] Expose UniFi AP channel and band with radio-first, ambiguity-safe band detection.
- [x] Allow visible fleet-table columns to be rearranged and persisted.
- [x] Allow visible fleet-table columns to be manually resized and persisted.
- [x] Share identity-based selection across list and matrix views.
- [x] Display complete activation keys without masking.
- [x] Implement the collapsible Settings, Web Interface, and Metrics inspector.
- [x] Allow the right-side configuration inspector to be manually resized and persisted.
- [x] Generate typed, dirty-aware settings editors from REST values and metadata.

## Operations

- [x] Poll license-server availability every 30 seconds without overlapping checks.
- [x] Read `DRONEBRIDGE_SECRET_TOKEN` without persistence.
- [x] Preserve sequential activation and duplicate-key protection.
- [x] Support bounded REST reboot and explicitly confirmed MAVLink broadcast reboot.
- [x] Validate and apply dirty settings with reboot warnings and structured results.
- [x] Import and export NVS-compatible configuration CSV files.
- [x] Default multi-device exclusions to static IP, subnet, gateway, hostname, and manual system ID.
- [x] Allow operators to change every exclusion before applying a template.
- [x] Support local release folders and explicit binaries for bounded parallel OTA.
- [x] Preserve chip validation, WWW upload, two-second wait, application upload, and reboot.
- [x] Stop queued OTA updates on cancellation while active uploads finish.
- [x] Offer retry-failed behavior for retryable operations.
- [x] Support account release listing and download before Fleet Manager OTA uploads.

## Serial Batch Flasher

- [x] Add start-page entry and a dedicated guided QML page with native file/folder pickers.
- [x] Support local, cached and account release sources using existing release workers.
- [x] Support release defaults/Custom Settings CSV, permanent activation with automatic offline recovery, session-only tokens, five baud choices and indexed assignments; preserve legacy backend modes.
- [x] Default to DLSE online releases, show shared license-server status, widen setup, split compact active/completed tables and expand Activity History.
- [x] Match the full-width start-page serial card to the other mode cards, clarify Config preview and flashing actions, normalize section headings and move Back above the page title.
- [x] Center Back and the serial start-card contents; add a nonnegative starting-index number picker and default-on Flash license toggle with explicit no-license review/confirmation.
- [x] Skip all licensing operations and strip existing template license entries when licensing is disabled; preserve source templates and permanent backups.
- [x] Restore asynchronous original success/failure WAV cues and show chip name, configured IP and activation key in results while redacting keys from diagnostics.
- [x] Verify optional licensing/NVS contents, chip-name resolution, key redaction, audio dispatch, number-picker/toggle submission and both rendered window sizes; 126 serial/Fleet UI regression tests passed. Physical flashing and audible playback qualification remain pending.
- [ ] Add a real firmware write-percentage bar when the isolated esptool helper exposes byte progress (deferred as requested).
- [x] Verify refreshed setup/review/results layouts at 1298×804 and 1180×720, live/results row transitions through retry/skip, and tokenless automatic recovery. Serial/Fleet UI/worker regression run: 145 passed; one unrelated UniFi asyncio test skipped because the Windows sandbox blocks its internal socket pair.
- [x] Validate CSV schema/values, firmware maps/files, assignment previews and license signature/type/device match/expiry.
- [x] Detect only new connections; initialize ports, process sequentially and skip completed duplicate devices.
- [x] Show current stages, busy indicators, per-board outcomes, counters and sanitized timestamped activity/logs.
- [x] Isolate workers and temporary artifacts; bound serial/licensing/NVS/flashing work with deadlines and descendant cleanup.
- [x] Pause failures for explicit retry/skip and confirm index reservation after possible partial writes.
- [x] Finish active work on Stop/Back/close while discarding queued devices.
- [x] Persist non-secret preferences and next index; preserve existing CLI and main library unchanged.
- [x] Add mocked pipeline/session, real-process preflight/protocol and offscreen QML navigation tests.
- [x] Verify descendant termination and temporary-file cleanup after real worker deadlines.
- [x] Verify rendered setup/review/results layouts and run the complete regression suite (hardware/network checks disabled).
- [ ] Qualify physical C3/C5/C6 flashing, licensing/recovery, unplugging and serial permissions on supported operating systems.

## Fleet Verification

- [x] Add tests preventing QWidget UI code from being reintroduced.
- [x] Add exact semantic-theme, normal-button, and status-badge color tests.
- [x] Add offscreen QML shell, navigation, polling, column, validation, and exclusion tests.
- [x] Add inventory identity, offline, role, filtering, selection, and 5,000-device tests.
- [x] Add OTA queue cancellation and target-version tests.
- [x] Load the complete QML application offscreen with PySide6 6.11.1.
- [ ] Validate discovery, activation, reboot, settings, WebEngine, and OTA on physical ESP32 hardware.
- [ ] Perform an operator test with a representative production network and fleet.
