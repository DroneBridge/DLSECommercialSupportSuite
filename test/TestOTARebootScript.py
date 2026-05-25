import argparse
import unittest
from unittest.mock import Mock, patch

import batch_ota_reboot as script


class TestOTARebootScript(unittest.TestCase):
    def setUp(self):
        self.original_subnet = script.SUBNET_MASK
        self.original_local_port = script.ESP32_LOCAL_BROADCAST_PORT
        self.original_remote_port = script.ESP32_REMOTE_BROADCAST_PORT
        self.original_http_timeout = script.HTTP_FALLBACK_TIMEOUT
        self.original_http_workers = script.HTTP_FALLBACK_MAX_WORKERS

    def tearDown(self):
        script.SUBNET_MASK = self.original_subnet
        script.ESP32_LOCAL_BROADCAST_PORT = self.original_local_port
        script.ESP32_REMOTE_BROADCAST_PORT = self.original_remote_port
        script.HTTP_FALLBACK_TIMEOUT = self.original_http_timeout
        script.HTTP_FALLBACK_MAX_WORKERS = self.original_http_workers

    def test_parse_args_accepts_force_rest(self):
        """The --force-rest flag selects HTTP discovery and reboot mode."""
        with patch("sys.argv", ["batch_ota_reboot.py", "--force-rest"]):
            args = script.parse_args()

        self.assertTrue(args.force_rest)

    def test_apply_args_updates_http_options(self):
        """HTTP timeout and worker CLI options update script settings."""
        args = argparse.Namespace(
            subnetmask="192.168.20.0/24",
            esp32localbrcstport=15000,
            esp32remotebrcstport=15001,
            http_timeout=2.0,
            http_workers=7,
            force_rest=False,
        )

        script.apply_args(args)

        self.assertEqual("192.168.20.0/24", script.SUBNET_MASK)
        self.assertEqual(15000, script.ESP32_LOCAL_BROADCAST_PORT)
        self.assertEqual(15001, script.ESP32_REMOTE_BROADCAST_PORT)
        self.assertEqual(2.0, script.HTTP_FALLBACK_TIMEOUT)
        self.assertEqual(7, script.HTTP_FALLBACK_MAX_WORKERS)

    @patch("batch_ota_reboot.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_reboot.db_scan_for_esp32_devices")
    def test_discovery_uses_mavlink_results_when_available(self, mavlink_scan, http_scan):
        """HTTP fallback is skipped when MAVLink discovery finds devices."""
        mavlink_scan.return_value = [{"ip": "192.168.1.42"}]
        logger = Mock()

        method, devices = script.discover_reboot_targets(False, logger)

        self.assertEqual("mavlink", method)
        self.assertEqual([{"ip": "192.168.1.42"}], devices)
        http_scan.assert_not_called()

    @patch("batch_ota_reboot.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_reboot.db_scan_for_esp32_devices")
    def test_discovery_falls_back_to_http_scan_when_mavlink_finds_nothing(self, mavlink_scan, http_scan):
        """HTTP subnet scanning runs when MAVLink discovery returns no devices."""
        mavlink_scan.return_value = []
        http_scan.return_value = [{"ip": "192.168.1.43"}]
        logger = Mock()

        method, devices = script.discover_reboot_targets(False, logger)

        self.assertEqual("rest", method)
        self.assertEqual([{"ip": "192.168.1.43"}], devices)
        http_scan.assert_called_once_with(
            subnet_mask=script.SUBNET_MASK,
            timeout=script.HTTP_FALLBACK_TIMEOUT,
            max_workers=script.HTTP_FALLBACK_MAX_WORKERS,
        )

    @patch("batch_ota_reboot.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_reboot.db_scan_for_esp32_devices")
    def test_forced_rest_skips_mavlink_discovery(self, mavlink_scan, http_scan):
        """Forced REST mode skips MAVLink discovery entirely."""
        http_scan.return_value = [{"ip": "192.168.1.44"}]
        logger = Mock()

        method, devices = script.discover_reboot_targets(True, logger)

        self.assertEqual("rest", method)
        self.assertEqual([{"ip": "192.168.1.44"}], devices)
        mavlink_scan.assert_not_called()

    @patch("batch_ota_reboot.db_api_create_request_session")
    @patch("batch_ota_reboot.db_api_reboot_esp32_device")
    def test_rest_reboot_fanout_records_success_and_failure(self, reboot_device, create_session):
        """REST reboot fanout returns separate success and failure IP lists."""
        session_a = Mock()
        session_b = Mock()
        create_session.side_effect = [session_a, session_b]
        reboot_device.side_effect = lambda _session, ip, **_kwargs: ip == "192.168.1.42"
        logger = Mock()

        successful, failed = script.reboot_with_rest(
            [{"ip": "192.168.1.42"}, {"ip": "192.168.1.43"}],
            logger,
        )

        self.assertEqual(["192.168.1.42"], successful)
        self.assertEqual(["192.168.1.43"], failed)
        session_a.close.assert_called_once()
        session_b.close.assert_called_once()

    @patch("batch_ota_reboot.db_mavlink_reboot_esp32_devices")
    def test_mavlink_reboot_forwards_configured_subnet_and_port(self, reboot_helper):
        """MAVLink reboot wrapper forwards the selected network settings."""
        reboot_helper.return_value = True
        logger = Mock()

        result = script.reboot_with_mavlink(logger)

        self.assertTrue(result)
        reboot_helper.assert_called_once_with(
            subnet_mask=script.SUBNET_MASK,
            esp32_broadcast_port=script.ESP32_LOCAL_BROADCAST_PORT,
            logger=logger,
        )


if __name__ == "__main__":
    unittest.main()
