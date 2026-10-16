---
title: "Requirement: req-005 - drop-product-id-gate"
summary: "Detailed requirements for this specific functional feature."
status: "draft"
version: "0.2.0"
---
# Requirement: req-005 - drop-product-id-gate

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000033-remove-telemetry-mcp
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I want the product-id gate to give a reason that is still true, so that P0 asks for the id without citing telemetry.

## Functional Requirements
- Keep the top-level `id` field in `product.yml` and in `planifest-zero/templates/product.template.yml`.
- Keep step 9's product-id hard stop in `planifest-zero/skills/planifest-orchestrator/SKILL.md`. Its prompt gives versioning and attribution of archived runs as the reason, matching framework 0000030 ADR 007.
- Keep `components[].id` in `product.yml` unchanged, because `planifest-zero/scripts/product-version.mjs` reads it.

## Acceptance Criteria
- [ ] `product.yml` has a top-level `id: "planifest-zero"` key, and `planifest-zero/templates/product.template.yml` has a top-level `id:` key, both checked by a test.
- [ ] The orchestrator skill's step 9 hard-stops when `id` is missing, and its prompt names versioning and does not name telemetry.
- [ ] `grep "id:" product.yml` still finds the `id:` field nested under `components[]`.

## Dependencies
- None.

## Revision

2026-10-16, v0.2.0: rewritten from "drop the gate" to "reword the gate" by the ADR-003 v0.2.0 reversal. The filename keeps its original slug so links stay valid.
