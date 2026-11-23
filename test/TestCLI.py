import contextlib
import io
import sys
import unittest
from unittest.mock import patch

import batch_install_dlse_allinone
import batch_ota_license_activation
import batch_ota_reboot
import batch_ota_update_allinone
from dlse_cli_utils import get_project_version
from ui.app import parse_args as parse_ui_args


class TestCLI(unittest.TestCase):
    """Verify the standard version option across every ``dlse-*`` launcher."""

    def assert_version_option(self, parse_args, program: str) -> None:
        """
        Assert that a parser prints the project version and exits successfully.

        :param parse_args: Parser callable under test.
        :param program: Executable name used as ``argv[0]``.
        :return: None. Fails when ``--version`` is not handled as expected.
        """
        output = io.StringIO()
        with (
            patch.object(sys, "argv", [program, "--version"]),
            contextlib.redirect_stdout(output),
            self.assertRaises(SystemExit) as raised,
        ):
            parse_args()

        self.assertEqual(0, raised.exception.code)
        self.assertEqual(f"{program} {get_project_version()}\n", output.getvalue())

    def test_batch_install_version_option(self):
        """The serial installer exposes the project version."""
        self.assert_version_option(
            batch_install_dlse_allinone.parse_args,
            "dlse-install",
        )

    def test_license_activation_version_option(self):
        """The OTA license activator exposes the project version."""
        self.assert_version_option(
            batch_ota_license_activation.parse_args,
            "dlse-activate",
        )

    def test_ota_reboot_version_option(self):
        """The OTA reboot command exposes the project version."""
        self.assert_version_option(batch_ota_reboot.parse_args, "dlse-reboot")

    def test_ota_update_version_option(self):
        """The OTA updater exposes the project version."""
        self.assert_version_option(
            batch_ota_update_allinone.parse_args,
            "dlse-update",
        )

    def test_ui_version_option(self):
        """The GUI launcher exposes the project version before Qt startup."""
        self.assert_version_option(parse_ui_args, "dlse-ui")

    def test_checkout_version_takes_precedence_over_stale_metadata(self):
        """Version lookup uses the source version after a bump in an editable install."""
        with (
            patch(
                "dlse_cli_utils.Path.read_text",
                return_value=(
                    '[project]\nname = "DLSECommercialSupportSuite"\n'
                    'version = "1.2.0"\ndescription = "Commercial Support Suite"\n'
                ),
            ),
            patch("dlse_cli_utils.importlib.metadata.version", return_value="1.1.1"),
        ):
            self.assertEqual("1.2.0", get_project_version())

    def test_installed_version_is_used_without_a_source_checkout(self):
        """Version lookup uses distribution metadata when the source file is absent."""
        with (
            patch("dlse_cli_utils.Path.read_text", side_effect=FileNotFoundError),
            patch("dlse_cli_utils.importlib.metadata.version", return_value="1.2.0"),
        ):
            self.assertEqual("1.2.0", get_project_version())


if __name__ == "__main__":
    unittest.main()
