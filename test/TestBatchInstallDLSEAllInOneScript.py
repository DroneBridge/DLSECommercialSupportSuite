import argparse
import unittest
from unittest.mock import Mock, patch

import batch_install_dlse_allinone as script
from dlse_cli_utils import resolve_resource_path
from DroneBridgeCommercialSupportSuite import DBLicenseType


class TestBatchInstallDLSEAllInOneScript(unittest.TestCase):
    def setUp(self):
        self.original_token = script.MY_SECRET_TOKEN
        self.original_release_path = script.DLSE_RELEASE_PATH
        self.original_settings_csv = script.PATH_SETTINGS_CSV
        self.original_start_index = script.START_DEVICE_ID
        self.original_baud = script.ESP_SERIAL_PORT_FLASH_BAUD_RATE
        self.original_license_type = script.LICENSE_TYPE
        self.original_validity_days = script.LICENSE_VALIDITY_DAYS

    def tearDown(self):
        script.MY_SECRET_TOKEN = self.original_token
        script.DLSE_RELEASE_PATH = self.original_release_path
        script.PATH_SETTINGS_CSV = self.original_settings_csv
        script.START_DEVICE_ID = self.original_start_index
        script.ESP_SERIAL_PORT_FLASH_BAUD_RATE = self.original_baud
        script.LICENSE_TYPE = self.original_license_type
        script.LICENSE_VALIDITY_DAYS = self.original_validity_days

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
            "evaluation": False,
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

    def test_parse_args_accepts_short_evaluation_flag(self):
        """The -e flag selects evaluation license mode."""
        with patch("sys.argv", ["batch_install_dlse_allinone.py", "-e"]):
            args = script.parse_args()

        self.assertTrue(args.evaluation)

    def test_parse_args_accepts_long_evaluation_flag(self):
        """The --evaluation flag selects evaluation license mode."""
        with patch("sys.argv", ["batch_install_dlse_allinone.py", "--evaluation"]):
            args = script.parse_args()

        self.assertTrue(args.evaluation)

    @patch.dict("batch_install_dlse_allinone.os.environ", {}, clear=True)
    def test_apply_args_defaults_to_activated_license(self):
        """Without -e, the installer requests regular activated licenses."""
        script.apply_args(self.make_args())

        self.assertEqual(DBLicenseType.ACTIVATED, script.LICENSE_TYPE)
        self.assertEqual(0, script.LICENSE_VALIDITY_DAYS)

    @patch.dict("batch_install_dlse_allinone.os.environ", {}, clear=True)
    def test_apply_args_sets_evaluation_license_mode(self):
        """With -e, the installer requests fixed 60-day evaluation licenses."""
        script.apply_args(self.make_args(evaluation=True))

        self.assertEqual(DBLicenseType.EVALUATION, script.LICENSE_TYPE)
        self.assertEqual(60, script.LICENSE_VALIDITY_DAYS)

    @patch("batch_install_dlse_allinone.db_api_request_license_file")
    @patch("batch_install_dlse_allinone.db_is_dlse_lic_server_available")
    def test_acquire_license_forwards_selected_evaluation_mode(self, server_available, request_license):
        """Online license acquisition forwards evaluation type and validity."""
        server_available.return_value = True
        request_license.return_value = "temp-license.dlselic"
        script.MY_SECRET_TOKEN = "token"
        script.LICENSE_TYPE = DBLicenseType.EVALUATION
        script.LICENSE_VALIDITY_DAYS = 60

        result = script.acquire_license_file("activation-key", "COM1", Mock())

        self.assertEqual("temp-license.dlselic", result)
        request_license.assert_called_once_with(
            "activation-key",
            "token",
            _license_type=DBLicenseType.EVALUATION,
            _validity_days=60,
        )

    @patch("batch_install_dlse_allinone.db_get_dlse_lic_via_serial")
    @patch("batch_install_dlse_allinone.db_get_dlse_lic_from_local_storage")
    @patch("batch_install_dlse_allinone.db_is_dlse_lic_server_available")
    def test_evaluation_mode_skips_offline_license_recovery(self, server_available, local_storage, serial_backup):
        """Evaluation licenses require the server and do not use activated-license offline fallback."""
        server_available.return_value = False
        script.LICENSE_TYPE = DBLicenseType.EVALUATION
        script.LICENSE_VALIDITY_DAYS = 60
        logger = Mock()

        result = script.acquire_license_file("activation-key", "COM1", logger)

        self.assertIsNone(result)
        local_storage.assert_not_called()
        serial_backup.assert_not_called()
        logger.log.assert_called_with(
            "❌ License server unavailable. Evaluation licenses cannot be created offline. Skipping device."
        )

    def test_mask_token_for_log_handles_empty_and_short_values(self):
        """Token logging stays masked and handles short values safely."""
        self.assertEqual("<missing>", script.mask_token_for_log(""))
        self.assertEqual("***", script.mask_token_for_log("abc"))
        self.assertEqual("abcd...wxyz", script.mask_token_for_log("abcd1234wxyz"))

    @patch.dict("batch_install_dlse_allinone.os.environ", {}, clear=True)
    @patch("batch_install_dlse_allinone.db_check_release_binaries_present")
    def test_main_rejects_placeholder_token_before_release_validation(self, check_release):
        """Placeholder activation tokens stop the CLI before release or serial checks."""
        script.MY_SECRET_TOKEN = "<ENTER YOUR TOKEN HERE - GET IT FROM DRONE-BRIDGE.COM WEBSITE>"
        with patch("sys.argv", ["batch_install_dlse_allinone.py"]):
            with self.assertRaises(SystemExit) as exit_context:
                script.main()

        self.assertEqual(2, exit_context.exception.code)
        check_release.assert_not_called()

    def test_resolve_resource_path_finds_bundled_notification_sound(self):
        """Bundled notification sounds can be resolved without playing audio."""
        path = resolve_resource_path("resources/new-notification-011-364050.wav")

        self.assertIsNotNone(path)
        self.assertTrue(path.exists())

    def test_resolve_resource_path_finds_bundled_public_key(self):
        """The installed CLI can resolve the bundled license validation public key."""
        path = resolve_resource_path("resources/pubkey_DLSE.pem")

        self.assertIsNotNone(path)
        self.assertTrue(path.exists())


if __name__ == "__main__":
    unittest.main()
