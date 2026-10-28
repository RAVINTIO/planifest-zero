---
title: "Initiative: 0000238 - backlog clearance two"
summary: "Clears 22 open backlog entries in 14 feature steps, then a chore step refreshes the installed setup."
status: "active"
---
# Initiative: 0000238 - backlog clearance two

**Goal:** Clear every open backlog entry filed during and after initiative 0000195 that needs no human-run check or paid service. Each step ships one feature release. A final chore step refreshes the installed setup so `.claude/skills/` matches the pack.
**Branch:** initiative/0000238-backlog-clearance-two
**Status:** active
**Position:** 9
**Speed:** standard

The human asked for this draft on 2026-10-27, after merging PR #55 for initiative 0000195. The human approved the chart on 2026-10-28, and I-B Activate ran the same day.

## Out of scope

Chart can pull any of these in if the human approves.

- **0000174, skill evaluation suite:** it needs paid `claude -p` calls, which count as a new service. The human must decide who pays.
- **0000220, verify Codex merge-guard after trust:** a person must trust the hook with `/hooks` by hand. A step session has no person present.
- **0000221, Codex end-to-end test:** the human chose to skip the Codex check for now. The test makes model calls on the human's OpenAI account.

## Notes for chart

- **Ids reserved.** Chart reserved `0000238` to `0000254` on 2026-10-27. This draft uses `0000238` for the initiative and `0000239` to `0000253` for the step features. Entry 0000254 took the last id. The counter change sits uncommitted on `main` until Activate commits it on the initiative branch.
- **Size first.** The orchestrator `SKILL.md` has 21 bytes of headroom under its 27,800-byte cap. Any step that adds a rule to it fails `test-0000151-req-011`. Steps 4 to 6 fix the caps and shrink the file, so later steps have room. Step 6 depends on step 5 (entry 0000236 depends on 0000237).
- **Shared files.** Steps 4, 6, 7, and 8 all touch `test-0000151-req-011-orchestrator-references-split.sh`. They run in that order, so each step builds on the last.
- **Driver changes mid-run.** Steps 2, 3, 12, and 13 change `initiative-run.mjs` or `initiative-watch.mjs`. The running driver loaded its code at activation, so it keeps the old code. Step 12 holds entry 0000227, which covers this case.
- **Visibility first.** The human moved steps 2 and 3 forward at chart on 2026-10-27, so steps 4 to 15 run with step activity in the human's chat. The driver loads its code once at launch, so step 3 ends with a planned stop. See the step 3 row in `## Decisions`.
- **Step confirmations.** Step 15 runs `ravintio-refresh-setup`, and override `custom-006` pre-approves its exact command. No other step loads a skill that asks the human for a confirmation. The human approved this record at chart on 2026-10-28.
- **P1 skips.** Only step 15 may skip P1, because it is a chore. The human approved this record at chart on 2026-10-28.
- **Security guards.** No step may widen `merge-guard`, `gate-write`, or another fail-closed hook. Entry 0000228 changes the ship skill's merge command only. It must not change what `merge-guard` allows.
- **Clarity check.** Confirm that every pulled-in entry has a **Wanted outcome** section before approval.

## Stop conditions

- Any step prints `Blocked:`.
- CI fails on a step PR.
- A step proposes a destructive change.
- A step needs a library or service that the Dependencies table doesn't list.

## Schema changes

**Unpredicted additive changes:** stop

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1 to 15 | none | none | none |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1 to 15 | none | none | none |

## Decisions

Chart fills this table.

| Step | Fork | Pre-approved answer | Bump effect |
|------|------|---------------------|-------------|
| 1 to 9 | `merge-guard` blocks a merge command that uses command substitution | Run the plain form `gh pr merge --squash --delete-branch {n}`. Never change `merge-guard`. Step 10 adds the plain form to the ship skill. | none |
| 1 to 12 | `RAVINTIO_INITIATIVE_STEP=1` leaks into a hook test and fails it | Rerun that suite with the variable unset, and log the rerun. Step 13 fixes the runner. | none |
| 1 to 15 | A count or budget test fails because of the step's own additions | Update the expected count to match, and log it as rework. | none |
| 1 to 15 | A size cap test fails | Stop. Only steps 4, 6, and 7 may change a cap, because their entries set it. | none |
| 1 | `test-0000151-req-014` fails because the installed copies lag the pack | Treat it as the fault this step fixes. Don't stop. | none |
| 2 | Whether the driver switches to `--output-format stream-json` | Yes. Use `--output-format stream-json --verbose`. The summary reader goes in `initiative-watch.mjs`, so one monitor carries every line. | none |
| 3 | The running driver keeps its launch code, so steps 4 to 15 would miss the step 2 and step 3 changes | At I-D Advance, in the same commit that moves the position to 4, set the initiative status to `blocked` with the reason "planned driver restart". The driver stops when it reads that status. The human sets the status back to `active` and restarts the driver and the watcher. | none |
| 5 | Where the detection script runs: inside `auto-trigger-orchestrator.mjs`, or as its own hook | Inside `auto-trigger-orchestrator.mjs`, on the prompt where it injects the load instruction | none |
| 7 | Whether override instructions can target one pack skill | Yes. An override names its target skill in a frontmatter field, such as `target: ravintio-ship`. Setup appends it to that installed skill and leaves it out of `CLAUDE.md`. An override with no target still goes to `CLAUDE.md`. May also change `test-0000151-req-014` to ignore appended override blocks. | none |

## Baselines

| Step | Target | Baseline | Source |
|------|--------|----------|--------|
| 6 | Orchestrator `SKILL.md` at 9,000 bytes or fewer | 27,779 bytes on 2026-10-27 | `wc -c` at chart |
| 7 | `CLAUDE.md` at 6,000 bytes or fewer | 10,317 bytes on 2026-10-27 | `wc -c` at chart |

## Criteria

Chart fills this table from each entry's **Wanted outcome**.

| Step | Criterion | Noise and margin | Checked in |
|------|-----------|------------------|------------|
| 1 | A suite that calls an undefined assert function exits non-zero. A stale installed copy fails outside an initiative only. | Deterministic | local |
| 2 | Each tool call and subagent start reaches the human's chat within 30 seconds. Summary lines stay at 200 characters or fewer. | The watcher polls every 30 seconds, which leaves zero margin. Step 2 lowers the stream poll to 10 seconds. | local |
| 3 | The four watcher conditions in entry 0000216 pass with `--once` | Deterministic | local |
| 4 | Adding an override leaves the size cap result unchanged | Deterministic | local |
| 5 | Resume Detection in `SKILL.md` is 400 bytes or fewer, and all 12 signal fixtures pass | Measures one section. The step's new reference file doesn't count. | local |
| 6 | The orchestrator `SKILL.md` is 9,000 bytes or fewer | The step's new reference files don't count. Baseline is 27,779 bytes. | local |
| 7 | The generated `CLAUDE.md` is 6,000 bytes or fewer, with every override in force | Step 15 regenerates `CLAUDE.md` and checks it again. Baseline is 10,317 bytes. | local |
| 8 to 14 | Each entry's **Wanted outcome** conditions pass as written | Text and fixture checks. Deterministic. | local |
| 15 | `.claude/skills/` matches `ravintio-zero/skills/`, and `CLAUDE.md` is still 6,000 bytes or fewer | Deterministic | local |

All pack skills share a 1,720-line cap, with 35 lines of headroom on 2026-10-28. Steps 2 and 5 add skill text before step 6 moves orchestrator text into reference files. The size cap row in `## Decisions` applies to this cap.

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | 0000239-test-suite-reliability | 0000211, 0000212 | patch | 0.30.2 | merged |
| 2 | 0000240-stream-step-session-activity | 0000219 | minor | 0.31.0 | merged |
| 3 | 0000241-watcher-false-events | 0000216 | patch | 0.31.1 | merged |
| 4 | 0000242-size-cap-excludes-overrides | 0000214 | patch | 0.31.2 | merged |
| 5 | 0000243-session-start-detection | 0000237 | minor | 0.32.0 | merged |
| 6 | 0000244-split-orchestrator-skill | 0000236 | minor | 0.33.0 | merged |
| 7 | 0000245-boot-rules-into-skills | 0000222 | minor | 0.34.0 | merged |
| 8 | 0000246-plan-checks-count-and-cap-tests | 0000210 | minor | 0.35.0 | merged |
| 9 | 0000247-git-state-hygiene | 0000213, 0000224, 0000231 | minor | | pending |
| 10 | 0000248-ship-merge-and-wall-clocks | 0000228, 0000232 | minor | | pending |
| 11 | 0000249-check-path-before-missing-claims | 0000233 | minor | | pending |
| 12 | 0000250-initiative-mid-run-changes | 0000226, 0000227 | minor | | pending |
| 13 | 0000251-driver-step-fixes | 0000229, 0000235 | patch | | pending |
| 14 | 0000252-chart-rules | 0000223, 0000225, 0000234 | minor | | pending |
| 15 | 0000253-refresh-setup | none (chore) | patch | | pending |

### Step grouping

- **Step 1:** both entries cause false test results in step sessions.
- **Step 9:** all three entries set rules for git state that a step or subagent changes: what it stages, when it commits a reservation, and a ban on `git stash`.
- **Step 10:** both entries change the ship skill.
- **Step 12:** both entries change how the initiative skill handles a change during a run.
- **Step 13:** both entries change how the driver starts or logs a step.
- **Step 14:** all three entries add chart rules to `roadmap-standards.md` and the initiative template.

## Step 15 chore

Run the `ravintio-refresh-setup` skill with the command that override `custom-006` approves:

```bash
ravintio-zero/setup.sh claude-code --strict-orchestrator
```

If the reconstructed command differs in any way, the step stops and asks the human. Then confirm that `.claude/skills/` matches `ravintio-zero/skills/`.
