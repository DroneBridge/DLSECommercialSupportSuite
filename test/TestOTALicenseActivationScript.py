import argparse
import unittest
from unittest.mock import Mock, patch

import batch_ota_license_activation as script
from DroneBridgeCommercialSupportSuite import DBLicenseType


class TestOTALicenseActivationScript(unittest.TestCase):
    def setUp(self):
        self.original_token = script.MY_SECRET_TOKEN
        self.original_subnet = script.SUBNET_MASK
        self.original_local_port = script.ESP32_LOCAL_BROADCAST_PORT
        self.original_remote_port = script.ESP32_REMOTE_BROADCAST_PORT
        self.original_license_type = script.LICENSE_TYPE
        self.original_validity_days = script.LICENSE_VALIDITY_DAYS
        self.original_force_rest = script.FORCE_REST_DISCOVERY

    def tearDown(self):
        script.MY_SECRET_TOKEN = self.original_token
        script.SUBNET_MASK = self.original_subnet
        script.ESP32_LOCAL_BROADCAST_PORT = self.original_local_port
        script.ESP32_REMOTE_BROADCAST_PORT = self.original_remote_port
        script.LICENSE_TYPE = self.original_license_type
        script.LICENSE_VALIDITY_DAYS = self.original_validity_days
        script.FORCE_REST_DISCOVERY = self.original_force_rest

    def test_parse_args_accepts_short_evaluation_flag(self):
        """The -e flag selects evaluation license mode."""
        with patch("sys.argv", ["batch_ota_license_activation.py", "-e"]):
            args = script.parse_args()

        self.assertTrue(args.evaluation)

    def test_parse_args_accepts_long_evaluation_flag(self):
        """The --evaluation flag selects evaluation license mode."""
        with patch("sys.argv", ["batch_ota_license_activation.py", "--evaluation"]):
            args = script.parse_args()

        self.assertTrue(args.evaluation)

    def test_parse_args_accepts_force_rest_flag(self):
        """The --force-rest flag selects HTTP-only discovery mode."""
        with patch("sys.argv", ["batch_ota_license_activation.py", "--force-rest"]):
            args = script.parse_args()

        self.assertTrue(args.force_rest)

    @patch.dict("batch_ota_license_activation.os.environ", {}, clear=True)
    def test_apply_args_defaults_to_activated_license(self):
        """Without -e, the script keeps requesting regular activated licenses."""
        args = argparse.Namespace(
            token=None,
            subnetmask=None,
            esp32localbrcstport=None,
            esp32remotebrcstport=None,
            evaluation=False,
            force_rest=False,
        )

        script.apply_args(args)

        self.assertEqual(DBLicenseType.ACTIVATED, script.LICENSE_TYPE)
        self.assertEqual(0, script.LICENSE_VALIDITY_DAYS)
        self.assertFalse(script.FORCE_REST_DISCOVERY)

    @patch.dict("batch_ota_license_activation.os.environ", {"DRONEBRIDGE_SECRET_TOKEN": "env-token"}, clear=True)
    def test_apply_args_cli_token_overrides_environment_token(self):
        """The explicit --token argument takes precedence over the environment."""
        args = argparse.Namespace(
            token="cli-token",
            subnetmask=None,
            esp32localbrcstport=None,
            esp32remotebrcstport=None,
            evaluation=False,
            force_rest=False,
        )

        script.apply_args(args)

        self.assertEqual("cli-token", script.MY_SECRET_TOKEN)

    @patch.dict("batch_ota_license_activation.os.environ", {}, clear=True)
    def test_apply_args_sets_evaluation_license_mode(self):
        """With -e, the script requests fixed 60-day evaluation licenses."""
        args = argparse.Namespace(
            token=None,
            subnetmask=None,
            esp32localbrcstport=None,
            esp32remotebrcstport=None,
            evaluation=True,
            force_rest=False,
        )

        script.apply_args(args)

        self.assertEqual(DBLicenseType.EVALUATION, script.LICENSE_TYPE)
        self.assertEqual(60, script.LICENSE_VALIDITY_DAYS)

    @patch.dict("batch_ota_license_activation.os.environ", {}, clear=True)
    def test_apply_args_sets_force_rest_discovery(self):
        """With --force-rest, the script stores HTTP-only discovery mode."""
        args = argparse.Namespace(
            token=None,
            subnetmask=None,
            esp32localbrcstport=None,
            esp32remotebrcstport=None,
            evaluation=False,
            force_rest=True,
        )

        script.apply_args(args)

        self.assertTrue(script.FORCE_REST_DISCOVERY)

    @patch("batch_ota_license_activation.db_api_activate_dlse_device")
    def test_process_device_forwards_selected_license_mode(self, activate):
        """Device processing forwards the configured license type and validity."""
        activate.return_value = Mock(success=True)
        script.MY_SECRET_TOKEN = "token"
        script.LICENSE_TYPE = DBLicenseType.EVALUATION
        script.LICENSE_VALIDITY_DAYS = 60

        result = script.process_dlse_device(
            {"ip": "192.168.1.42"},
            Mock(),
            set(),
            set(),
            Mock(),
        )

        self.assertTrue(result)
        _args, kwargs = activate.call_args
        self.assertEqual(DBLicenseType.EVALUATION, kwargs["license_type"])
        self.assertEqual(60, kwargs["validity_days"])

    @patch("batch_ota_license_activation.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_license_activation.db_scan_for_esp32_devices")
    def test_discover_devices_uses_mavlink_results_when_available(self, mavlink_scan, http_scan):
        """HTTP fallback is skipped when MAVLink discovery finds devices."""
        script.FORCE_REST_DISCOVERY = False
        mavlink_scan.return_value = [{"ip": "192.168.1.42"}]
        logger = Mock()

        devices = script.discover_dlse_devices(logger)

        self.assertEqual([{"ip": "192.168.1.42"}], devices)
        http_scan.assert_not_called()
        logger.log.assert_not_called()

    @patch("batch_ota_license_activation.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_license_activation.db_scan_for_esp32_devices")
    def test_discover_devices_falls_back_to_http_scan_when_mavlink_finds_nothing(self, mavlink_scan, http_scan):
        """HTTP subnet scanning runs only when MAVLink discovery returns no devices."""
        script.FORCE_REST_DISCOVERY = False
        mavlink_scan.return_value = []
        http_scan.return_value = [{"ip": "192.168.1.43"}]
        logger = Mock()

        devices = script.discover_dlse_devices(logger)

        self.assertEqual([{"ip": "192.168.1.43"}], devices)
        http_scan.assert_called_once_with(
            subnet_mask=script.SUBNET_MASK,
            timeout=script.HTTP_FALLBACK_TIMEOUT,
            max_workers=script.HTTP_FALLBACK_MAX_WORKERS,
        )
        logger.log.assert_called_once_with(
            "MAVLink discovery found no ESP32 devices. Falling back to HTTP subnet scan."
        )

    @patch("batch_ota_license_activation.db_scan_for_esp32_devices_by_ip_range")
    @patch("batch_ota_license_activation.db_scan_for_esp32_devices")
    def test_discover_devices_force_rest_skips_mavlink_scan(self, mavlink_scan, http_scan):
        """Forced REST discovery skips MAVLink and scans the IP range directly."""
        script.FORCE_REST_DISCOVERY = True
        http_scan.return_value = [{"ip": "192.168.1.44"}]
        logger = Mock()

        devices = script.discover_dlse_devices(logger)

        self.assertEqual([{"ip": "192.168.1.44"}], devices)
        mavlink_scan.assert_not_called()
        http_scan.assert_called_once_with(
            subnet_mask=script.SUBNET_MASK,
            timeout=script.HTTP_FALLBACK_TIMEOUT,
            max_workers=script.HTTP_FALLBACK_MAX_WORKERS,
        )
        logger.log.assert_called_once_with("Forced REST discovery selected. Skipping MAVLink discovery.")

    @patch.dict("batch_ota_license_activation.os.environ", {}, clear=True)
    @patch("batch_ota_license_activation.db_scan_for_esp32_devices")
    def test_main_rejects_placeholder_token_before_discovery(self, mavlink_scan):
        """Placeholder activation tokens stop the CLI before network scanning."""
        script.MY_SECRET_TOKEN = "<Add Token here>"
        with patch("sys.argv", ["batch_ota_license_activation.py"]):
            with self.assertRaises(SystemExit) as exit_context:
                script.main()

        self.assertEqual(2, exit_context.exception.code)
        mavlink_scan.assert_not_called()


if __name__ == "__main__":
    unittest.main()
