# Execution Plan - rename the runner lock and archive folder

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** plan
**Feature:** 0000192-rename-runner-lock-and-archive
**Version:** 0.19.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | | No capability skill applies |

## Decisions referenced

| ADR | Decision |
|-----|----------|
| ADR-001 | Keep the declared stack, with no new dependency |
| ADR-002 | Archive to an `-initiative-` folder and read both forms |

## Functional Requirements Directory

| File | Requirement | Source |
|------|------------|--------|
| [req-001-runner-lock.md](requirements/req-001-runner-lock.md) | The driver uses `plan/.initiative-runner.lock` | US-001 |
| [req-002-archive-folder.md](requirements/req-002-archive-folder.md) | Delivery archives to an `-initiative-` folder, and the driver reads both forms | US-002 |
| [req-003-old-name-guard.md](requirements/req-003-old-name-guard.md) | The guard flags both old names | US-003 |

## Build order

REQ-001 and REQ-002 both change `initiative-run.mjs` and `test-0000043-req-007-roadmap-driver.sh`, so they run as one track. REQ-003 follows, because the guard fails until both old names are gone.

## Non-functional requirements

- Rename completeness: 0 old names outside the allowlist.
- Regression: full suite green on Linux, macOS, and Windows in CI, with no test removed.

## API and data summary

- No API. No datasets. The lock file and archive folders are local working files.
