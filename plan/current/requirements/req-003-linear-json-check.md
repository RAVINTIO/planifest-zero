---
title: "Requirement: req-003 - linear-json-check"
summary: "Test-JsonText runs in linear time and rejects nesting deeper than 1024 levels before the parse."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - linear-json-check

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Source:** US-003 (backlog 0000122)
**Priority:** should-have

## User Story

As a person running `setup.ps1`, I get a prompt failure on very deep nesting, so that the strict JSON check never slows with the square of the depth.

## Functional Requirements
- `Test-JsonText` in `setup.ps1` tracks the bracket stack in a `[System.Collections.Generic.Stack[char]]` and the depth in an integer.
  - Today it appends to and trims a string, `$stack`. Each change copies the string, so cost grows with the square of the depth.
  - Push and pop on `Stack[char]` are constant time, so cost grows linearly with input length.
- Each `{` or `[` increments the depth. Each matching close decrements it.
- When the depth passes 1024, `Test-JsonText` stops at once, before it scans the rest of the text.
  - A text that nests 1024 levels passes the depth check. A text that nests 1025 levels fails it.
- The depth failure is distinct from a syntax failure, so the caller can tell them apart.
  - A depth failure makes `Merge-EnforcementHookSettings` print the shape line from req-002.
  - A syntax failure keeps the invalid-JSON line from 0000039 ADR-002.
- `Test-JsonText` stays non-recursive and keeps its anchored patterns for strings and numbers.
- No path prints the file's contents or a parser message (0000033 req-004).
- `setup.sh` is out of scope. `JSON.parse` in node handles deep input without this change.

## Acceptance Criteria
- [ ] (a) With a `settings.json` of 100,000 `[` characters, `setup.ps1` prints `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` to stderr, exits 1, and finishes in under 5 seconds.
- [ ] (b) With 1025 nested `[` and 1025 matching `]`, `Test-JsonText` fails on depth, and `setup.ps1` prints the same line and exits 1.
- [ ] (c) With 1024 nested `[` and 1024 matching `]`, the depth check passes.
- [ ] (d) `Test-JsonText` returns the same result as before for every input in the existing 0000039 req-001 tests.
- [ ] (e) After each run in (a) and (b), `settings.json` is byte-identical to its input, and the output holds no file content.
- [ ] (f) The function source contains `[System.Collections.Generic.Stack[char]]` and no `$stack +=` or `$stack.Substring` line.

## Dependencies
- req-002 prints the shape line that a depth failure uses.
- 0000039 req-001 and ADR-002 define the strict JSON check and the invalid-JSON line, which this change keeps.
- Non-functional target from the design: 100,000 levels of nesting finishes in under 5 seconds.
- PowerShell tests skip locally when `pwsh` is missing. CI runs them.
