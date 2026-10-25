---
title: "Story Map - 0000171-faster-setup-ps1-tests"
summary: "The backbone of maintainer and consumer activities, with the steps under each and the requirement that covers each step."
---
# Story Map - 0000171-faster-setup-ps1-tests

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Run the PowerShell CI suites | Wait for both Windows jobs to finish their setup runs | US-001 | REQ-001 |
| Install or refresh the pack | Run `setup.ps1` and get the skill and hook files | US-002 | REQ-002 |
| Check the speed target | Read the `setup.ps1` total for a run | US-003 | REQ-003 |
| Run the Bash suites | Wait for `setup.sh` runs on Linux | none | gap: out of scope |
| Prepare a test workspace | Copy the pack into a temporary project | none | gap: out of scope |

## Gaps

- Faster `setup.sh` runs are out of scope. The backlog entry targets the Windows jobs only.
- A faster workspace copy is out of scope. The wanted outcome measures `setup.ps1` time only.
