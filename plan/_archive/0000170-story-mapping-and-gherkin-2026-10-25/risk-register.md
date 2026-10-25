---
title: "Risk Register - story-mapping-and-gherkin"
summary: "Technical and operational risks for the story map and Gherkin criteria, with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - story-mapping-and-gherkin

**Skill:** plan
**Feature:** 0000170-story-mapping-and-gherkin
**Version:** 0.15.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | Consumer runs in flight fail the new checks on old-format criteria. | medium | low | The finding names the expected Gherkin format. The fix is a text edit to the criterion, with no code change. | open |
| R-002 | technical | The ratchet parser misreads a Gherkin step line and blocks a valid write. | low | medium | Add stdin fixture tests for strengthening, weakening, and disarmed writes that contain Gherkin step lines. | open |
| R-003 | technical | The plan skill text grows, and shell suites under `ravintio-zero/tests/` that grep the skill text break. | medium | medium | Run the full shell suite before each commit. Update the grep assertions in the same commit as the skill edit. | open |
| R-004 | operational | The story map adds work to small plans with one or two stories. | medium | low | The mapping pass fills the backbone template only. The human answers a gated question only for a gap outside the brief. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Plain Markdown lines are enough for Gherkin. No `.feature` files are needed. | A later release adds a `.feature` export. | open |
