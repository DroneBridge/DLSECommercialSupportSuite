"""Tests for bounded and cancellable Fleet Manager workers."""

import unittest
from threading import Barrier, Lock
from time import sleep
from types import SimpleNamespace
from unittest.mock import Mock, patch

from DroneBridgeCommercialSupportSuite import DBDLSERelease
from ui.models import DeviceRecord
from ui.workers import (
    DiscoveryWorker,
    OtaReleaseListWorker,
    OtaReleaseResolveWorker,
    OtaWorker,
    StatsPollingWorker,
)


class TestFleetWorkers(unittest.TestCase):
    """Verify worker queue behavior without hardware or network access."""

    @patch("ui.workers.db_list_offline_dlse_releases", return_value=["cached-release"])
    @patch("ui.workers.db_api_get_dlse_releases")
    def test_ota_release_listing_prefers_latest_online_release(self, get_releases, _offline):
        """Online releases are sorted newest-first before cached release options."""
        get_releases.return_value = [
            DBDLSERelease("2026-04-01", "DLSE v1.0.0", "/old.zip"),
            DBDLSERelease("2026-06-01", "DLSE v1.1.0", "/new.zip"),
        ]
        worker = OtaReleaseListWorker("token")
        finished = []
        worker.signals.finished.connect(finished.append)

        worker.run()

        options = finished[0]["options"]
        self.assertEqual("2026-06-01", options[0]["releaseDate"])
        self.assertEqual("online", options[0]["source"])
        self.assertIn("latest", options[0]["label"])
        self.assertEqual("cached", options[-1]["source"])

    @patch("ui.workers.db_download_and_extract_dlse_release", return_value=None)
    def test_ota_release_resolve_reports_failed_download(self, download_release):
        """A failed online release download emits an error instead of a path."""
        release = DBDLSERelease("2026-06-01", "DLSE v1.1.0", "/new.zip")
        worker = OtaReleaseResolveWorker({
            "id": "online:1",
            "source": "online",
            "release": release,
        }, "token")
        errors = []
        finished = []
        worker.signals.error.connect(errors.append)
        worker.signals.finished.connect(finished.append)

        worker.run()

        download_release.assert_called_once_with(release, "token")
        self.assertEqual([], finished)
        self.assertIn("download", errors[0].lower())

    @patch("ui.workers.db_check_release_binaries_present", return_value=True)
    @patch("ui.workers.db_find_extracted_dlse_release_root", return_value=None)
    def test_ota_release_resolve_accepts_cached_release_path(self, _find_root, check_release):
        """Cached release options resolve directly after binary validation."""
        worker = OtaReleaseResolveWorker({
            "id": "cached:1",
            "source": "cached",
            "path": "cached-release",
        }, "")
        finished = []
        worker.signals.finished.connect(finished.append)

        worker.run()

        check_release.assert_called_once_with("cached-release")
        self.assertEqual("cached-release", finished[0]["release_path"])

    def test_ota_cancellation_stops_not_started_records(self):
        """Cancelling during one upload leaves later queued records unstarted."""
        records = [
            DeviceRecord(identity=f"KEY-{index}", ip=f"192.168.1.{index + 2}")
            for index in range(4)
        ]
        worker = OtaWorker(records, None, None, None, workers=1)
        started = []
        finished = []

        def update(record):
            """Cancel the queue after the first active upload starts."""
            started.append(record.identity)
            worker.cancel()
            return SimpleNamespace(success=True)

        worker._update_one = update
        worker.signals.finished.connect(finished.append)
        worker.run()

        self.assertEqual(["KEY-0"], started)
        self.assertEqual(1, len(finished[0]))

    def test_ota_target_version_skips_nonmatching_records(self):
        """Exact target filtering reports skipped records without updating them."""
        records = [
            DeviceRecord(identity="A", ip="192.168.1.2", firmware_version="1.0"),
            DeviceRecord(identity="B", ip="192.168.1.3", firmware_version="2.0"),
        ]
        worker = OtaWorker(records, None, None, None, workers=1, target_version="1.0")
        statuses = []
        worker._update_one = lambda _record: SimpleNamespace(success=True)
        worker.signals.progress.connect(statuses.append)
        worker.run()

        self.assertTrue(any(
            status.get("identity") == "B" and status.get("status") == "skipped version"
            for status in statuses
        ))

    def test_stats_polling_bounds_concurrency_for_large_fleet(self):
        """A large polling round keeps only the configured requests active."""
        records = [
            DeviceRecord(identity=f"KEY-{index}", ip=f"10.0.{index // 256}.{index % 256}")
            for index in range(2000)
        ]
        worker = StatsPollingWorker(records, timeout=1.0, workers=20)
        lock = Lock()
        active = 0
        maximum_active = 0
        progress = []

        def poll(_record):
            """Track simultaneous calls while returning deterministic stats."""
            nonlocal active, maximum_active
            with lock:
                active += 1
                maximum_active = max(maximum_active, active)
            sleep(0.001)
            with lock:
                active -= 1
            return {"esp_rssi": -50}

        worker._poll_one = poll
        worker.signals.progress.connect(progress.append)
        worker.run()

        self.assertLessEqual(maximum_active, 20)
        self.assertGreater(maximum_active, 1)
        self.assertEqual(2000, len(progress))

    def test_stats_polling_emits_failures_without_internal_retries(self):
        """One failed stats request produces one failed per-device result."""
        record = DeviceRecord(identity="KEY", ip="192.168.1.42")
        worker = StatsPollingWorker([record], timeout=1.0, workers=20)
        progress = []
        calls = []

        def poll(polled_record):
            """Return one failed attempt for the supplied record."""
            calls.append(polled_record.identity)
            return None

        worker._poll_one = poll
        worker.signals.progress.connect(progress.append)
        worker.run()

        self.assertEqual(["KEY"], calls)
        self.assertFalse(progress[0]["success"])

    @patch("ui.workers.db_api_get_json", return_value={"esp_rssi": -50})
    @patch("ui.workers.db_api_create_request_session")
    def test_stats_http_session_disables_automatic_retries(
        self,
        create_session,
        get_json,
    ):
        """Each polling attempt uses an isolated session configured for zero retries."""
        session = Mock()
        create_session.return_value = session
        record = DeviceRecord(identity="KEY", ip="192.168.1.42")
        worker = StatsPollingWorker([record], timeout=1.5, workers=1)

        worker.run()

        create_session.assert_called_once_with(retries=0, backoff_factor=0)
        get_json.assert_called_once_with(
            session,
            "192.168.1.42",
            "/api/system/stats",
            timeout=1.5,
        )
        session.close.assert_called_once()

    @patch("ui.workers.db_scan_for_esp32_devices_by_ip_range")
    @patch("ui.workers.db_scan_for_esp32_devices")
    def test_discovery_methods_run_concurrently(self, mavlink_scan, http_scan):
        """Enabled MAVLink and HTTP scans overlap inside one discovery pass."""
        barrier = Barrier(2)

        def scan(*_args, **_kwargs):
            """Wait for the other discovery method before completing."""
            barrier.wait(timeout=2)
            return []

        mavlink_scan.side_effect = scan
        http_scan.side_effect = scan
        worker = DiscoveryWorker(
            "192.168.1.0/24",
            True,
            True,
            14555,
            14550,
            1.0,
            20,
        )
        finished = []
        worker.signals.finished.connect(finished.append)

        worker.run()

        self.assertEqual([[]], finished)
        mavlink_scan.assert_called_once()
        http_scan.assert_called_once()


if __name__ == "__main__":
    unittest.main()
