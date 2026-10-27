# Changelog (0000202-improvement-loops, 27 Oct 2026)

**Feature:** improvement loops
**Version:** 0.24.0
**PR:** #45

## What changed

- After a requirement reaches GREEN and refactor, the implement phase runs an improvement loop of up to 2 cycles. Each cycle dispatches a fresh-context reviewer. The reviewer names a simpler or cleaner design, or returns `no change worth making`, which stops the loop early.
- The refactor skill describes an improvement mode. It applies only the reviewer's finding, keeps its hard limits, and reverts the change if the suite fails.
- The dispatch standard has an `## Improvement loop` section with the cycle steps and the reviewer brief. The implement skill points to it and names the loop in the TDD loop block and the fast batch.
- The workflow governance standard lists two `Improve:` marker forms. `workflow-metrics.mjs` does not count them.
- `component.yml`, the architecture overview, and the pipeline reference name the loop.

## Why

The pipeline looped back to fix defects but stopped at the first green result, so a working solution was never reviewed for a cleaner design. Backlog entry 0000179 asked for a bounded improvement loop with a record of each cycle.

## Deviations

- The cycle steps live in `agent-dispatch-standards.md`, not in the implement skill. A first draft added 23 lines to the skills and breached the 1447-line budget in `test-0000031-req-003`. The skills keep short pointers.
- The refactor skill describes improvement mode in its output section, not in a section of its own, for the same reason.
- The installed copies under `.claude/skills/` keep the old skills until step 13 of initiative 0000195 reruns setup. `test-0000151-req-014` fails locally for that reason.
- The entry's title names validate loops. The wanted outcome covers P2 only, so P3 keeps its failure loops.

## Validation results

The feature suites pass except `test-0000151-req-014`, as noted above. The regression suite passes. The consistency check is clean on this run's plan. The security review found nothing above low.

## Skipped phases

None.
