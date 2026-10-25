---
title: "Verification report: 0000172-subagent-acceleration"
summary: "Execution verification of nine acceptance criteria across REQ-001 to REQ-003."
status: "active"
version: "0.1.0"
---
# Verification report - 0000172-subagent-acceleration

All checks ran on branch `feat/0000172-subagent-acceleration` at `81555a5` (macOS). The feature changes pack text and adds three Bash suites. The targets are files, so the method is to run each suite, then observe each criterion in the files it names with `grep -n`. Each requirement also got a mutation check. No pack file stayed modified.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 9 |
| failed | 0 |
| not-verifiable | 0 |

Total: 9 criteria across REQ-001 to REQ-003.

## Suites

| Command | Exit code | Result |
|---|---|---|
| `bash ravintio-zero/tests/test-0000172-req-001-run-speed.sh` | 0 | 4 passed, 0 failed |
| `bash ravintio-zero/tests/test-0000172-req-002-fast-batches.sh` | 0 | 6 passed, 0 failed |
| `bash ravintio-zero/tests/test-0000172-req-003-phase-timing.sh` | 0 | 3 passed, 0 failed |

## Outcome per criterion

| REQ | AC | Outcome | Method |
|---|---|---|---|
| REQ-001 | AC-1 | verified | `grep -n` over Design Confirmation and the reference file |
| REQ-001 | AC-2 | verified | `grep -n` over the reference file, roadmap standards, and template |
| REQ-001 | AC-3 | verified | `grep -n` over ship Step 8 and the reference cleanup list |
| REQ-002 | AC-1 | verified | `grep -n` over the `## Fast batches` section |
| REQ-002 | AC-2 | verified | `grep -n` for `### Fast batch` in four skills |
| REQ-002 | AC-3 | verified | `grep -n` over Phase Invocation |
| REQ-003 | AC-1 | verified | `grep -n` over the build-log template |
| REQ-003 | AC-2 | verified | `grep -n` over Phase Invocation |
| REQ-003 | AC-3 | verified | `grep -n` over ship Steps 3 and 5 |

## REQ-001

- **AC-1: verified.**
  - `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:222` says "ask the run-speed question and write `plan/.run-speed`". `SKILL.md:119` lists the reference in the Pack Index.
  - `references/orchestrator-run-speed.md:10-13` holds the question with the `Standard` and `Fast` options.
  - `references/orchestrator-run-speed.md:16` holds the `Run speed:` line.
- **AC-2: verified.**
  - `references/orchestrator-run-speed.md:18-19` says a missing or unknown value counts as `standard`.
  - `ravintio-zero/standards/roadmap-standards.md:117` names the `**Speed:**` field under R-C Run (heading at line 111).
  - `ravintio-zero/templates/roadmap-entry.template.md:28` names the `**Speed:**` field.
- **AC-3: verified.**
  - `ravintio-zero/skills/ravintio-ship/SKILL.md:79` names `plan/.run-speed` in the sentinel deletion.
  - `references/orchestrator-run-speed.md:36-38` lists the interrupted-ship cleanup, the stale run-mode check, and Ship Step 8.
- **Run-mode values.** `SKILL.md:220` still says `No other value is valid`. The speed never goes into `plan/.run-mode`.
- **Mutation.** I removed line 18 of the reference file. The REQ-001 suite exited 1 with 1 failing check. I restored the file from `/tmp` and `git diff --quiet` passed.

## REQ-002

- **AC-1: verified.**
  - `ravintio-zero/standards/agent-dispatch-standards.md:84` holds `## Fast batches`.
  - Line 86 names `plan/.run-speed`. Line 88 names one message.
  - Line 90 names disjoint files. Line 92 names phases in order. Line 93 names gates.
- **AC-2: verified.** Each skill holds `### Fast batch` and names `plan/.run-speed` in the first line of its section.
  - `ravintio-plan/SKILL.md:124`
  - `ravintio-implement/SKILL.md:136`
  - `ravintio-validate-and-accept/SKILL.md:123`
  - `ravintio-ship/SKILL.md:162`
- **AC-3: verified.** `SKILL.md:234` opens Phase Invocation. Line 244 says to read `plan/.run-speed` and, at `fast`, dispatch the phase's fast batch.
- **Mutation.** I removed line 244 of the orchestrator `SKILL.md`. The REQ-002 suite exited 1 with 1 failing check. I restored the file and `git diff --quiet` passed.

## REQ-003

- **AC-1: verified.** In `ravintio-zero/templates/build-log.template.md`, the `Run speed` row is at line 18. The `End` and `Wall clock` rows are at lines 29-30 and 49-50. The `Total wall clock` row is at line 77.
- **AC-2: verified.** `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:245` says to fill `End` and `Wall clock` when a phase completes.
- **AC-3: verified.**
  - `ravintio-zero/skills/ravintio-ship/SKILL.md:48` (Step 3) names wall-clock time.
  - Lines 61-62 (Step 5) name the run speed, wall-clock time, and `not recorded`.
- **Mutation.** I removed line 77 of the template (`Total wall clock`). The REQ-003 suite exited 1 with 1 failing check. I restored the file and `git diff --quiet` passed.

## Hand-off

- `.claude/skills/ravintio-orchestrator/references/orchestrator-run-speed.md` exists in the installed copy. `cmp` shows it identical to the source file.
- `ravintio-zero/setup.sh:93` copies each skill folder with `cp -R "$skill_dir/." "$dest_dir/"`. A fresh install therefore carries the new reference file.

## Failures

None. `git status --short` was clean after the mutation checks, apart from this report.
