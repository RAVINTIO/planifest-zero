---
title: "Execution Plan - self-host-on-planifest-zero"
summary: "Requirements directory, build order, and measurable targets for this feature."
status: "active"
version: "0.5.0"
---
# Execution Plan - self-host-on-planifest-zero

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Wave:** not waved
**Version:** 0.5.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | n/a | No capability skill applies. The work edits Bash, PowerShell, YAML, and markdown. |

## Functional Requirements Directory

| File | Requirement | Traces to |
|------|------------|-----------|
| [req-001-drop-telemetry-ci-job.md](requirements/req-001-drop-telemetry-ci-job.md) | CI has no `validate-telemetry-schema` job. | US-003, AC 5 |
| [req-002-refresh-script-flags.md](requirements/req-002-refresh-script-flags.md) | `refresh-planifest-zero-dir.ps1` passes no retired flag. | US-002, AC 6 |
| [req-003-setup-record-move.md](requirements/req-003-setup-record-move.md) | The setup record lives at `plan/state/claude-code.md`. | US-002, AC 3, 4, and 7 |
| [req-004-remove-old-framework.md](requirements/req-004-remove-old-framework.md) | The repo has no `planifest-framework/`, and git reads hooks from `planifest-zero/hooks`. | US-001, AC 1, 2, 8, and 10 |
| [req-005-override-phase-names.md](requirements/req-005-override-phase-names.md) | `custom-004-p9-push-and-raise-pr.md` names the ship phase. | AC 9 |
| [req-006-bash-suites-ci-job.md](requirements/req-006-bash-suites-ci-job.md) | CI runs the Bash suites in a `bash-suites` job. | US-004, AC 10 and 11 |
| [req-007-sh-filter-any-matcher.md](requirements/req-007-sh-filter-any-matcher.md) | `setup.sh` wires `gate-write` once per tool on any matcher. | US-005, AC 12 |
| [req-008-non-array-hook-events.md](requirements/req-008-non-array-hook-events.md) | Both setup scripts warn on a non-array hook event and wire the Planifest entries. | US-006, AC 13 and 14 |
| [req-009-assume-standard-iterative.md](requirements/req-009-assume-standard-iterative.md) | The orchestrator states standard-iterative mode without asking when it's the only signal. | US-007, AC 15 |

## Build Order

1. req-001, req-002, req-003, req-005, and req-009 touch separate files. They run as parallel subagents.
2. req-007 and req-008 share `setup.sh` and `setup.ps1`. One subagent runs them in sequence.
3. req-004 runs next. The old installed skills keep their source files until then.
4. req-006 runs last. Its job fails until the rename suite passes.

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Reliability | The full local test run passes. | 0 failing suites, against 1 today | Summary line of `planifest-zero/tests/run-tests.sh` |
| NFR-002 | Reliability | CI passes on the PR. | Every job green, `bash-suites` included | PR checks on GitHub |
| NFR-003 | Security | The `bash-suites` job holds no write access and no secret. | `contents: read`, `persist-credentials: false`, a checkout pinned to a commit SHA, and 0 `secrets` references | req-006 suite |
| NFR-004 | Integrity | Git keeps running the `commit-msg` hook after the deletion. | `git config core.hooksPath` prints `planifest-zero/hooks` | req-004 suite |

## API and Data Summary

- No API, so no OpenAPI spec.
- No data store. No component owns data.
- Component: `planifest-zero` (existing). The run changes its tests, tests README, setup scripts, and orchestrator skill. Its manifest moves to 0.5.0.
- The other changed files sit at repo level.

## Assumptions

Each is a risk item with likelihood: medium. The risk register logs them as A-001 to A-003.

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | No phase from P4 to P9 needs the four files that `planifest-zero/` lacks. | That phase reads a missing file and must stop for direction. |
| A-002 | Setup rewrites `writtenAt` in `plan/state/claude-code.md` on every run. | The maintainer sees an unexpected diff at the reinstall. |
| A-003 | `planifest-zero/setup.sh` reads `plan/state/claude-code.md` and carries no retired flag forward. | The post-merge reinstall replays a retired flag, which warns and installs nothing. |

## Open Questions

None.
