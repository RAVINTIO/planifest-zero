# Execution Plan - powershell-setup-parity

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Wave:** not waved
**Version:** 0.4.2
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | n/a | No capability skill applies. The work edits Bash, PowerShell, and markdown. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-six-hooks-on-windows.md](requirements/req-001-six-hooks-on-windows.md) | `setup.ps1` wires the same six hooks as `setup.sh`. |
| [req-002-scalar-hook-values.md](requirements/req-002-scalar-hook-values.md) | The legacy cleanup skips a non-array event value. |
| [req-003-powershell-5-1.md](requirements/req-003-powershell-5-1.md) | `Merge-AllowedTools` drops `-AsHashtable`. |
| [req-004-flag-case.md](requirements/req-004-flag-case.md) | The `setup.ps1` flag `switch` is case-sensitive. |
| [req-005-leftover-temp-file.md](requirements/req-005-leftover-temp-file.md) | Both scripts remove a leftover temporary file at the start of each run. |

## Build Order

1. req-001 to req-004 edit separate functions in `setup.ps1`. They run in sequence in one context, because they share the file.
2. req-005 edits both scripts and runs last.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Compatibility | A `setup.sh` run writes byte-identical `settings.json` to 0.4.1 | Existing 0000034 req-003 suite |
| Parity | 0 differences in the hook modules each script wires | req-001 parity suite |
| Robustness | 0 leftovers after a completed run | req-005 suite |

## API and Data Summary

- No API. `setup.ps1` flags become case-sensitive.
- No data store. Setup writes `.claude/settings.json` in the target project, as in 0.4.1.
- Component: `planifest-zero` (existing). Its manifest moves to 0.4.2.
