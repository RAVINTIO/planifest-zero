# Changelog (0000239-test-suite-reliability, 28 Oct 2026)

**Feature:** Test suite reliability
**Version:** 0.30.2
**PR:** pending

## What changed

- `helpers/assert.sh` gains `assert_not_contains`.
- `print_summary` fails a suite that calls an undefined `assert_*` function.
- `helpers/assert.sh` gains `stale_install_skip_reason`. Section (c) of `test-0000151-req-014` prints `SKIP` and runs no comparison while an initiative is active and the install manifest lags the pack.
- Two new suites cover both behaviours: `test-0000239-req-001-undefined-assert-fails.sh` and `test-0000239-req-002-stale-install-skip.sh`.
- The tests README, the architecture overview, and the decisions index describe the guards.

## Why

A suite that called an undefined assert function printed `command not found` and still passed. The installed-copies check failed in every initiative step, because `.claude/skills/` changes only when setup runs.

## Deviations

- The plan chose `command_not_found_handle` with a temp file. macOS Bash 3.2 has no such handler, so `print_summary` scans the suite for lines that start with an `assert_*` word. ADR-001 records the change.
- The scan does not cover a call after `&&` or inside `$(...)`.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
