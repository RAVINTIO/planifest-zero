---
title: "Retrospective: 2026-10-27 - backlog clearance initiative"
summary: "A blameless review of initiative 0000195, which shipped 15 steps from 0.20.0 to 0.30.1, and the changes it proposes."
status: "open"
---
# Retrospective: 2026-10-27 - backlog clearance initiative

> Path: `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. It never names a person or an agent.

**Mode:** initiative
**Subject:** 0000195-backlog-clearance
**Date:** 2026-10-27

## Summary

The initiative merged 15 steps into `initiative/0000195-backlog-clearance`, from v0.20.0 to v0.30.1. It cleared 15 backlog entries. Twelve steps ran without a stop. One step stopped for a confirmation, and the human added two steps after step 13 merged. The main gaps sat in the tooling around the steps: chart review, progress visibility, id reservation, and the merge guard.

## What helped

- Each step merged into the initiative branch with CI green and its tag pushed. No step needed a revert (`git log --first-parent`, tags `v0.20.0` to `v0.30.1`).
- The chart ordered steps so that early fixes helped later steps. Step 4 seeded the id counter before steps 9 to 15 filed entries (`initiative.md`, Notes for chart).
- Tests written first gave proof of effect in most steps. Step 15 failed 12 assertions before its fix and passed 44 after it (`plan/.initiative-logs/step-15.log`).
- A step that repeated an earlier step's shape reused its archive (`plan/retrospectives/0000204-run-and-initiative-retrospectives-2026-10-27.md`).
- The charted override text let the step 13 re-run finish with no further stop (`plan/retrospectives/0000208-refresh-setup-record-2026-10-27.md`).
- Step 14 ran Codex for real, which exposed a false claim from step 12 (`plan/retrospectives/0000217-verify-codex-setup-2026-10-27.md`).

## What slowed the work

### Chart

- At chart on 2026-10-26, the human asked for a **Wanted outcome** in entries 0000190, 0000193, and 0000194. The draft for 0000190 widened the fix to skip heredoc bodies in `merge-guard`. That would have weakened a fail-closed guard, because its shell blocklist misses forms such as `python3 -c`, `xargs`, and `find -exec`. The human caught it in review, and chart cut 0000190 back to a message-only fix (commit `f2df492`). No chart check asks whether an entry widens what a guard lets through.

### Progress visibility

- The driver started before step 10 shipped the `ravintio-initiative` skill and `initiative-watch.mjs` (`initiative.md`, Notes for chart). The human's session had no progress watcher, and the human asked three times for an update.
- After step 10, the watcher gave false events. It repeated stale warnings during P3 test runs. It replayed the whole repo history as new commits after a branch switch. It reported the lock as held after release (`plan/backlog/0000216-watcher-false-events/entry.md`).
- The driver runs `claude -p` with text output, so each step log stays empty until the step ends (`plan/backlog/0000219-stream-step-session-activity/entry.md`). Each log in `plan/.initiative-logs/` holds only final replies.

### Stops and confirmations

- The first step 13 session stopped at the `ravintio-refresh-setup` Step 4 confirmation and never ran P0. A step session has no human to answer a confirmation, and chart did not pre-approve the command.
- The `gate-write` hook then blocked the human's session from writing the override. The human gave a standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator` as override `custom-006` (commit `9214ada`). Step 13 then ran again.
- The `step-13.log` file holds only the re-run. The first session's reply is not in the evidence.

### Ids and staging

- The human's session reserved ids 0000214 to 0000216 but left them uncommitted while step 13 ran. Step 13 reserved 0000214 too and committed it. The human's entry became 0000215 (commit `d57472d`). An uncommitted reservation does not protect an id from a concurrent session.
- During step 13, `plan/backlog/.next-id` moved from 0000214 to 0000217 in the shared working tree. The step blamed a test run and restored it by hand (`plan/retrospectives/0000208-refresh-setup-record-2026-10-27.md`). The real cause was the human's session, which reserved 0000214 to 0000216 there without a commit. No test writes the real counter. Entry 0000224 covers this.
- Broad staging swept queued entries into step commits twice. Step 12 committed three queued entries and needed PR #51 to restore 0000212. Step 15 committed 0000220 (`step-12.log`, `step-15.log`). Entry 0000213 covers this.
- A step 5 subagent ran `git stash` and briefly took the other agents' edits (`step-5.log`).

### Tests and caps

- Test `test-0000151-req-014` failed in every step from 6 to 12, because the installed `.claude/skills/` copies lag the pack until setup reruns (`step-6.log` to `step-12.log`). Entry 0000212 covers this.
- Count, budget, and size-cap tests caused rework in steps 4, 5, 7, 8, 9, 10, 11, and 13. No plan named them in advance (archived build logs, `Rework:` lines). Entry 0000210 covers this.
- Step 13 raised the size cap in `test-0000151-req-011` to 38,200 bytes. The human accepted the raise. Entry 0000214 holds the lasting fix.
- `RAVINTIO_INITIATIVE_STEP=1` leaked from the step session into hook tests in steps 13, 14, and 15 (`step-13.log`, `step-14.log`, `0000218` retrospective). Step 15 cleared it in two suites only.

### Merge guard

- `merge-guard` blocked the first merge command in steps 3, 4, 8, 11, and 13, because each used command substitution. Each step reran a plain `gh pr merge --squash --delete-branch {n}` (`step-3.log`, `step-4.log`, `step-8.log`, `step-11.log`, `step-13.log`). The ship skill gives no plain form to copy.

### Codex claims

- Step 12 reported that no Codex program was available, but `/opt/homebrew/bin/codex` existed. Step 12 also said `merge-guard` was active in Codex, based on the docs alone (`step-12.log`).
- Step 14 found that Codex skips project hooks until a person trusts them with `/hooks`. The auto-mode classifier denied its rerun with `--dangerously-bypass-hook-trust`, so the fix was a warning only (`step-14.log`). The human skipped the manual trust check (0000220) and asked for an end-to-end test (0000221).

### Records

- Steps 11 to 15 recorded no phase wall clocks (archived build logs). Step 3 logged estimated times (`step-3.log`). The recorded totals for steps 1 to 10 do not match the merge-to-merge times.
- No postmortem exists for this initiative. `plan/postmortems/` is absent, although the step 13 stop and the step 12 staging slip both qualify.
- The hooks named `ravintio-orchestrator` instead of `ravintio-initiative` for the human's session. Step 15 fixed this (entry 0000215, PR #54).

## Initiative questions

1. **Charted versus shipped:** chart planned 13 steps. The human added steps 14 and 15 on 2026-10-27 after step 13 merged (commit `cfdc12d`). Steps 1 to 13 and 15 shipped at their charted bumps. Step 14 rose from patch to minor under its bump rule, because check 2 failed. Steps 13 to 15 skipped P1. Steps 13 and 14 were chores, and step 15 changed hook code. Chart left 0000174 out of scope, as planned.
2. **Repeated friction:** the stale installed copies failed one test in 7 steps. Count, budget, and cap tests caused rework in 8 steps. `merge-guard` blocked a merge command in 5 steps. The step environment variable broke hook tests in 3 steps. Broad staging swept queued entries in 2 steps.
3. **Stops and step times:** see the step times table. The only stop was the first step 13 session. The branch sat idle from 13:13 to 18:04 UTC until the human added the standing approval. The whole run took about 12 hours 24 minutes, from activation at 06:59 to the step 15 merge at 19:23 UTC.
4. **Initiative tooling gaps:** the driver started before step 10 changed the driver and added the watcher, so the human's session had none. The watcher gave false events (0000216). Step logs stay empty while a step runs (0000219). The `gate-write` hook blocked the human's session from writing an override, as designed, so the override went into the step 13 scope. The hooks named the wrong skill for the human's session (0000215, fixed in step 15). The driver kept the stage rules in place at activation, so I-E Delivery relies on a manual retrospective (`step-9.log`).

### Step times

Times come from merge commits on the initiative branch, in UTC. Each time runs from the previous merge, or from activation for step 1.

| Step | Feature id | Version | Merged | Minutes | Rework lines | Stop |
|------|------------|---------|--------|---------|--------------|------|
| 1 | 0000196-setup-argument-checks | 0.20.0 | 07:31 | 32 | 2 | none |
| 2 | 0000197-merge-guard-block-message | 0.20.1 | 07:51 | 20 | 0 | none |
| 3 | 0000198-cap-echoed-plan-text | 0.20.2 | 08:17 | 26 | 1 | none |
| 4 | 0000199-reserve-ids-from-counter | 0.21.0 | 08:49 | 32 | 2 | none |
| 5 | 0000200-reply-conventions | 0.22.0 | 09:38 | 49 | 1 | none |
| 6 | 0000201-plan-concurrent-work | 0.23.0 | 10:01 | 23 | 1 | none |
| 7 | 0000202-improvement-loops | 0.24.0 | 10:34 | 33 | 1 | none |
| 8 | 0000203-blameless-postmortems | 0.25.0 | 11:06 | 32 | 2 | none |
| 9 | 0000204-run-and-initiative-retrospectives | 0.26.0 | 11:28 | 22 | 3 | none |
| 10 | 0000205-initiative-skill | 0.27.0 | 12:07 | 39 | 2 rounds, not logged as lines | none |
| 11 | 0000206-chart-time-decisions | 0.28.0 | 12:34 | 27 | 1 | none |
| 12 | 0000207-codex-support | 0.29.0 | 13:07, PR #51 at 13:13 | 39 | 0, 1 deviation | none |
| 13 | 0000208-refresh-setup-record | 0.29.1 | 18:30 | 317, of which the re-run took 26 | 0, 1 cap raise | refresh confirmation |
| 14 | 0000217-verify-codex-setup | 0.30.0 | 19:06 | 33 | 1 | none |
| 15 | 0000218-strict-hook-follows-active-skill | 0.30.1 | 19:23 | 17 | 0 | none |

## Keep

- One step per entry group, each merged and tagged on its own (`git tag`, `v0.20.0` to `v0.30.1`).
- Exact text and exact commands in `initiative.md` for chore steps (`initiative.md`, Step 13 chore).
- A real run of a target tool before a claim about it ships (`plan/retrospectives/0000217-verify-codex-setup-2026-10-27.md`).
- Human review of every Wanted outcome at chart. It caught the `merge-guard` widening before activation (commit `f2df492`).

## Change

- Chart flags any entry that widens what a guard lets through.
- Commit each id reservation at once.
- Chart pre-approves or removes every human confirmation a step skill asks for.
- Start the driver only once the tooling it relies on has shipped, or restart it after a step changes that tooling.
- Make visibility and the watcher reliable (0000216, 0000219).

## Actions

Each row names the backlog entry that holds the action.

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Chart flags any entry that widens what a guard lets through, and asks the human to approve it | pack maintainers | `ravintio-zero/skills/ravintio-initiative/SKILL.md`, chart rules in `ravintio-zero/standards/roadmap-standards.md` | A test reads the rule in the chart text || `plan/backlog/0000223-chart-flags-guard-widening/` |
| Commit each id reservation as soon as it is made, in step and human sessions | pack maintainers | `ravintio-zero/scripts/reserve-id.mjs`, `ravintio-zero/skills/ravintio-initiative/SKILL.md` | A test reserves an id and finds the counter change committed || `plan/backlog/0000224-commit-id-reservations-at-once/` |
| Chart lists each confirmation a step skill asks for, and pre-approves it or plans a human stop | pack maintainers | chart rules, `## Decisions` table | A test reads the rule, and a chore step with a confirmation runs with no stop || `plan/backlog/0000225-chart-plans-step-confirmations/` |
| Route a repo instruction that the human asks for mid-run into the next step's scope, as step 13 did. Keep the `gate-write` hook as it is | pack maintainers | `ravintio-zero/skills/ravintio-initiative/SKILL.md` | A test reads the rule in the initiative skill || `plan/backlog/0000226-route-mid-run-instructions-to-step-scope/` |
| Restart the driver after a step changes the driver, the initiative skill, or the watcher | pack maintainers | `initiative-run.mjs` | A driver test changes the script mid-run and sees a restart || `plan/backlog/0000227-restart-driver-after-tooling-change/` |
| Give a plain merge command in the ship skill, with no command substitution | pack maintainers | `ravintio-zero/skills/ravintio-ship/SKILL.md` | A test reads the command, and `merge-guard` allows it || `plan/backlog/0000228-plain-merge-command-in-ship/` |
| Clear `RAVINTIO_INITIATIVE_STEP` in the test runner, not only in two suites | pack maintainers | `ravintio-zero/tests/` runner | A step-session run passes every hook suite || `plan/backlog/0000229-runner-clears-step-variable/` |
| Forbid `git stash` in subagents during a parallel batch | pack maintainers | `ravintio-zero/standards/agent-dispatch-standards.md` | A test reads the rule || `plan/backlog/0000231-no-stash-in-parallel-subagents/` |
| Ship fails a build log with blank phase wall clocks | pack maintainers | `ravintio-zero/skills/ravintio-ship/SKILL.md` or `consistency-check.mjs` | A check fails a build log with a blank wall clock || `plan/backlog/0000232-ship-fails-blank-wall-clocks/` |
| Check `PATH` before a report says a program is missing, and mark any claim drawn only from docs as unverified | pack maintainers | `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` | A test reads the rule || `plan/backlog/0000233-check-path-before-missing-claims/` |
| Chart records whether each step may skip P1 | pack maintainers | chart rules, `## Decisions` table | A test reads the column in the template || `plan/backlog/0000234-chart-records-p1-skip/` |
| Keep each step's full log when the driver re-runs a step | pack maintainers | `initiative-run.mjs` | A driver test re-runs a step and finds both logs || `plan/backlog/0000235-keep-full-step-logs-on-rerun/` |
| Watcher false events | pack maintainers | `initiative-watch.mjs` | See the entry | `plan/backlog/0000216-watcher-false-events/` |
| Stream step session activity | pack maintainers | `initiative-run.mjs` | See the entry | `plan/backlog/0000219-stream-step-session-activity/` |
| Size cap ignores local overrides | pack maintainers | `test-0000151-req-011` | See the entry | `plan/backlog/0000214-size-cap-ignores-local-overrides/` |
| Move boot file rules into skills | pack maintainers | boot template, `ravintio-overrides/` | See the entry | `plan/backlog/0000222-move-boot-rules-into-skills/` |
| Plan checks count, budget, and cap tests | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | See the entry | `plan/backlog/0000210-plan-checks-count-and-cap-tests/` |
| Installed-copies test during an initiative | pack tests | `test-0000151-req-014` | See the entry | `plan/backlog/0000212-installed-copies-test-lags-pack/` |
| Stage run files by path | orchestrator and ship skills | skill text | See the entry | `plan/backlog/0000213-stage-run-files-by-path/` |
| Verify Codex `merge-guard` after trust, and a Codex end-to-end test | pack maintainers | `ravintio-zero/getting-started.md`, `ravintio-zero/tests/` | See the entries | `plan/backlog/0000220-verify-codex-merge-guard-after-trust/`, `plan/backlog/0000221-codex-end-to-end-test/` |
