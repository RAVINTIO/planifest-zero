---
title: "Scope - setup-json-checks-and-park"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.7.0"
---
# Scope - setup-json-checks-and-park

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Wave:** 1
**Version:** 0.7.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- req-001-setup-sh-shape-check (US-001, backlog 0000121): `setup.sh` prints one fixed error line and exits 1 when `settings.json` is valid JSON but not a settings object. A `hooks` value that is present and not a plain object fails the same way. A `hooks` value of `null` counts as absent.
- req-002-setup-ps1-shape-check (US-002, backlog 0000120): `setup.ps1` prints the same fixed line and exits 1 for the same inputs. It also fails on case-duplicate keys.
- req-003-linear-json-check (US-003, backlog 0000122): `Test-JsonText` tracks depth with an integer and a `[System.Collections.Generic.Stack[char]]`. It fails at depth 1024, and its cost grows linearly with input length.
- req-004-park-command (US-004, backlog 0000101): the park command in the orchestrator skill and the new `park.template.md`. It writes `plan/current/park.md`, pushes the feature branch, raises a chore PR with a `parked` backlog entry, and returns the working tree to `main`.
- req-005-parked-pickup (US-005, backlog 0000101): parked-entry handling at P1 backlog pickup, with resume and discard. Resume detection also finishes the chore PR step when it finds `park.md` with no chore PR.
- Cases in the `.sh` and `.ps1` setup suites, and contract tests for the park and pickup text in the orchestrator skill.
- A minor release, version 0.7.0, because park is a new capability.

## Out of Scope

- `setup.sh` rejecting case-duplicate keys. Node reads them, so the two scripts differ here by design.
- Reverting commits on `main`. Unmerged feature work never reaches `main`.
- Parking more than one feature at a time on one working tree.

## Deferred

- Nothing deferred.
