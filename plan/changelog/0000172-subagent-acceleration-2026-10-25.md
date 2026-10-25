# Changelog (0000172-subagent-acceleration, 25 Oct 2026)

**Feature:** subagent-acceleration
**Version:** 0.17.0
**PR:** [#33](https://github.com/RAVINTIO/ravintio-zero/pull/33)

## What changed

A run now has a speed as well as a mode. At `fast`, each phase dispatches the units in its `### Fast batch` list, each batch in one message. Phases still run in order, and every gate and exception stop stays in place. The build log records each phase's end time and wall-clock time. The release adds no dependency, script, or hook.

- req-001: after the run-mode question, the orchestrator asks for a run speed and writes `standard` or `fast` to `plan/.run-speed`. A missing or unknown value counts as `standard`. A roadmap step takes the roadmap's optional `**Speed:**` field. Ship Step 8 deletes the file with the other sentinels. The rules live in `references/orchestrator-run-speed.md`.
- req-002: the dispatch standard gains `## Fast batches`. Units in a batch write disjoint files, commit one at a time, and stop together on an exception. The plan, implement, validate-and-accept, and ship skills each list their fast batch.
- req-003: the build-log template gains `Run speed`, `End`, `Wall clock`, and `Total wall clock` rows. The orchestrator fills `End` and `Wall clock` when each phase completes. The build report lists them with the agent count.

## Why

Backlog entry 0000110: each phase decided for itself when to split work, so a run with many independent units still moved slowly. The build log held no phase duration, so no one could measure a gain.

## Deviations

- The run-speed question and rules moved from the orchestrator `SKILL.md` to a new reference file. `SKILL.md` has a size budget and keeps its base lines word for word (0000151 req-011). REQ-001 records the change.
- P3 found three medium gaps in the fast batch rules (S-001 to S-003). The rules now cover a stop in one unit, shared dependency manifests, and concurrent commits.
- Backlog entries 0000179 to 0000182 joined this branch from another session while the step ran. The run reworded three lines in 0000177 and 0000182 to pass the wording suite.

## Validation results

- 151 feature and 19 regression Bash suites pass under macOS Bash 3.2 with `env -i`. The PowerShell suites pass under `pwsh` 7. One `pwsh` start-up hit a .NET culture error once, then passed 3 runs out of 3.
- All 9 acceptance criteria pass, verified by execution, with a mutation check per requirement.
- Security review: overall low, no critical or high findings. S-001 to S-003 (medium) are mitigated. The low and informational findings are accepted.

## Skipped phases

None
