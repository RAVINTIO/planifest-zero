# Changelog (0000246-plan-checks-count-and-cap-tests, 28 Oct 2026)

**Feature:** Plan checks count and cap tests
**Version:** 0.35.0
**PR:** pending

## What changed

- `ravintio-plan/SKILL.md` has a `## Test impact scan` section. The plan agent greps `ravintio-zero/tests/` for tests that hold a skill count, a skill-text budget, a size cap or a backlog entry id.
- `execution-plan.template.md` has a `## Test impact` table of cause, test and unit. A row writes `none found` when a grep matches nothing.
- `test-0000246-req-001-test-impact-scan.sh` fails when either file loses its section or the scan grows past 15 lines.
- `docs/architecture-overview.md` and `docs/decisions-index.md` describe the scan (ADR-001).

## Why

Run 0000204 lost three test runs to tests the plan never named. Backlog entry 0000210 asked for the plan to name them up front.

## Deviations

None.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
