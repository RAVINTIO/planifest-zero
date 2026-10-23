---
title: "Requirement: req-007 - product-name-planifest-zero"
summary: "product.yml and component.yml name the product Planifest Zero, so no manifest reads as Planifest Framework."
status: "active"
version: "0.1.0"
---
# Requirement: req-007 - product-name-planifest-zero

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-004
**Priority:** must-have

## User Story

As a reader of `product.yml`, `component.yml`, or the README, I see the name Planifest Zero, so that I never confuse it with Planifest Framework.

## Functional Requirements
- `product.yml` sets `name: "Planifest Zero"`. It currently sets `name: "Planifest Framework"`.
- `planifest-zero/component.yml` sets `name: "Planifest Zero"`. It currently sets `name: "Planifest Framework"`.
- Both `id` fields stay `planifest-zero`. The `components[].id` entry in `product.yml` also stays `planifest-zero`.
- No other manifest field changes in this requirement.
- Planifest Framework is a separate product (repo `planifest/planifest-framework`). Any reference to it by that name stays.
- The README names no product "Planifest Framework". Its title and description wording belong to req-008.
  - Current state: `README.md` has no "Planifest Framework" string. The title is `# Planifest`.
  - If req-008 or a later edit adds that string as a name for this product, that edit fails this requirement.

### Impact check

Nothing reads the `name` field of either manifest.

| File | Finding |
|------|---------|
| `planifest-zero/scripts/product-version.mjs` | Reads `id`, `path`, and `version` only. It uses `id` in error labels and never reads `name`. |
| `planifest-zero/scripts/consistency-check.mjs` | Does not read manifest names. |
| `planifest-zero/scripts/self-description-check.mjs` | Checks README structure paths only. |
| `planifest-zero/setup.sh`, `planifest-zero/setup.ps1` | Mention `component.yml` in generated text only. They never read `name`. |
| `docs/about.md` | Holds no product name field. It does not read the manifests. |
| `.claude/` hooks | The grep for `.name` and "Planifest Framework" finds no hit. |

The only files that contain the string `"Planifest Framework"` as a name value are `product.yml` and `planifest-zero/component.yml`. Matches in `plan/current/` describe the separate product and stay.

### Templates

Neither template hard-codes the name. Both use placeholders, so neither changes.
- `planifest-zero/templates/product.template.yml` sets `name: "{{Product Display Name}}"`.
- `planifest-zero/templates/component.template.yml` sets `name: "{{Human-Readable Name}}"`.

### Test
- One test asserts both name fields equal `Planifest Zero`.
  - It reads `name` from `product.yml` and from `planifest-zero/component.yml`.
  - It also asserts both `id` fields equal `planifest-zero`.
  - It asserts `README.md` holds no "Planifest Framework" string.

## Acceptance Criteria
- [ ] (a) `product.yml` and `planifest-zero/component.yml` each hold `name: "Planifest Zero"` and `id: "planifest-zero"`. `node planifest-zero/scripts/product-version.mjs` derives the same version as before, and both template files are unchanged.
- [ ] (b) `grep -rn "Planifest Framework" product.yml planifest-zero/component.yml README.md` returns no match. References to Planifest Framework as a separate product remain in place.
- [ ] (c) The one test from this requirement asserts the name and id values and the README check. It fails before the change and passes after it.

## Dependencies
- req-008 (wording) owns the README title and description. This requirement only bars the name "Planifest Framework" there.
- The `id` stays `planifest-zero`, so archive attribution (0000033 ADR-003) and `gate-write` component matching stand.
