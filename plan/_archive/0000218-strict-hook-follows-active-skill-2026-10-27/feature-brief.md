---
title: "Feature Brief - strict hook follows active skill"
summary: "Makes both prompt hooks name the skill that owns the session, and ignores the driver lock."
status: "approved"
version: "0.1.0"
---
# Feature Brief - strict hook follows active skill

**Feature ID:** 0000218-strict-hook-follows-active-skill

## Business Goal

The strict-mode hook picks the banner skill from the driver lock, which is a poor signal. Between steps the human's session gets the orchestrator banner, and the orchestrator's resume detection could take over a step. The hook must name the skill that owns the session, and the auto-trigger hook must name the same one.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Skill-owner banner | As a human on an active initiative, I get the initiative banner in my session, so that the orchestrator never takes over a step. | must-have | 1 |
| Ignore the ack | As a maintainer, I find `plan/.initiative-ack` git-ignored, so that a step session never commits the human's ack. | must-have | 1 |

## Scope Boundaries

### In Scope
- `check-orchestrator-presence.mjs` decides by `plan/current-initiative/initiative.md` status and `RAVINTIO_INITIATIVE_STEP`, in strict and advisory mode.
- `auto-trigger-orchestrator.mjs` applies the same rule.
- Add `plan/.initiative-ack` to `.gitignore`.
- Update the tests, `roadmap-standards.md`, and the other docs that describe the lock rule.

### Out of Scope
- Changes to the driver, the lock, or the ack file contents.
- Git-ignoring `plan/.orchestrator-ack`. A step session owns and commits it by design.

### Deferred
- None.

## Acceptance Criteria

- [ ] AC-1: An active initiative with the lock free and no step variable gives the initiative banner.
- [ ] AC-2: An active initiative with the lock held and no step variable gives the initiative banner.
- [ ] AC-3: A step session (`RAVINTIO_INITIATIVE_STEP=1`) gives the orchestrator banner.
- [ ] AC-4: No active initiative gives the orchestrator banner, with the lock free or held.
- [ ] AC-5: The auto-trigger hook names the same skill as the strict-mode hook in each of these cases.
- [ ] AC-6: `git check-ignore plan/.initiative-ack` succeeds.
