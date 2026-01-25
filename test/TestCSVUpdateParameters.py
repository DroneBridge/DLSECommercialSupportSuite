import unittest
import os
import csv
import tempfile
import shutil

from DroneBridgeCommercialSupportSuite import db_csv_update_parameters


class TestCSVUpdateParameters(unittest.TestCase):
    def setUp(self):
        """Create a temporary directory and test CSV file for each test"""
        self.test_dir = tempfile.mkdtemp()
        self.test_csv_path = os.path.join(self.test_dir, "test_params.csv")

        # Create a test CSV with sample data
        self.create_test_csv()

    def tearDown(self):
        """Clean up temporary directory after each test"""
        shutil.rmtree(self.test_dir)

    def create_test_csv(self):
        """Create a test CSV file with parameters"""
        with open(self.test_csv_path, 'w', newline='') as f:
            f.write("# Comment line\n")
            f.write("key,type,encoding,value\n")
            f.write("settings,namespace,,\n")
            f.write("ip_sta,data,string,192.168.50.10\n")
            f.write("wifi_hostname,data,string,Drone\n")
            f.write("ssid_ap,data,string,SSIDDrone\n")
            f.write("wifi_brcst_port,data,u16,14550\n")

    def read_csv_value(self, key):
        """Helper function to read a specific parameter value from the CSV"""
        with open(self.test_csv_path, 'r', newline='') as f:
            for line in f:
                if line.lstrip().startswith('#'):
                    continue
                if not line.strip():
                    continue

            # Re-read with proper CSV parsing
            f.seek(0)
            fieldnames = None
            for line in f:
                if line.lstrip().startswith('#'):
                    continue
                elif not fieldnames:
                    fieldnames = line.strip().split(',')
                else:
                    reader = csv.DictReader([line], fieldnames=fieldnames)
                    row = next(reader)
                    if row['key'] == key:
                        return row['value']
        return None

    def test_update_ip_with_index(self):
        """Test updating IP address last octet using _index parameter"""
        result = db_csv_update_parameters(self.test_csv_path, 3)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ip_sta'), '192.168.50.3')

    def test_update_hostname_with_index(self):
        """Test updating hostname by appending _index"""
        result = db_csv_update_parameters(self.test_csv_path, 5)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'Drone5')

    def test_update_ssid_ap_with_index(self):
        """Test updating ssid_ap by appending _index"""
        result = db_csv_update_parameters(self.test_csv_path, 7)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ssid_ap'), 'SSIDDrone7')

    def test_strip_existing_numbers_hostname(self):
        """Test that existing numbers at the end are stripped before appending _index"""
        # First update to add a number
        db_csv_update_parameters(self.test_csv_path, 10)
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'Drone10')

        # Update again with different index - should strip '10' and add '3'
        result = db_csv_update_parameters(self.test_csv_path, 3)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'Drone3')

    def test_strip_existing_numbers_ssid_ap(self):
        """Test that existing numbers in ssid_ap are stripped: SSIDDrone34 -> SSIDDrone3"""
        # Create CSV with ssid_ap ending in numbers
        with open(self.test_csv_path, 'w', newline='') as f:
            f.write("# Comment line\n")
            f.write("key,type,encoding,value\n")
            f.write("settings,namespace,,\n")
            f.write("ip_sta,data,string,192.168.50.10\n")
            f.write("wifi_hostname,data,string,Drone\n")
            f.write("ssid_ap,data,string,SSIDDrone34\n")
            f.write("wifi_brcst_port,data,u16,14550\n")

        result = db_csv_update_parameters(self.test_csv_path, 3)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ssid_ap'), 'SSIDDrone3')

    def test_update_with_custom_ip(self):
        """Test providing a custom IP address"""
        result = db_csv_update_parameters(self.test_csv_path, 5, new_ip='10.0.0.100')
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ip_sta'), '10.0.0.100')

    def test_update_with_custom_hostname(self):
        """Test providing a custom hostname"""
        result = db_csv_update_parameters(self.test_csv_path, 5, new_hostname='CustomDrone')
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'CustomDrone')

    def test_update_with_custom_ssid_ap(self):
        """Test providing a custom ssid_ap"""
        result = db_csv_update_parameters(self.test_csv_path, 5, new_ssid_ap='CustomSSID')
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ssid_ap'), 'CustomSSID')

    def test_update_all_parameters(self):
        """Test updating all three parameters at once"""
        result = db_csv_update_parameters(
            self.test_csv_path,
            8,
            new_ip='192.168.1.200',
            new_hostname='TestDrone',
            new_ssid_ap='TestSSID'
        )
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ip_sta'), '192.168.1.200')
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'TestDrone')
        self.assertEqual(self.read_csv_value('ssid_ap'), 'TestSSID')

    def test_invalid_ip_address(self):
        """Test that invalid IP addresses are rejected"""
        result = db_csv_update_parameters(self.test_csv_path, 5, new_ip='999.999.999.999')
        self.assertFalse(result)

    def test_nonexistent_file(self):
        """Test that function returns False for non-existent file"""
        result = db_csv_update_parameters("nonexistent.csv", 5)
        self.assertFalse(result)

    def test_csv_comments_preserved(self):
        """Test that comment lines are preserved in the output"""
        db_csv_update_parameters(self.test_csv_path, 3)

        with open(self.test_csv_path, 'r') as f:
            first_line = f.readline()
            self.assertTrue(first_line.startswith('# Comment'))

    def test_sta_ip_not_set_by_user(self):
        """Test that existing numbers in ssid_ap are stripped: SSIDDrone34 -> SSIDDrone3"""
        # Create CSV with ssid_ap ending in numbers
        with open(self.test_csv_path, 'w', newline='') as f:
            f.write("# Comment line\n")
            f.write("key,type,encoding,value\n")
            f.write("settings,namespace,,\n")
            f.write("ip_sta,data,string,\n")
            f.write("wifi_hostname,data,string,Drone\n")
            f.write("ssid_ap,data,string,SSIDDrone54\n")
            f.write("wifi_brcst_port,data,u16,14550\n")

        result = db_csv_update_parameters(self.test_csv_path, 3)
        self.assertTrue(result)
        self.assertEqual(self.read_csv_value('ip_sta'), '', "ip_sta should be empty since it was not set initially")
        self.assertEqual(self.read_csv_value('wifi_hostname'), 'Drone3')
        self.assertEqual(self.read_csv_value('ssid_ap'), 'SSIDDrone3')

if __name__ == '__main__':
    unittest.main()
