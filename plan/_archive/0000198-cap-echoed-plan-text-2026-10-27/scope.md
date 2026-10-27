---
title: "Scope - cap echoed plan text"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - cap echoed plan text

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Version:** 0.20.2

## In Scope

- Cut each `removed:` line in the `ratchet-check.mjs` block message to 200 characters and mark the cut.
- Cut the story map row label in the two `consistency-check.mjs` findings that echo it to 200 characters and mark the cut.
- Add one test suite with a case per program for a line over the cap, a line at the cap, and the exit code.
- Update the docs that describe the printed text.

## Out of Scope

- Which writes the ratchet blocks, and which findings the consistency check raises.
- The 500-character cap on the `.ratchet-approve` reason in the audit log.
- Findings that echo file names, requirement ids, or counts.
- The hook-parity check and setup wiring.

## Deferred

Nothing deferred.
