"""Tests for shared REST, CSV, and OTA helpers used by the Fleet Manager."""

import csv
import tempfile
import unittest
from pathlib import Path
from unittest.mock import Mock, patch

import requests

from DroneBridgeCommercialSupportSuite import (
    DBOtaStage,
    db_api_ota_update_device,
    db_api_update_settings,
    db_settings_from_csv,
    db_settings_to_csv,
)


class TestFleetSupportApis(unittest.TestCase):
    """Verify UI-facing support APIs without hardware or network access."""

    def test_settings_update_posts_partial_payload(self):
        """Settings updates send only the supplied keys and return a structured result."""
        session = Mock()
        response = Mock(status_code=200, text="")
        response.json.return_value = {"status": "success", "msg": "Settings changed"}
        session.post.return_value = response

        result = db_api_update_settings(
            session, "192.168.1.42", {"wifi_chan": 6}, timeout=2.5, logger=Mock()
        )

        self.assertTrue(result.success)
        session.post.assert_called_once_with(
            "http://192.168.1.42/api/settings",
            json={"wifi_chan": 6},
            headers={"Accept": "application/json"},
            timeout=2.5,
        )

    def test_settings_update_reports_armed_rejection(self):
        """HTTP 422 settings responses are returned instead of raised."""
        session = Mock()
        response = Mock(status_code=422, text="")
        response.json.return_value = {"status": "failed", "msg": "Cannot change settings while drone is armed"}
        session.post.return_value = response

        result = db_api_update_settings(session, "192.168.1.42", {"baud": 115200}, logger=Mock())

        self.assertFalse(result.success)
        self.assertEqual(422, result.status_code)
        self.assertIn("armed", result.message)

    def test_settings_csv_round_trip(self):
        """REST settings survive NVS-compatible CSV export and import."""
        with tempfile.TemporaryDirectory(dir=".") as directory:
            path = Path(directory) / "settings.csv"
            settings = {
                "wifi_hostname": "Drone1",
                "wifi_chan": 6,
                "baud": 57600,
                "data_types": ["string", "u8", "i32"],
                "wifi_chan_type": "number",
            }
            self.assertTrue(db_settings_to_csv(settings, path))
            with path.open("r", newline="", encoding="utf-8") as csv_file:
                rows = list(csv.DictReader(csv_file))
                self.assertNotIn(
                    "data_types",
                    [row["key"] for row in rows],
                )
                self.assertEqual(
                    ["settings", "wifi_hostname", "wifi_chan", "baud"],
                    [row["key"] for row in rows],
                )
                self.assertEqual(
                    {"wifi_hostname": "string", "wifi_chan": "u8", "baud": "i32"},
                    {row["key"]: row["encoding"] for row in rows if row["type"] == "data"},
                )
            self.assertEqual(
                {"wifi_hostname": "Drone1", "wifi_chan": 6, "baud": 57600},
                db_settings_from_csv(path),
            )

    @patch("DroneBridgeCommercialSupportSuite.time.sleep")
    @patch("DroneBridgeCommercialSupportSuite.db_api_get_json")
    def test_ota_preserves_www_wait_firmware_order(self, get_json, _sleep):
        """OTA uploads WWW first, waits, then uploads the application image."""
        get_json.return_value = {"esp_chip_model": 5}
        session = Mock()
        session.post.return_value = Mock(status_code=200)
        progress = []
        with tempfile.TemporaryDirectory(dir=".") as directory:
            root = Path(directory)
            www = root / "www.bin"
            firmware = root / "db_esp32.bin"
            www.write_bytes(b"www")
            firmware.write_bytes(b"firmware")

            result = db_api_ota_update_device(
                session,
                "192.168.1.42",
                www_path=www,
                firmware_path=firmware,
                progress_callback_fn=progress.append,
                logger=Mock(),
            )

        self.assertTrue(result.success)
        self.assertEqual(
            ["http://192.168.1.42/update/www", "http://192.168.1.42/update/firmware"],
            [call.args[0] for call in session.post.call_args_list],
        )
        self.assertEqual(DBOtaStage.COMPLETE, progress[-1].stage)

    @patch("DroneBridgeCommercialSupportSuite.db_api_get_json", return_value={"esp_chip_model": 99})
    def test_ota_rejects_unsupported_chip(self, _get_json):
        """Unsupported chip IDs fail before any binary upload."""
        session = Mock(spec=requests.Session)
        result = db_api_ota_update_device(
            session, "192.168.1.42", www_path="www.bin", firmware_path="app.bin", logger=Mock()
        )
        self.assertFalse(result.success)
        session.post.assert_not_called()


if __name__ == "__main__":
    unittest.main()
