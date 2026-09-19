# Network Manager feature proposal

Status: proposal for discussion; no implementation or hardware validation.
Reference date: 2026-09-04. UniFi API baseline: the supplied Network v10.4.57 specification.

## Product purpose

Help an operator choose the drones for a show, distribute that roster across an existing UniFi deployment, apply the necessary drone settings, and verify the resulting connections.

UniFi remains responsible for configuring gateways, APs, radios, SSIDs, VLANs, DHCP, security, and RF settings. The suite reads that configuration and owns fleet identity, show rosters, assignment plans, migrations, and fleet-specific diagnostics. Make Network Manager a sibling view of Fleet Manager using the same inventory and selection.

The primary workflow is **Select show → Select roster → Plan assignments → Review changes → Apply in stages → Verify**. Planning must also work with powered-off drones and cached infrastructure, with freshness visible and execution requiring fresh validation.

## What the API supports

The supplied [UniFi specification](https://developer.ui.com/network/v10.4.57/openapi.json) documents a local console base at `https://{consoleIP}/proxy/network/integration` and these useful reads:

| Relative endpoint | Purpose |
| --- | --- |
| `/v1/info`, `/v1/sites` | Application and site selection |
| `/v1/sites/{siteId}/wifi/broadcasts` | Wi-Fi profiles, bands, and broadcasting scope |
| `/v1/sites/{siteId}/device-tags` | Resolve AP scopes based on device tags |
| `/v1/sites/{siteId}/devices/{deviceId}` | AP details and radio channels/widths |
| `/v1/sites/{siteId}/clients` | Client MAC/IP and connected AP via `uplinkDeviceId` |
| `/v1/sites/{siteId}/networks/{networkId}` | Network/VLAN and applicable IP configuration |
| `/v1/sites/{siteId}/devices/{deviceId}/statistics/latest` | Device statistics and optional radio retry percentage |

The client schema does not document connected SSID, BSSID, band, or RSSI. The radio statistics schema does not document airtime utilization. Client actions cover guest authorization, not AP locking. Client pagination has a maximum of 200 entries per request: 5,000 clients require at least 25 pages. Never treat one page as a complete inventory.

Use documented read operations only for the UniFi integration. Detect version/capabilities, handle missing fields, and label unsupported observations as unknown. Do not silently substitute private controller endpoints.

## Assignment semantics: the central product decision

An SSID names a wireless network. An AP can broadcast several SSIDs on several radios; one SSID can be broadcast by several APs. Therefore assigning an SSID does not generally select one AP or band.

Offer destinations that reflect what can actually be enforced:

| Destination | What the operator can expect |
| --- | --- |
| SSID broadcast by one selected AP on one band | Specific AP/band placement, subject to verified configuration and device compatibility |
| SSID broadcast by an AP group or several bands | Membership in that group; individual AP/band remains chosen by the client |
| Shared SSID plus preferred AP | Planning preference only unless firmware gains a supported enforcement mechanism |

For the first release, recommend dedicated SSIDs scoped in UniFi to the desired AP or AP group, and to one band when band placement matters. These SSIDs may share a VLAN when the deployment permits it; do not require a VLAN per SSID. Check any existing MAVLink routing design before combining networks. Avoid broadcasting every fleet SSID on every AP.

Show a destination as, for example, `North / AP-03 / 5 GHz / Show-North-03`, with “Specific AP” or “AP group” beside it. Resolve scope from IDs/tags, not display-name matching. If an SSID is also broadcast elsewhere or its scope changes, invalidate exact-placement claims.

[Espressif supports BSSID selection in the station driver](https://docs.espressif.com/projects/esp-idf/en/v5.4.4/esp32c5/api-guides/wifi.html), but the repository's DLSE API does not expose such a setting. BSSID targeting would be a separate firmware feature, requiring actual per-radio/per-SSID BSSID discovery, AP replacement handling, and an explicit fallback policy. An AP's management MAC is not a substitute for its BSSID.

## Operator experience

### Show roster

- Maintain a persistent fleet independently of the currently connected inventory.
- Create named shows with explicit drone membership and roles: participating, spare, excluded. Spare and excluded drones may still consume network capacity when powered on.
- Select by saved groups, crates, fleet-number ranges, pasted IDs, CSV manifests, IP/subnet, or SYS ID with network context. Preview unmatched and ambiguous entries.
- Offer “Select all matching 1,000” separately from selecting visible rows. Keep the selection count visible when filters change.
- Save the chosen device identities as a roster snapshot. A changing search result must not silently change an approved execution scope.
- Reuse a prior show as a template; show the differences in drones and infrastructure. Offer explicit replacement of a missing drone with a spare.

### Overview and planning

Default to a compact table of destinations/AP radios, not thousands of device tiles or a large topology graph. At higher AP counts, collapse destinations by deployment zone or AP group. Use virtualized rows for both APs and drones.

Each destination row shows:

- AP/group and destination SSID, supported band and current channel/width when known.
- Observed show drones, observed other clients, planned show drones, and operator-defined planning limit.
- Moves into/out of the destination and unresolved assignments.
- Evidence status: observed, inferred, stale, or unavailable.

Keep **observed**, **planned**, and **verified** distinct. A configured SSID read from DLSE is not proof of the active association. An AP connection observed through UniFi is not proof of a usable flight-control link.

The operator can select a row to open a filtered drone table and inspector, pin assignments, or assign a selected group through a bulk action. Drag and drop can be optional convenience; all operations must be possible with keyboard and bulk selectors.

Offer AP and channel views. The channel view aggregates radios that may contend, including bandwidth overlap. Different SSIDs on the same channel do not create extra spectrum. Treat spatial reuse as an explicit assumption until coverage evidence exists. UniFi remains the place to inspect/change RF configuration; its [troubleshooting guide](https://help.ui.com/hc/en-us/articles/32064585817495-WiFi-Troubleshooting-Guide) explains airtime, interference, and retry measurements.

### Review and verify

Review shows a concrete diff: roster size, unchanged assignments, moves, offline pending devices, unsupported destinations, IP changes, and expected connection interruption. Filter immediately to blockers or changed drones.

After applying, lead with exceptions: missing after reconnect, wrong AP/group, incompatible configuration, ambiguous identity, and stale observations. Clicking an exception reveals affected drones and the evidence. Avoid 5,000 concurrent notifications.

## Planning logic

Start with a deterministic, explainable planner rather than an opaque optimization score.

1. Remove ineligible destinations: disabled/offline infrastructure, unsupported band/security/protocol, unreachable target network, missing credentials, incompatible device mode, or unresolved scope.
2. Reserve capacity for non-show clients and connected spares, and honor pinned assignments and group constraints.
3. Keep valid existing assignments where budgets permit. Move the minimum necessary drones by default; offer explicit redistribution when desired.
4. Place constrained devices first, then flexible devices. Respect both AP-radio limits and shared-channel budgets.
5. If capacity is insufficient, leave drones unassigned and explain the shortfall. Never silently exceed a limit or claim a feasible plan.

The initial capacity model uses operator-defined, field-tested drone-count budgets, with optional traffic classes and headroom. These are planning constraints, not manufacturer capacity guarantees. Later calibration can incorporate measured traffic/retries and external RF observations; do not estimate airtime directly from byte counters alone. Ground RSSI does not establish coverage throughout an airborne formation.

Track capability by chip **and firmware/configuration**, rather than assuming all ESP32s support all bands. In particular, [ESP32-C6 is 2.4 GHz](https://docs.espressif.com/projects/esp-hardware-design-guidelines/en/latest/esp32c6/product-overview.html), whereas [ESP32-C5 supports selectable 2.4/5 GHz operation](https://docs.espressif.com/projects/esp-idf/en/v5.4.4/esp32c5/api-guides/wifi.html). A 5 GHz AP does not make every drone 5 GHz-capable.

## Identity and fleet persistence

Use an internal immutable fleet UUID and an operator-visible fleet label. Store verified hardware identifiers as aliases; bind a drone to its DLSE datalink so hardware replacement can be handled explicitly. Match UniFi clients using the verified Wi-Fi station MAC. Confirm on hardware whether `/api/system/info.esp_mac` is the station MAC; do not infer a MAC offset.

The current `DeviceRecord` is session-scoped and uses activation-key/MAC/IP-derived identity. Preserve existing call patterns, but add a reconciliation layer that maps observations and existing identities to persistent fleet UUIDs. IP and activation state changes must not create a second drone or lose its plan membership. Ambiguous matches require reconciliation before writes.

SYS ID and IP remain useful selectors, not permanent global identity. [MAVLink system IDs range from 1 to 255 and must be unique within a MAVLink network](https://mavlink.io/en/services/mavlink_id_assignment.html). A 5,000-drone fleet therefore needs explicit routing/domain context or an existing show-system identity scheme. SSIDs alone do not isolate MAVLink domains; VLANs alone are also insufficient if a router merges their MAVLink traffic. Keep the operator's existing routing scheme and show-ID mapping as inputs.

DLSE's documented `show_en_syid_ip` can derive SYS ID from an assigned IP. A subnet/DHCP change must therefore flag possible SYS ID changes and collision risks; never silently align flight-controller IDs as part of a Wi-Fi migration.

Suggested persisted records: `FleetDrone`, `HardwareBinding`, `ShowRoster`, `UniFiSiteSnapshot`, `WifiDestination`, `AssignmentPlan`, `DesiredAssignment`, `ConnectionObservation`, `MigrationRun`, and `DeviceMigrationResult`. Plans retain an immutable revision, target roster, source observation timestamps, and infrastructure fingerprint.

SQLite suits local persistent inventory, plan history, and crash recovery. Store secrets through an OS credential store; persist references in the plan. Logs, exports, and previews must not expose API keys or Wi-Fi passwords. Do not assume the API will return usable passwords.

## Migration workflow

This is a ground-maintenance operation. The [local DLSE API](../api_definition/openapi_definition.yaml) documents automatic reboot after settings changes and refusal while armed. Require fresh disarmed status before writing; unknown state is a blocker. Retain explicit confirmation for the reviewed multi-device operation.

1. **Validate:** refresh identities, destination configuration, management reachability, credentials, addressing, UDP destinations/ports, and execution scope. Keep source networks available during migration. Confirm how devices on each target VLAN can be discovered/reached.
2. **Snapshot:** save the relevant prior settings securely and a durable execution journal. Do not include unrelated device settings in the write.
3. **Pilot:** migrate a small representative sample for every destination/capability combination, then verify before releasing the remaining queue.
4. **Apply in waves:** bound global and per-source/per-destination concurrency; use a shared request budget with fleet polling. Pause on failed pilots or excessive unresolved results.
5. **Reconnect:** correlate by stable identity at the new address. Treat a dropped POST response as an uncertain outcome and reconcile before retrying; the device may already have rebooted.
6. **Verify:** separately record accepted settings, DLSE reachability, observed target AP/group, and the required telemetry link. Distinguish partial evidence from complete verification. A network check is not a flight-readiness certification.
7. **Recover:** retry only unresolved work after revalidation, or restore old settings where the device remains reachable. Keep offline roster members pending until explicitly resumed against a freshly reviewed plan.

Suggested starting defaults for lab validation: one active write per destination, five globally; 5-second HTTP timeout; 120-second reconnect deadline; read retries twice with 1/2-second backoff and jitter. These are provisional, configurable limits. Do not automatically retry uncertain settings writes.

Cancellation stops new writes and continues tracking operations already sent. Restarting the application resumes reconciliation from the journal rather than blindly replaying requests. Prevent concurrent OTA, reboot, static-IP, and settings operations on affected devices.

**Current recovery limitation:** saving old settings does not permit rollback if the device cannot join any reachable network. Reliable automatic recovery requires firmware support such as staged credentials and a commit deadline that restores the old configuration unless the manager confirms success. Until then, document recovery access and the risk explicitly in the migration review.

The schema names the station SSID setting `ssid`, but the POST example uses `wifi_ssid`; resolve this contract discrepancy on the supported firmware before implementation. The existing `wifi_chan` setting is documented for AP/ESP-NOW mode and must not be presented as a station-channel selector.

## Implementation boundaries and scale

- Reuse `ui/models.py` fleet projections, selection, and the existing library's HTTP helpers. Add a Network Manager controller/model and QML view rather than expanding the current controller indefinitely.
- Put reusable UniFi integration and migration/planning logic in UI-independent modules; keep QML adapters and presentation logic under `ui/`. Preserve existing public library APIs.
- Fetch controller client lists in pages; cache AP/configuration data separately. Refresh live client observations more often than relatively static Wi-Fi definitions.
- Start with configurable 10-second client refresh and 60-second infrastructure refresh, extending intervals under load. Use timeouts, bounded retries/backoff, and controller rate-limit handling. Mark a collection complete only after all pages succeed; pagination changes must not create false disconnects.
- Share a total network-request budget with discovery/stats polling. Existing two-second device-stat targets must adapt for large fleets; do not add another independent 5,000-device poller.
- Merge changes incrementally and coalesce UI notifications. Maintain indexes by fleet UUID, station MAC, and current IP; benchmark current linear lookups/broad inventory notifications before assuming virtualization alone solves scale.
- Use a wired management connection where available. Work locally without internet after setup; cached plans remain readable if the controller is unavailable, while live verification becomes unavailable.

## Delivery sequence and acceptance gates

1. **Capability spike:** inspect a real target controller and supported DLSE firmware; verify station identity, settings names, observed fields, AP scope resolution, and reconnect behavior. Deliver a tested capability matrix.
2. **Read-only Network Manager:** connection/site setup, complete client inventory, AP/radio overview, identity matching, freshness and missing-data states. Gate: complete 5,000-client fixture across pagination, including partial failures.
3. **Persistent shows and planner:** manifests/groups, offline members, manual assignment, budgets, before/after preview, reusable plans. Gate: no hidden scope changes, unsupported assignments, or silently exceeded budgets.
4. **Staged migration:** confirmation, pilots, bounded waves, durable journal, reconnect verification, cancellation, and recovery guidance. Gate: lab tests for wrong password, missing AP, changed IP, lost response, controller outage, and application restart.
5. **Advanced controls:** firmware-assisted recovery/BSSID policy if needed, coverage zones, traffic calibration, and explicit failover plans. Continuous automatic reassignment during a show is outside the initial scope.

Test with deterministic 50-, 500-, and 5,000-drone fixtures; duplicate SYS IDs in different domains; station-MAC ambiguity; non-show occupancy; shared SSIDs; dual-band APs; AP/tag configuration drift; mixed chips; missing fields; and interrupted pagination. Benchmark selection/filtering and progress updates while ingestion runs. Validate radio capacity and movement coverage on representative hardware; simulated scale tests cannot establish RF capacity.

## Questions to settle before implementation

1. Are deployments based on dedicated SSIDs per AP/group, shared SSIDs, or both?
2. What persistent identifier do operators use, and how are crates and show manifests represented?
3. What chip/firmware mix must the first release support?
4. How does the existing show-control system isolate or address repeated SYS IDs at large fleet sizes?
5. Is a firmware change acceptable for safer rollback or precise AP targeting?

Recommended first scope: read-only UniFi integration, persistent show rosters, explicit SSID/AP-group assignment, honest planned-versus-observed status, and pilot-first migration.
