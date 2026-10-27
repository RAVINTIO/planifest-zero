# Changelog (0000206-chart-time-decisions, 27 Oct 2026)

**Feature:** chart-time decisions
**Version:** 0.28.0
**PR:** pending, updated at Step 9

## What changed

- Chart now writes three more tables in `initiative.md`: `## Decisions`, `## Baselines`, and `## Criteria`. The new Chart-time decisions section in the roadmap standards sets the rules: a pre-mortem per step, a baseline before a performance target, a criterion critic, pre-approved fallbacks, a bump rule, an environment check, and the latest retrospectives as input.
- A step that meets a fork matching a `## Decisions` row applies the answer and its bump effect, logs `Decision applied (initiative chart): {fork}`, and stops only for a fork no row covers. A criterion marked `CI` counts as validated after the step's first CI run.
- A worked example replays the four roadmap 0000168 step 3 stops against four rows.
- The initiative and orchestrator skills each gain one line that points to the rules.

## Why

Roadmap 0000168 stopped step 3 for four decisions that Chart could have taken, and a PowerShell bug passed P3 locally because the machine had no `pwsh`. Backlog entry 0000186 asked for chart-time approval of these forks.

## Deviations

- The orchestrator skill pointer is one short line, because a longer one passed the 27,800-byte cap in test 0000151 req-011.
- The installed copies under `.claude/skills/` keep the old skills until step 13 of initiative 0000195 reruns setup. `test-0000151-req-014` fails locally for that reason.
- The driver that runs this initiative started before this step, so steps 12 and 13 keep the old stage rules.

## Validation results

Every suite passes except `test-0000151-req-014`, as noted above. The security review found nothing above low.

## Skipped phases

None.
