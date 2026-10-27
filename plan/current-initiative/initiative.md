---
title: "Initiative: 0000195 - backlog clearance"
summary: "Clears 14 open backlog entries in 12 feature steps, then a chore step refreshes the setup record and commits the queued entries."
status: "active"
---
# Initiative: 0000195 - backlog clearance

**Goal:** Clear every valid open backlog entry from 2026-10-26, one feature release per step. A final chore step refreshes the setup record and commits the backlog entries that the steps queued.
**Branch:** initiative/0000195-backlog-clearance
**Status:** active
**Position:** 7
**Speed:** standard

The human asked for this draft on 2026-10-26. The human approved the chart on 2026-10-27, and I-B Activate ran the same day.

## Out of scope

Backlog entry 0000174 (skill evaluation suite) stays in the backlog. It needs a new paid service for `claude -p` calls, and the human must decide who pays. Chart can pull it in if the human approves the service and its cost.

## Notes for chart

- **Clarity check:** entries 0000190, 0000193, and 0000194 had no **Wanted outcome** section. At chart on 2026-10-26, the human asked for one in each, drafted from its **Suggested Action**.
- **Order:** steps 1 to 3 are small fixes that cut friction in later steps. Step 4 comes before step 10, because the initiative skill queues entries with ids from the step 4 counter. Step 8 comes before step 9, because retrospectives read postmortems. Steps 9 and 10 come before step 11, because chart-time decisions read retrospectives and use the initiative skill.
- **Shared files:** step 1 holds both setup entries. Both change argument parsing in `setup.sh` and `setup.ps1`, so one step avoids two edits of the same lines. Step 5 holds both reply entries for the same reason. Each one adds a reply rule to the boot file and the orchestrator skill.
- **Counter seed:** feature ids 0000196 to 0000208 are reserved below, and backlog entry 0000209 exists. Step 4 seeds `plan/backlog/.next-id` at `0000210` or higher, so later ids don't clash with them.
- **Driver changes mid-run:** step 10 changes `initiative-run.mjs`, the ship skill, and where I-E Delivery runs. The driver that runs this initiative started before step 10. Steps 11 to 13 and I-E Delivery keep the stage rules in place at activation, unless chart decides otherwise.
- **Installed skills:** step sessions load skills from `.claude/skills/`, which change only when setup runs. Step 13 reruns setup, so the installed skills match the pack before delivery.

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a step PR.
- A step proposes a destructive change.
- A step needs a library or service that the Dependencies table doesn't list.

## Schema changes

**Unpredicted additive changes:** pre-approved

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1 | none | none | none |
| 2 | none | none | none |
| 3 | none | none | none |
| 4 | none | none | none |
| 5 | none | none | none |
| 6 | none | none | none |
| 7 | none | none | none |
| 8 | none | none | none |
| 9 | none | none | none |
| 10 | none | none | none |
| 11 | none | none | none |
| 12 | none | none | none |
| 13 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1 | none | none | none |
| 2 | none | none | none |
| 3 | none | none | none |
| 4 | none | none | none |
| 5 | none | none | none |
| 6 | none | none | none |
| 7 | none | none | none |
| 8 | none | none | none |
| 9 | none | none | none |
| 10 | none | none | none |
| 11 | none | none | none |
| 12 | none | none | none |
| 13 | none | none | none |

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000196-setup-argument-checks | 0000193, 0000194 | minor | 0.20.0 | merged |
| 2 | 0000197-merge-guard-block-message | 0000190 | patch | 0.20.1 | merged |
| 3 | 0000198-cap-echoed-plan-text | 0000176 | patch | 0.20.2 | merged |
| 4 | 0000199-reserve-ids-from-counter | 0000183 | minor | 0.21.0 | merged |
| 5 | 0000200-reply-conventions | 0000181, 0000209 | minor | 0.22.0 | merged |
| 6 | 0000201-plan-concurrent-work | 0000180 | minor | 0.23.0 | merged |
| 7 | 0000202-improvement-loops | 0000179 | minor | | pending |
| 8 | 0000203-blameless-postmortems | 0000177 | minor | | pending |
| 9 | 0000204-run-and-initiative-retrospectives | 0000178 | minor | | pending |
| 10 | 0000205-initiative-skill | 0000182 | minor | | pending |
| 11 | 0000206-chart-time-decisions | 0000186 | minor | | pending |
| 12 | 0000207-codex-support | 0000175 | minor | | pending |
| 13 | 0000208-refresh-setup-record | none (chore) | patch | | pending |

## Step 13 chore

Step 13 has no backlog entry. It runs these tasks:

1. Run the `ravintio-refresh-setup` skill with the flags in `plan/state/claude-code.md`. The run updates the `writtenAt` value in that file and reinstalls the skills from the pack.
2. Commit each backlog entry that the steps queued during the initiative, one commit per entry.

**Wanted outcome:** `plan/state/claude-code.md` holds a `writtenAt` value later than the step 12 merge. Every queued backlog entry is in `plan/backlog/` on the initiative branch, and the working tree is clean.
