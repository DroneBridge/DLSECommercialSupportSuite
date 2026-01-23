import unittest

from DroneBridgeCommercialSupportSuite import db_merge_user_parameters_with_release


class MergeTestCase(unittest.TestCase):
    def test_merge_same_release(self):
        res = db_merge_user_parameters_with_release(r"test/test_resources/db_show_params_user_same_release.csv", r"test/test_resources/")
        self.assertNotEqual(res, None)  # add assertion here

    def test_merge_different_release(self):
        res = db_merge_user_parameters_with_release(r"test/test_resources/db_show_params_user_diff_release.csv", r"test/test_resources/")
        self.assertNotEqual(res, None)


if __name__ == '__main__':
    unittest.main()
