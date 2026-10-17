---
title: "Scope - test-runner-coverage"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.4.3"
---
# Scope - test-runner-coverage

**Skill:** [spec-agent](../skills/spec-agent-SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Wave:** not waved
**Version:** 0.4.3

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Stray-file pre-flight in `run-tests.sh` (req-001).
- `.ps1` regression suites in the Section 7 manifest check (req-002).
- `test-*.ps1` discovery in `run-tests.sh`, and a new `run-tests.ps1` (req-003).
- `helpers/assert.ps1` and `setup.ps1` runtime suites (req-004).
- A `windows-powershell` CI job (req-005).
- Living docs, `tests/README.md`, and `component.yml` updated to 0.4.3.

## Out of Scope

- `planifest-framework/`.
- Bash suites in CI.
- Pester.
- `planifest-zero/hooks/planifest.yml`, the consumer copy of the workflow.

## Deferred

- Bash suites in CI, until backlog 0000097 makes the rename suite pass.
