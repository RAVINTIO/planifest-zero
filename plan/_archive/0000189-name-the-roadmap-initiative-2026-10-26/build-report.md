# Build report - 0000189-name-the-roadmap-initiative

> Sourced from the archived `build-log.md`.

**Run speed:** `fast`. The run was autonomous from P1. It stopped once, to recommend a context clear before P2.

## Agents, tiers, and time

| Phase | Agents | Tier | Parallel batches | Wall clock |
|-------|--------|------|------------------|------------|
| P0 Discovery | 0 | primary | 0 | 14m 49s |
| P1 Plan | 2 | primary | 2 | 4m 16s |
| P2 Implement | 4 | primary (sonnet for tracks A to C, haiku for track D) | 1 | 21m 17s |
| P3 Validate and Accept | 2 | primary | 1 | 5m 28s |
| P4 Ship | 1 | cheaper (haiku) | 1 | 0m 12s to the summary |

The agent total of 9 matches the phase rows. By tier, the phase rows give 6 sonnet (primary) and 3 haiku (cheaper) agents, which matches the summary.

- **P4 wall clock:** the first draft of the P4 block held a guessed start time that fell after its End time. Ship corrected Start to the first P4 commit, `02:30:17Z`. The P4 End marks the build-log summary. The archive, version bump, and PR came after it.
- **Total wall clock:** The summary records `290m 41s` and says it includes the gap between sessions. The P0 to P3 rows sum to 45m 50s. The remaining 244m 51s covers P4 and the gap between sessions. The log does not split them.

## Parallelism

- **P0** ran in sequence, with 0 agents and 0 batches.
- **P1** ran 2 parallel batches. The log lists haiku work on scope, risks, and glossary, and sonnet work on ADR-002 to ADR-005.
- **P2** ran 4 track agents in 1 parallel batch. REQ-007 and REQ-009 ran inline after the tracks, because both depend on every track. The log does not record why requirements within Tracks A and B ran one after another.
- **P3** ran verification and the security review in 1 parallel batch.
- **P4** recorded 1 batch with 1 agent. The log says the build assessment ran beside the version bump. It does not say how the version bump ran.

Four phases used parallelism: P1, P2, P3, and P4.

## Self-corrections

The log records one self-correction, on REQ-006.

- **What happened:** The brand guard flagged two `PLANIFEST_ROADMAP_*` lines in the new old-variable test. The fix added a line allowlist entry at 2026-10-26T02:17:17Z.
- **Avoidable:** Probably yes. REQ-006 removes the old fallback, so the test must name the old variable, and the guard scans for that name. The log shows no plan to allowlist these lines before the test ran, so the entry could have landed with the test. This assessment comes from the log entries, not from a recorded finding.

The P2 deviation that allowlists `plan/current/` is a recorded design change, not a rework. This report does not count it.

## Commit 8c7fb77

Commit 8c7fb77 also carried three pure renames, with no content change. Tracks A and B staged them. The renames are:

- `initiative-run.mjs`
- `initiative-labels.mjs`
- `initiative.template.md`

Later commits name explicit paths.

## Improvement suggestions

| Phase | Suggestion |
|-------|-----------|
| P0 | Check the design's counts against the items it lists before confirming. The log records A-003: the design says four initiative states but lists five. |
| P1 | Record one agent count per phase, matching the agents named in the row. The P1 row gives 2 agents but names seven. |
| P2 | When a test needs a name that a guard scans for, add the allowlist entry in the same change. This avoids the REQ-006 rework. |
| P3 | None. The phase had no self-correction cycles, and both agents finished. |
| P4 | Write the End row after the ship step completes. The current End time precedes the Start time. |

## Workflow governance

| Metric | Value | Threshold | Result |
|--------|-------|-----------|--------|
| Rework loops per requirement (highest) | 1 (REQ-006) | 2 | ok |
| `Blocked:` stops | 0 | 1 | ok |
| Mid-pipeline design changes | 0 | 1 | ok |
| Human corrections at gates | 0 | 2 | ok |

Breaches: 0. The gate reports and does not block. Counts come from marker lines only.
