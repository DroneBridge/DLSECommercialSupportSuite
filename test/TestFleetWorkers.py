"""Tests for bounded and cancellable Fleet Manager workers."""

import unittest
from threading import Barrier, Lock
from time import sleep
from types import SimpleNamespace
from unittest.mock import Mock, patch

from DroneBridgeCommercialSupportSuite import DBDLSERelease
from pymavlink import mavutil
from ui.models import DeviceRecord
from ui.workers import (
    DiscoveryWorker,
    OtaReleaseListWorker,
    OtaReleaseResolveWorker,
    OtaWorker,
    SettingsRefreshWorker,
    StatsPollingWorker,
    StaticIpAssignmentWorker,
    SystemInfoRefreshWorker,
    SysIdAlignmentWorker,
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

    def test_static_ip_generation_rolls_from_final_octet_to_third_octet(self):
        """Generated host addresses skip zero and 255 while carrying to octet three."""
        targets = StaticIpAssignmentWorker.generate_target_ips("192.168.1.253", 4)

        self.assertEqual(
            ["192.168.1.253", "192.168.1.254", "192.168.2.1", "192.168.2.2"],
            targets,
        )

    def test_static_ip_preflight_normalizes_network_and_rejects_conflicts(self):
        """Static-IP preflight normalizes masks and rejects retained IP collisions."""
        records = [
            DeviceRecord(identity="A", ip="192.168.10.10"),
            DeviceRecord(identity="B", ip="192.168.10.11"),
        ]
        assignments, netmask, gateway = StaticIpAssignmentWorker.prepare_assignments(
            records,
            records,
            "192.168.20.1",
            "/16",
            "192.168.0.1",
        )

        self.assertEqual({"A": "192.168.20.1", "B": "192.168.20.2"}, assignments)
        self.assertEqual("255.255.0.0", netmask)
        self.assertEqual("192.168.0.1", gateway)
        with self.assertRaisesRegex(ValueError, "already assigned"):
            StaticIpAssignmentWorker.prepare_assignments(
                records,
                records,
                "192.168.10.11",
                "255.255.0.0",
                "192.168.0.1",
            )

    def test_static_ip_preflight_rejects_range_outside_subnet(self):
        """A /24 cannot accept a generated range that rolls into another third octet."""
        records = [
            DeviceRecord(identity=f"A{index}", ip=f"10.0.10.{index + 20}")
            for index in range(2)
        ]

        with self.assertRaisesRegex(ValueError, "outside the entered subnet"):
            StaticIpAssignmentWorker.prepare_assignments(
                records,
                records,
                "192.168.1.254",
                "255.255.255.0",
                "192.168.1.1",
            )

    @patch("ui.workers.db_api_update_settings")
    @patch("ui.workers.db_api_create_request_session")
    def test_static_ip_worker_posts_per_device_payload_and_returns_target(self, create_session, update_settings):
        """Each device receives its own generated IP and the result carries cache data."""
        session = Mock()
        create_session.return_value = session
        update_settings.return_value = SimpleNamespace(success=True, message="accepted")
        record = DeviceRecord(identity="A", ip="192.168.1.42")
        worker = StaticIpAssignmentWorker(
            [record],
            {"A": "192.168.20.1"},
            "255.255.0.0",
            "192.168.0.1",
            workers=1,
        )
        progress = []
        worker.signals.progress.connect(progress.append)

        worker.run()

        update_settings.assert_called_once_with(
            session,
            "192.168.1.42",
            {
                "ip_sta": "192.168.20.1",
                "ip_sta_netmsk": "255.255.0.0",
                "ip_sta_gw": "192.168.0.1",
            },
        )
        self.assertTrue(progress[0]["success"])
        self.assertEqual("192.168.20.1", progress[0]["target_ip"])
        self.assertEqual("static IP accepted", progress[0]["status"])
        session.close.assert_called_once()

    def test_sys_id_alignment_resolves_all_three_source_modes(self):
        """IP, FC, and manual modes derive their documented source IDs."""
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            settings={"show_man_sysid": 17},
            stats={"fc_sysid": 23},
        )

        self.assertEqual((42, ""), SysIdAlignmentWorker([record], "ip", 14555)._target_sys_id(record))
        self.assertEqual((23, ""), SysIdAlignmentWorker([record], "fc", 14555)._target_sys_id(record))
        self.assertEqual((17, ""), SysIdAlignmentWorker([record], "manual", 14555)._target_sys_id(record))

    def test_sys_id_alignment_rejects_invalid_source_ids_before_network_work(self):
        """Missing or invalid cached sources become safe per-device failures."""
        worker = SysIdAlignmentWorker([], "manual", 14555)
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.0",
            settings={"show_man_sysid": 0},
            stats={"fc_sysid": -1},
        )

        self.assertIn("last octet", SysIdAlignmentWorker([], "ip", 14555)._target_sys_id(record)[1])
        self.assertIn("FC SYS ID", SysIdAlignmentWorker([], "fc", 14555)._target_sys_id(record)[1])
        self.assertIn("manual DLSE SYS ID", worker._target_sys_id(record)[1])

    def test_sys_id_alignment_prefers_device_udp_port_and_falls_back_safely(self):
        """Per-device udp_local_port wins, with the scan port used only as fallback."""
        self.assertEqual(14600, SysIdAlignmentWorker._resolve_udp_port("14600", 14555))
        self.assertEqual(14555, SysIdAlignmentWorker._resolve_udp_port("invalid", 14555))
        self.assertIsNone(SysIdAlignmentWorker._resolve_udp_port(0, 70000))

    @patch("ui.workers.sleep")
    @patch("ui.workers.mavutil.mavlink_connection")
    def test_sys_id_alignment_falls_back_to_px4_parameter_and_requires_reboot_ack(
        self,
        mavlink_connection,
        _sleep,
    ):
        """A missing ArduPilot parameter falls back to confirmed PX4 update and reboot."""
        master = Mock()
        mavlink_connection.return_value = master
        master.recv_match.side_effect = [
            None,
            None,
            SimpleNamespace(param_id=b"MAV_SYS_ID\x00", param_type=6),
            SimpleNamespace(param_id=b"MAV_SYS_ID\x00", param_value=42),
            SimpleNamespace(
                command=mavutil.mavlink.MAV_CMD_PREFLIGHT_REBOOT_SHUTDOWN,
                result=mavutil.mavlink.MAV_RESULT_ACCEPTED,
            ),
        ]
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            settings={"udp_local_port": 14600},
            stats={"fc_sysid": 10},
        )
        worker = SysIdAlignmentWorker([record], "ip", 14555, workers=1)

        success, message = worker._update_and_reboot_fc(record, 42)

        self.assertTrue(success)
        self.assertIn("MAV_SYS_ID", message)
        mavlink_connection.assert_called_once_with("udpout:192.168.1.42:14600", source_system=255)
        self.assertEqual(
            b"MAV_SYS_ID",
            master.mav.param_set_send.call_args.args[2],
        )
        master.mav.command_long_send.assert_called_once()
        master.close.assert_called_once()

    @patch("ui.workers.db_api_update_settings")
    def test_sys_id_alignment_keeps_dlse_settings_unchanged_when_fc_fails(self, update_settings):
        """A failed FC confirmation prevents the subsequent DLSE settings mutation."""
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            settings={"show_man_sysid": 42},
            stats={"fc_sysid": 10},
        )
        worker = SysIdAlignmentWorker([record], "manual", 14555)
        worker._update_and_reboot_fc = Mock(return_value=(False, "FC confirmation failed"))

        result = worker._align_one(record)

        self.assertFalse(result["success"])
        self.assertIn("confirmation", result["message"])
        update_settings.assert_not_called()

    @patch("ui.workers.db_api_update_settings")
    @patch("ui.workers.db_api_create_request_session")
    def test_sys_id_alignment_fc_mode_updates_dlse_without_fc_commands(
        self,
        create_session,
        update_settings,
    ):
        """FC-source mode copies the cached FC ID to DLSE settings only."""
        session = Mock()
        create_session.return_value = session
        update_settings.return_value = SimpleNamespace(success=True, message="accepted")
        record = DeviceRecord(
            identity="KEY",
            ip="192.168.1.42",
            activation_status="ACTIVATED",
            stats={"fc_sysid": 19},
        )
        worker = SysIdAlignmentWorker([record], "fc", 14555)
        worker._update_and_reboot_fc = Mock()

        result = worker._align_one(record)

        self.assertTrue(result["success"])
        worker._update_and_reboot_fc.assert_not_called()
        update_settings.assert_called_once_with(
            session,
            "192.168.1.42",
            {"show_man_sysid": 19, "show_en_syid_ip": 0},
        )
        session.close.assert_called_once()

    @patch("ui.workers.db_api_get_json")
    @patch("ui.workers.db_api_create_request_session")
    def test_system_info_refresh_worker_requests_only_supplied_devices(
        self,
        create_session,
        get_json,
    ):
        """Post-operation info refresh requests only the submitted device set."""
        sessions = [Mock(), Mock()]
        create_session.side_effect = sessions
        get_json.side_effect = [
            {"license_type": "ACTIVATED"},
            {"license_type": "EVALUATION"},
        ]
        records = [
            DeviceRecord(identity="A", ip="192.168.1.2"),
            DeviceRecord(identity="B", ip="192.168.1.3"),
        ]
        worker = SystemInfoRefreshWorker(records, timeout=1.5, workers=1)
        progress = []
        finished = []
        worker.signals.progress.connect(progress.append)
        worker.signals.finished.connect(finished.append)

        worker.run()

        self.assertEqual(2, len(progress))
        self.assertEqual(2, len(finished[0]))
        self.assertEqual(
            ["192.168.1.2", "192.168.1.3"],
            [request.args[1] for request in get_json.call_args_list],
        )
        self.assertTrue(all(
            request.args[2] == "/api/system/info"
            and request.kwargs["timeout"] == 1.5
            for request in get_json.call_args_list
        ))
        self.assertEqual(2, create_session.call_count)
        for session in sessions:
            session.close.assert_called_once()

    @patch("ui.workers.db_api_get_json")
    @patch("ui.workers.db_api_create_request_session")
    def test_settings_refresh_worker_requests_settings_at_current_target_ips(
        self,
        create_session,
        get_json,
    ):
        """Delayed settings refresh uses only affected devices and new IPs."""
        sessions = [Mock(), Mock()]
        create_session.side_effect = sessions
        get_json.side_effect = [
            {"wifi_chan": 7},
            {"wifi_chan": 8},
        ]
        records = [
            DeviceRecord(identity="A", ip="192.168.1.2"),
            DeviceRecord(identity="B", ip="192.168.1.3"),
        ]
        worker = SettingsRefreshWorker(
            records,
            target_ips={"B": "192.168.2.3"},
            timeout=1.5,
            workers=1,
        )
        progress = []
        finished = []
        worker.signals.progress.connect(progress.append)
        worker.signals.finished.connect(finished.append)

        worker.run()

        self.assertEqual(2, len(progress))
        self.assertEqual(2, len(finished[0]))
        self.assertEqual(
            ["192.168.1.2", "192.168.2.3"],
            [request.args[1] for request in get_json.call_args_list],
        )
        self.assertTrue(all(
            request.args[2] == "/api/settings"
            and request.kwargs["timeout"] == 1.5
            for request in get_json.call_args_list
        ))
        for session in sessions:
            session.close.assert_called_once()


if __name__ == "__main__":
    unittest.main()
