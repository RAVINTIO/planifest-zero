# Changelog (0000248-ship-merge-and-wall-clocks, 28 Oct 2026)

**Feature:** Ship merge command and wall clock check
**Version:** 0.37.0
**PR:** #66

## What changed

- `ravintio-ship/SKILL.md` gives the step merge as one plain line, `gh pr merge --squash --delete-branch {n}`. It says `{n}` is the literal PR number from the `gh pr create` output and forbids command substitution, variables, and pipes on the line. I-D Advance step 4 in `roadmap-standards.md` carries the same wording. `merge-guard` is unchanged (entry 0000228).
- `ravintio-zero/scripts/build-log-check.mjs` fails a build log with a blank `Start`, `End`, or `Wall clock`, a `Wall clock` more than one minute from `End` minus `Start`, a missing phase block with no `Skipped: P{n}` line, or a `Total wall clock` that is blank or reads `not recorded`. Ship Step 3 runs it before Archive and stops on a failure (entry 0000232, ADR-001).
- `build-log.template.md` names the `Skipped: P{n}` line.
- Two tests: `test-0000248-req-001-plain-merge-command.sh` and `test-0000248-req-002-build-log-wall-clock-check.sh`.
- `docs/architecture-overview.md`, `docs/decisions-index.md`, and `component.yml` describe both changes.

## Why

In initiative 0000195, `merge-guard` blocked the first merge command in 5 of 15 steps, because each agent built the line with command substitution. Steps 11 to 15 also archived build logs with blank or zero wall clocks, so the retrospective could not compute step times.

## Deviations

Requirement AC-3 of REQ-001 (`merge-guard` unchanged) moved from a test to a P3 `git diff` check. A live diff in a test breaks on later branches.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
