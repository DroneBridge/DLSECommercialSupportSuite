import os
import unittest

from DroneBridgeCommercialSupportSuite import db_get_dlse_lic_via_serial, db_is_dlse_lic_server_available, \
    db_dlse_validate_license


class SerialLicenseBackup(unittest.TestCase):
    def test_extract_license(self):
        path_to_backup = db_get_dlse_lic_via_serial("COM49")
        self.assertEqual(os.path.exists(path_to_backup), True, "License file does not exist")
        valid, license_info = db_dlse_validate_license(path_to_backup)
        self.assertEqual(valid, True, "License file is not valid")

    def test_server_available(self):
        self.assertEqual(db_is_dlse_lic_server_available(), True, "License server not available!")

if __name__ == '__main__':
    unittest.main()