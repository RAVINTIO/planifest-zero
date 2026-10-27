---
title: "Risk Register - cap echoed plan text"
summary: "Technical and operational risks with their mitigations."
status: "active"
version: "0.1.0"
---
# Risk Register - cap echoed plan text

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000198-cap-echoed-plan-text
**Version:** 0.20.2
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A cap edit changes which writes the ratchet blocks, or an exit code | low | medium | The edit touches only the echoed string. The existing suites and a new exit code assertion with a long line prove the same exits. | open |
| R-002 | technical | A cut splits a surrogate pair and prints a broken character | low | low | The cut counts code points, and a test line holds an astral character at the boundary. | open |
| R-003 | operational | A test elsewhere asserts an uncapped line | low | low | P2 runs the full suite and edits any such assertion in the same commit. | open |
| R-004 | operational | The installed hook stays uncapped until setup refreshes it | medium | low | Step 13 of the initiative reruns setup. The pack source is the source of truth. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The cap counts the echoed line and excludes the marker | A test asserts a slightly different length, and P2 adjusts the test and the docs | open |
