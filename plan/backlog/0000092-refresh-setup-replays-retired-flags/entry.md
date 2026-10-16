---
title: "Backlog Entry: 0000092 - refresh-setup replays retired setup flags and setup exits 1"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000092 - refresh-setup replays retired setup flags and setup exits 1

**Source feature:** 0000033-remove-telemetry-mcp
**Source phase:** P5
**Deferral source:** discovered mid-flight

**Date filed:** 2026-10-16

---

## Problem

Feature 0000033 removed `--structured-telemetry-mcp` and `--backend-url`. `setup.sh` now rejects
both as unknown flags and exits 1. A project set up before 0000033 can still carry a flags marker
that lists them. `planifest-refresh-setup` rebuilds the setup command from that marker, and step 2
of the skill (`skills/planifest-refresh-setup/SKILL.md:44`) does not discard unknown flags. A
refresh on an upgraded project therefore fails.

`planifest-framework` handled the same removal in its feature 0000030 ADR 003. That ADR accepts
retired flags as no-ops.

## Suggested Action

Choose one of these approaches, then add a test:

- Accept the retired flags in both setup scripts as no-ops that print one notice, matching
  `planifest-framework`.
- Have `planifest-refresh-setup` drop retired flags before it replays the command.

## Why Deferred

The choice changes how setup treats retired flags, which is a design decision outside 0000033's
confirmed scope. The P5 review found it as an operational issue, not a security one.

## Decision (2026-10-16)

The human chose to fix this in `setup.sh` and `setup.ps1`. When setup reads a retired flag, it prints a warning, skips the flag, and continues. The refresh skill stays unchanged. Planned for the next release with 0000088, 0000091, 0000096, and 0000102.
