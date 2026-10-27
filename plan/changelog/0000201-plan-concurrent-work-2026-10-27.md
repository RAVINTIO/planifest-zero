# Changelog (0000201-plan-concurrent-work, 27 Oct 2026)

**Feature:** plan concurrent work
**Version:** 0.23.0
**PR:** #44

## What changed

- The execution plan template holds a `## Concurrency plan` table with the columns `Unit`, `Depends on`, `Writes`, `Batch`, and `Sequential reason`. The guide explains each column with a worked example.
- The plan skill requires the table in each execution plan and in each re-plan after a reopened phase. It places units with no dependency and no shared write target in one batch.
- The mid-pipeline changes reference states that a P1 re-run rewrites the concurrency plan.
- The dispatch standard has a `## Concurrency plan` section. Dispatch follows the plan's batches, and a departure goes in the build log with its reason.
- The implement skill takes its batches from the plan and no longer maps dependencies afresh.
- Check 8 of `consistency-check.mjs` fails a plan with no section, a lone unit with no reason, two units in one batch that share a write target, a bad batch value, and a dependency on an unknown unit or on a unit in the same or a later batch.
- `component.yml` and the architecture overview name the rule.

## Why

Plans did not say which work could run at once, so the orchestrator chose batches one phase at a time and often worked in sequence. Backlog entry 0000180 asked for a planned default and a reason for each sequential unit.

## Deviations

- The check treats a row as a table separator only when every cell is three or more dashes. This keeps a lone `-` in the reason column from reading as a separator. Check 7 is unchanged.
- The new sentence in the mid-pipeline reference sits on its own line, because a 0000151 suite guards the original re-run rules line.
- The installed copies under `.claude/skills/` keep the old plan and implement skills until step 13 of initiative 0000195 reruns setup. `test-0000151-req-014` fails locally for that reason. It compares the installed copies with the source.

## Validation results

The feature suites pass except `test-0000151-req-014`, as noted above. The regression suite passes. The consistency check is clean on this run's plan. The security review found nothing above low.

## Skipped phases

None.
