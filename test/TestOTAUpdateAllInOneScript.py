import argparse
import unittest
from unittest.mock import patch

import batch_ota_update_allinone as script


class TestOTAUpdateAllInOneScript(unittest.TestCase):
    def setUp(self):
        self.original_release_path = script.DLSE_RELEASE_PATH
        self.original_target_version = script.TARGET_VERSION
        self.original_subnet = script.SUBNET_MASK
        self.original_local_port = script.ESP32_LOCAL_BROADCAST_PORT
        self.original_remote_port = script.ESP32_REMOTE_BROADCAST_PORT

    def tearDown(self):
        script.DLSE_RELEASE_PATH = self.original_release_path
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
            "--target-version",
            "1.0.0-beta.5",
        ]):
            args = script.parse_args()

        self.assertEqual("release", args.release_folder)
        self.assertEqual("1.0.0-beta.5", args.target_version)

    def test_apply_args_updates_ota_update_settings(self):
        """Command-line settings update the OTA update configuration."""
        args = argparse.Namespace(
            release_folder="release",
            subnetmask="192.168.20.0/24",
            esp32localbrcstport=15000,
            esp32remotebrcstport=15001,
            target_version="1.0.0-beta.5",
        )

        script.apply_args(args)

        self.assertEqual("release", script.DLSE_RELEASE_PATH)
        self.assertEqual("192.168.20.0/24", script.SUBNET_MASK)
        self.assertEqual(15000, script.ESP32_LOCAL_BROADCAST_PORT)
        self.assertEqual(15001, script.ESP32_REMOTE_BROADCAST_PORT)
        self.assertEqual("1.0.0-beta.5", script.TARGET_VERSION)


if __name__ == "__main__":
    unittest.main()
