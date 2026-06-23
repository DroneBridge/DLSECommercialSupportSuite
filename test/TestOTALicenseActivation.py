import unittest
from unittest.mock import Mock, patch

import requests

from DroneBridgeCommercialSupportSuite import (
    DBLicenseActivationStatus,
    DBLicenseType,
    db_api_activate_dlse_device,
    db_api_get_activation_key,
    db_scan_for_esp32_devices_by_ip_range,
)


class TestOTALicenseActivation(unittest.TestCase):
    def setUp(self):
        self.session = requests.Session()
        self.logger = Mock()

    def tearDown(self):
        self.session.close()

    def test_get_activation_key_does_not_send_license_token(self):
        """Fetching an ESP32 activation key does not require a DroneBridge token."""
        session = Mock()
        response = Mock()
        response.json.return_value = {"activation_key": "ACTIVATION_KEY"}
        session.get.return_value = response

        result = db_api_get_activation_key(session, "192.168.1.42")

        self.assertEqual("ACTIVATION_KEY", result)
        session.get.assert_called_once_with(
            "http://192.168.1.42/api/system/info",
            headers={"Accept": "application/json"},
            timeout=5,
        )
        response.raise_for_status.assert_called_once()

    @patch("DroneBridgeCommercialSupportSuite.db_api_upload_license", return_value=(True, "Activated"))
    @patch("DroneBridgeCommercialSupportSuite.db_dlse_validate_license", return_value=(True, {}))
    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file", return_value="received_licenses/key.dlselic")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated", return_value=False)
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_successful_activation_updates_sets(self, _get_key, _check_active, request_license,
                                                _validate, _upload):
        """A normal activation returns success and records processed IP/key state."""
        processed_keys = set()
        successful_ips = set()

        result = db_api_activate_dlse_device(
            {"ip": "192.168.1.42", "sys_id": 42},
            self.session,
            "token",
            processed_keys=processed_keys,
            successful_ips=successful_ips,
            logger=self.logger,
        )

        self.assertTrue(result.success)
        self.assertEqual(DBLicenseActivationStatus.ACTIVATED, result.status)
        self.assertEqual({"ACTIVATION_KEY"}, processed_keys)
        self.assertEqual({"192.168.1.42"}, successful_ips)
        request_license.assert_called_once()

    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated", return_value=True)
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_already_activated_skips_license_request(self, _get_key, _check_active, request_license):
        """Already activated devices are marked successful without downloading a license."""
        processed_keys = set()
        successful_ips = set()

        result = db_api_activate_dlse_device(
            {"ip": "192.168.1.42"},
            self.session,
            "token",
            processed_keys=processed_keys,
            successful_ips=successful_ips,
            logger=self.logger,
        )

        self.assertTrue(result.success)
        self.assertEqual(DBLicenseActivationStatus.ALREADY_ACTIVATED, result.status)
        self.assertEqual({"ACTIVATION_KEY"}, processed_keys)
        self.assertEqual({"192.168.1.42"}, successful_ips)
        request_license.assert_not_called()

    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated")
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_duplicate_activation_key_skips_device(self, _get_key, check_active, request_license):
        """Duplicate activation keys are skipped before activation-state or server calls."""
        result = db_api_activate_dlse_device(
            {"ip": "192.168.1.42"},
            self.session,
            "token",
            processed_keys={"ACTIVATION_KEY"},
            logger=self.logger,
        )

        self.assertTrue(result.success)
        self.assertEqual(DBLicenseActivationStatus.SKIPPED_DUPLICATE, result.status)
        check_active.assert_not_called()
        request_license.assert_not_called()

    @patch("DroneBridgeCommercialSupportSuite.db_api_upload_license")
    @patch("DroneBridgeCommercialSupportSuite.db_dlse_validate_license", return_value=(False, None))
    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file", return_value="received_licenses/key.dlselic")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated", return_value=False)
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_invalid_downloaded_license_fails_before_upload(self, _get_key, _check_active,
                                                            _request_license, _validate, upload):
        """Invalid downloaded licenses are not uploaded to devices."""
        result = db_api_activate_dlse_device({"ip": "192.168.1.42"}, self.session, "token", logger=self.logger)

        self.assertFalse(result.success)
        self.assertEqual(DBLicenseActivationStatus.FAILED, result.status)
        self.assertIn("validation", result.message)
        upload.assert_not_called()

    def test_missing_token_fails_without_network_calls(self):
        """Missing tokens fail immediately and avoid network side effects."""
        result = db_api_activate_dlse_device({"ip": "192.168.1.42"}, self.session, "", logger=self.logger)

        self.assertFalse(result.success)
        self.assertEqual(DBLicenseActivationStatus.FAILED, result.status)
        self.assertIn("token", result.message.lower())

    @patch("DroneBridgeCommercialSupportSuite.db_api_upload_license", return_value=(True, "Activated"))
    @patch("DroneBridgeCommercialSupportSuite.db_dlse_validate_license", return_value=(True, {}))
    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file", return_value="received_licenses/key.dlselic")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated", return_value=False)
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_evaluation_license_uses_requested_fixed_validity(self, _get_key, _check_active,
                                                              request_license, _validate, _upload):
        """Evaluation activation forwards the fixed 60-day validity used by the UI."""
        db_api_activate_dlse_device(
            {"ip": "192.168.1.42"},
            self.session,
            "token",
            license_type=DBLicenseType.EVALUATION,
            validity_days=60,
            logger=self.logger,
        )

        _args, kwargs = request_license.call_args
        self.assertEqual(DBLicenseType.EVALUATION, kwargs["_license_type"])
        self.assertEqual(60, kwargs["_validity_days"])

    @patch("DroneBridgeCommercialSupportSuite.os.remove")
    @patch("DroneBridgeCommercialSupportSuite.db_api_upload_license", return_value=(True, "Activated"))
    @patch("DroneBridgeCommercialSupportSuite.db_dlse_validate_license", return_value=(True, {}))
    @patch("DroneBridgeCommercialSupportSuite.db_api_request_license_file", return_value="temp/key.dlselic")
    @patch("DroneBridgeCommercialSupportSuite.db_api_check_is_activated", return_value=False)
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_activation_key", return_value="ACTIVATION_KEY")
    def test_evaluation_license_file_is_removed_after_activation(self, _get_key, _check_active,
                                                                 _request_license, _validate,
                                                                 _upload, remove):
        """Evaluation license files are temporary and are removed after upload."""
        result = db_api_activate_dlse_device(
            {"ip": "192.168.1.42"},
            self.session,
            "token",
            license_type=DBLicenseType.EVALUATION,
            validity_days=60,
            logger=self.logger,
        )

        self.assertTrue(result.success)
        self.assertIsNone(result.license_path)
        remove.assert_called_once_with("temp/key.dlselic")

    def test_invalid_http_scan_subnet_returns_empty_list(self):
        """Invalid HTTP discovery subnet input returns no devices instead of raising."""
        with patch("DroneBridgeCommercialSupportSuite.DBLogger", return_value=self.logger):
            self.assertEqual([], db_scan_for_esp32_devices_by_ip_range("not-a-subnet"))


if __name__ == "__main__":
    unittest.main()
