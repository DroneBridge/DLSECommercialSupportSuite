import csv
import unittest
from pathlib import Path

from DroneBridgeCommercialSupportSuite import db_csv_merge_user_parameters_with_release


class MergeTestCase(unittest.TestCase):
    """Verify CSV merging independently of the test runner's working directory."""

    RESOURCE_ROOT = Path(__file__).resolve().parent / "test_resources"

    def _assert_merged_password(self, fixture_name: str) -> None:
        """
        Merge one user fixture and verify its Wi-Fi password is retained.

        :param fixture_name: Filename located under ``test/test_resources``.
        :return: None. The generated temporary output is removed after the test.
        """
        result = db_csv_merge_user_parameters_with_release(
            str(self.RESOURCE_ROOT / fixture_name),
            str(self.RESOURCE_ROOT),
        )
        self.assertIsNotNone(result)
        output_path = Path(result)
        self.addCleanup(output_path.unlink, missing_ok=True)

        with output_path.open(mode="r", newline="") as csvfile:
            reader = csv.DictReader(csvfile)
            password = next(
                row["value"] for row in reader if row["key"] == "wifi_pass"
            )
        self.assertEqual("DifferentPassword", password)

    def test_merge_same_release(self):
        """Parameters from a matching release merge successfully."""
        self._assert_merged_password("db_show_params_user_same_release.csv")

    def test_merge_different_release(self):
        """Known parameters survive when release schemas differ."""
        self._assert_merged_password("db_show_params_user_diff_release.csv")


if __name__ == "__main__":
    unittest.main()
