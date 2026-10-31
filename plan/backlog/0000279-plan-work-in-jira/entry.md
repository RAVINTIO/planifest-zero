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
- Keep ADRs in the repo, in `docs/adr/` once entry 0000280 lands. Each Story links to the ADRs its feature wrote. The human decided this on 2026-10-31.
- Never put Jira credentials in the repo or in context. The MCP server holds them.

### Records in Jira and in the repo

The human decided this on 2026-10-31. Planning records move to Jira, and run records stay in the repo.

- Chart writes the initiative as a draft Epic. Confirming the chart moves the Epic out of draft.
- Discovery writes the design as a draft User Story. Confirming the design moves the Story out of draft.
- At confirmation, `plan/current/design.md` becomes a brief summary. It holds the Story link and key, the feature id, the version, and the component fields that `gate-write` and `check-design` read, in their current format. The rest of the design lives on the Story.
- At chart, `plan/current-initiative/initiative.md` becomes a brief summary. It holds:
  - the Epic link and key
  - the fields the driver and `resume-detect.mjs` read: Status, Position, Branch, and the Steps table with a Story key column
  - the approval tables: `## Schema changes`, `## Decisions`, and `## P1 skips`
- The approval tables stay in the repo, because a commit there goes through review and a Jira field edit doesn't. A step must never trust an approval that nobody reviewed.
- The build log, the archive, postmortems, retrospectives, the changelog, and ADRs stay in the repo.

### Jira drives the phases

With the flag, Jira statuses replace the pack's internal phase gates. The orchestrator picks up only issues in a ready status. When a phase finishes, the agent moves the issue to the next ready status. A human can also move an issue into a ready status.

Default statuses, which each repo can change in the same config as the issue types:

| Jira status | Pack phase that picks it up | On finish, the agent moves it to |
|-------------|-----------------------------|----------------------------------|
| Ready to analyse | P0 Discovery: brief, coaching, and adoption mode | Ready to design |
| Ready to design | P0 design confirmation, then P1 Plan | Ready to implement |
| Ready to implement | P2 Implement, then P3 Validate | Ready to ship |
| Ready to ship | P4 Ship | Done |
| Any status | A stop | Blocked, with the stop message as a comment |

- **Gated mode:** the agent moves a finished issue to a review status, and a human moves it on to the next ready status. That move replaces the gate confirmation in chat.
- **Autonomous mode:** the agent moves the issue to the next ready status itself.
- **Claiming:** on pickup, the agent assigns itself and moves the issue to an in-progress status, so two sessions can't take the same issue.
- **Order:** the orchestrator picks the highest-ranked ready issue. The initiative driver picks the Stories under its Epic in rank order.
- **Transitions:** a Jira workflow can forbid some moves. The config names the allowed transitions as well as the statuses. Setup checks that each one exists on the project.

## Wanted outcome

With `--jira-planning`, the human plans and tracks pack work in Jira instead of in `plan/`. Tests check these conditions:

- Setup accepts `--jira-planning` and records it in `plan/state/{tool}.md`.
- Without the flag, the pack behaves as it does today.
- With the flag, chart creates an Epic for the initiative and one Story per step.
- With the flag, discovery writes the feature's user stories and requirements as acceptance criteria on its Story.
- A local config file changes the mapping, and the default applies when the file is missing.
- No Jira credential appears in a tracked file.
- With the flag, ADRs stay in the repo, and each Story links to its feature's ADRs.
- With the flag, `design.md` holds only the summary fields, and `gate-write` and `check-design` behave exactly as they do today.
- With the flag, `initiative.md` holds only the summary fields and the approval tables, and the driver runs from it unchanged.
- The orchestrator picks up only issues in a configured ready status, claims each one, and moves it to the configured next status when a phase finishes.
- Setup fails when a configured status or transition is missing from the Jira project.

## Open questions

- Is Jira the source of truth, or a mirror of `plan/`?
- Which Atlassian MCP server does the pack support?
- If two developers on one Jira project use different mappings, their issues won't match. Should the mapping be per repo, with a per-developer override only for personal views?

## Why Deferred

The human asked for it on 2026-10-31. No run is active.
