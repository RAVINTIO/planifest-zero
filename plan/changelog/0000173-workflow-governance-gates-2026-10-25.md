# Changelog (0000173-workflow-governance-gates, 25 Oct 2026)

**Feature:** workflow-governance-gates
**Version:** 0.18.0
**PR:** pending, updated at Step 9

## What changed

The pipeline now measures its own workflow. Phase skills write four fixed marker lines to the build log. At ship, a script counts them and compares each count against a threshold in the pack. The build report and the PR description show the result. A breach never stops ship.

- req-001: `scripts/workflow-metrics.mjs` reads a run folder's `build-log.md` and `loop-state-*.md` files. It counts `Rework:`, `Blocked:`, `Requirement change:`, and `Gate revised:` markers at the start of a line or list item, outside fenced code. It prints a `## Workflow governance` table with counts and requirement ids only.
- req-002: `standards/workflow-governance-standards.md` defines the metrics, the marker forms, and a `## Thresholds` table. The defaults are 2, 1, 1, and 2. The script exits 0 with or without a breach.
- req-003: the implement and validate-and-accept skills write `Rework:`. The mid-pipeline change reference writes `Requirement change:`. The orchestrator writes `Gate revised:` at a gate in a gated run.
- req-004: ship Step 5 appends the section to `build-report.md`. Step 9 copies it into the PR body. If the script fails, ship writes `Workflow governance: not measured` with a fixed reason.

## Why

Backlog entry 0000100: the pipeline checked the product but not the workflow. A change to the skills could not show that it improved quality. The evaluation suite from the same entry stays in the backlog as 0000174.

## Deviations

- The orchestrator holds a short `Gate revised: P{N}` line without naming the standard. The 0000151 size budget left 57 bytes. The governance standard holds the full form. REQ-003 records it.
- The standard lists marker forms as bullets, because the `|` characters in one form would break a table cell. A tie on rework names the lower requirement id. REQ-001 records both.

## Validation results

- 155 feature and 19 regression Bash suites pass under macOS Bash 3.2 with `env -i`.
- All 12 acceptance criteria pass, verified by execution on fixture run folders and by `file:line` cites.
- Security review: overall low, no critical, high, or medium findings. S-001 to S-003 (low) are mitigated. The rest are accepted.

## Skipped phases

None
