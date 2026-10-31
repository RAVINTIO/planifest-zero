---
title: "Initiative: 0000312 - guards, history, and test noise"
summary: "Clears 16 backlog entries in 9 feature steps, with a setup rerun after each step that changes installed pack files."
status: "proposed"
---
# Initiative: 0000312 - guards, history, and test noise

**Goal:** Make the guards fail closed, keep every initiative history titled one commit per change, and stop step logs and session state breaking the suite. Step 1 teaches the driver to stop for a setup rerun, so each later step runs on installed copies that match the pack.
**Branch:** initiative/0000312-guards-history-and-test-noise
**Status:** proposed
**Position:** 1
**Speed:** standard

The human asked for this draft on 2026-10-31 and confirmed the scope and order the same day. Chart runs on `main` after PR #77 lands.

## Notes for chart

- **Ids reserved.** Commit `7d3f0b3` reserved `0000311` to `0000321` on 2026-10-31. Entry 0000311 took the first id. This draft uses `0000312` for the initiative and `0000313` to `0000321` for the step features.
- **Setup stops.** Step sessions load the installed copies in `.claude/`. Setup writes only ignored files, so a rerun needs a pause between steps, not a step or a commit. Step 1 adds a `Setup:` stop to the driver (entry 0000311). After it, the initiative skill reruns setup with the command that override `custom-006` approves, checks that every hook runs, and starts a new driver. See `## Setup stops`.
- **Step 1 runs on the old driver.** The driver loaded its code at activation, so step 1 ends with a `Restart:` stop. At that stop, the initiative skill reruns setup by hand with the same command, then starts the new driver.
- **Clean suite first.** Steps 2 and 3 remove the test noise that cost a note or a rerun in nine retrospectives, 0000245 to 0000253. Later steps then run on a clean suite.
- **Guards before history.** Steps 4 and 5 make the guards fail closed before step 6 changes how the coordinator commits.
- **Coordinator change mid-run.** Step 6 (entry 0000274) changes the initiative skill and the roadmap standards. After it lands, coordinator work reaches the initiative branch as titled PRs, including I-E Delivery.
- **Tracked workflow.** Setup writes `.github/workflows/ravintio.yml` only when it is missing (`setup.sh:729`). Step 7 must change the tracked copy in the same step as the pack's copy.
- **Security guards.** No entry widens `merge-guard`, `gate-write`, `ratchet-check`, or another fail-closed hook. Entries 0000276 and 0000288 make guards stricter. Entry 0000274 keeps `merge-guard` as it is.
- **Clarity check.** Every pulled-in entry has a **Wanted outcome** section with test conditions.

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a step PR.
- A step proposes a destructive change.
- A hook fails to run after a setup rerun.
- The setup command at a `Setup:` stop differs from the command that `custom-006` approves.

## Setup stops

| After step | Stop | Why |
|------------|------|-----|
| 1 | `Restart:`, then a setup rerun by hand | The step changes the driver and the initiative skill. |
| 2 | `Setup:` | The step changes the orchestrator and initiative skills. |
| 3 | none | The step changes tests and the test runner only. |
| 4 | `Setup:`, then a check that every hook runs | The step changes `setup.sh` and how setup wires hooks. |
| 5 | `Setup:` | The step adds a hook. |
| 6 | `Restart:` and `Setup:` | The step changes the initiative skill and other skills. |
| 7 | `Setup:` if the step changes the pack's hooks | The step adds a script and changes CI. |
| 8 | `Setup:` | The step changes two hooks, a script, and the migrator skill. |
| 9 | `Setup:`, before I-E Delivery | The step changes the backlog template and the orchestrator skill. |

## Schema changes

**Unpredicted additive changes:** stop

Chart fills this table on `main`.

## Dependencies

Chart fills this table on `main`.

## Decisions

Chart confirms these rows and adds the rest on `main`.

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1 | Confirmation: setup rerun at the step 1 `Restart:` stop | Run the exact command `ravintio-zero/setup.sh claude-code --strict-orchestrator`, as override `custom-006` approves. If the command differs in any way, stop for the human. | none |
| 2-9 | Confirmation: setup rerun at each `Setup:` stop | Run the same exact command. If it differs in any way, stop for the human. | none |
| 4 | A hook fails to resolve or run after the setup rerun | Stop for the human. Never carry on with a guard that doesn't run. | none |
| 7 | The step changes the pack's `ravintio.yml` | Change `.github/workflows/ravintio.yml` in the same step, because setup won't overwrite it. | none |

## Baselines

Chart fills this table on `main`.

## Criteria

Chart fills this table on `main`.

## P1 skips

Chart fills this table on `main`. Every step changes code, so the expected answer is `no` for each.

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000313-driver-setup-stop | 0000311 | minor | 0.41.0 | pending |
| 2 | 0000314-step-logs-stay-in-place | 0000264, 0000265 | patch | 0.41.1 | pending |
| 3 | 0000315-isolated-test-state | 0000309, 0000267 | patch | 0.41.2 | pending |
| 4 | 0000316-hooks-fail-closed | 0000287, 0000288 | minor | 0.42.0 | pending |
| 5 | 0000317-block-forced-adds | 0000276 | minor | 0.43.0 | pending |
| 6 | 0000318-titled-coordinator-prs | 0000274 | minor | 0.44.0 | pending |
| 7 | 0000319-initiative-history-checks | 0000275, 0000277, 0000278 | minor | 0.45.0 | pending |
| 8 | 0000320-quiet-session-start | 0000307, 0000282, 0000322 | minor | 0.46.0 | pending |
| 9 | 0000321-backlog-triage | 0000310 | minor | 0.47.0 | pending |

### Step grouping

- **Step 2:** both entries stop step logs in `plan/.initiative-logs/` from breaking or being moved by the suite.
- **Step 3:** both entries stop session state from changing test results.
- **Step 4:** both entries keep the guards working when the working directory moves.
- **Step 7:** all three entries catch an untitled or squashed history before or as it reaches `main`.
- **Step 8:** all three entries stop hook text that repeats or misfires: the load instruction, the migration findings, and the false prefix warning.
