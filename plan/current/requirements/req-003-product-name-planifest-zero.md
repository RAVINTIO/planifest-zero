---
title: "Requirement: req-003 - product-name-planifest-zero"
summary: "product.yml and component.yml name the product Planifest Zero, so no manifest reads as Planifest Framework."
status: "active"
version: "0.1.0"
---
# Requirement: req-003 - product-name-planifest-zero

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
- The README names no product "Planifest Framework". Its title and description wording belong to req-004.
  - Current state: `README.md` has no "Planifest Framework" string. The title is `# Planifest`.
  - If req-004 or a later edit adds that string as a name for this product, that edit fails this requirement.

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
- [ ] (a) `product.yml` holds `name: "Planifest Zero"` and `id: "planifest-zero"`.
- [ ] (b) `planifest-zero/component.yml` holds `name: "Planifest Zero"` and `id: "planifest-zero"`.
- [ ] (c) `grep -rn "Planifest Framework" product.yml planifest-zero/component.yml README.md` returns no match.
- [ ] (d) `node planifest-zero/scripts/product-version.mjs` still derives the same version as before the change.
- [ ] (e) `product.template.yml` and `component.template.yml` are unchanged.
- [ ] (f) The test from this requirement fails before the change and passes after it.
- [ ] (g) References to Planifest Framework as a separate product remain in place.

## Dependencies
- req-004 (wording) owns the README title and description. This requirement only bars the name "Planifest Framework" there.
- The `id` stays `planifest-zero`, so archive attribution (0000033 ADR-003) and `gate-write` component matching stand.
