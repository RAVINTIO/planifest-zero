---
title: "Risk Register - hardening-efficiency-and-ci"
summary: "Technical, operational, security, and compliance risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - hardening-efficiency-and-ci

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000151-hardening-efficiency-and-ci
**Version:** 0.1.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

Rows R-001 to R-010 come from the design's Risks section and the requirements. Rows R-011 to R-013 come from its Assumptions section, logged at likelihood medium. No compliance risk applies, because the design records no regulated data.

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The references split (REQ-011) moves text out of `SKILL.md`. Tests that grep `SKILL.md` then fail. | high | medium | Update each test to read the new `references/` file. Never drop an assertion. A test fails if a `references/` file has no Pack Index row. | open |
| R-002 | technical | The CI matrix (REQ-015) breaks the literal checks in `test-0000036-req-005`. | high | low | Update the test to the matrix shape. Keep the PowerShell suites on Linux. | open |
| R-003 | technical | The ship renumber (REQ-002) breaks the order tests for 0000023, 0000042, and 0000043. | high | low | Update those tests to the new order: Step 7 tag, Step 8 sentinels, Step 9 PR, Step 10 final gate. Keep every assertion. | open |
| R-004 | operational | The `claude` CLI exit code at the turn cap is not documented. The driver may treat a capped step as a different failure. | medium | medium | P2 measures the exit code with a real capped session. REQ-006 uses the existing non-zero exit stop and names the cap in the stop line. | open |
| R-005 | operational | The haiku tier fails more TDD units (REQ-007), so runs take longer and cost more in retries. | medium | medium | A haiku unit that fails twice retries on sonnet. P3 compares the retry count with the saving. | open |
| R-006 | operational | Quiet mode (REQ-008) hides the context around a failure, so the agent cannot diagnose it. | medium | medium | Quiet mode keeps every FAIL line, its detail, the failing suite name, the summary, and the exit codes. A test checks that a failing case prints all of them. | open |
| R-007 | security | The park symlink check (REQ-001) refuses a repo where `plan/` is legitimately a symlink. | low | medium | The refusal names the path part, so the maintainer can see the cause. Document the limit in the park docs. Park fails closed because a missed symlink writes outside the repo. | open |
| R-008 | operational | The release holds about 19 points against an 8-point budget. Review and P3 take longer, and a late failure delays all fifteen requirements. | medium | medium | The human accepted the size. Each requirement commits on its own, and the Skill Map runs them through parallel subagents. | accepted |
| R-009 | operational | Installed `.claude/` copies stay stale until the maintainer reruns setup. Fixes in `planifest-zero/` then do not reach the running hooks. | high | medium | Edit sources under `planifest-zero/` only and rerun setup in this repo before P3. The ship notes tell downstream projects to rerun setup. REQ-004 prunes retired hooks on that rerun. | open |
| R-010 | security | Telemetry labels (REQ-013) leak sensitive text into `OTEL_RESOURCE_ATTRIBUTES`. | low | low | Labels hold identifiers only, percent-encoded. The driver appends to existing attributes and never replaces them. | open |
| R-011 | technical | Assumption: Claude Code reads only stderr from a PreToolUse hook that exits 2. If wrong, REQ-003 changes nothing for agents. | medium | medium | The hooks write each reason to stderr and stdout, as `merge-guard` does, so either channel works. | open |
| R-012 | technical | Assumption: the `claude` CLI accepts `--model` and `--max-turns` in print mode. If wrong, REQ-006 needs another mechanism. | medium | high | P2 runs the flags against the real CLI before the driver change merges. The stub tests alone do not prove it. | open |
| R-013 | technical | Assumption: Claude Code may ignore a skill-level `model` field. If wrong, there is no impact. | medium | low | P1 checks the field. REQ-007 passes `model` on each Agent call regardless. | open |
