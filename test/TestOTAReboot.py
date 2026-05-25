import unittest
from unittest.mock import Mock, patch

import requests

from DroneBridgeCommercialSupportSuite import (
    db_api_reboot_esp32_device,
    db_mavlink_reboot_esp32_devices,
)


class TestOTARebootHelpers(unittest.TestCase):
    def setUp(self):
        self.logger = Mock()

    def test_rest_reboot_posts_empty_settings_payload(self):
        """REST reboot sends an empty JSON object to /api/settings."""
        session = Mock()
        session.post.return_value = Mock(status_code=200)

        result = db_api_reboot_esp32_device(session, "192.168.1.42", timeout=2.5, logger=self.logger)

        self.assertTrue(result)
        session.post.assert_called_once_with(
            "http://192.168.1.42/api/settings",
            json={},
            headers={"Accept": "application/json"},
            timeout=2.5,
        )

    def test_rest_reboot_returns_false_on_non_200(self):
        """REST reboot returns False when the ESP32 rejects the settings request."""
        session = Mock()
        session.post.return_value = Mock(status_code=422, text="armed")

        result = db_api_reboot_esp32_device(session, "192.168.1.42", logger=self.logger)

        self.assertFalse(result)

    def test_rest_reboot_returns_false_on_request_error(self):
        """REST reboot returns False instead of raising request errors."""
        session = Mock()
        session.post.side_effect = requests.ConnectionError("offline")

        result = db_api_reboot_esp32_device(session, "192.168.1.42", logger=self.logger)

        self.assertFalse(result)

    @patch("DroneBridgeCommercialSupportSuite.mavutil.mavlink_connection")
    def test_mavlink_reboot_sends_broadcast_command(self, mavlink_connection):
        """MAVLink reboot sends MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN to the subnet broadcast address."""
        master = Mock()
        mavlink_connection.return_value = master

        result = db_mavlink_reboot_esp32_devices(
            subnet_mask="192.168.1.0/24",
            esp32_broadcast_port=14555,
            logger=self.logger,
        )

        self.assertTrue(result)
        mavlink_connection.assert_called_once_with("udpout:192.168.1.255:14555", source_system=255)
        args = master.mav.command_long_send.call_args.args
        self.assertEqual(0, args[0])
        self.assertEqual(0, args[1])
        self.assertEqual(246, args[2])
        self.assertEqual(1, args[6])


if __name__ == "__main__":
    unittest.main()
