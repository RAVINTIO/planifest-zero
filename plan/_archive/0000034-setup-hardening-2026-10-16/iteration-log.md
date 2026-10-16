---
title: "Iteration Log - 0000034-setup-hardening"
summary: "Execution log for the agent session."
status: "active"
version: "0.1.0"
---
# Iteration Log - 0000034-setup-hardening

> **Audience:** Build-assessment-agent (P8) and post-run technical review. This is NOT the PR changelog.

**Skill:** [docs-agent](../skills/planifest-docs-agent/SKILL.md)
**Date:** 2026-10-16

## Iteration Steps Completed

| Phase | Status | Gate Result | Notes |
|-------|--------|-------------|-------|
| 0 - Assess & Coach | pass | Design confirmed: yes | 6 decisions plus a batched Scope Lock with 7 gap resolutions |
| 1 - Specification | pass | All artifacts produced: yes | 6 requirements |
| 2 - ADRs | pass | 3 ADRs generated | ADR-001 supersedes part of 0000030 ADR-001 |
| 3 - Code Generation | pass | Implementation complete: yes | 0 deviations |
| 4 - Validation | pass | CI clean: no, 1 known failure | 2 self-correct cycles |
| 5 - Security | pass | Critical findings: 0 | 3 Medium fixed in-phase |
| 6 - Docs & Ship | pass | All docs synced: yes | |

## Requirement Changes During Run

| Change | Phase Active | Classification | Action Taken |
|--------|-------------|----------------|-------------|
| Retired flag set widened from two to four | P0 | additive | Recorded before design confirmation |
| Atomic write hardened: exclusive create, mode copy, `File.Replace`, read-only refusal, symlink write-through | P5 | additive | ADR-002 v0.1.1, req-003 suite case (d) |
| `--backend-url` never skips a tool name, and `=` forms never print a value | P5 | additive | req-001 suite cases in (b) |

## Self-Correct Log

1. P4: three older suites asserted that `--structured-telemetry-mcp` exits 1 (0000031 req-004, 0000033 req-002 and req-003). ADR-001 supersedes that. The suites now carve out the retired-flag block and assert a warning with exit 0.
2. P4: one req-006 assertion looked for guidance on a `Deferral source` line. The guidance is in the comment block, so the assertion now matches its sentence.
3. P5: the req-003 forced-failure case used a read-only leftover temporary file. The hardened helper removes leftovers first, so the case now plants a folder at the temporary path.

## Quirks

- `setup.ps1` sets `$ValidTools` after argument parsing, so the retired-flag loop keeps its own `$RetiredFlagTools` list.
- `test-0000034-req-003` compares against the `v0.4.0` script when the tag is reachable, and falls back to a format check in a shallow checkout.
