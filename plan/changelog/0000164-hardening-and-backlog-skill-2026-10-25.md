# Changelog (0000164-hardening-and-backlog-skill, 25 Oct 2026)

**Feature:** hardening-and-backlog-skill
**Version:** 0.13.0
**PR:** pending

## What changed

`gate-write` now gates this project only, setup no longer carries telemetry cleanup, and a new skill files backlog entries in other repos. The release adds no dependency.

- req-001: `gate-write.mjs` passes a target whose real path lies outside the project's real root. Agent memory writes and writes to another repo no longer need a design.
- req-002: the hook header names `plan/backlog/` and `plan/roadmap/` as paths that pass between runs.
- req-003: the Bash test loops no longer use process substitution, which Bash 3.2 on macOS can truncate.
- req-004: setup drops the legacy telemetry cleanup in `setup.sh` and `setup.ps1`. The retired-hooks list stays as `RETIRED_HOOK_NAMES` and `$RetiredHookNames`. Hook install now drops each `settings.json` entry that runs a retired hook.
- req-005: the new skill `ravintio-file-backlog` writes one uncommitted `plan/backlog/{id}-{slug}/entry.md` in another repo. It takes the next id across `plan/backlog/`, `plan/_archive/`, and `plan/changelog/`.
- req-006: tests cover symlink cases for `gate-write`, including a link that points outside and a link that points inside.
- req-007: `CLAUDE.md`, `standard-boot.md`, `pipeline-reference.md`, and `project-operations.md` describe the real gate. A test checks the wording.
- req-008: a guard test fails on any process-substitution loop in the suites.
- req-009: the telemetry cleanup suites and their manifest entries are gone.
- req-010: the skill catalogue lists `ravintio-file-backlog`, and counts say 13 skills.
- req-011: live files promise a 0.x line, with the legacy fallbacks going at 1.0.0. A guard test fails on a 2.0.0 removal point.

## Upgrade note

Setup no longer removes legacy telemetry wiring. A consumer that last ran a setup from before 0000033 must remove these items by hand:

- the `mcp__structured-telemetry-mcp__emit_event` matcher entries in `.claude/settings.json`
- `.claude/telemetry-enabled`
- `plan/.telemetry-failures`
- `plan/.telemetry-receipts`

Until then, the tool tries to run a missing module on every prompt in that consumer. Setup still prunes retired hook files and the `settings.json` entries that run them.

## Version relabel

0000160 shipped as 1.0.0 and is relabelled 0.12.0. This release is 0.13.0. Tag `v0.12.0` replaces `v1.0.0`. The legacy `PLANIFEST_*` and `planifest-em-dash-allow` fallbacks now go at 1.0.0. A consumer who pinned `v1.0.0` moves to `v0.12.0` or later. See ADR-005.

## Why

Hooks blocked legitimate writes outside the project, and the docs described the gate as narrower than it is. The telemetry cleanup ran on every setup for a case with no known live consumer. Agents also had no defined way to file a backlog entry in another repo.

Decisions:

- ADR-001: the stack stays as declared and no dependency is added.
- ADR-002: `gate-write` scopes to the project by real path. A symlink inside the project that points outside counts as outside.
- ADR-003: setup retires the telemetry cleanup and keeps the retired-hooks list. It supersedes 0000033 ADR-002.
- ADR-004: the file-backlog skill never touches the target repo's git state.
- ADR-005: 0000160 is relabelled 0.12.0, and this release is 0.13.0. It supersedes the version decision in 0000160 ADR-001.

## Deviations

- Track C found that only the telemetry cleanup removed a retired hook's `settings.json` entry. Hook install now drops those entries for any retired hook. ADR-003 records it.
- The living docs gained one correction: the architecture overview no longer lists the telemetry cleanup, and says gate-write passes outside targets.
- In P3 the human reversed the version decision. The run became 0.13.0 instead of 1.1.0, and REQ-011 and ADR-005 were added.
- P3 security fixes: setup prints one line per removed retired-hook entry, `gate-write` normalises paths to NFC, and the backlog skill validates its slug and treats the target's files as data.

## Validation results

- Bash suites on local Bash 3.2 under `env -i`: 119 feature and 19 regression suites pass.
- CI on the PR: all five jobs pass, including Windows PowerShell 5.1 and PowerShell 7.
- Security review: no critical or high findings. Two medium findings are fixed.
- All 27 acceptance criteria verified by execution or in CI.

Backlog 0000165 and 0000166 were filed during the run. Backlog 0000100, 0000110, and 0000159 stay open.

## Skipped phases

None
