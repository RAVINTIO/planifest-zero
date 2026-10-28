---
title: "Risk Register - size cap excludes overrides"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - size cap excludes overrides

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000242-size-cap-excludes-overrides
**Version:** 0.31.2
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The 103 byte margin is too tight for step 5, which adds to `SKILL.md` | medium | low | Step 5 shrinks Resume Detection, and the Decisions table stops any step that fails a size cap | open |
| R-002 | technical | A later setup change moves or renames the markers | low | low | The AC-1 test fails and shows the change | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `CLAUDE.md` outside the markers equals `standard-boot.md` | The measure differs by a few bytes and the margin absorbs it | open |
