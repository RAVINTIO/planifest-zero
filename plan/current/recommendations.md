---
title: "Recommendations - 0000036-test-runner-coverage"
summary: "P6 recommendations, deferred items, and tech debt filed for this feature."
status: "draft"
version: "0.1.0"
---
# Recommendations - 0000036-test-runner-coverage

**Skill:** [docs-agent](../../.claude/skills/planifest-docs-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Date:** 2026-10-17

## Deferred Items

| Item | Reference | Status |
|------|-----------|--------|
| The Bash suites don't run in CI. | Scope Deferred section, ADR-003. | Filed as backlog 0000108. |
| `test-0000031-req-001-rename.sh` cases (a) and (b) still fail while `planifest-framework/` exists. | Build log P4 entry. | Referenced, already tracked as backlog 0000097. |

## Tech Debt

| Item | Reference | Status |
|------|-----------|--------|
| None | n/a | n/a |

## Recommendations

- Pick up backlog 0000097 next, then 0000108. Together they put every suite in CI.
- The first Windows run found a real defect that static checks missed for two releases. Add a runtime `.ps1` case alongside any future `setup.ps1` change.

## Deliberate Absence: No per-component `docs/` folder

`planifest-zero/` is the single component and the product itself. `planifest-zero/component.yml` and the living docs carry the per-component role.

## Other Notes for the Ship Agent

- This branch starts from the PR #9 head. Merge PR #9 first. PR #10 is already open as a draft, so update its description and mark it ready rather than raising a new one.
- `product.yml` reads `0.4.2` and `0000035-powershell-setup-parity`. Update both fields to `0.4.3` and `0000036-test-runner-coverage` at ship.
