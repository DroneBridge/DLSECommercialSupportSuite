import unittest
from pathlib import Path
from unittest.mock import Mock, patch

from DroneBridgeCommercialSupportSuite import DBDLSERelease
from dlse_release_cli_utils import (
    default_settings_file_for_release,
    resolve_dlse_release_folder_interactive,
    select_and_validate_dlse_release_folder,
)


class TestDLSEReleaseCLIUtils(unittest.TestCase):
    def test_explicit_release_folder_is_returned_without_prompting(self):
        """Manual --release-folder paths preserve the existing non-interactive workflow."""
        logger = Mock()

        result = resolve_dlse_release_folder_interactive("manual-release", "token", logger)

        self.assertEqual("manual-release", result)

    @patch("dlse_release_cli_utils.db_check_release_binaries_present", return_value=True)
    @patch("dlse_release_cli_utils.db_find_extracted_dlse_release_root", return_value=None)
    def test_select_and_validate_accepts_valid_manual_folder(self, _find_root, check_release):
        """The selector validates manual release folders before hardware operations."""
        logger = Mock()

        result = select_and_validate_dlse_release_folder("manual-release", "token", logger)

        self.assertEqual("manual-release", result)
        check_release.assert_called_once_with("manual-release")

    @patch("dlse_release_cli_utils.db_check_release_binaries_present", return_value=False)
    @patch("dlse_release_cli_utils.db_find_extracted_dlse_release_root", return_value=None)
    def test_select_and_validate_rejects_invalid_manual_folder(self, _find_root, _check_release):
        """Invalid release folders stop the workflow before flashing or OTA."""
        logger = Mock()

        self.assertIsNone(select_and_validate_dlse_release_folder("bad-release", "token", logger))

    @patch("dlse_release_cli_utils.db_check_release_binaries_present", return_value=True)
    @patch("dlse_release_cli_utils.db_find_extracted_dlse_release_root")
    def test_select_and_validate_normalizes_outer_cache_folder(self, find_root, check_release):
        """Outer cache folders are normalized to their nested release root before validation."""
        logger = Mock()
        find_root.return_value = Path("dlse_releases") / "cache-folder" / "DroneBridge_ESP32DLSE_BETA5"

        result = select_and_validate_dlse_release_folder("dlse_releases/cache-folder", "token", logger)

        expected = str(Path("dlse_releases") / "cache-folder" / "DroneBridge_ESP32DLSE_BETA5")
        self.assertEqual(expected, result)
        check_release.assert_called_once_with(expected)

    @patch("dlse_release_cli_utils.input", return_value="1")
    @patch("dlse_release_cli_utils.db_api_get_dlse_releases")
    @patch("dlse_release_cli_utils.db_list_offline_dlse_releases", return_value=["cached-release"])
    def test_interactive_selection_can_pick_offline_release(self, _offline, get_releases, _input):
        """Offline cached releases can be selected without downloading anything."""
        logger = Mock()
        get_releases.return_value = []

        result = resolve_dlse_release_folder_interactive(None, "token", logger)

        self.assertEqual("cached-release", result)

    @patch("dlse_release_cli_utils.input", return_value="1")
    @patch("dlse_release_cli_utils.db_download_and_extract_dlse_release", return_value="downloaded-release")
    @patch("dlse_release_cli_utils.db_api_get_dlse_releases")
    @patch("dlse_release_cli_utils.db_list_offline_dlse_releases", return_value=[])
    def test_interactive_selection_can_download_online_release(self, _offline, get_releases, download_release, _input):
        """Online release choices download and return the extracted release root."""
        logger = Mock()
        release = DBDLSERelease("2026-05-01", "DLSE v1.0.0", "/userdownloads/dlse-v1.zip")
        get_releases.return_value = [release]

        result = resolve_dlse_release_folder_interactive(None, "token", logger)

        self.assertEqual("downloaded-release", result)
        download_release.assert_called_once_with(release, "token", output_dir="dlse_releases")

    @patch("dlse_release_cli_utils.input", return_value="manual-release")
    @patch("dlse_release_cli_utils.db_api_get_dlse_releases")
    @patch("dlse_release_cli_utils.db_list_offline_dlse_releases", return_value=[])
    def test_interactive_selection_prompts_manual_path_without_available_releases(self, _offline, get_releases, _input):
        """The operator can still enter a manual path when no cache or online list is available."""
        logger = Mock()
        get_releases.return_value = []

        result = resolve_dlse_release_folder_interactive(None, "token", logger)

        self.assertEqual("manual-release", result)

    def test_default_settings_file_uses_selected_release_folder(self):
        """Installer defaults can point at the settings CSV in the selected release."""
        self.assertEqual("release-root\\db_show_params.csv", default_settings_file_for_release("release-root"))


if __name__ == "__main__":
    unittest.main()
