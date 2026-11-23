# Serial Batch Flasher

Launch `dlse-ui` (or `python -m ui` from a source checkout), then choose **Serial
Batch Flasher** on the start page. The existing `dlse-install` CLI is unchanged.
The **Serial Batch Flasher** mode button in the header returns to the start page.
If a serial session or preparation job is active, it first offers to stop and
leave; the current board or job finishes before the page closes.

1. **DLSE online releases** is selected by default. Refresh the release list and
   choose a cached or account release, or select **Local release folder** for an
   extracted release root. The release list opens wider than the selector to show
   more of each path or name. Online downloads need a DroneBridge token. A release
   must contain `db_show_params.csv` and `esp32c3_generic`, `esp32c5_generic` and
   `esp32c6_generic` folders with `flash_args.txt` and all referenced binaries.
2. Use release-default settings or choose **Custom Settings CSV**, a self-contained NVS CSV
   with the header `key,type,encoding,value`. Export a known working configuration
   from a DLSE device first when provisioning a production fleet.
3. **Flash license** is enabled by default. With it enabled, the UI uses permanent activation and automatically falls back to a valid,
   matching permanent license in `received_licenses/`, then the connected board,
   when the license server is unavailable. No separate recovery mode is needed.
   Online activation requires a token; `DRONEBRIDGE_SECRET_TOKEN` supplies the
   initial value. Tokens are masked and never saved in UI preferences. A local
   or cached release can be validated without a token for offline recovery;
   online activation still fails safely without one. Account firmware listing
   and downloads are separate online operations. The color-coded **License server**
   indicator uses the existing background HTTP reachability check every **30 seconds**
   with a **five-second** request timeout; it does not validate the token.
   Select **License details** in the flasher to review recovery and token behavior.
   Disable **Flash license** to install firmware and settings without acquiring,
   validating, recovering or embedding a license. Any license payload already
   in the settings template is omitted from the generated NVS partition.
   **This replaces the board's settings partition and removes any existing
   on-board license.** Local permanent backups are left untouched. The review
   and final confirmation explicitly show that licensing is disabled. Online
   firmware downloads still need a token; local/cached firmware does not.
4. Choose the starting index using the number picker (initial default **1**,
   minimum **0**; a saved next index is retained). Static-IP subnet and network-address
   checks still apply: index 0 is rejected when it would produce a network address.
   Choose flash baud from
   **115200**, **230400**, **460800** (default), **921600**, or **1500000**.
   Supported baud preferences persist; older custom values fall back to 460800
   in the dropdown. Use 115200 for connection problems. Select **Check and Validate
   Configuration**, inspect **Config preview** and schema warnings, then select
   **Start flashing…** and confirm. Validation only previews assignments; it
   does not flash a board. When your configuration is missing keys present in
   the release schema, the review lists those keys and uses their release default values.

The flasher snapshots existing ports and processes **new connections only**.
While armed, a persistent amber banner warns that newly connected boards will
be flashed automatically, and **Stop** is highlighted in red. The banner also
identifies paused and stopping states. Stop disarms automatic flashing after
any current operation finishes.
Reconnect already-attached boards after monitoring starts. Ports are checked
every **one second**, with **two seconds** allowed for initialization. Install
the board's USB/serial driver and ensure your OS account can access the port;
close other programs using that serial port. Serial flashing itself does not
require MAVLink access or stopping Skybrush Live unless it owns that port.

The compact **Newly Connected Boards** table shows waiting and active boards.
**Flashed Boards / Results** lists completed outcomes with index, resolved chip
name (for example ESP32-C5), static IP, activation key and Success/Fail/Skipped
status, including boards skipped before flashing. Fields not yet read or assigned
remain empty. The **Static IP** column shows `—` when no static IP was configured;
it does not show an address assigned later by DHCP. Activation keys are visible in this table as requested, but remain
redacted in diagnostic logs and Activity History. Failed
rows return to the active table during an explicit retry. The **Activity
History**, current-activity banner and outcome counts show what is happening.
The Results table and Activity History share available vertical space equally;
enlarge the window to see more rows and history at the same time.
Simultaneous arrivals wait internally while the current board finishes; there
is no queued counter in the UI. Busy indicators are indeterminate; no estimated
flash percentage is shown. Firmware, settings and license are installed one
board at a time. Keep each board connected until it completes.
The original success and failure WAV notifications play asynchronously through
Qt audio support after each device result. Skipped boards are silent; missing
audio resources or unavailable audio output do not fail flashing. The current
isolated esptool helper does not report byte progress to the UI, so the Stage
column remains the flashing indicator without an estimated percentage.

The index replaces the last static-IP octet when configured and replaces trailing
numbers in the hostname and AP name. Blank static IP remains blank. Invalid or
exhausted assignments stop processing instead of wrapping. The next index is
saved after success. Failed boards pause the queue for explicit retry or skip;
retry rechecks their identity. If writing began, skipping requires confirmation
and reserves that index to avoid assigning it to another board. Unsupported chips
and successfully processed duplicate devices are skipped automatically.

**Stop**, the mode button and window close stop arrivals and discard queued work while the
active board finishes. Worker deadlines are **120 seconds per serial-read stage**,
**180 seconds for licensing**, **60 seconds for validation/settings/NVS generation**,
**600 seconds for flashing**, and **900 seconds for release download/extraction**.
Existing helpers retain their four identification attempts and three transient
license-request attempts, including their network timeouts and backoff. Deadline
failures terminate the worker and its descendants; interrupted flashing can leave
a partially programmed board and is never retried automatically.

Release binaries and source CSVs are not edited. Intermediate files are isolated
per worker and removed afterward; permanent license backups remain in
`received_licenses/`. Sanitized logs are written to `logs/dlse_serial_ui_*.log`.
Non-secret flasher preferences and the next index persist; monitoring never starts
automatically on launch. Physical C3/C5/C6 and Linux/macOS qualification remains
pending; test a small batch before production use.
