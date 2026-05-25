import argparse
import unittest
from unittest.mock import patch

import batch_install_dlse_allinone as script


class TestBatchInstallDLSEAllInOneScript(unittest.TestCase):
    def setUp(self):
        self.original_token = script.MY_SECRET_TOKEN
        self.original_release_path = script.DLSE_RELEASE_PATH
        self.original_settings_csv = script.PATH_SETTINGS_CSV
        self.original_start_index = script.START_DEVICE_ID
        self.original_baud = script.ESP_SERIAL_PORT_FLASH_BAUD_RATE

    def tearDown(self):
        script.MY_SECRET_TOKEN = self.original_token
        script.DLSE_RELEASE_PATH = self.original_release_path
        script.PATH_SETTINGS_CSV = self.original_settings_csv
        script.START_DEVICE_ID = self.original_start_index
        script.ESP_SERIAL_PORT_FLASH_BAUD_RATE = self.original_baud

    @staticmethod
    def make_args(**overrides):
        """
        Build an argparse namespace matching ``batch_install_dlse_allinone`` arguments.

        :param overrides: Optional argument values to override the defaults.
        :return: Namespace suitable for ``script.apply_args``.
        """
        defaults = {
            "token": None,
            "release_folder": None,
            "settings_file": None,
            "start_index": None,
            "baud": None,
        }
        defaults.update(overrides)
        return argparse.Namespace(**defaults)

    @patch.dict("batch_install_dlse_allinone.os.environ", {}, clear=True)
    def test_apply_args_keeps_default_token_without_env_or_cli(self):
        """Without environment or CLI token, the configured default remains active."""
        script.apply_args(self.make_args())

        self.assertEqual(self.original_token, script.MY_SECRET_TOKEN)

    @patch.dict("batch_install_dlse_allinone.os.environ", {"DRONEBRIDGE_SECRET_TOKEN": "env-token"}, clear=True)
    def test_apply_args_uses_environment_token(self):
        """The DRONEBRIDGE_SECRET_TOKEN environment variable sets the token."""
        script.apply_args(self.make_args())

        self.assertEqual("env-token", script.MY_SECRET_TOKEN)

    @patch.dict("batch_install_dlse_allinone.os.environ", {"DRONEBRIDGE_SECRET_TOKEN": "env-token"}, clear=True)
    def test_apply_args_cli_token_overrides_environment_token(self):
        """The explicit --token argument takes precedence over the environment."""
        script.apply_args(self.make_args(token="cli-token"))

        self.assertEqual("cli-token", script.MY_SECRET_TOKEN)

    @patch.dict("batch_install_dlse_allinone.os.environ", {}, clear=True)
    def test_apply_args_updates_other_cli_settings(self):
        """Existing command-line settings still update installer configuration."""
        script.apply_args(self.make_args(
            release_folder="release",
            settings_file="settings.csv",
            start_index=0,
            baud=115200,
        ))

        self.assertEqual("release", script.DLSE_RELEASE_PATH)
        self.assertEqual("settings.csv", script.PATH_SETTINGS_CSV)
        self.assertEqual(0, script.START_DEVICE_ID)
        self.assertEqual(115200, script.ESP_SERIAL_PORT_FLASH_BAUD_RATE)

    def test_parse_args_accepts_token_argument(self):
        """Argument parsing still accepts the existing --token option."""
        with patch("sys.argv", ["batch_install_dlse_allinone.py", "--token", "cli-token"]):
            args = script.parse_args()

        self.assertEqual("cli-token", args.token)

    def test_mask_token_for_log_handles_empty_and_short_values(self):
        """Token logging stays masked and handles short values safely."""
        self.assertEqual("<missing>", script.mask_token_for_log(""))
        self.assertEqual("***", script.mask_token_for_log("abc"))
        self.assertEqual("abcd...wxyz", script.mask_token_for_log("abcd1234wxyz"))


if __name__ == "__main__":
    unittest.main()
