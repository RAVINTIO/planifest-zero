---
title: "Risk Register - test-runner-coverage"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.4.3"
---
# Risk Register - test-runner-coverage

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000036-test-runner-coverage
**Version:** 0.4.3
**Overall Risk Level:** low

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The PowerShell suites fail in CI for reasons that can't be reproduced locally, because no `pwsh` exists here. | high | low | Push early, read the CI log, and cap fixes at five attempts before escalating. | open |
| R-002 | operational | The stray-file check flags a file someone needs, such as an editor backup. | low | low | One allowlist array with a comment. The message names the file. | open |
| R-003 | technical | A PowerShell suite finds a real `setup.ps1` defect. | medium | medium | Fix it here if small, otherwise file a backlog entry and mark the assertion. | open |
| R-004 | security | The CI job gains write access or secrets it doesn't need. | low | medium | `permissions: contents: read` and no `secrets` reference. A suite asserts both. | open |
| R-005 | technical | `setup.ps1` writes outside the temporary project in CI, for example to the runner's global git config. | medium | low | Suites run inside a fresh temporary folder with its own `git init`. | open |
