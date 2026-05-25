import os
import unittest
from unittest.mock import Mock, mock_open, patch

import requests

from DroneBridgeCommercialSupportSuite import (
    DLSE_LICENSE_SERVER_BASE_URL,
    DBLicenseType,
    db_api_request_license_file,
    db_build_dlse_license_generate_url,
    db_is_dlse_lic_server_available,
)


class TestLicenseServerConfig(unittest.TestCase):
    def test_license_generate_url_uses_default_base_url(self):
        """The default license endpoint is derived from the module-level base URL."""
        self.assertEqual(
            f"{DLSE_LICENSE_SERVER_BASE_URL}/api/license/generate",
            db_build_dlse_license_generate_url(),
        )

    def test_license_generate_url_accepts_local_base_url(self):
        """Local test servers can be configured by passing only their base URL."""
        self.assertEqual(
            "http://127.0.0.1:8000/api/license/generate",
            db_build_dlse_license_generate_url("http://127.0.0.1:8000"),
        )

    def test_license_generate_url_accepts_trailing_slash(self):
        """Trailing slashes on the configured base URL do not change the endpoint."""
        self.assertEqual(
            "http://127.0.0.1:8000/api/license/generate",
            db_build_dlse_license_generate_url("http://127.0.0.1:8000/"),
        )

    def test_license_generate_url_keeps_full_endpoint_for_compatibility(self):
        """Existing callers that pass the full endpoint keep working."""
        self.assertEqual(
            "http://127.0.0.1:8000/api/license/generate",
            db_build_dlse_license_generate_url("http://127.0.0.1:8000/api/license/generate"),
        )

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_server_available_uses_default_license_endpoint(self, request_get, _logger):
        """The availability check uses the default base URL plus the license path."""
        request_get.return_value = Mock(status_code=200)

        self.assertTrue(db_is_dlse_lic_server_available())

        request_get.assert_called_once_with(
            f"{DLSE_LICENSE_SERVER_BASE_URL}/api/license/generate",
            timeout=5,
        )

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_server_available_uses_local_base_url(self, request_get, _logger):
        """The availability check can target a local test server."""
        request_get.return_value = Mock(status_code=200)

        self.assertTrue(db_is_dlse_lic_server_available("http://127.0.0.1:8000"))

        request_get.assert_called_once_with(
            "http://127.0.0.1:8000/api/license/generate",
            timeout=5,
        )

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_server_available_returns_false_on_server_error(self, request_get, _logger):
        """Server-side errors make the availability check return False."""
        request_get.return_value = Mock(status_code=503)

        self.assertFalse(db_is_dlse_lic_server_available("http://127.0.0.1:8000"))

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_server_available_returns_false_on_request_error(self, request_get, _logger):
        """Network errors make the availability check return False."""
        request_get.side_effect = requests.ConnectionError("offline")

        self.assertFalse(db_is_dlse_lic_server_available("http://127.0.0.1:8000"))

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_request_license_file_uses_local_base_url(self, request_get, _logger):
        """License downloads use the derived endpoint for a local test server."""
        response = Mock(status_code=200)
        response.headers = {"Content-Disposition": 'attachment; filename="license.dlselic"'}
        response.iter_content.return_value = [b"license-data"]
        request_get.return_value = response

        with patch("DroneBridgeCommercialSupportSuite.os.makedirs") as makedirs, \
                patch("builtins.open", mock_open()) as file_open:
            license_path = db_api_request_license_file(
                "ACTIVATION_KEY",
                "token",
                _output_path="licenses",
                base_url="http://127.0.0.1:8000",
            )

        expected_license_path = os.path.join("licenses", "license.dlselic")
        self.assertEqual(expected_license_path, license_path)
        makedirs.assert_called_once_with("licenses", exist_ok=True)
        file_open.assert_called_once_with(expected_license_path, "wb")
        request_get.assert_called_once()
        self.assertEqual("http://127.0.0.1:8000/api/license/generate", request_get.call_args.args[0])

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.tempfile.gettempdir", return_value="temp")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_evaluation_license_uses_temp_folder_by_default(self, request_get, _get_temp_dir, _logger):
        """Evaluation licenses do not enter the received_licenses offline cache by default."""
        response = Mock(status_code=200)
        response.headers = {"Content-Disposition": 'attachment; filename="evaluation.dlselic"'}
        response.iter_content.return_value = [b"license-data"]
        request_get.return_value = response

        with patch("DroneBridgeCommercialSupportSuite.os.makedirs") as makedirs, \
                patch("builtins.open", mock_open()) as file_open:
            license_path = db_api_request_license_file(
                "ACTIVATION_KEY",
                "token",
                _license_type=DBLicenseType.EVALUATION,
            )

        expected_folder = os.path.join("temp", "dronebridge_evaluation_licenses")
        expected_license_path = os.path.join(expected_folder, "evaluation.dlselic")
        self.assertEqual(expected_license_path, license_path)
        makedirs.assert_called_once_with(expected_folder, exist_ok=True)
        file_open.assert_called_once_with(expected_license_path, "wb")


if __name__ == "__main__":
    unittest.main()
