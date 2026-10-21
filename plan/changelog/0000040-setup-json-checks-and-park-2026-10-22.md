# Changelog (0000040-setup-json-checks-and-park, 22 Oct 2026)

**Feature:** setup-json-checks-and-park
**Version:** 0.7.0
**PR:** https://github.com/planifest/planifest-zero/pull/17

## What changed

Both setup scripts now reject valid JSON they can't use. A new park command shelves a part-finished feature on its branch.

- req-001: if `settings.json` is valid JSON but not a settings object, `setup.sh` prints one fixed line and exits 1. The same applies when `hooks` is present and not an object. A `hooks` value of `null` counts as absent. The file stays unchanged.
- req-002: `setup.ps1` prints the same line for the same inputs and for case-duplicate keys.
- req-003: `Test-JsonText` in `setup.ps1` tracks depth with an integer and a `Stack[char]`. Its cost grows linearly with input length, and it stops at depth 1024.
- req-004: the orchestrator skill gains a Park Command section and a new `park.template.md`. Park writes `plan/current/park.md` and pushes the feature branch. It then raises a `chore/park-{id}` PR with a `parked` backlog entry and checks out `main`.
- req-005: at P1 backlog pickup, a `parked` entry offers resume or discard. Resume detection finishes the chore PR step when it finds `park.md` with no chore PR.
- The backlog entry template allows status `parked` and gains a `**Parked branch:**` field.
- `skills/planifest-orchestrator/scripts/park.mjs` runs the git and `gh` steps for park, resume, and discard.

The shared line is `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`

## Why

Setup could report the hooks as installed while it left a non-object `settings.json` unchanged. The entries behind this release are:

- Backlog 0000121: `setup.sh` accepted an array as the settings object.
- Backlog 0000120: `setup.ps1` called some valid JSON invalid.
- Backlog 0000122: the strict JSON check in `setup.ps1` slowed with the square of the depth.
- Backlog 0000101: no command shelved a part-finished feature without hand reverts.

Decisions:

- ADR-001: the stack stays as it is.
- ADR-002: a non-object `settings.json` exits 1 with a fixed message.
- ADR-003: only `setup.ps1` rejects case-duplicate keys, because node reads them.
- ADR-004: the JSON depth cap is 1024.
- ADR-005: park keeps the work on the feature branch and files the entry through a chore PR.

## Deviations

Park's git and `gh` steps live in `park.mjs` beside the orchestrator skill, not in the skill text alone. Node runs on every platform, so park needs no `.ps1` twin. The execution plan records this.

## Validation results

- CI run `39647163506` at `837025a`: all four jobs pass.
- The 0000040 `.ps1` suite passes 155 of 155 on Windows PowerShell 5.1 and PowerShell 7.
- The local runner passes 70 feature suites and 18 regression suites.
- Execution verification: 15 of 15 acceptance criteria verified by execution.
- Security: overall Low. The review found F-001 to F-005 in `park.mjs` (2 medium, 3 low). Commit `108d1ce` fixes all five with tests.
- The human accepted the build on 2026-10-22.

Backlog filed during this run:

- 0000127: `setup.sh` telemetry cleanup warns on a `null` file.
- 0000128: `setup.ps1` telemetry cleanup can rewrite a one-item top-level array.
- 0000129: a failed chore commit in `park.mjs` can carry the entry file.
- 0000130: the non-array warning prints the old hook value. This predates the feature.

## Skipped phases

None
