---
title: "Feature Brief - refresh setup record"
summary: "Chore: add the standing refresh approval, refresh setup, commit queued backlog entries."
status: "approved"
version: "0.1.0"
---
# Feature Brief - refresh setup record

**Feature ID:** 0000208-refresh-setup-record

## Business Goal

Installed skills and `CLAUDE.md` must match the pack before initiative delivery. The setup record must show a refresh later than the step 12 merge. Queued backlog entries must reach the initiative branch.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Standing approval override | US-001: As the human on the loop, I want a standing approval for one exact setup command, so that step sessions refresh setup without stopping. | 1 | 1 |
| Setup refresh | US-002: As a maintainer, I want the setup record and installed skills refreshed, so that they match the pack. | 2 | 1 |
| Queued entries | US-003: As a maintainer, I want queued backlog entries committed, so that the working tree is clean. | 3 | 1 |

## Acceptance criteria

- `ravintio-overrides/instructions/custom-006-standing-setup-refresh-approval.md` holds the exact text in `initiative.md`.
- `plan/state/claude-code.md` holds a `writtenAt` later than the step 12 merge.
- `CLAUDE.md` holds the standing approval between its override markers.
- Every queued entry in `plan/backlog/` is committed, one commit per entry. The working tree is clean.

## Out of scope

Backlog entry 0000174. Any change to `setup.sh`.
