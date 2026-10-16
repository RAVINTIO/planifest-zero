# Changelog (0000035-powershell-setup-parity, 17 Oct 2026)

**Feature:** PowerShell setup parity
**Pipeline run:** P0 to P9 completed. No phases skipped.
**PR:** https://github.com/planifest/planifest-zero/pull/8

## What Was Built

A Windows install made with `setup.ps1` now matches a bash install. This release delivers four backlog items:

- **Six hooks on Windows (0000090):** `setup.ps1` wires `ratchet-check` and `em-dash-guard`, using the same entries as `setup.sh`. A parity suite fails if the scripts drift.
- **Scalar hook values (0000094):** the legacy telemetry cleanup leaves a hook value that isn't an array unchanged.
- **PowerShell 5.1 and flag case (0000105):** `setup.ps1` drops `-AsHashtable` and the PowerShell 6 `` `u{} `` escape. Flags and the tool name match case, as in `setup.sh`.
- **Leftover temporary file (0000104):** both scripts remove a leftover `settings.json.planifest-tmp` at the start of each run.

P5 also hardened `setup.ps1`. It now reads and writes `settings.json` as UTF-8 with no BOM, and it never follows a link at the temporary path.

## Artifacts Produced

- `discovery.md`, `design.md`, `build-log.md`, `feature-brief.md`
- `execution-plan.md`, `scope.md`, `risk-register.md`, `domain-glossary.md`
- `requirements/req-001` to `req-005` (five files)
- `adr/ADR-001` to `ADR-003` (three files)
- `security-report.md`, `recommendations.md`, `iteration-log.md`

## Decisions

- **ADR-001:** `setup.ps1` writes the same hook entries as `setup.sh`.
- **ADR-002:** `setup.ps1` supports Windows PowerShell 5.1.
- **ADR-003:** `setup.ps1` flags are case-sensitive, and both scripts remove a leftover temporary file at the start of each run.

## Skipped Phases

None
