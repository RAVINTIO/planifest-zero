---
title: "Risk Register - setup-hardening"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.4.1"
---
# Risk Register - setup-hardening

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000034-setup-hardening
**Version:** 0.4.1
**Overall Risk Level:** low

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | `setup.ps1` changes for req-001 and req-003 ship without a runtime test, because no `pwsh` exists locally or in CI. | medium | medium | Static checks in the suites assert the flag names, the `--` value rule, and that no `settings.json` write targets the file directly. | open |
| R-002 | technical | The temporary-file write changes `settings.json` bytes, such as the trailing newline or encoding, so a current-flags run no longer matches 0.4.0. | low | medium | req-003 compares a fresh run's `settings.json` with output from the `v0.4.0` script. | open |
| R-003 | security | The `--backend-url` value reaches output or a command after the change, for example in a warning message. | low | medium | The warning names the flag only. A req-001 test asserts the value never appears in output or on disk. | open |
| R-004 | operational | The `--backend-url` value rule swallows a real flag, such as `--strict-orchestrator`, that follows it. | low | medium | Setup skips the next argument only when it doesn't start with `--`. A req-001 test covers `--backend-url --strict-orchestrator`. | open |
| R-005 | technical | `setup.ps1` writes on Windows PowerShell 5.1 can't use `[System.IO.File]::Replace` when the target doesn't exist yet. | medium | low | Use `Move-Item -Force` from the temporary file, which works with or without a target. | open |
| R-006 | operational | Old markers record retired flags in a form this design doesn't expect, such as `--backend-url=x`. | low | low | Assumption recorded in the design. If found, setup still exits 1 with `Unknown flag`, which is the 0.4.0 behaviour. | open |
