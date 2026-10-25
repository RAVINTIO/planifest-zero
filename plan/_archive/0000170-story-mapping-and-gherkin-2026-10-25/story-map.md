---
title: "Story Map - 0000170-story-mapping-and-gherkin"
summary: "The backbone of maintainer and test-writer activities, with the steps under each and the requirement that covers each step."
---
# Story Map - 0000170-story-mapping-and-gherkin

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Plan a feature | Lay out activities and steps before writing requirements | US-001 | REQ-001 |
| Plan a feature | Write each criterion as Given, When, and Then lines | US-002 | REQ-002 |
| Check the plan | Flag a criterion with missing or misordered steps | US-003 | REQ-003 |
| Check the plan | Flag a gap between the story map and the requirements | US-004 | REQ-004 |
| Guard the plan in a loop | Block removal of a Gherkin step line | US-005 | REQ-005 |
| Test a feature | Run Gherkin criteria through a test framework | none | gap: out of scope |

## Gaps

- Running Gherkin through a framework such as Cucumber is out of scope. The brief does not state or imply it.
