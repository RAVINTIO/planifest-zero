---
title: "Scope - hardening-efficiency-and-ci"
summary: "Defines explicit boundaries of what is in scope, out of scope, and deferred."
status: "active"
version: "0.1.0"
---
# Scope - hardening-efficiency-and-ci

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Version:** 0.1.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- REQ-001 to REQ-015, which cover the ten backlog entries in `plan/current/backlog-sources/`
- Park symlink containment in `park.mjs` (REQ-001)
- Ship order: sentinels cleared in a commit before the push (REQ-002)
- Block reasons on stderr for `gate-write`, `em-dash-guard`, and `ratchet-check` (REQ-003)
- Setup deletes installed hooks named on the retired list, with `phase-enum` added to it (REQ-004)
- One fixed error line for settings write failures, including the second unguarded write in `merge_allowed_tools` (REQ-005)
- Token efficiency from backlog 0000148 (REQ-006 to REQ-011)
  - Roadmap step model and turn cap
  - Dispatch model tiers
  - Quiet test output
  - Context size at gates
  - WebFetch through a subagent
  - Orchestrator `references/` split and Pack Index rows
- Roadmap step logs and telemetry labels in `roadmap-run.mjs` (REQ-012, REQ-013)
- R-A Chart clarity check, the approved dependency list, and the dependency stop (REQ-014)
- PowerShell CI matrix and per-case timing (REQ-015)
- Parity in `setup.ps1` wherever `setup.sh` changes
- Test updates that follow from the references split, the CI matrix, and the ship renumber

## Out of Scope

- Backlog 0000095
- Backlog 0000100
- Backlog 0000110
- New hooks
- New pipeline phases
- Weakening any gate, suite, hook, TDD step, review, or acceptance check

## Deferred

- Batching PowerShell test cases per process. Blocked: REQ-015 timing must show that process start-up dominates the run time. If it does not, the work stays out.
