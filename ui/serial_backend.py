"""Validated serial installation orchestration, used only by isolated UI workers."""

from __future__ import annotations

import base64
import csv
import ipaddress
import shutil
import time
from pathlib import Path
from typing import Any, Callable

import DroneBridgeCommercialSupportSuite as db
from dlse_cli_utils import validate_activation_token


def read_settings(path: Path) -> list[dict[str, str]]:
    """Read an NVS CSV, rejecting malformed headers, rows and duplicate keys.

    ``path`` must contain namespaces followed by typed data. Returns rows;
    raises ValueError/OSError before any hardware operation on invalid input.
    """
    with path.open(newline='', encoding='utf-8-sig') as source:
        reader = csv.DictReader(line for line in source if line.strip() and not line.lstrip().startswith('#'))
        if reader.fieldnames != ['key', 'type', 'encoding', 'value']:
            raise ValueError('Settings CSV must have header key,type,encoding,value.')
        rows = list(reader)
    namespace = ''
    seen: set[str] = set()
    for row in rows:
        if None in row or any(value is None for value in row.values()):
            raise ValueError('Settings CSV contains a malformed row.')
        if any('\n' in value or '\r' in value for value in row.values()):
            raise ValueError('Settings CSV values must stay on one physical line.')
        key, kind = row['key'], row['type']
        if not key or len(key.encode('utf-8')) > 15 or key in seen:
            raise ValueError('Settings CSV contains an empty, duplicate or oversized key.')
        seen.add(key)
        if kind == 'namespace':
            if row['encoding'] or row['value']:
                raise ValueError('Namespace rows must have empty encoding and value.')
            namespace = key
        elif kind != 'data' or not namespace:
            raise ValueError('Settings data must follow a namespace and use type data.')
        elif row['encoding'] not in {'u8', 'i8', 'u16', 'i16', 'u32', 'i32', 'u64', 'i64', 'string', 'hex2bin', 'base64', 'binary'}:
            raise ValueError('Settings CSV contains an unsupported encoding.')
        elif row['encoding'] in {'u8', 'i8', 'u16', 'i16', 'u32', 'i32', 'u64', 'i64'}:
            encoding = row['encoding']
            bits = int(encoding[1:])
            signed = encoding.startswith('i')
            try:
                value = int(row['value'], 0) if row['value'].lower().startswith(('0x', '-0x')) else int(row['value'])
            except ValueError as exc:
                raise ValueError('Settings CSV contains an invalid integer.') from exc
            if not (-(2 ** (bits - 1)) if signed else 0) <= value < 2 ** (bits - int(signed)):
                raise ValueError('Settings CSV integer is outside its encoding range.')
        elif row['encoding'] == 'binary':
            raise ValueError('External binary settings entries are unsupported; export a self-contained CSV.')
        elif row['encoding'] == 'base64':
            try:
                base64.b64decode(row['value'], validate=True)
            except ValueError as exc:
                raise ValueError('Settings CSV contains invalid base64 data.') from exc
        elif row['encoding'] == 'hex2bin':
            try:
                bytes.fromhex(row['value'])
            except ValueError as exc:
                raise ValueError('Settings CSV contains invalid hexadecimal data.') from exc
    if not rows or not any(row['type'] == 'data' for row in rows):
        raise ValueError('Settings CSV contains no data.')
    return rows


def validate_release(release: Path) -> None:
    """Validate all supported chip maps and files in ``release``; raise on failure."""
    if not db.db_check_release_binaries_present(str(release)):
        raise ValueError('Release is missing its settings CSV or supported chip folders.')
    read_settings(release / 'db_show_params.csv')
    for chip in db.DLSESupportedChips:
        folder = release / db.db_get_bin_folder(chip.value)
        parts = (folder / 'flash_args.txt').read_text().split()
        pairs: dict[int, Path] = {}
        index = 0
        while index < len(parts):
            if parts[index].startswith('0x'):
                if index + 1 >= len(parts):
                    raise ValueError(f'{chip.name}: incomplete flash address/file pair.')
                address = int(parts[index], 16)
                binary = folder / Path(parts[index + 1].replace('\\', '/')).name
                if address in pairs or not binary.is_file() or binary.stat().st_size == 0:
                    raise ValueError(f'{chip.name}: missing binary or duplicate flash address.')
                pairs[address] = binary
                index += 2
            else:
                index += 1
        firmware = [path for address, path in pairs.items() if address != db.DLSE_SETTINGS_PARTITION_ADDRESS]
        if not pairs or not any(path.name in {'db_esp32.bin', 'dlse_esp32.bin'} for path in firmware) or not any(path.name == 'www.bin' for path in firmware):
            raise ValueError(f'{chip.name}: flash map must include application and WWW images.')
        ranges = sorted((address, address + path.stat().st_size) for address, path in pairs.items() if address != db.DLSE_SETTINGS_PARTITION_ADDRESS)
        ranges.append((db.DLSE_SETTINGS_PARTITION_ADDRESS, db.DLSE_SETTINGS_PARTITION_ADDRESS + db.DLSE_SETTINGS_PARTITION_SIZE))
        ranges.sort()
        if any(end > next_start for (_, end), (next_start, _) in zip(ranges, ranges[1:])):
            raise ValueError(f'{chip.name}: flash partitions overlap.')


def prepare_settings(config: dict[str, Any], work: Path, emit: Callable[[dict], None] | None = None) -> tuple[Path, list[str]]:
    """Merge validated settings into ``work``; return CSV and schema warnings.

    Source CSVs and releases are never modified. Invalid inputs raise ValueError.
    """
    release = Path(config['release']).resolve()
    validate_release(release)
    source = Path(config['settings']).resolve() if config.get('settings') else release / 'db_show_params.csv'
    user_rows = read_settings(source)
    release_rows = read_settings(release / 'db_show_params.csv')
    user_keys = {row['key'] for row in user_rows if row['type'] == 'data'}
    release_keys = {row['key'] for row in release_rows if row['type'] == 'data'}
    warnings = []
    if release_keys - user_keys:
        warnings.append('Release defaults will be used for: ' + ', '.join(sorted(release_keys - user_keys)))
    if user_keys - release_keys:
        warnings.append('Obsolete settings will be ignored: ' + ', '.join(sorted(user_keys - release_keys)))
    if emit:
        emit({'event': 'stage', 'stage': 'merge', 'message': 'Merging settings with the release schema', 'timeout': 60})
    merged = db.db_csv_merge_user_parameters_with_release(str(source), str(release))
    if not merged:
        raise ValueError('Settings merge failed.')
    destination = work / 'template.csv'
    shutil.copyfile(merged, destination)
    return destination, warnings


def assign_settings(template: Path, index: int, destination: Path) -> dict[str, Any]:
    """Apply ``index`` to a copy, returning its assignments; raise on invalid IPs."""
    if index < 0:
        raise ValueError('Device index must be nonnegative.')
    shutil.copyfile(template, destination)
    values = {row['key']: row['value'] for row in read_settings(template)}
    if values.get('ip_sta'):
        original = ipaddress.IPv4Address(values['ip_sta'])
        if not 0 <= index <= 255:
            raise ValueError('Static IP index exhausted; choose another subnet or template.')
        address = ipaddress.IPv4Address('.'.join(str(original).split('.')[:3] + [str(index)]))
        network = ipaddress.IPv4Network(f"{original}/{values.get('ip_sta_netmsk') or '255.255.255.0'}", strict=False)
        if address not in network or address in {network.network_address, network.broadcast_address}:
            raise ValueError('Assigned static IP is outside the subnet or is a network/broadcast address.')
    if not db.db_csv_update_parameters(str(destination), index):
        raise ValueError('Could not assign IP, hostname or AP name from the template.')
    assigned = {row['key']: row['value'] for row in read_settings(destination)}
    return {'index': index, 'ip': assigned.get('ip_sta', ''), 'hostname': assigned.get('wifi_hostname', ''), 'ap': assigned.get('ssid_ap', '')}


def process_device(config: dict[str, Any], work: Path, emit: Callable[[dict[str, Any]], None]) -> dict[str, Any]:
    """Install one board using existing helpers, emitting stages and returning a result.

    ``config`` supplies port, baud, index, mode, token and prepared template.
    Mode ``none`` skips license acquisition and embedding, and strips existing
    license entries from the working CSV before generating NVS.
    Failures return structured status; no flash is attempted before validation.
    """
    port, baud, index = config['port'], int(config['baud']), int(config['index'])
    stage = 'identify'
    result: dict[str, Any] = {'outcome': 'failed', 'flash_started': False, 'index': index, 'port': port}

    def progress(name: str, message: str, timeout: int = 120) -> None:
        """Emit the current stage and its deadline; return None."""
        nonlocal stage
        stage = name
        emit({'event': 'stage', 'stage': name, 'message': f'{port} · index {index}: {message}', 'timeout': timeout})

    try:
        progress('identify', 'Identifying chip')
        chip = db.db_get_esp32_chip_id(port, baud)
        if chip is None:
            raise ValueError('Could not identify the connected chip.')
        if chip not in {item.value for item in db.DLSESupportedChips}:
            result.update(outcome='skipped', chip=str(chip), message=f'Unsupported chip ID {chip}.')
            return result
        result['chip'] = db.DLSESupportedChips(chip).name.replace('ESP32', 'ESP32-')
        emit({'event': 'details', 'chip': result['chip']})
        progress('activation_key', 'Reading activation key')
        key = db.db_get_activation_key(port, baud)
        if not key:
            raise ValueError('Could not read the activation key.')
        decoded = base64.b64decode(key, validate=True)
        if len(decoded) != 9 or decoded[6] != chip:
            raise ValueError('Device returned an invalid activation key.')
        result['activation_key'] = key
        emit({'event': 'secret', 'value': key})
        if config.get('retry_key') and config['retry_key'] != key:
            raise ValueError('A different device is connected to the retry port; flashing cancelled.')
        if key in config.get('processed_keys', []):
            result.update(outcome='skipped', message='Device already completed in this session.')
            return result
        mode = config['mode']
        license_path = None
        if mode != 'none':
            license_type = db.DBLicenseType.EVALUATION if mode == 'evaluation' else db.DBLicenseType.ACTIVATED
            progress('license', 'Checking license server' if mode != 'offline' else 'Looking for cached permanent license', 180)
            online = mode != 'offline' and db.db_is_dlse_lic_server_available()
            if online:
                progress('license', 'Requesting license from server', 180)
                token = validate_activation_token(config.get('token'))
                # Stage downloads privately, then publish only validated permanent licenses.
                license_path = db.db_api_request_license_file(key, token, _output_path=str(work / 'licenses'), _license_type=license_type, _validity_days=60 if mode == 'evaluation' else 0)
            elif mode == 'evaluation':
                raise ValueError('Evaluation licensing requires the license server.')
            else:
                progress('license', 'Looking for cached permanent license', 180)
                license_path = db.db_get_dlse_lic_from_local_storage(key)
                if not license_path:
                    progress('license', 'Recovering license from device', 120)
                    license_path = db.db_get_dlse_lic_via_serial(port, baud)
            if not license_path:
                raise ValueError('No license could be acquired; flashing has not started.')
            progress('validate_license', 'Validating license signature and device match', 180)
            valid, info = db.db_dlse_validate_license(license_path, match_activation_key=key)
            if not valid or not info or info.get('license_type') != license_type.value:
                raise ValueError('License is invalid, mismatched or has the wrong type.')
            if mode == 'evaluation' and int(info.get('valid_till', 0)) <= time.time():
                raise ValueError('Evaluation license has expired.')
            if mode != 'evaluation':
                cache = Path(db.DLSE_LICENSE_FOLDER).resolve()
                cache.mkdir(parents=True, exist_ok=True)
                cached_path = cache / (key.replace('/', '_') + '.dlselic')
                if Path(license_path).resolve() != cached_path:
                    shutil.copyfile(license_path, cached_path)
        progress('settings', 'Preparing indexed settings', 60)
        assignment = assign_settings(Path(config['template']), index, work / 'device.csv')
        result.update(assignment)
        emit({'event': 'details', **assignment})
        combined = str(work / 'device.csv')
        if mode != 'none':
            progress('embed', 'Embedding license in settings', 60)
            # The legacy embedding helper uses '#' quoting, while merge/update/NVS
            # use normal CSV quoting. Normalize only this disposable working copy.
            device_csv = work / 'device.csv'
            rows = read_settings(device_csv)
            with device_csv.open('w', newline='', encoding='utf-8') as output:
                writer = csv.DictWriter(output, fieldnames=['key', 'type', 'encoding', 'value'], quotechar='#')
                writer.writeheader()
                writer.writerows(rows)
            combined = db.db_embed_license_in_settings_csv(str(device_csv), str(license_path))
            if not combined:
                raise ValueError('Could not embed the license into settings.')
            with Path(combined).open(newline='', encoding='utf-8') as source:
                embedded_rows = list(csv.reader(source, quotechar='#'))
            with Path(combined).open('w', newline='', encoding='utf-8') as output:
                csv.writer(output).writerows(embedded_rows)
            read_settings(Path(combined))
        else:
            # Settings replace the entire NVS partition. Explicitly exclude any
            # license already present in an exported template or release defaults.
            rows = read_settings(Path(combined))
            clean_rows = []
            namespace = ''
            for row in rows:
                if row['type'] == 'namespace':
                    namespace = row['key']
                if namespace != 'license' and row['key'] != 'db_lic_key':
                    clean_rows.append(row)
            with Path(combined).open('w', newline='', encoding='utf-8') as output:
                writer = csv.DictWriter(output, fieldnames=['key', 'type', 'encoding', 'value'])
                writer.writeheader()
                writer.writerows(clean_rows)
            read_settings(Path(combined))
        progress('nvs', 'Generating NVS settings partition', 60)
        binary = db.db_parameters_generate_binary(combined, '0x6000')
        if not binary or not Path(binary).is_file() or Path(binary).stat().st_size != db.DLSE_SETTINGS_PARTITION_SIZE:
            raise ValueError('NVS partition generation failed.')
        progress('map', 'Validating firmware address map', 60)
        validate_release(Path(config['release']))
        mapping = db.db_create_address_binary_map(chip, config['release'], binary)
        if not mapping or len(mapping) < 2 or any(not Path(path).is_file() or Path(path).stat().st_size == 0 for path in mapping.values()):
            raise ValueError('Firmware map contains missing or empty binaries.')
        progress('recheck', 'Rechecking connected device identity')
        if db.db_get_esp32_chip_id(port, baud) != chip or db.db_get_activation_key(port, baud) != key:
            raise ValueError('The connected device changed; flashing cancelled.')
        progress('flash', 'Flashing firmware and settings; keep the board connected', 600)
        result['flash_started'] = True
        if not db.db_flash_binaries(port, mapping, baud_rate=baud):
            raise ValueError('Flashing failed; board may be partially programmed.')
        progress('complete', 'Board completed successfully', 60)
        result.update(outcome='success', message='Firmware and settings installed without a license.' if mode == 'none' else 'Firmware, settings and license installed.')
    except Exception as exc:
        result['message'] = str(exc)
    finally:
        result['stage'] = stage
    return result
