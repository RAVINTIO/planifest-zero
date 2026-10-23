---
title: "Scope - autonomous-mode-and-prefixes"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.9.0"
---
# Scope - autonomous-mode-and-prefixes

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Wave:** 1
**Version:** 0.9.0

> All three sections must be present. If "Deferred" is empty, state "Nothing deferred."

## In Scope

- Run modes `gated` and `autonomous` replace `interactive` and `continuous`. The run-mode question and `plan/.run-mode` use these values (US-001, US-002).
- `autonomous` runs P1 to P4 without phase gates. It ends with a raised pull request (US-001).
- `gated` stops for your confirmation at the P1, P2, P3, and P4 gates (US-002).
- Both modes stop on the exception stops (US-001, US-002):
  - A requirement or check still fails after 5 attempts.
  - P2 needs a schema change.
  - The P3 security review finds an unmitigated critical or high issue.
  - A push or `gh pr create` fails.
- A resume with a missing or unknown `plan/.run-mode` asks the run-mode question again. It names the value it found and logs the answer (US-001, US-002).
- Phases P0 Discovery to P4 Ship replace the P1 to P5 numbering. Build-log headings use `### P<n>: {Phase Name}`, with n from 0 to 4 (US-003).
- Every message starts with one of five prefixes, such as `P2 Implement:` (US-003).
- Every status uses the form `{prefix} {Status}: {one-liner}` (US-003).
- `name: "Planifest Zero"` in `product.yml` and `planifest-zero/component.yml` (US-004).
- Prose that describes Planifest Zero as a framework changes to "Planifest Zero", "the pack", or "the pipeline" (US-005).
- Identifiers that name Planifest Zero as a framework take a Zero-specific name. Examples are `FRAMEWORK_DIR` and `framework-update-policy.md`. The P1 ADR fixes the name map (US-005).
- A test greps every tracked file outside `plan/_archive/` and `plan/changelog/`. It fails on any "framework" line outside the allowlist of generic uses (US-005).
- Old phase cites, such as "P0 briefing" and "P9 push", move to the new numbers. This includes `custom-004-p9-push-and-raise-pr.md` (US-003).

## Out of Scope

- Multi-release autonomy, tracked as backlog 0000098 and 0000099.
- Generic uses of "framework", such as the `test-frameworks.md` standards and "meta-framework".
- References to Planifest Framework, the separate product.
- History under `plan/_archive/` and `plan/changelog/`.
- Migration or compatibility for other installs. This repo is the only known install.
- Renaming test files that carry old feature IDs. Tests keep their names and change their assertions.
- Stale installed hooks in `.claude/hooks/enforcement/` that have no source. These are filed to the backlog.

## Deferred

- Nothing deferred.
