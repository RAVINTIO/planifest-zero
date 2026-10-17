---
title: "Iteration Log - 0000036-test-runner-coverage"
summary: "Execution log for the agent session."
status: "active"
version: "0.1.0"
---
# Iteration Log - 0000036-test-runner-coverage

> **Audience:** Build-assessment-agent (P8) and post-run technical review. This is NOT the PR changelog.

**Skill:** [docs-agent](../skills/planifest-docs-agent/SKILL.md)
**Date:** 2026-10-17

## Iteration Steps Completed

| Phase | Status | Gate Result | Notes |
|-------|--------|-------------|-------|
| 0 - Assess & Coach | pass | Design confirmed: yes | One batched confirmation for the design and four Scope Lock drafts |
| 1 - Specification | pass | All artifacts produced: yes | 5 requirements. The reverse manifest check already existed, so req-002 shrank |
| 2 - ADRs | pass | 3 ADRs generated | |
| 3 - Code Generation | pass | Implementation complete: yes | 1 deviation: a `setup.ps1` fix for a defect the new suites found |
| 4 - Validation | pass | CI clean: yes, local has 1 known failure | 0 self-corrections |
| 5 - Security | pass | Critical findings: 0 | 6 Low or Info findings fixed, 2 accepted |
| 6 - Docs & Ship | pass | All docs synced: yes | |

## Requirement Changes During Run

| Change | Phase Active | Classification | Action Taken |
|--------|-------------|----------------|-------------|
| `setup.ps1` skips a `--backend-url=` value that PowerShell 7 splits at its colon | P3 | additive | Fix in `setup.ps1`, runtime case in the flags suite |
| `setup.ps1` never prints a tool name that isn't a plain name | P5 | additive | S-003 fix and runtime case |
| The CI workflow grants `contents: read` to every job | P5 | additive | S-006 fix and a static case |

## Self-Correct Log

1. P3: the red run of the runner suite called the old runner, which ran the whole pack again, this suite included. The run was stopped, and the call is now guarded by a check for `PLANIFEST_PREFLIGHT_ONLY`.
2. P3: the first fix for the PowerShell 7 split tested for a trailing colon. A debug print in CI showed the colon is dropped. The second fix tests for a missing colon.
3. P5: a test-edit script stopped at a non-unique match, after the fixes had committed. The remaining tests went in with the next commit.

## Quirks

- PowerShell 7 splits a `-File` argument such as `--x=https://y` into `--x=https` and `//y`. Windows PowerShell 5.1 keeps it whole.
- `.ps1` suites must stay ASCII, because 5.1 reads a file with no BOM as ANSI.
