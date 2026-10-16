---
title: "Recommendations - 0000035-powershell-setup-parity"
summary: "P6 recommendations, deferred items, and tech debt filed for this feature."
status: "draft"
version: "0.1.0"
---
# Recommendations - 0000035-powershell-setup-parity

**Skill:** [docs-agent](../../.claude/skills/planifest-docs-agent/SKILL.md)
**Feature:** 0000035-powershell-setup-parity
**Date:** 2026-10-17

## Deferred Items

| Item | Reference | Status |
|------|-----------|--------|
| Every `setup.ps1` change has static checks only. | Scope Deferred section, R-001. | Referenced, already tracked as backlog 0000084. |
| `setup.sh` keeps a `Write|Edit` entry that an older `setup.ps1` wrote. | Scope Out of Scope section, R-002. | Filed as backlog 0000106. |
| `test-0000031-req-001-rename.sh` cases (a) and (b) still fail while `planifest-framework/` exists. | Build log P4 entry. | Referenced, already tracked as backlog 0000097. |

## Tech Debt

| Item | Reference | Status |
|------|-----------|--------|
| The enforcement hook merge in both scripts assumes array event values. | Scope Out of Scope section. | Filed as backlog 0000107. |

## Recommendations

- Pick up backlog 0000084 next. This feature and 0000034 together changed six `setup.ps1` functions that no test runs. P5 found a Medium encoding fault by reading the code, which a 5.1 runner would have caught.
- Before merging, run `setup.ps1` once on Windows PowerShell 5.1, with a `settings.json` that holds non-ASCII text.

## Deliberate Absence: No per-component `docs/` folder

`planifest-zero/` is the single component and the product itself, as in 0000031 to 0000034. `planifest-zero/component.yml` and the living docs carry the per-component role.

## Other Notes for the Ship Agent

- This branch starts from the PR #7 head. Merge PR #7 first.
- `product.yml` reads `0.4.1` and `0000034-setup-hardening`. Update both fields to `0.4.2` and `0000035-powershell-setup-parity` at ship.
