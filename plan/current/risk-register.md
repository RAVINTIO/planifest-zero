---
title: "Risk Register - self-host-on-planifest-zero"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.5.0"
---
# Risk Register - self-host-on-planifest-zero

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000037-self-host-on-planifest-zero
**Version:** 0.5.0
**Overall Risk Level:** medium

> Every entry must be specific to this feature. Do not produce generic risks.

The template allows low, medium, or high for likelihood. Where the design says "certain", this register records high and says so in the description.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | A file in the repo still needs `planifest-framework/` after the deletion. | low | medium | The rename suite and a full local run catch it. | open |
| R-002 | operational | A session resets after the deletion and reloads skills that cite old paths. | high | low | The design constraint maps each `planifest-framework/{path}` to `planifest-zero/{path}`. | open |
| R-003 | operational | The human squash-merges PR #9 or PR #10, and GitHub closes this stacked PR. | high | low | Cherry-pick onto a branch from `main`, with no force push. | open |
| R-004 | operational | The installed `auto-trigger-orchestrator` hook looks for `planifest-framework/`. After req-004, a new session doesn't load the orchestrator on its own. | high | low | The human loads the `planifest-orchestrator` skill by name, as `CLAUDE.md` directs for tools without the hook. | open |
| R-005 | security | Git reads its hooks from `planifest-framework/hooks`. A deletion without the `core.hooksPath` change switches off `commit-msg` with no error. This is certain without req-004's first step. | high | high | req-004 changes `core.hooksPath` to `planifest-zero/hooks` before the deletion. Its suite checks the value. | open |
| R-006 | operational | Until req-006 lands, only the local run proves the rename suite passes. This is certain. | high | low | req-006 closes the gap within this run. | open |
| R-007 | technical | The Bash suites have only run on macOS. On `ubuntu-latest`, a GNU and BSD tool difference could fail a suite. | medium | medium | P4 fixes each failure. CI on the PR proves the fix. | open |
| R-008 | operational | The run holds 7 user stories, above the 3-story rule of thumb. This is certain. | high | low | The items are small and independent, and the human chose the larger run. Backlog 0000109 covers release sizing. | accepted |
| R-009 | security | The req-006 `bash-suites` job runs code from the PR. A token with write access or a stored credential could leak through it. | low | medium | Pin `actions/checkout` to a commit SHA. Set `persist-credentials: false` and `permissions: contents: read`. Reference no `secrets`. The req-006 suite asserts each one. | open |

## Assumptions Logged as Risks

Documented assumptions from the specification are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | No phase from P4 to P9 needs the four files that `planifest-zero/` lacks: `standards/telemetry-standards.md`, `templates/defect-report.template.md`, `workflows/change-pipeline.md`, and `workflows/fast-path.md`. | That phase reads a missing file and must stop for direction. | open |
| A-002 | Setup rewrites `writtenAt` in `plan/state/claude-code.md` on every run. The maintainer commits that diff with the reinstall. | The maintainer sees an unexpected diff at the reinstall. | open |
| A-003 | `planifest-zero/setup.sh` reads `plan/state/claude-code.md` and carries no retired flag forward. | The post-merge reinstall replays a retired flag, which warns and installs nothing. | open |
