# Changelog (0000218-strict-hook-follows-active-skill, 27 Oct 2026)

**Feature:** Strict hook follows the active skill
**Version:** 0.30.1
**PR:** pending

## What changed

- `check-orchestrator-presence.mjs` picks the banner skill from `plan/current-initiative/initiative.md` and `RAVINTIO_INITIATIVE_STEP`, in strict and advisory mode. It no longer reads the driver lock.
- `auto-trigger-orchestrator.mjs` applies the same rule and no longer requires an empty `plan/current/`.
- `.gitignore` now lists `plan/.initiative-ack`.
- `roadmap-standards.md` and `project-operations.md` describe the rule.
- A new suite, `test-0000218-req-001-002-skill-owner-banner.sh`, covers all six criteria for both hooks.

## Why

The lock is free between steps and after the driver exits. The human's session then got the orchestrator banner while an initiative was active, and the orchestrator's resume detection could take over a step. During step 13 the banner also asked the human's session for the ack that the step session owns.

## Deviations

- The auto-trigger hook drops its empty `plan/current/` condition, so both hooks always name the same skill.
- The 0000205 hook suite changed to match, and both suites clear `RAVINTIO_INITIATIVE_STEP` because a step session sets it.

## Validation results

Bash runner: 199 feature suites and 19 regression checks passed. PowerShell runner: 19 suites passed. See `acceptance-evidence.md` in the archive.

## Skipped phases

P1 Plan: skipped. The backlog entry fixes the spec.
