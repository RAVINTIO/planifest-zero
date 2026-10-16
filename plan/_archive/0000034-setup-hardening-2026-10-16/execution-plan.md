# Execution Plan - setup-hardening

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Wave:** not waved
**Version:** 0.4.1
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | n/a | No capability skill applies. The work edits Bash, PowerShell, inline Node, and markdown. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-retired-flags.md](requirements/req-001-retired-flags.md) | Both setup scripts warn about and skip four retired flags. |
| [req-002-exact-tool-name.md](requirements/req-002-exact-tool-name.md) | `setup.sh` matches the tool name exactly. |
| [req-003-atomic-settings-writes.md](requirements/req-003-atomic-settings-writes.md) | Every `settings.json` write goes through a temporary file and a rename. |
| [req-004-missing-node-warning.md](requirements/req-004-missing-node-warning.md) | `setup.sh` warns when `node` is missing and it skips the settings cleanup. |
| [req-005-stray-feature-id.md](requirements/req-005-stray-feature-id.md) | Delete the root `.feature-id`. |
| [req-006-human-request-source.md](requirements/req-006-human-request-source.md) | The backlog template allows `human request`. |

## Build Order

1. req-001, req-002, and req-004 edit separate functions in `setup.sh`. req-001 also edits `setup.ps1` argument parsing.
2. req-003 edits the `settings.json` write sites in both scripts. It runs after req-004, which touches the same cleanup function.
3. req-005 and req-006 are independent of the setup scripts and can run in parallel with step 1.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Compatibility | A current-flags run writes byte-identical `settings.json` to the `v0.4.0` script | req-003 suite |
| Robustness | 0 truncated `settings.json` files on a failed write | req-003 suite forces a failure |
| Security | The `--backend-url` value appears in no output and no file | req-001 suite |

## API and Data Summary

- No API. The CLI flag contract widens: four retired flags warn and continue.
- No data store. Setup writes `.claude/settings.json`, the flags marker, and the setup record in the target project, as in 0.4.0.
- Component: `planifest-zero` (existing). Its manifest moves to 0.4.1 and gains the retired-flag responsibility.
