import os
import unittest

from DroneBridgeCommercialSupportSuite import db_get_dlse_lic_via_serial, db_is_dlse_lic_server_available, \
    db_dlse_validate_license

RUN_HARDWARE_TESTS = os.environ.get("DLSE_RUN_HARDWARE_TESTS") == "1"
RUN_NETWORK_TESTS = os.environ.get("DLSE_RUN_NETWORK_TESTS") == "1"
SERIAL_PORT = os.environ.get("DLSE_TEST_SERIAL_PORT", "COM18")


class SerialLicenseBackup(unittest.TestCase):
    """Run destructive/environment-dependent integration checks only by opt-in."""

    @unittest.skipUnless(
        RUN_HARDWARE_TESTS,
        "set DLSE_RUN_HARDWARE_TESTS=1 with a test ESP32 connected",
    )
    def test_extract_license(self):
        """Extract and validate a license through the Python esptool API."""
        path_to_backup = db_get_dlse_lic_via_serial(SERIAL_PORT, 460800)
        self.assertEqual(os.path.exists(path_to_backup), True, "License file does not exist")
        valid, license_info = db_dlse_validate_license(path_to_backup)
        self.assertEqual(valid, True, "License file is not valid")

    @unittest.skipUnless(
        RUN_HARDWARE_TESTS,
        "set DLSE_RUN_HARDWARE_TESTS=1 with a test ESP32 connected",
    )
    def test_extract_license_cmd_line_tool(self):
        """Extract and validate a license through the esptool command line."""
        path_to_backup = db_get_dlse_lic_via_serial(
            SERIAL_PORT,
            460800,
            _use_cmd_line_tool=True,
        )
        self.assertEqual(os.path.exists(path_to_backup), True, "License file does not exist")
        valid, license_info = db_dlse_validate_license(path_to_backup)
        self.assertEqual(valid, True, "License file is not valid")

    @unittest.skipUnless(
        RUN_NETWORK_TESTS,
        "set DLSE_RUN_NETWORK_TESTS=1 to contact the live license server",
    )
    def test_server_available(self):
        """Verify that the production license endpoint is reachable."""
        self.assertEqual(db_is_dlse_lic_server_available(), True, "License server not available!")

if __name__ == '__main__':
    unittest.main()
