---
title: "Backlog Entry: 0000279 - plan work in Jira through the Atlassian MCP"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000279 - plan work in Jira through the Atlassian MCP

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-31

---

## Problem

The pack plans all work in files under `plan/`. Backlog entries live in `plan/backlog/`, initiatives in `plan/current-initiative/`, and each run's requirements and plan in `plan/current/`.

A team that tracks work in Jira can't see or shape that plan where it already works. The pack has no link to Jira, and no skill reads from or writes to it.

## Suggested Action

- Add a setup flag, `--jira-planning`. With the flag, the skills plan in Jira. Without it, the pack plans in `plan/` as it does today.
- Record the flag in `plan/state/{tool}.md` like any other setup flag, so `ravintio-refresh-setup` keeps it.
- Use this Jira structure by default:

  | Pack record | Jira item |
  |-------------|-----------|
  | Initiative, the multi-day work | Epic, which can hold as many Stories as it needs |
  | Feature, one PR and one release | Story under the initiative's Epic |
  | Feature outside an initiative | Story with no Epic |
  | The feature's user stories and requirements | Acceptance criteria on the Story |
  | P2 units | Sub-tasks, if wanted |
  | Backlog entry | Story, Task, or Bug in the backlog. At pickup, it closes into the feature's Story or becomes it. |

  The default needs no level above Epic, so it works on every Jira plan.
- Let each developer change the mapping for themselves, for example to put an Initiative item above Epic, with each feature as an Epic and its user stories as Stories. Keep the change in a local, untracked config file.
- Use the Atlassian MCP server to read and write Jira issues from the skills.
- Decide which records stay in the repo. The build log, the design, and the archive may still need to live beside the code.
- Never put Jira credentials in the repo or in context. The MCP server holds them.

## Wanted outcome

With `--jira-planning`, the human plans and tracks pack work in Jira instead of in `plan/`. Tests check these conditions:

- Setup accepts `--jira-planning` and records it in `plan/state/{tool}.md`.
- Without the flag, the pack behaves as it does today.
- With the flag, chart creates an Epic for the initiative and one Story per step.
- With the flag, discovery writes the feature's user stories and requirements as acceptance criteria on its Story.
- A local config file changes the mapping, and the default applies when the file is missing.
- No Jira credential appears in a tracked file.

## Open questions

- Which records move to Jira, and which stay in `plan/`?
- Is Jira the source of truth, or a mirror of `plan/`?
- Which Atlassian MCP server does the pack support?
- If two developers on one Jira project use different mappings, their issues won't match. Should the mapping be per repo, with a per-developer override only for personal views?

## Why Deferred

The human asked for it on 2026-10-31. No run is active.
