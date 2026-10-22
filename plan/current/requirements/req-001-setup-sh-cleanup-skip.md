---
title: "Requirement: req-001 - setup-sh-cleanup-skip"
summary: "The setup.sh telemetry cleanup skips a settings.json that is not a settings object, so only the shape check line reaches the output."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - setup-sh-cleanup-skip

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000041-setup-cleanup-and-park-hardening
**Source:** US-001 (backlog 0000127)
**Priority:** must-have

## User Story

As a person running `setup.sh`, I see only the shape check line when `settings.json` is not a settings object, so that the output names the real fault once.

## Functional Requirements
- In `remove_legacy_telemetry_wiring`, the inline node script applies the 0000040 shape rule before it touches `settings.json`.
  - The check runs after `JSON.parse` succeeds and before the script reads `hooks` or writes.
- The rule passes only when both conditions hold:
  - The top-level value is a plain object. Arrays, `null`, strings, numbers, and booleans all fail.
  - `hooks` is absent, `null`, or a plain object.
- If the rule fails, the cleanup prints nothing to stdout and nothing to stderr, and it writes nothing.
  - The skip counts as "nothing to clean", not as a failure, so it never prints the "could not remove telemetry hook entries" warning.
  - Setup continues to the hook install step.
- The hook install step then prints the shape check line from 0000040 ADR-002 and exits 1. This requirement does not change that line or the exit code.
- If `JSON.parse` throws, the cleanup also skips in silence. The hook install step then prints the 0000040 invalid JSON line and exits 1.
- If a real failure occurs, the cleanup still warns and continues, per 0000033 ADR-002. A real failure is a read or write error, not a parse or shape failure.
- If the file passes the rule, the cleanup removes telemetry entries as it does today, and it prints the removal line.
- The cleanup never prints `settings.json` content or a parser message (0000033 req-004).

## Acceptance Criteria
- [ ] (a) Each of `null`, `["x"]`, and `{"hooks":"text"}` makes `setup.sh` print only `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` to stderr and exit 1. The file stays byte-identical.
- [ ] (b) For each input in (a), the cleanup prints no line of its own. Stdout holds no cleanup line, and stderr holds no "could not remove telemetry hook entries" warning.
- [ ] (c) A valid settings object with a telemetry entry still has the entry removed, and `setup.sh` prints the removal line as today.
- [ ] (d) A file that holds `{bad` makes `setup.sh` print only `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` to stderr and exit 1. The file stays byte-identical.
- [ ] (e) If the cleanup's write fails, it still prints the "could not remove telemetry hook entries" warning and setup continues.

## Dependencies
- 0000040 ADR-002 (shape check line and exit 1) stands. The shape rule comes from 0000040 req-001.
- 0000033 ADR-002 (cleanup runs on every setup run and warns on a real failure) and 0000033 req-004 (no content in output) stand.
- The cleanup runs before the hook install step, so it must skip for the install step to report the fault.
- req-002 applies the same rule to `setup.ps1`.
