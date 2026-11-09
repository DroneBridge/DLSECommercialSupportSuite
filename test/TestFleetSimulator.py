"""Tests for the fleet simulator without physical hardware or network access."""

import json
import unittest
from types import SimpleNamespace
from unittest.mock import AsyncMock

from fleet_simulator import FleetSimulator, make_devices


def invoke(simulator, ip, method, path, body=b""):
    """Run a zero-delay request handler without opening sockets or an event loop."""
    request = SimpleNamespace(
        transport=SimpleNamespace(get_extra_info=lambda _: (ip, 80)),
        method=method, path=path, read=AsyncMock(return_value=body),
    )
    coroutine = simulator.handle(request)
    try:
        coroutine.send(None)
    except StopIteration as result:
        response = result.value
        return response.status, json.loads(response.body)
    finally:
        coroutine.close()
    raise AssertionError("Handler unexpectedly suspended")


class TestFleetSimulator(unittest.TestCase):
    """Verify simulator identity, settings, failures, and loopback validation."""

    def setUp(self):
        """Create two independent simulated devices."""
        self.devices = make_devices("127.0.0.0/29", 2, 0, 1)
        self.ips = list(self.devices)
        self.simulator = FleetSimulator(self.devices, reboot_seconds=1)

    def test_identity_settings_and_reboot(self):
        """Each device keeps unique identity and settings through simulated reboot."""
        first = invoke(self.simulator, self.ips[0], "GET", "/api/system/info")[1]
        second = invoke(self.simulator, self.ips[1], "GET", "/api/system/info")[1]
        self.assertNotEqual(first["activation_key"], second["activation_key"])
        self.assertNotEqual(first["esp_mac"], second["esp_mac"])
        self.assertEqual(200, invoke(self.simulator, self.ips[0], "POST", "/api/settings", b'{"baud":57600}')[0])
        self.assertEqual(503, invoke(self.simulator, self.ips[0], "GET", "/api/system/info")[0])
        self.assertEqual(115200, invoke(self.simulator, self.ips[1], "GET", "/api/settings")[1]["baud"])
        self.devices[self.ips[0]].reboot_until = 0
        settings = invoke(self.simulator, self.ips[0], "GET", "/api/settings")[1]
        self.assertEqual(57600, settings["baud"])
        self.assertEqual("number", settings["baud_type"])
        stats = invoke(self.simulator, self.ips[0], "GET", "/api/system/stats")[1]
        self.assertEqual(self.ips[0], stats["current_client_ip"])
        self.assertEqual(7, self.simulator.requests)
        self.assertEqual(1, self.simulator.errors)

    def test_invalid_and_unsupported_requests(self):
        """Invalid updates do not mutate settings and unimplemented APIs return 404."""
        self.assertEqual(400, invoke(self.simulator, self.ips[0], "POST", "/api/settings", b'{"unknown":1}')[0])
        self.assertEqual(400, invoke(self.simulator, self.ips[0], "POST", "/api/settings", b'[]')[0])
        self.assertEqual(404, invoke(self.simulator, self.ips[0], "GET", "/api/license")[0])
        self.assertEqual(115200, self.devices[self.ips[0]].settings["baud"])

    def test_range_and_scenarios(self):
        """Validate local-only ranges and deterministic offline and error scenarios."""
        with self.assertRaises(ValueError):
            make_devices("192.168.1.0/24", 1, 0, 1)
        with self.assertRaises(ValueError):
            make_devices("127.0.0.0/30", 500, 0, 1)
        first = make_devices("127.0.0.0/28", 10, 30, 5)
        second = make_devices("127.0.0.0/28", 10, 30, 5)
        self.assertEqual([d.offline for d in first.values()], [d.offline for d in second.values()])
        self.assertEqual(3, sum(d.offline for d in first.values()))
        simulator = FleetSimulator(self.devices, error_percent=100)
        self.assertEqual(503, invoke(simulator, self.ips[0], "GET", "/api/system/info")[0])
