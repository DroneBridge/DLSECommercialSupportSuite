import unittest

from DroneBridgeCommercialSupportSuite import db_get_dlse_lic_via_serial, db_is_dlse_lic_server_available


class SerialLicenseBackup(unittest.TestCase):
    def test_read_extract_license(self):
        path_to_backup = db_get_dlse_lic_via_serial("COM21")
        #is_valid = db_dlse_validate_license(path_to_backup)
        self.assertNotEqual(path_to_backup, None)

    def test_server_available(self):
        self.assertEqual(db_is_dlse_lic_server_available(), True)

if __name__ == '__main__':
    unittest.main()