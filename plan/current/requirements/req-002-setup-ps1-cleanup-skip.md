---
title: "Requirement: req-002 - setup-ps1-cleanup-skip"
summary: "The setup.ps1 telemetry cleanup skips a settings.json that is not a settings object, so setup never rewrites a file it rejects."
status: "active"
version: "0.1.0"
---
# Requirement: req-002 - setup-ps1-cleanup-skip

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Source:** US-002 (backlog 0000128)
**Priority:** must-have

## User Story

As a person running `setup.ps1`, I keep my `settings.json` unchanged when it is not a settings object, so that setup never rewrites a file it rejects.

## Functional Requirements
- `Remove-LegacyTelemetryWiring` applies the same shape test as `Merge-EnforcementHookSettings` before it changes or writes `settings.json`.
- The shape test passes only when all of these hold:
  - The first non-space character of the file is `{`.
  - The parsed value is a `PSCustomObject`.
  - `hooks` is absent, `null`, or a `PSCustomObject`.
- The first-character check is needed because PowerShell 7 unrolls a one-item top-level array into its item. PowerShell 5.1 reads through it. The parsed value alone can't show the array.
- If the shape test fails, the cleanup prints nothing, writes nothing, and moves on to its other steps. This skip is "nothing to clean" and is not a failure.
- After the skip, the hook install step prints the shape check line from 0000040 ADR-002 and exits 1. The line is `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`
- Text that is not valid JSON keeps today's behaviour in the cleanup.
- A real failure in the cleanup still prints a warning and continues (0000033 ADR-002).
- A valid settings object with a telemetry entry still has the entry removed, with the same printed line as today.
- The cleanup never prints `settings.json` content or a parser message (0000033 req-004).

## Acceptance Criteria
- [ ] (a) A `settings.json` that holds `[{"hooks":{"Stop":[...telemetry entry...]}}]` makes `setup.ps1` print the shape check line and exit 1. The file stays byte-identical.
- [ ] (b) A `settings.json` that holds `null` or `{"hooks":"text"}` makes `setup.ps1` print only the shape check line and exit 1. The file stays byte-identical.
- [ ] (c) A valid settings object with a telemetry entry still has the entry removed.
- [ ] (d) Text that is not valid JSON behaves as it did before this change.

## Dependencies
- 0000040 ADR-002 (shape check line and exit 1) stands. `Merge-EnforcementHookSettings` owns the shape test that the cleanup copies.
- 0000033 ADR-002 (the cleanup runs every setup run and warns on a real failure) and 0000033 req-004 (no content in output) stand.
- req-001 makes the matching change in `setup.sh`.
- The reading of 0000128 is untested, because no PowerShell host was available when it was filed. The test writer must confirm RED in CI.
- PowerShell tests run only in CI, because `pwsh` is not installed locally. They skip locally.
