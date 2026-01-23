import unittest
import os
import tempfile
import shutil
from DroneBridgeCommercialSupportSuite import db_create_address_binary_map


class TestAddressBinaryMap(unittest.TestCase):

    def setUp(self):
        """Create temporary directory structure for testing"""
        self.test_dir = tempfile.mkdtemp()
        self.bin_folder = os.path.join(self.test_dir, "esp32c5_generic")
        os.makedirs(self.bin_folder)

    def tearDown(self):
        """Clean up temporary directory"""
        shutil.rmtree(self.test_dir)

    def test_valid_flash_args(self):
        """Test parsing a valid flash_args.txt file"""
        # Create a sample flash_args.txt
        flash_args_content = """--flash_mode dio --flash_freq 80m --flash_size 4MB
                                0x0 bootloader/bootloader.bin
                                0x20000 db_esp32.bin
                                0x8000 partition_table/partition-table.bin
                                0xf000 ota_data_initial.bin
                                0x3ac000 www.bin
                                """

        flash_args_path = os.path.join(self.bin_folder, "flash_args.txt")
        with open(flash_args_path, 'w') as f:
            f.write(flash_args_content)

        # Test with ESP32-C5 chip ID (23)
        settings_bin = "/path/to/settings.bin"
        result = db_create_address_binary_map(23, self.test_dir, settings_bin)

        self.assertIsNotNone(result)
        self.assertEqual(len(result), 6)
        self.assertEqual(result[0x0], os.path.join(self.test_dir, "esp32c5_generic", "bootloader.bin"))
        self.assertEqual(result[0x8000], os.path.join(self.test_dir, "esp32c5_generic", "partition-table.bin"))
        self.assertEqual(result[0x9000], settings_bin)  # Should use custom settings partition
        self.assertEqual(result[0xf000], os.path.join(self.test_dir, "esp32c5_generic", "ota_data_initial.bin"))
        self.assertEqual(result[0x20000], os.path.join(self.test_dir, "esp32c5_generic", "db_esp32.bin"))
        self.assertEqual(result[0x3ac000], os.path.join(self.test_dir, "esp32c5_generic", "www.bin"))

    def test_flash_args_with_paths(self):
        """Test parsing flash_args.txt with full paths (should extract filename only)"""
        flash_args_content = """0x0 /some/path/bootloader.bin
0x8000 ../another/path/partition-table.bin
0x20000 db_esp32.bin"""

        flash_args_path = os.path.join(self.bin_folder, "flash_args.txt")
        with open(flash_args_path, 'w') as f:
            f.write(flash_args_content)

        settings_bin = "/custom/settings.bin"
        result = db_create_address_binary_map(23, self.test_dir, settings_bin)

        self.assertIsNotNone(result)
        # Should extract just the filename, not the full path
        self.assertEqual(result[0x0], os.path.join(self.test_dir, "esp32c5_generic", "bootloader.bin"))
        self.assertEqual(result[0x8000], os.path.join(self.test_dir, "esp32c5_generic", "partition-table.bin"))
        self.assertEqual(result[0x9000], settings_bin)

    def test_missing_flash_args_file(self):
        """Test behavior when flash_args.txt doesn't exist"""
        result = db_create_address_binary_map(23, self.test_dir, "/path/to/settings.bin")
        self.assertIsNone(result)

    def test_empty_flash_args_file(self):
        """Test parsing an empty flash_args.txt file"""
        flash_args_path = os.path.join(self.bin_folder, "flash_args.txt")
        with open(flash_args_path, 'w') as f:
            f.write("")

        result = db_create_address_binary_map(23, self.test_dir, "/path/to/settings.bin")

        self.assertIsNotNone(result)
        self.assertEqual(len(result), 1)  # Only settings partition should be present
        self.assertEqual(result[0x9000], "/path/to/settings.bin")

    def test_different_chip_ids(self):
        """Test with different chip IDs (C3, C5, C6)"""
        # Create flash_args.txt for C3
        c3_folder = os.path.join(self.test_dir, "esp32c3_generic")
        os.makedirs(c3_folder)
        flash_args_path = os.path.join(c3_folder, "flash_args.txt")
        with open(flash_args_path, 'w') as f:
            f.write("0x0 bootloader.bin\n0x8000 partition-table.bin")

        result = db_create_address_binary_map(5, self.test_dir, "/settings.bin")  # ESP32-C3
        self.assertIsNotNone(result)
        self.assertIn(0x0, result)
        self.assertEqual(result[0x9000], "/settings.bin")


if __name__ == '__main__':
    unittest.main()
