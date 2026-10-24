---
title: "Requirement: REQ-003 - bash32-test-loops"
summary: "Test suites avoid done < <(...) so that macOS Bash 3.2 gives the same results as CI."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - bash32-test-loops

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000164-hardening-and-backlog-skill
**Source:** US-003 (backlog 0000161)
**Priority:** must-have

## User Story

As a maintainer on macOS, I get the same suite results as CI, so that a local pass is a real pass.

## Functional Requirements
- On macOS Bash 3.2, a `while read` loop fed by `done < <(...)` can silently stop yielding lines. The suite then passes without running its checks.
- Each of these five files replaces `done < <(...)` with `done <<< "$(...)"`:
  - `ravintio-zero/tests/run-tests.sh`
  - `ravintio-zero/tests/test-0000042-req-009-pack-identifiers.sh`
  - `ravintio-zero/tests/test-0000042-req-010-pack-wording-allowlist.sh`
  - `ravintio-zero/tests/regression/test-0000042-req-010-pack-wording-allowlist.sh`
  - `ravintio-zero/tests/test-0000160-req-001-pack-identifiers.sh`
- Each converted loop skips empty lines, because `<<< "$(...)"` yields one empty line for empty output.
- A guard test under `ravintio-zero/tests/` fails when any file under `tests/` contains `done < <(`. The guard excludes its own file.

## Acceptance Criteria
- [ ] `grep -rl 'done < <(' ravintio-zero/tests` lists only the guard test, if it names the pattern at all.
- [ ] Each converted loop skips an empty line and gives the same results as before on its input.
- [ ] The guard test exits non-zero when a temporary file under `tests/` contains `done < <(`, and exits 0 otherwise.
- [ ] The full suite passes on Bash 3.2 (`env -i` run) and on Bash 5 in CI.

## Dependencies
- None.
