---
title: "Risk Register - faster-setup-ps1-tests"
summary: "Technical, operational, and security risks for the faster setup.ps1 copy and the timing total, with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - faster-setup-ps1-tests

**Skill:** plan
**Feature:** 0000171-faster-setup-ps1-tests
**Version:** 0.16.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The .NET copy differs from `Copy-Item` on dot files or an existing target folder. | medium | medium | The tree test compares every installed file against the bundle rules under both hosts. | open |
| R-002 | operational | The CI time per case misses the 946 ms target. | low | medium | R-D Advance reads the totals from the step PR's CI logs before the merge. A miss stops the step with `Blocked:`. | open |
| R-003 | technical | Windows PowerShell 5.1 lacks an API the copy uses. | low | high | Keep to .NET Framework 4.5 APIs such as `File.Copy`, `Directory.CreateDirectory`, and `Directory.GetFiles` with `SearchOption.AllDirectories`. The tree test runs under 5.1. | open |
| R-004 | security | The timing file stays in the temp folder after a run. | medium | low | The file holds only millisecond counts. `run-tests.ps1` removes it when the run ends. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Cmdlet overhead per file is at least as high on Windows as on macOS, so the local 8x copy gain carries over. | The CI time per case misses 946 ms, and the step stops with `Blocked:` before merge. | open |
