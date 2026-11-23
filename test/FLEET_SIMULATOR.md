# Fleet Manager HTTP simulator

The simulator provides independent, in-memory ESP32-like devices for Fleet
Manager stress testing. It binds **only** addresses in `127.0.0.0/8`; it does
not discover or operate physical devices or contact a license server. Stop it
with Ctrl+C. All simulated state is lost when it stops.

## Start a 500-device baseline

From the repository root, install the project's dependencies (`python -m pip
install -e .`) and start:

```powershell
python test/fleet_simulator.py --count 500
```

The simulator uses `aiohttp`, which is also used by Fleet Manager. If it is not
installed in your environment, install it with `python -m pip install aiohttp`.
The simulator binds 500 distinct loopback addresses on port 80; that port must
be available. Binding may require different privileges or loopback configuration
depending on the operating system. If startup fails, the error is printed and
any listeners already opened by the simulator are closed.

In Fleet Manager discovery settings:

1. Set the IPv4 range to `127.0.0.0/23`.
2. Enable HTTP discovery, disable MAVLink discovery, and disable UniFi polling.
3. Enable statistics polling and start discovery.

Wait for discovery and hydration to finish. The default simulator assigns
addresses from `127.0.0.2` upward (excluding `127.0.0.1`). Some loopback hosts
in the scanned subnet do not correspond to simulated devices, so connection
failures for those addresses are expected. If a proxy is configured, ensure it
does not intercept requests to `127.0.0.0/8`. The simulator needs port 80 for the
current Fleet Manager; `--port` is useful only for independent HTTP testing.

## Scenarios

```powershell
python test/fleet_simulator.py --count 500 --delay-ms 50 --error-percent 2 --seed 42
python test/fleet_simulator.py --count 500 --offline-percent 5
python test/fleet_simulator.py --count 1000 --subnet 127.0.0.0/22
```

Use `--help` for all options. The seed makes the initially offline devices and
the random failure sequence reproducible; concurrent request ordering can still
change which requests fail. Offline devices return HTTP 503 from startup and
therefore will not appear in a fresh HTTP discovery. Errors are HTTP 503, not
network timeouts. Settings changes trigger a simulated offline period of two
seconds by default; adjust it with `--reboot-seconds`. Delay applies to every
simulated request. Device count is capped at 5,000 and the subnet must have
enough usable addresses.

The simulator reports cumulative request and error counts, average request
rate, current and peak active requests, and mean and maximum server-side handler
duration every ten seconds (`--report-interval`). The duration includes the
configured delay but does not measure client-side latency or UI responsiveness.
Use Task Manager to compare simulator and Fleet Manager CPU and memory, and
measure discovery completion, polling duration, scrolling and filtering in the
UI. Start with no delay or failures, then add them; otherwise slow simulator
responses can be mistaken for a Fleet Manager bottleneck.

Fleet Manager groups discovery and statistics updates for up to 100 ms before
notifying its views. This keeps large fleets responsive while preserving the
latest device values and failure counts; a completed polling round is flushed
immediately.

## Scope and limitations

Implemented: `GET /api/system/info`, `GET /api/system/stats`, `GET
/api/settings`, and `POST /api/settings`. A settings POST, including an empty
object used for a REST reboot, changes that simulated device only and causes a
temporary 503 response during reboot. Only the included settings are accepted;
unsupported endpoints and settings return errors. Payloads and statistics are
synthetic and do not fully emulate firmware validation, Wi-Fi, MAVLink, flight
controllers, licenses, OTA or the ESP32 webpage. More than 254 devices reuse
MAVLink system IDs, since the valid ID space is limited.

Run the simulator unit tests with:

```powershell
python -m unittest discover -s test -p "TestFleetSimulator.py" -v
```

These unit tests exercise the handler without network access. Verify the actual
500-address loopback setup and Fleet Manager interaction on the target machine.
