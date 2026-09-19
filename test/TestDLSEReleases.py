import io
import shutil
import unittest
import uuid
import zipfile
from contextlib import contextmanager
from pathlib import Path
from unittest.mock import Mock, patch

import requests

from DroneBridgeCommercialSupportSuite import (
    DBDLSERelease,
    DLSE_LICENSE_SERVER_BASE_URL,
    db_api_get_dlse_releases,
    db_build_dlse_releases_url,
    db_download_and_extract_dlse_release,
    db_find_extracted_dlse_release_root,
    db_list_offline_dlse_releases,
)


WORKSPACE_TEMP_DIR = Path.cwd()


@contextmanager
def workspace_temp_dir():
    """
    Create a temporary test directory in the writable workspace.

    :return: Context manager yielding the directory path as a string.
    """
    path = WORKSPACE_TEMP_DIR / f"tmp_test_{uuid.uuid4().hex}"
    path.mkdir()
    try:
        yield str(path)
    finally:
        shutil.rmtree(path, ignore_errors=True)


def build_release_zip(root_folder: str = "DroneBridge_ESP32DLSE_TEST") -> bytes:
    """
    Build an in-memory release zip containing the minimum files required by release validation.

    :param root_folder: Top-level folder name to include in the archive.
    :return: Zip archive bytes.
    """
    buffer = io.BytesIO()
    with zipfile.ZipFile(buffer, "w") as archive:
        archive.writestr(f"{root_folder}/db_show_params.csv", "key,type,encoding,value\n")
        for folder in ("esp32c3_generic", "esp32c5_generic", "esp32c6_generic"):
            archive.writestr(f"{root_folder}/{folder}/flash_args.txt", "0x0 db_esp32.bin\n")
    return buffer.getvalue()


def create_release_folder(path: Path) -> None:
    """
    Create a minimal valid extracted DLSE release folder for offline release tests.

    :param path: Directory to populate.
    :return: None.
    """
    path.mkdir(parents=True, exist_ok=True)
    (path / "db_show_params.csv").write_text("key,type,encoding,value\n", encoding="utf-8")
    for folder in ("esp32c3_generic", "esp32c5_generic", "esp32c6_generic"):
        chip_folder = path / folder
        chip_folder.mkdir()
        (chip_folder / "flash_args.txt").write_text("0x0 db_esp32.bin\n", encoding="utf-8")


class TestDLSEReleases(unittest.TestCase):
    def test_releases_url_uses_default_base_url(self):
        """The default releases endpoint is derived from the license server base URL."""
        self.assertEqual(
            f"{DLSE_LICENSE_SERVER_BASE_URL}/api/dlse/releases",
            db_build_dlse_releases_url(),
        )

    def test_releases_url_accepts_local_base_url(self):
        """Local test servers can be configured by passing only their base URL."""
        self.assertEqual(
            "http://127.0.0.1:8000/api/dlse/releases",
            db_build_dlse_releases_url("http://127.0.0.1:8000/"),
        )

    def test_releases_url_keeps_full_endpoint(self):
        """Existing callers can pass the full releases endpoint."""
        self.assertEqual(
            "http://127.0.0.1:8000/api/dlse/releases",
            db_build_dlse_releases_url("http://127.0.0.1:8000/api/dlse/releases"),
        )

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_get_releases_returns_typed_release_data(self, request_get, _logger):
        """Successful release listing returns typed release objects."""
        response = Mock(status_code=200)
        response.json.return_value = {
            "ok": True,
            "releases": [
                {
                    "release_date": "2026-05-01",
                    "name": "Drone Light Show Edition v1.0.0",
                    "download_link": "/userdownloads/dlse-v1.zip",
                }
            ],
        }
        request_get.return_value = response

        releases = db_api_get_dlse_releases("token", base_url="http://127.0.0.1:8000")

        self.assertEqual(1, len(releases))
        self.assertEqual("Drone Light Show Edition v1.0.0", releases[0].name)
        self.assertEqual("/userdownloads/dlse-v1.zip", releases[0].download_link)
        request_get.assert_called_once_with(
            "http://127.0.0.1:8000/api/dlse/releases",
            headers={"Authorization": "Bearer token", "Accept": "application/json"},
            timeout=(5, 30),
        )

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_get_releases_returns_none_for_unauthorized_token(self, request_get, _logger):
        """Invalid tokens return None without retrying non-transient 401 responses."""
        response = Mock(status_code=401)
        response.text = '{"ok": false}'
        request_get.return_value = response

        self.assertIsNone(db_api_get_dlse_releases("bad-token", base_url="http://127.0.0.1:8000"))
        request_get.assert_called_once()

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_get_releases_retries_transient_errors(self, request_get, _logger):
        """Transient release listing failures are retried before returning success."""
        first_response = Mock(status_code=503)
        first_response.text = '{"ok": false}'
        second_response = Mock(status_code=200)
        second_response.json.return_value = {"ok": True, "releases": []}
        request_get.side_effect = [first_response, second_response]

        with patch("DroneBridgeCommercialSupportSuite.time.sleep"):
            releases = db_api_get_dlse_releases("token", base_url="http://127.0.0.1:8000")

        self.assertEqual([], releases)
        self.assertEqual(2, request_get.call_count)

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_get_releases_rejects_malformed_entries(self, request_get, _logger):
        """Release listing rejects entries missing fields needed by the UI and downloader."""
        response = Mock(status_code=200)
        response.json.return_value = {"ok": True, "releases": [{"name": "missing fields"}]}
        request_get.return_value = response

        self.assertIsNone(db_api_get_dlse_releases("token", base_url="http://127.0.0.1:8000"))

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_download_extracts_release_root_and_deletes_zip(self, request_get, _logger):
        """Downloaded release zips are extracted and removed after validation succeeds."""
        zip_bytes = build_release_zip()
        response = Mock(status_code=200)
        response.iter_content.return_value = [zip_bytes]
        request_get.return_value = response
        release = DBDLSERelease(
            release_date="2026-05-01",
            name="Drone Light Show Edition v1.0.0",
            download_link="/userdownloads/dlse-v1.zip",
        )

        with workspace_temp_dir() as temp_dir:
            stale_folder = Path(temp_dir) / release.safe_folder_name
            stale_folder.mkdir()
            (stale_folder / "stale.txt").write_text("old", encoding="utf-8")

            release_root = db_download_and_extract_dlse_release(
                release,
                "token",
                output_dir=temp_dir,
                base_url="http://127.0.0.1:8000",
            )

            release_root_path = Path(release_root)
            self.assertTrue((release_root_path / "db_show_params.csv").exists())
            self.assertFalse((Path(temp_dir) / f"{release.safe_folder_name}.zip").exists())
            self.assertFalse((stale_folder / "stale.txt").exists())

        request_get.assert_called_once()
        self.assertEqual("http://127.0.0.1:8000/userdownloads/dlse-v1.zip", request_get.call_args.args[0])
        self.assertEqual("Bearer token", request_get.call_args.kwargs["headers"]["Authorization"])

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_download_keeps_zip_when_validation_fails(self, request_get, _logger):
        """Invalid release contents leave the downloaded zip for diagnostics."""
        buffer = io.BytesIO()
        with zipfile.ZipFile(buffer, "w") as archive:
            archive.writestr("not-a-release/readme.txt", "invalid")
        response = Mock(status_code=200)
        response.iter_content.return_value = [buffer.getvalue()]
        request_get.return_value = response

        with workspace_temp_dir() as temp_dir:
            release_root = db_download_and_extract_dlse_release(
                "/userdownloads/broken.zip",
                "token",
                output_dir=temp_dir,
                base_url="http://127.0.0.1:8000",
            )

            self.assertIsNone(release_root)
            self.assertTrue((Path(temp_dir) / "broken.zip").exists())

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_download_rejects_unsafe_zip_member(self, request_get, _logger):
        """Zip members that escape the extraction folder are rejected."""
        buffer = io.BytesIO()
        with zipfile.ZipFile(buffer, "w") as archive:
            archive.writestr("../escape.txt", "unsafe")
        response = Mock(status_code=200)
        response.iter_content.return_value = [buffer.getvalue()]
        request_get.return_value = response

        with workspace_temp_dir() as temp_dir:
            release_root = db_download_and_extract_dlse_release(
                "/userdownloads/unsafe.zip",
                "token",
                output_dir=temp_dir,
                base_url="http://127.0.0.1:8000",
            )

            self.assertIsNone(release_root)
            self.assertFalse((Path(temp_dir).parent / "escape.txt").exists())

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    def test_list_offline_releases_returns_only_valid_release_folders(self, _logger):
        """Offline release scanning skips incomplete local folders."""
        with workspace_temp_dir() as temp_dir:
            valid_release = Path(temp_dir) / "valid"
            invalid_release = Path(temp_dir) / "invalid"
            create_release_folder(valid_release)
            invalid_release.mkdir()

            self.assertEqual([str(valid_release)], db_list_offline_dlse_releases(temp_dir))

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    def test_list_offline_releases_returns_nested_release_root(self, _logger):
        """Offline cached downloads return the nested release root used by flash scripts."""
        with workspace_temp_dir() as temp_dir:
            cache_folder = Path(temp_dir) / "2026-04-21_21_07_14_v1.0.0_BETA5"
            nested_release = cache_folder / "DroneBridge_ESP32DLSE_BETA5"
            create_release_folder(nested_release)

            self.assertEqual([str(nested_release)], db_list_offline_dlse_releases(temp_dir))

    def test_find_extracted_release_root_accepts_outer_cache_folder(self):
        """Release-root discovery maps outer cache folders to the actual nested release root."""
        with workspace_temp_dir() as temp_dir:
            cache_folder = Path(temp_dir) / "2026-04-21_21_07_14_v1.0.0_BETA5"
            nested_release = cache_folder / "DroneBridge_ESP32DLSE_BETA5"
            create_release_folder(nested_release)

            self.assertEqual(nested_release, db_find_extracted_dlse_release_root(cache_folder))

    @patch("DroneBridgeCommercialSupportSuite.DBLogger")
    @patch("DroneBridgeCommercialSupportSuite.requests.get")
    def test_download_returns_none_on_network_error(self, request_get, _logger):
        """Download request failures return None instead of raising to CLI/UI callers."""
        request_get.side_effect = requests.ConnectionError("offline")

        with workspace_temp_dir() as temp_dir:
            with patch("DroneBridgeCommercialSupportSuite.time.sleep"):
                result = db_download_and_extract_dlse_release(
                    "/userdownloads/dlse-v1.zip",
                    "token",
                    output_dir=temp_dir,
                    base_url="http://127.0.0.1:8000",
                )

        self.assertIsNone(result)
        self.assertEqual(3, request_get.call_count)


if __name__ == "__main__":
    unittest.main()
