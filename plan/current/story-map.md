---
title: "Story Map - 0000189-name-the-roadmap-initiative"
summary: "The backbone of activities and steps, with the requirement that covers each step."
---
# Story Map - 0000189-name-the-roadmap-initiative

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Understand the terms | Read the glossary entry for "roadmap" and "roadmap initiative" | US-001 | REQ-001 |
| Understand the terms | Read the initiative states and how they change | US-001, US-004 | REQ-001 |
| Chart an initiative | Draft `plan/roadmap/{id}-{slug}/initiative.md` from the initiative template | US-002 | REQ-002 |
| Chart an initiative | Set the status field to one of the five states | US-004 | REQ-004 |
| Activate an initiative | Cut `initiative/{id}-{slug}` and move the file to `plan/current-initiative/initiative.md` | US-002 | REQ-002 |
| Run an initiative | Start the driver `initiative-run.mjs` with `RAVINTIO_INITIATIVE_*` variables | US-002 | REQ-002 |
| Run an initiative | Start the driver with an old `RAVINTIO_ROADMAP_*` variable set | US-002 | REQ-006 |
| Run an initiative | Read step logs in `plan/.initiative-logs/` and `initiative` telemetry labels | US-002 | REQ-002 |
| Run an initiative | See `I-A` to `I-E` prefixes on stage messages | US-003 | REQ-003 |
| Deliver an initiative | Squash-merge a step PR into `initiative/*` past `merge-guard`, with CI on `initiative/**` | US-002 | REQ-002 |
| Upgrade a consumer | Run migration `0005` to rename drafts and the CI pattern | US-005 | REQ-005 |
| Upgrade a consumer | Rerun migration `0005` or run it during an active roadmap | US-005 | REQ-005 |
| Keep the rename complete | Run the old-name search test in CI | US-006 | REQ-007 |
| Pick up the next initiative | Read open backlog entries in the new terms | US-007 | REQ-008 |
| Install the pack | Refresh `.claude/skills/` from `ravintio-zero/skills/` | none | gap: out of scope |

## Gaps

- Refreshing `.claude/skills/` is a run task the human pre-approved at P0, not a user story. The run does it after P2, and `scope.md` lists it under the run's own tasks, not as a requirement.
