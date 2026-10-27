---
title: "Backlog Entry: 0000232 - ship accepts a build log with blank wall clocks"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000232 - ship accepts a build log with blank wall clocks

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

Ship archives a build log even when its phase blocks hold no times. Steps 11 to 15 of initiative 0000195 recorded no usable phase wall clocks. The archived build logs show it:

| Step | Archive | Phase blocks | Blank End or Wall clock | Wall clock `0` | Total wall clock |
|------|---------|--------------|-------------------------|----------------|------------------|
| 11 | `plan/_archive/0000206-chart-time-decisions-2026-10-27/` | 5 | 1 (P1) | 4 | `0 minutes recorded per phase` |
| 12 | `plan/_archive/0000207-codex-support-2026-10-27/` | 5 | 0 | 5 | `not recorded` |
| 13 | `plan/_archive/0000208-refresh-setup-record-2026-10-27/` | 1 (P0 only) | 1 | 0 | `not recorded` |
| 14 | `plan/_archive/0000217-verify-codex-setup-2026-10-27/` | 1 (P0 only) | 1 | 0 | `not recorded` |
| 15 | `plan/_archive/0000218-strict-hook-follows-active-skill-2026-10-27/` | 1 (P0 only) | 1 | 0 | `not recorded` |

The `0` values are wrong, not short. Step 11's P0 block runs from `12:09:04Z` to `12:11:27Z` and still says `0`. Steps 13 to 15 wrote no P2 to P4 blocks at all. Their Summary tables say `not recorded` in every Wall clock cell.

`ravintio-zero/skills/ravintio-ship/SKILL.md` Step 3 tells ship to fill the P4 `End`, the P4 `Wall clock`, and the `Total wall clock`. Nothing checks the result. `ravintio-zero/scripts/consistency-check.mjs` has no build log check. The retrospective could not compute step times from the build logs, so it used merge commit times instead.

## Suggested Action

- Add a build log check to `consistency-check.mjs`, or a ship step that runs one before Archive.
- Fail when a phase that ran has no block, or its block has a blank `Start`, `End`, or `Wall clock`.
- Fail when `Wall clock` differs from the minutes between `Start` and `End` by more than one.
- Fail when `Total wall clock` reads `not recorded` or is blank.
- Accept a phase the build log marks as skipped, with no block.

## Wanted outcome

Ship stops before Archive when the build log has a blank or wrong wall clock. Tests check these conditions:

- A build log with a blank `End` in any phase block fails the check and names the phase.
- A build log with a blank `Wall clock` in any phase block fails the check and names the phase.
- A P0 block from `12:09:04Z` to `12:11:27Z` with `Wall clock` `0` fails the check.
- A build log whose P2 block is missing fails the check, unless the log marks P2 as skipped.
- A `Total wall clock` of `not recorded` fails the check.
- A complete build log from the template passes.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. This entry holds one of them.
