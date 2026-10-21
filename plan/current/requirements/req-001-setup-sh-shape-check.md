---
title: "Requirement: req-001 - setup-sh-shape-check"
summary: "setup.sh prints one fixed error and exits 1 when settings.json is valid JSON but not a settings object, and leaves the file unchanged."
status: "active"
version: "0.1.0"
---
# Requirement: req-001 - setup-sh-shape-check

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Source:** US-001 (backlog 0000121)
**Priority:** must-have

## User Story

As a person running `setup.sh`, I get one fixed error line and exit 1 when `settings.json` is valid JSON but not a settings object, so that I never believe the hooks are installed when they are not.

## Functional Requirements
- In the hook install step, the inline node script in `install_enforcement_hooks` checks the shape of the parsed value before it reads `hooks`.
  - The check runs after `JSON.parse` succeeds and before any write.
- The check rejects the file when either condition holds:
  - The top-level value is not a plain object. Arrays, `null`, strings, numbers, and booleans all fail.
  - `hooks` is present and is not a plain object. A `hooks` value of `null` counts as absent, as today, and passes.
- On rejection, the script prints exactly one line to stderr: `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`
  - `{path}` is the settings file path relative to the project root, as the invalid-JSON line prints it today.
  - The line never includes the file's contents, a parser message, or a stack trace.
- On rejection, the script leaves `settings.json` byte-identical and exits 1.
- Invalid JSON keeps the existing line from 0000039 ADR-002: `! Error: {path} is not valid JSON. Fix it and rerun setup.` This requirement does not change it.
- `setup.sh` accepts case-duplicate keys, such as `{"a":1,"A":2}`, because node reads them as two keys. This difference from `setup.ps1` is deliberate.
- The message text is identical to the one in req-002. A parity test asserts the exact line for both scripts.

## Acceptance Criteria
- [ ] (a) With `["x"]`, `null`, `"text"`, `42`, or `true` as the whole content of `.claude/settings.json`, `setup.sh` prints `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` to stderr and exits 1.
- [ ] (b) With `{"hooks":"text"}`, `{"hooks":[]}`, or `{"hooks":5}`, the same line prints and the exit code is 1.
- [ ] (c) After each run in (a) and (b), `settings.json` is byte-identical to its input.
- [ ] (d) A value planted in a rejected file, such as `["PLANTED-VALUE"]`, appears in neither stdout nor stderr.
- [ ] (e) With `{"hooks":null}` and with `{"a":1,"A":2}`, `setup.sh` exits 0 and wires the hooks.
- [ ] (f) With `{"a":1,`, the output is the existing `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` and the exit code is 1.

## Dependencies
- 0000039 ADR-002 (invalid-JSON message) and 0000037 ADR-003 (non-array hooks events) stand.
- Setup never logs `settings.json` contents (0000033 req-004).
- The hook install step runs before the allowedTools step, so a rejected file stops setup before the allowedTools step reads it.
- req-002 implements the same check in `setup.ps1`. The parity test depends on both.
