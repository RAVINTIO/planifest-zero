---
title: "Retrospective: 2026-10-27 - run and initiative retrospectives"
summary: "A blameless review of the run that added the retrospective skill, and the changes it files."
status: "open"
---
# Retrospective: 2026-10-27 - run and initiative retrospectives

> Path: `plan/retrospectives/0000204-run-and-initiative-retrospectives-2026-10-27.md`. Written by `ravintio-retrospective`.
> Blameless: a cause names a gap in a process, check, standard, or tool. Never name a person or an agent.

**Mode:** run
**Subject:** 0000204-run-and-initiative-retrospectives
**Date:** 2026-10-27

## Summary

The run added the `ravintio-retrospective` skill, its template, the ship and delivery hooks, and the P0 and chart reads. It shipped as 0.26.0 in about 46 minutes, with 3 rework loops and no `Blocked:` stop.

## What helped

- The step 8 archive gave a worked example of every plan artifact and every doc that counts skills, so P1 and P2 needed no new design (`plan/_archive/0000203-blameless-postmortems-2026-10-27/`).
- Writing the three test files first showed RED for the right reason, so each later pass proved the wording and not the setup (build log, P2).

## What slowed the work

- A P2 edit rewrote a base line of Discovery Start Actions and pushed the orchestrator skill past its 27,700 byte cap. No plan step named the cap test (build log, P2 `Rework:` line 1).
- Adding a skill changed the skill count and line budget in four tests. The plan listed none of them (build log, P2 `Rework:` line 2).
- A test required a pulled-in backlog entry to exist, and the plan did not name that test (build log, P2 `Rework:` line 3).

## Keep

- Start from the previous step's archive when a step repeats its shape (`plan/_archive/0000203-blameless-postmortems-2026-10-27/`).
- Write tests first, even for Markdown rules (build log, P2).

## Change

- Add a P1 check that lists the tests a plan touches, by grepping for the skill count, the skill-text budget, the size caps, and the pulled-in entry ids.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| List the count, budget, cap, and entry-id tests in every plan that adds a skill, edits the orchestrator skill, or pulls in an entry | pack maintainers | `ravintio-zero/skills/ravintio-plan/SKILL.md` | A plan test that reads the skill text | Backlog entry 0000210, source retrospective `plan/retrospectives/0000204-run-and-initiative-retrospectives-2026-10-27.md` |
