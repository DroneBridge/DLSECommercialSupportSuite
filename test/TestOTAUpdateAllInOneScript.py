import argparse
import unittest
from unittest.mock import patch

import batch_ota_update_allinone as script


class TestOTAUpdateAllInOneScript(unittest.TestCase):
    def setUp(self):
        self.original_release_path = script.DLSE_RELEASE_PATH
        self.original_token = script.MY_SECRET_TOKEN
        self.original_target_version = script.TARGET_VERSION
        self.original_subnet = script.SUBNET_MASK
        self.original_local_port = script.ESP32_LOCAL_BROADCAST_PORT
        self.original_remote_port = script.ESP32_REMOTE_BROADCAST_PORT

    def tearDown(self):
        script.DLSE_RELEASE_PATH = self.original_release_path
        script.MY_SECRET_TOKEN = self.original_token
        script.TARGET_VERSION = self.original_target_version
        script.SUBNET_MASK = self.original_subnet
        script.ESP32_LOCAL_BROADCAST_PORT = self.original_local_port
        script.ESP32_REMOTE_BROADCAST_PORT = self.original_remote_port

    def test_parse_args_accepts_release_folder_and_target_version(self):
        """The installed dlse-update command keeps the existing OTA update options."""
        with patch("sys.argv", [
            "dlse-update",
            "--release-folder",
            "release",
            "--token",
            "download-token",
            "--target-version",
            "1.0.0-beta.5",
        ]):
            args = script.parse_args()

        self.assertEqual("release", args.release_folder)
        self.assertEqual("download-token", args.token)
        self.assertEqual("1.0.0-beta.5", args.target_version)

    @patch.dict("batch_ota_update_allinone.os.environ", {}, clear=True)
    def test_apply_args_updates_ota_update_settings(self):
        """Command-line settings update the OTA update configuration."""
        args = argparse.Namespace(
            release_folder="release",
            token="cli-token",
            subnetmask="192.168.20.0/24",
            esp32localbrcstport=15000,
            esp32remotebrcstport=15001,
            target_version="1.0.0-beta.5",
        )

        script.apply_args(args)

        self.assertEqual("release", script.DLSE_RELEASE_PATH)
        self.assertEqual("cli-token", script.MY_SECRET_TOKEN)
        self.assertEqual("192.168.20.0/24", script.SUBNET_MASK)
        self.assertEqual(15000, script.ESP32_LOCAL_BROADCAST_PORT)
        self.assertEqual(15001, script.ESP32_REMOTE_BROADCAST_PORT)
        self.assertEqual("1.0.0-beta.5", script.TARGET_VERSION)

    @patch.dict("batch_ota_update_allinone.os.environ", {"DRONEBRIDGE_SECRET_TOKEN": "env-token"}, clear=True)
    def test_apply_args_uses_environment_token_for_release_downloads(self):
        """The OTA updater can use DRONEBRIDGE_SECRET_TOKEN for release downloads."""
        args = argparse.Namespace(
            release_folder=None,
            token=None,
            subnetmask=None,
            esp32localbrcstport=None,
            esp32remotebrcstport=None,
            target_version=None,
        )

        script.apply_args(args)

        self.assertEqual("env-token", script.MY_SECRET_TOKEN)


if __name__ == "__main__":
    unittest.main()
