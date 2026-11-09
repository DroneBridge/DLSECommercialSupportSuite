"""Loopback-only HTTP simulator for exercising Fleet Manager without hardware."""

from __future__ import annotations

import argparse
import asyncio
import ipaddress
import json
import random
import time
from dataclasses import dataclass, field
from typing import Any

from aiohttp import web


@dataclass
class Device:
    """Hold independent, temporary state for one simulated device."""

    number: int
    ip: str
    offline: bool = False
    reboot_until: float = 0.0
    settings: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        """Populate deterministic settings; state is discarded on process exit."""
        sysid = (self.number - 1) % 254 + 1
        self.settings = {
            "wifi_hostname": f"sim-drone-{self.number:04d}",
            "esp32_mode": 2, "ssid": "Simulated Fleet", "wifi_chan": 6,
            "baud": 115200, "gpio_tx": 16, "gpio_rx": 17,
            "gpio_cts": 0, "gpio_rts": 0, "led_cont_en": 1,
            "adc_a_en": 1, "adc_v_en": 1, "udp_local_port": 14550,
            "wifi_brcst_port": 14555, "show_pm_en": 1,
            "show_pm_en_hb": 1, "show_en_syid_ip": 0, "show_man_sysid": sysid,
        }

    def info(self) -> dict[str, Any]:
        """Return stable synthetic system information with a unique identity."""
        n = self.number
        return {
            "idf_version": "simulated", "db_build_version": 100,
            "major_version": 1, "minor_version": 0, "patch_version": 0,
            "maturity_version": "simulator", "license_type": "SIMULATED",
            "expiration_date": "Never", "activation_key": f"SIMULATED-{n:08d}",
            "esp_chip_model": 13, "has_rf_switch": 0, "serial_via_JTAG": 0,
            "esp_mac": f"02:00:{(n >> 24) & 255:02X}:{(n >> 16) & 255:02X}:{(n >> 8) & 255:02X}:{n & 255:02X}",
        }

    def stats(self, elapsed: float) -> dict[str, Any]:
        """Return plausible changing counters for elapsed simulator seconds."""
        tick = int(elapsed)
        return {
            "read_bytes": tick * (500 + self.number % 100),
            "serial_bytes_sent": tick * (400 + self.number % 100),
            "serial_mav_msgs_received": tick * 5, "serial_mav_msgs_lost": 0,
            "tcp_connected": 0, "udp_connected": 1, "udp_clients": [],
            "current_client_ip": self.ip, "esp_rssi": -45 - (self.number + tick // 5) % 35,
            "fc_pw_state": 1, "fc_armed_state": 0,
            "fc_sysid": (self.number - 1) % 254 + 1,
            "battery_voltage": round(15.5 + (self.number % 20) / 100, 2),
            "battery_current": 1.2, "cpu_load": 2000 + self.number % 1000,
        }


def make_devices(subnet: str, count: int, offline_percent: float, seed: int) -> dict[str, Device]:
    """Create loopback devices; reject invalid ranges, counts, and percentages."""
    try:
        network = ipaddress.ip_network(subnet, strict=False)
    except ValueError as exc:
        raise ValueError(f"Invalid subnet: {exc}") from exc
    if not isinstance(network, ipaddress.IPv4Network) or not network.subnet_of(ipaddress.ip_network("127.0.0.0/8")):
        raise ValueError("The subnet must be an IPv4 loopback range within 127.0.0.0/8")
    if count < 1 or count > 5000 or not 0 <= offline_percent <= 100:
        raise ValueError("Device count must be 1..5000 and offline percentage 0..100")
    addresses = []
    for host in network.hosts():
        if str(host) != "127.0.0.1":
            addresses.append(str(host))
            if len(addresses) == count:
                break
    if len(addresses) != count:
        raise ValueError("Subnet does not contain enough usable loopback addresses")
    offline = set(random.Random(seed).sample(range(count), round(count * offline_percent / 100)))
    return {ip: Device(i + 1, ip, i in offline) for i, ip in enumerate(addresses)}


class FleetSimulator:
    """Serve isolated device state and accumulate lightweight request metrics."""

    def __init__(self, devices: dict[str, Device], delay_ms: float = 0,
                 error_percent: float = 0, reboot_seconds: float = 2, seed: int = 1) -> None:
        """Configure response behavior; invalid percentages or delays raise ValueError."""
        if delay_ms < 0 or reboot_seconds < 0 or not 0 <= error_percent <= 100:
            raise ValueError("Delays must be nonnegative and error percentage must be 0..100")
        self.devices = devices
        self.delay_ms = delay_ms
        self.error_percent = error_percent
        self.reboot_seconds = reboot_seconds
        self.random = random.Random(seed)
        self.started = time.monotonic()
        self.requests = 0
        self.errors = 0
        self.active = 0
        self.peak_active = 0
        self.total_ms = 0.0
        self.max_ms = 0.0

    async def handle(self, request: web.Request) -> web.StreamResponse:
        """Handle one device request, returning HTTP errors for offline or invalid requests."""
        started = time.monotonic()
        self.requests += 1
        self.active += 1
        self.peak_active = max(self.active, self.peak_active)
        status = 500
        try:
            peer = request.transport.get_extra_info("sockname") if request.transport else None
            device = self.devices.get(peer[0]) if peer else None
            if device is None:
                status = 404
                return web.json_response({"error": "Unknown simulated device"}, status=status)
            if self.delay_ms:
                await asyncio.sleep(self.delay_ms / 1000)
            if device.offline or time.monotonic() < device.reboot_until:
                status = 503
                return web.json_response({"error": "Device unavailable"}, status=status)
            if self.random.random() * 100 < self.error_percent:
                status = 503
                return web.json_response({"error": "Simulated transient failure"}, status=status)
            if request.method == "GET" and request.path == "/api/system/info":
                payload = device.info()
            elif request.method == "GET" and request.path == "/api/system/stats":
                payload = device.stats(time.monotonic() - self.started)
            elif request.method == "GET" and request.path == "/api/settings":
                payload = dict(device.settings)
                payload.update({f"{key}_type": "number" if isinstance(value, (int, float)) else "string"
                                for key, value in device.settings.items()})
            elif request.method == "POST" and request.path == "/api/settings":
                try:
                    raw = await request.read()
                    if len(raw) >= 10240:
                        status = 400
                        return web.Response(text="content too long", status=status)
                    updates = json.loads(raw)
                    if not isinstance(updates, dict):
                        raise ValueError("Expected an object")
                except (ValueError, UnicodeDecodeError):
                    status = 400
                    return web.json_response({"status": "failed", "msg": "Invalid JSON object"}, status=status)
                if any(key not in device.settings for key in updates):
                    status = 400
                    return web.json_response({"status": "failed", "msg": "Unsupported simulated setting"}, status=status)
                device.settings.update(updates)
                device.reboot_until = time.monotonic() + self.reboot_seconds
                payload = {"status": "success", "msg": "Settings changed! Rebooting ..."}
            else:
                status = 404
                return web.json_response({"error": "Endpoint not simulated"}, status=status)
            status = 200
            return web.json_response(payload)
        finally:
            self.active -= 1
            self.errors += int(status >= 400)
            elapsed_ms = (time.monotonic() - started) * 1000
            self.total_ms += elapsed_ms
            self.max_ms = max(self.max_ms, elapsed_ms)

    def report(self) -> str:
        """Return aggregate counts and server-side latency since startup."""
        elapsed = max(time.monotonic() - self.started, 0.001)
        return (f"requests={self.requests} errors={self.errors} rate={self.requests / elapsed:.1f}/s "
                f"active={self.active} peak_active={self.peak_active} "
                f"mean_ms={self.total_ms / max(self.requests, 1):.2f} max_ms={self.max_ms:.2f}")


async def run_server(simulator: FleetSimulator, port: int, report_interval: float) -> None:
    """Bind all device addresses and serve until cancelled; close listeners on failure."""
    app = web.Application(client_max_size=10240)
    app.router.add_route("*", "/{path:.*}", simulator.handle)
    runner = web.AppRunner(app, access_log=None)
    await runner.setup()
    try:
        for ip in simulator.devices:
            await web.TCPSite(runner, ip, port, backlog=128).start()
        print(f"Simulating {len(simulator.devices)} devices on port {port}; "
              f"{sum(d.offline for d in simulator.devices.values())} offline. Press Ctrl+C to stop.", flush=True)
        while True:
            await asyncio.sleep(report_interval)
            print(simulator.report(), flush=True)
    finally:
        await runner.cleanup()


def main() -> None:
    """Parse simulator options and run until interrupted; report invalid startup clearly."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--count", type=int, default=500)
    parser.add_argument("--subnet", default="127.0.0.0/23")
    parser.add_argument("--port", type=int, default=80, help="HTTP port; Fleet Manager requires 80")
    parser.add_argument("--delay-ms", type=float, default=0)
    parser.add_argument("--offline-percent", type=float, default=0)
    parser.add_argument("--error-percent", type=float, default=0)
    parser.add_argument("--reboot-seconds", type=float, default=2)
    parser.add_argument("--seed", type=int, default=1)
    parser.add_argument("--report-interval", type=float, default=10)
    args = parser.parse_args()
    if not 1 <= args.port <= 65535 or args.report_interval <= 0:
        parser.error("port must be 1..65535 and report interval must be positive")
    try:
        devices = make_devices(args.subnet, args.count, args.offline_percent, args.seed)
        simulator = FleetSimulator(devices, args.delay_ms, args.error_percent, args.reboot_seconds, args.seed)
        asyncio.run(run_server(simulator, args.port, args.report_interval))
    except (ValueError, OSError) as exc:
        parser.exit(1, f"Simulator could not start: {exc}\n")
    except KeyboardInterrupt:
        print("\nSimulator stopped.")


if __name__ == "__main__":
    main()
