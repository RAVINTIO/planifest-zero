---
title: "Requirement: req-013 - roadmap-telemetry-labels"
summary: "The roadmap driver labels each step's telemetry with the roadmap and step, without replacing any attributes the user already set."
status: "draft"
version: "0.1.0"
---
# Requirement: req-013 - roadmap-telemetry-labels

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-008 (backlog 0000149)
**Priority:** should-have

## User Story

As a maintainer, I see which roadmap step spent what in telemetry, so that I can attribute cost per step.

## Functional Requirements
- `runStep` passes an `env` option to `spawn`. It copies `process.env` and changes only `OTEL_RESOURCE_ATTRIBUTES`.
- The driver appends these labels:
  - `work.kind=roadmap`
  - `planifest.roadmap={id}-{slug}`
  - `planifest.step={position}`
- If `OTEL_RESOURCE_ATTRIBUTES` is unset or empty, the value is the three labels joined by commas.
- If it holds a value, the new value is the old value, a comma, and the three labels.
  - The driver keeps the old value byte for byte.
  - If the old value already ends in a comma, the driver adds no second comma.
  - The driver never replaces, reorders, or removes an old attribute.
- The driver percent-encodes each label value before it joins the labels.
  - It encodes comma as `%2C`, equals as `%3D`, space as `%20`, and percent as `%25`.
  - It encodes percent first, so it never encodes its own output twice.
  - It never encodes keys or the old value.
- The encoder is a named function in `planifest-zero/scripts/roadmap-labels.mjs`, so a test can call it without running the driver.
- The labels hold identifiers only. They never hold prompt text, file content, or a build-log line.
- The header comment of `roadmap-run.mjs` and `roadmap-standards.md` document the three labels.

## Acceptance Criteria
- [ ] (a) With the variable unset, a stub that runs `printenv OTEL_RESOURCE_ATTRIBUTES` logs `work.kind=roadmap,planifest.roadmap=0000050-demo,planifest.step=1`.
- [ ] (b) With the variable set to `service.name=x,team=a`, the stub logs `service.name=x,team=a,work.kind=roadmap,planifest.roadmap=0000050-demo,planifest.step=1`.
- [ ] (c) On step 2 of a two-step run, the stub logs `planifest.step=2`.
- [ ] (d) A call to the encoder with `a,b=c d%e` returns `a%2Cb%3Dc%20d%25e`.
- [ ] (e) An old value that ends in a comma produces no `,,` in the result.
- [ ] (f) The driver's own environment after the run is unchanged, and the labels reach only the child.
- [ ] (g) No other environment variable in the child differs from the driver's environment.

## Dependencies
- REQ-006 and REQ-012 change the same `spawn` call. Build them first.
- The labels rest on the observed fact that Claude Code copies `OTEL_RESOURCE_ATTRIBUTES` onto every record.
  - Impact if wrong: the labels reach no record, and the tests still pass.
- Files in reach:
  - `planifest-zero/scripts/roadmap-run.mjs` (edit `runStep`, import the helper)
  - `planifest-zero/scripts/roadmap-labels.mjs` (new, no dependencies)
  - `planifest-zero/standards/roadmap-standards.md` (document the labels)
  - `planifest-zero/tests/test-0000151-req-013-roadmap-telemetry-labels.sh` (new, uses a stub `claude` that runs `printenv`)

## Input Validation

- [ ] Input source: the roadmap `{id}` and `{slug}` from the validated branch line, the sanitised `position`, and the existing `OTEL_RESOURCE_ATTRIBUTES`
- [ ] Allowed character pattern: `{id}` and `{slug}` already match the branch pattern. The encoder escapes comma, equals, space, and percent in any label value, so a future value cannot split an attribute
- [ ] maximum length: no new limit. The branch pattern and the 3-digit position bound the labels
- [ ] Failure behaviour: the encoder cannot fail on a string. The driver does not parse the old value
- [ ] Logging policy: the driver never prints the environment value
