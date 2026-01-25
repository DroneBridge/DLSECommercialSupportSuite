import unittest
import csv

from DroneBridgeCommercialSupportSuite import db_csv_merge_user_parameters_with_release


class MergeTestCase(unittest.TestCase):
    def test_merge_same_release(self):
        res = db_csv_merge_user_parameters_with_release(r"test_resources/db_show_params_user_same_release.csv", r"test_resources/")
        self.assertNotEqual(res, None)
        
        with open(res, mode='r') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                if row['key'] == 'wifi_pass':
                    self.assertEqual(row['value'], 'DifferentPassword')
                    break

    def test_merge_different_release(self):
        res = db_csv_merge_user_parameters_with_release(r"test_resources/db_show_params_user_diff_release.csv", r"test_resources/")
        self.assertNotEqual(res, None)
        with open(res, mode='r') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                if row['key'] == 'wifi_pass':
                    self.assertEqual(row['value'], 'DifferentPassword')
                    break


if __name__ == '__main__':
    unittest.main()
