import argparse
import importlib.metadata
import re
from pathlib import Path


PROJECT_DISTRIBUTION_NAME = "DLSECommercialSupportSuite"
PLACEHOLDER_TOKEN_MARKERS = (
    "<add token",
    "<enter your token",
    "<your_secret_token",
    "add token here",
    "enter your token",
)


def get_project_version() -> str:
    """
    Return the source checkout version or the installed distribution version.

    :return: The version from the adjacent ``pyproject.toml`` when running
        from a checkout, even if editable-install metadata is stale.
        Otherwise, the installed distribution version is returned.
    :failure behavior: Returns ``"unknown"`` if neither source provides a version.
    """
    pyproject_path = Path(__file__).resolve().with_name("pyproject.toml")
    try:
        pyproject_text = pyproject_path.read_text(encoding="utf-8")
    except OSError:
        pyproject_text = ""

    project_section = re.search(
        r"(?ms)^\[project\]\s*(.*?)(?=^\[|\Z)",
        pyproject_text,
    )
    if project_section is not None:
        version_match = re.search(
            r'(?m)^\s*version\s*=\s*["\']([^"\']+)["\']\s*$',
            project_section.group(1),
        )
        if version_match is not None:
            return version_match.group(1)

    try:
        return importlib.metadata.version(PROJECT_DISTRIBUTION_NAME)
    except importlib.metadata.PackageNotFoundError:
        return "unknown"


def add_version_argument(parser: argparse.ArgumentParser) -> None:
    """
    Add the standard project version option to an argument parser.

    :param parser: Parser receiving the ``--version`` action.
    :return: None. The action prints ``<program> <version>`` and exits.
    """
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {get_project_version()}",
        help="Show the DLSE Commercial Support Suite version and exit.",
    )


def is_placeholder_token(token: str | None) -> bool:
    """
    Check whether a token value is missing or still one of the documented placeholders.

    :param token: Token value from defaults, environment, or command line.
    :return: ``True`` when the token should be rejected before hardware or network work starts.
    """
    if token is None:
        return True
    stripped_token = token.strip()
    if not stripped_token:
        return True
    normalized_token = stripped_token.lower()
    return any(marker in normalized_token for marker in PLACEHOLDER_TOKEN_MARKERS)


def validate_activation_token(token: str | None) -> str:
    """
    Validate that a DroneBridge activation token was supplied by the operator.

    :param token: Token value from defaults, ``DRONEBRIDGE_SECRET_TOKEN``, or ``--token``.
    :return: The stripped token when valid.
    :raises ValueError: If the token is missing or still a placeholder.
    """
    if is_placeholder_token(token):
        raise ValueError(
            "Missing DroneBridge activation token. Provide --token <YOUR_SECRET_TOKEN> "
            "or set DRONEBRIDGE_SECRET_TOKEN."
        )
    return token.strip()


def resolve_resource_path(relative_path: str | Path) -> Path | None:
    """
    Resolve a bundled resource from the current working tree or an installed package.

    :param relative_path: Resource path such as ``resources/new-notification-011-364050.wav``.
    :return: Existing filesystem path, or ``None`` when the resource is unavailable.
    """
    path = Path(relative_path)
    candidates = [
        Path.cwd() / path,
        Path(__file__).resolve().parent / path,
    ]
    for candidate in candidates:
        if candidate.exists():
            return candidate
    return None
