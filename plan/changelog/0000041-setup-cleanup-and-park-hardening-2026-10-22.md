# Changelog (0000041-setup-cleanup-and-park-hardening, 22 Oct 2026)

**Feature:** setup-cleanup-and-park-hardening
**Version:** 0.8.0
**PR:** https://github.com/planifest/planifest-zero/pull/18

## What changed

Setup now reports each settings fault once and never rewrites a file it rejects. The non-array warning no longer prints hook values, and park cleans up after a failed local commit.

- req-001: the telemetry cleanup in `setup.sh` skips `settings.json` in silence when the parse or the shape check fails. The hook install step then prints the one correct line. The shape rule now lives in one shared snippet, `PLANIFEST_SETTINGS_SHAPE_JS`.
- req-002: `setup.ps1` gets the same skip. A new helper, `Read-SettingsObject`, serves the cleanup and the hook install step. A one-item top-level array now stays byte-identical.
- req-003: both scripts warn `hooks.{event} in {file} is not an array. Setup replaced it with the Planifest entries.` The warning no longer prints the old value.
- req-004: if the chore branch's `git add` or commit fails, `park.mjs` unstages and deletes the entry, then returns to the feature branch. The original git error survives a failed cleanup.
- Park refuses an `--entry` that is the target entry path, so the cleanup never deletes the only copy.

A read or write failure in the cleanup still prints a warning, and setup carries on.

## Why

The telemetry cleanup read `settings.json` before the 0000040 shape check. The entries behind this release are:

- Backlog 0000127: `setup.sh` printed a wrong cleanup warning before the shape check line.
- Backlog 0000128: `setup.ps1` could rewrite a one-item top-level array as an object, so setup exited 0.
- Backlog 0000130: the non-array warning printed hook values, which can hold secrets.
- Backlog 0000129: a failed chore commit in `park.mjs` could carry the entry file back to the feature branch.

Decisions:

- ADR-001: the stack stays as it is.
- ADR-002: the cleanup skips unreadable settings, and the hook install step reports the fault once. Extends 0000033 ADR-002.
- ADR-003: the non-array warning drops the old value. Supersedes decision item 4 of 0000037 ADR-003.

## Deviations

- In P2, the human widened the cleanup skip from shape failures to parse failures. The confirmed design had kept the extra warning on invalid JSON. The design, the brief, and req-001 and req-002 record the change.
- P3 split the work by file rather than by the execution plan's two steps. The execution plan records the new order.
- In P4, the security review found that req-004 could delete the only copy of an entry (F-001). Park now refuses that `--entry`, and req-004 records the rule.

## Validation results

- CI run `39866180506` on PR #18: all four jobs pass.
- The 0000041 `.ps1` suite passes 78 of 78 on Windows PowerShell 5.1 and PowerShell 7.
- Throwaway PR #19 ran that suite against the old `setup.ps1`. It failed 23 assertions on 5.1 and 21 on 7, which confirms RED. The PR is closed and its branch deleted.
- The local runner passes 72 feature suites and 18 regression suites.
- Execution verification: 9 criteria verified, 0 failed, and 9 not-verifiable locally because `pwsh` is missing. CI covers those 9.
- Security: overall low. F-001 fixed in P4. F-002 filed as backlog 0000142. F-003 stays with backlog 0000139.
- The human accepted the build on 2026-10-22.

Backlog filed during this run:

- 0000139: a read-only `settings.json` gives a node stack trace in the `setup.sh` hook install step. This predates the feature.
- 0000142: park's entry path check doesn't follow symlinks.

## Skipped phases

None
