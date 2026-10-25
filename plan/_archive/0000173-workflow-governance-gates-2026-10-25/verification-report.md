---
title: "Verification report: 0000173-workflow-governance-gates"
summary: "Execution verification of twelve acceptance criteria across REQ-001 to REQ-004."
status: "active"
version: "0.1.0"
---
# Verification report - 0000173-workflow-governance-gates

All checks ran on branch `feat/0000173-workflow-governance-gates` at `2a6aa15` (macOS). REQ-001 and REQ-002 target a CLI script, so the method is to build fixture run folders in `mktemp -d` and invoke the script. REQ-003 and REQ-004 target pack text, so the method is `grep -n` over the named files. The fixtures lived outside the repo and were deleted afterwards. `git status --short` was clean before this report.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 12 |
| failed | 0 |
| not-verifiable | 0 |

Total: 12 criteria across REQ-001 to REQ-004.

## Outcome per criterion

| REQ | AC | Outcome | Method |
|---|---|---|---|
| REQ-001 | AC-1 | verified | Ran the script on a fixture with known markers |
| REQ-001 | AC-2 | verified | Ran the script on a fixture with prose and fenced mentions |
| REQ-001 | AC-3 | verified | Ran the script on a folder with no build log |
| REQ-002 | AC-1 | verified | Ran the script with default thresholds on the REQ-001 fixture |
| REQ-002 | AC-2 | verified | Ran the script with `--standard` and `blocked-stops` set to 5 |
| REQ-002 | AC-3 | verified | Ran the script with `--standard` and no `gate-corrections` row |
| REQ-003 | AC-1 | verified | `grep -n` over the implement and validate skills |
| REQ-003 | AC-2 | verified | `grep -n` over the change reference and orchestrator skill |
| REQ-003 | AC-3 | verified | `grep -n` over the governance standard |
| REQ-004 | AC-1 | verified | `grep -n` over ship Step 5 |
| REQ-004 | AC-2 | verified | `grep -n` over ship Step 9 |
| REQ-004 | AC-3 | verified | `grep -n` over ship Steps 5 and 9 |

## Fixtures

- **Fixture A** holds a `build-log.md` and one `loop-state-1.md`.
  - The build log has two `Rework: REQ-001:` lines, one list-item `Rework: REQ-002:` line, three `Blocked:` lines, one `Requirement change:` line, and one `Gate revised:` line.
  - The loop-state file has one `Rework: REQ-001:` line and one `Gate revised:` line.
  - Expected counts: rework 3 (REQ-001), blocked 3, design changes 1, gate corrections 2.
- **Fixture B** holds a `build-log.md` with `Blocked:` and `Requirement change:` mid-sentence, and `Blocked:` and `Rework: REQ-009:` inside a fenced block.
- **Fixture C** is an empty folder.

## REQ-001 (script `ravintio-zero/scripts/workflow-metrics.mjs`)

- **AC-1: verified.**
  - Command: `node ravintio-zero/scripts/workflow-metrics.mjs {fixture-A}`. Exit code 0.
  - The `## Workflow governance` section showed rework `3 (REQ-001)`, `Blocked:` stops `3`, design changes `1`, and gate corrections `2`.
  - All four counts match the expected values. The rework row names REQ-001, the highest count, and the loop-state marker was included.
- **AC-2: verified.**
  - Command: same script on fixture B. Exit code 0.
  - All four metrics read `0`. The mid-sentence and fenced mentions did not count.
- **AC-3: verified.**
  - Command: same script on fixture C. Exit code 1. Stdout held 0 bytes.
  - Stderr held one line, `workflow-metrics: cannot read {fixture-C}/build-log.md`, which names the missing path.

## REQ-002 (thresholds and report-only gate)

- **AC-1: verified.**
  - Command: script on fixture A with the default standard. Exit code 0.
  - The `Blocked:` stops row read `3 | 1 | breach`. The section ended with `Breaches: 2. The gate reports and does not block.`
  - The two breaches were rework (3 against 2) and blocked stops (3 against 1).
- **AC-2: verified.**
  - Command: script on fixture A with `--standard` pointing at a copy of the standard with `blocked-stops` set to 5. Exit code 0.
  - The `Blocked:` stops row read `3 | 5 | ok`. The breach count fell to 1.
- **AC-3: verified.**
  - Command: script on fixture A with `--standard` pointing at a copy that lacks the `gate-corrections` row. Exit code 1. Stdout held 0 bytes.
  - Stderr held `workflow-metrics: threshold key missing: gate-corrections`.

## REQ-001 and REQ-002 on a real archive

- Command: `node ravintio-zero/scripts/workflow-metrics.mjs plan/_archive/0000172-subagent-acceleration-2026-10-25`. Exit code 0.
- That run predates the markers, so all four values read `0` and every row read `ok`. The script handled a real build log without error and wrote no file.

## REQ-003 (metric markers)

- **AC-1: verified.**
  - `ravintio-zero/skills/ravintio-implement/SKILL.md:76` holds `Rework: REQ-{nnn}: {reason} ({ISO-8601 timestamp})` and names `ravintio-zero/standards/workflow-governance-standards.md`.
  - `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md:43` holds the same marker form and names the same standard.
- **AC-2: verified.**
  - `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-mid-pipeline-changes.md:21` holds `Requirement change: {cosmetic | additive | contradictory}: {what changed} ({ISO-8601 timestamp})`.
  - `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:221` holds ``On a gate change, append `Gate revised: P{N}`.``
  - The criterion asks only for `Gate revised: P{N}`, so the shortened line meets it. This matches the recorded REQ-003 deviation, which cites the 0000151 size budget.
- **AC-3: verified.** `ravintio-zero/standards/workflow-governance-standards.md` lists all four markers.
  - Line 22: `Rework:`
  - Line 23: `Blocked:`
  - Line 24: `Requirement change:`
  - Line 25: `Gate revised:` with the full form `P{N} ({ISO-8601 timestamp}, {what changed})`

## REQ-004 (governance report at ship)

- **AC-1: verified.** `ravintio-zero/skills/ravintio-ship/SKILL.md:67`, in Step 5 (heading at line 57), names `node ravintio-zero/scripts/workflow-metrics.mjs {archive-folder}` and `build-report.md`.
- **AC-2: verified.** `ravintio-zero/skills/ravintio-ship/SKILL.md:100`, in Step 9 (heading at line 85), names the `## Workflow governance` section. It applies to both run modes and both PR options.
- **AC-3: verified.**
  - Line 67 (Step 5) holds `Workflow governance: not measured ({reason})` and says a breach does not stop ship in either run mode.
  - Line 100 (Step 9) holds the same `not measured` line and says a breach does not stop ship.

## Observation

- The functional requirements say each skill points at the governance standard. The orchestrator `SKILL.md` has no `workflow-governance-standards.md` reference (`grep -n` finds none), so line 221 does not name the standard.
- No acceptance criterion requires the pointer, so this does not fail a criterion. The REQ-003 deviation note covers the shortened marker but not the missing pointer. Update the note or add the pointer if the size budget allows.

## Failures

None. No pack file changed during verification.
