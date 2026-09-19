from pathlib import Path

from DroneBridgeCommercialSupportSuite import (
    DBDLSERelease,
    DBLogger,
    DLSE_RELEASES_FOLDER,
    db_api_get_dlse_releases,
    db_check_release_binaries_present,
    db_download_and_extract_dlse_release,
    db_find_extracted_dlse_release_root,
    db_list_offline_dlse_releases,
)
from dlse_cli_utils import is_placeholder_token


def resolve_dlse_release_folder_interactive(
        release_folder: str | None,
        token: str | None,
        logger: DBLogger,
        releases_dir: str | Path = DLSE_RELEASES_FOLDER) -> str | None:
    """
    Resolve a DLSE release folder from a manual path, local cache, or server download.

    If ``release_folder`` is supplied it is returned unchanged so existing CLI
    behavior is preserved and later validation can report any missing files. If
    it is not supplied, the operator is asked to choose an offline cached release,
    download an online release when a valid token is available, enter a manual
    path, or cancel.

    :param release_folder: Explicit release root folder supplied via CLI.
    :param token: DroneBridge activation token used for server release listing
        and release downloads. Placeholder or empty tokens disable online choices.
    :param logger: Shared script logger for operator-facing status.
    :param releases_dir: Local cache folder containing extracted releases.
    :return: Selected release root folder, or ``None`` if no release was selected.
    """
    if release_folder:
        return release_folder

    offline_releases = db_list_offline_dlse_releases(releases_dir)
    online_releases: list[DBDLSERelease] = []
    can_fetch_online = not is_placeholder_token(token)
    if can_fetch_online:
        online_releases = db_api_get_dlse_releases(token.strip()) or []
    else:
        logger.log("No valid activation token available for online release listing.")

    if not offline_releases and not online_releases:
        logger.log("No cached DLSE releases were found and no online releases are available.")
        manual_path = _prompt_manual_release_folder()
        return manual_path or None

    while True:
        _print_release_choices(offline_releases, online_releases)
        choice = input("Select a release number, 'm' for manual path, or 'q' to cancel: ").strip().lower()
        if choice in {"q", "quit", "c", "cancel"}:
            logger.log("Release selection cancelled by user.")
            return None
        if choice in {"m", "manual"}:
            manual_path = _prompt_manual_release_folder()
            if manual_path:
                return manual_path
            continue
        if not choice.isdigit():
            print("Invalid selection.")
            continue

        selected_index = int(choice)
        if 1 <= selected_index <= len(offline_releases):
            return offline_releases[selected_index - 1]

        online_index = selected_index - len(offline_releases) - 1
        if 0 <= online_index < len(online_releases):
            selected_release = online_releases[online_index]
            downloaded_path = db_download_and_extract_dlse_release(
                selected_release,
                token.strip(),
                output_dir=releases_dir,
            )
            if downloaded_path:
                return downloaded_path
            logger.log("Release download or extraction failed.")
            continue

        print("Selection out of range.")


def select_and_validate_dlse_release_folder(
        release_folder: str | None,
        token: str | None,
        logger: DBLogger,
        releases_dir: str | Path = DLSE_RELEASES_FOLDER) -> str | None:
    """
    Resolve and validate a DLSE release folder before hardware operations start.

    :param release_folder: Explicit release root folder supplied via CLI.
    :param token: DroneBridge activation token used for optional online release
        listing and download.
    :param logger: Shared script logger for operator-facing status.
    :param releases_dir: Local cache folder containing extracted releases.
    :return: Valid release root folder path, or ``None`` when selection or
        release binary validation fails.
    """
    selected_release_folder = resolve_dlse_release_folder_interactive(
        release_folder,
        token,
        logger,
        releases_dir=releases_dir,
    )
    if selected_release_folder is None:
        return None

    release_root = db_find_extracted_dlse_release_root(selected_release_folder)
    if release_root is None:
        release_root = Path(selected_release_folder)

    release_root_str = str(release_root)
    logger.log(f"Using release folder: {release_root_str}")
    if not db_check_release_binaries_present(release_root_str):
        logger.log("  Required DroneBridge release binaries are missing!")
        logger.log("  Provide a valid --release-folder or download a release from the DroneBridge license server.")
        logger.log(f"  Expected release path: {release_root_str}")
        return None
    return release_root_str


def default_settings_file_for_release(release_folder: str) -> str:
    """
    Return the default settings CSV path inside a selected release folder.

    :param release_folder: Valid DLSE release root folder.
    :return: Path to the release's ``db_show_params.csv`` file.
    """
    return str(Path(release_folder) / "db_show_params.csv")


def _print_release_choices(offline_releases: list[str], online_releases: list[DBDLSERelease]) -> None:
    """
    Print release choices for the interactive terminal selector.

    :param offline_releases: Valid cached release root folder paths.
    :param online_releases: Release metadata fetched from the license server.
    :return: None.
    """
    print("\nAvailable DLSE releases:")
    option_number = 1
    for release_path in offline_releases:
        print(f"  {option_number}. [offline] {release_path}")
        option_number += 1
    for release in online_releases:
        print(f"  {option_number}. [download] {release.release_date} - {release.name}")
        option_number += 1


def _prompt_manual_release_folder() -> str | None:
    """
    Ask the operator for a manually extracted release root folder path.

    :return: Entered folder path, or ``None`` when the operator leaves it empty
        or the process has no interactive stdin.
    """
    try:
        manual_path = input("Enter a manually extracted release folder path, or leave empty to cancel: ").strip()
    except EOFError:
        return None
    return manual_path or None
