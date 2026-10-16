---
title: "Requirement: req-004 - missing-node-warning"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - missing-node-warning

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000034-setup-hardening
**Source:** US-004
**Priority:** should-have

## User Story

As a user without `node` on the `PATH`, I run `setup.sh`, so that it tells me it skipped the settings cleanup.

## Functional Requirements
- When `settings.json` exists and `node` isn't on the `PATH`, `remove_legacy_telemetry_wiring` prints one warning that it skipped the telemetry cleanup, and names the file.
- When `settings.json` doesn't exist, the cleanup prints nothing, as today.

## Acceptance Criteria
- [ ] With `node` hidden from the `PATH` and a `settings.json` present, the cleanup prints exactly one warning naming `settings.json`.
- [ ] With `node` hidden and no `settings.json`, the cleanup prints no warning.
- [ ] With `node` present, the output is unchanged.

## Dependencies
- None
