from pathlib import Path


PLACEHOLDER_TOKEN_MARKERS = (
    "<add token",
    "<enter your token",
    "<your_secret_token",
    "add token here",
    "enter your token",
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
