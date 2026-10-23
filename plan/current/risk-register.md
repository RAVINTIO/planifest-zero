---
title: "Risk Register - autonomous-mode-and-prefixes"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.9.0"
---
# Risk Register - autonomous-mode-and-prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Version:** 0.9.0
**Overall Risk Level:** high

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | operational | `pwsh` is missing on this machine, so the PowerShell suite skips locally (0000041 REQ-002, REQ-003). Only CI proves the PowerShell changes. | high | medium | CI runs the PowerShell suite before acceptance. | open |
| R-002 | technical | The non-array warning text in the two setup scripts drifts apart (0000041 REQ-003). | low | low | Parity tests assert the exact line in both suites. | open |
| R-003 | technical | The two `park.mjs` copies drift apart (0000041 REQ-004). | low | medium | P4 reruns setup to refresh the installed copy, then checks the two copies with `diff`. | open |
| R-004 | security | A hook value that holds a secret reaches the terminal through the non-array warning (0000041 REQ-003). | low | high | The warning drops the old value. Tests assert the exact stderr lines and that a planted secret never appears. | open |
| R-005 | operational | The wording and renumbering edits touch the same files. Parallel subagents conflict when they edit one file at once (REQ-004 to REQ-006, REQ-008 to REQ-010). | high | medium | P2 runs REQ-004 to REQ-006 before REQ-008 to REQ-010, or splits subagents by file. | open |
| R-006 | technical | A stray old phase number or "framework" survives in a tracked file (REQ-004 to REQ-006, REQ-008 to REQ-010). | medium | low | Tests grep for P5 to P9 and for "framework", and they run in CI. | open |
| R-007 | security | Autonomous hides a P3 finding until the PR (REQ-001 to REQ-003). | low | high | The P3 security stop halts the run on an unmitigated critical or high finding. P3 evidence also appears in the PR description. | open |
| R-008 | operational | This run uses the 0.8.0 skills while it edits them (REQ-001 to REQ-003, REQ-004 to REQ-006). | high | low | Setup refreshes `.claude/skills/` at P3. The run keeps the old phase numbers in its own log. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | A failing `pre-commit` hook in a temporary repo forces the chore commit to fail. | The park test needs another way to fail the commit, such as a read-only index. | open |
| A-002 | The PowerShell reading of 0000128 is correct, though nobody has run it. | The new test passes before the fix, so the test writer must confirm RED in CI. | open |
| A-003 | No other repo installs Planifest Zero. | Another install breaks on the renamed identifiers and run-mode values. Mitigation: none is planned, and this repo is the only known install. | open |
| A-004 | Tests whose file names carry old feature ids keep their names. Only names that call Planifest Zero a framework change, per ADR-004. Likelihood: medium. | A name such as `continuous-run-p1-p3` misleads a reader. Mitigation: the test header comment states the current behaviour. | open |
