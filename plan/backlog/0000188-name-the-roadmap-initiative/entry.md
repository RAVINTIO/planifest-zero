---
title: "Backlog Entry: 0000188 - name the roadmap initiative"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000188 - name the roadmap initiative

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

The pack uses "roadmap" for two different things. A roadmap is a long-term plan. The pack also calls one charted set of feature steps "a roadmap". That set ships together on one branch, in one PR to `main`. The domain then has no word for the long-term plan, and "the roadmap" sounds singular when a project runs many.

The word appears 722 times in 80 files outside `plan/`. It appears in these places:

- the `roadmap/*` branch pattern and the `merge-guard` hook
- `plan/roadmap/`, `plan/current-roadmap/`, and `roadmap.md`
- `ravintio-zero/scripts/roadmap-run.mjs` and its telemetry labels
- `ravintio-zero/standards/roadmap-standards.md` and `roadmap-entry.template.md`
- the orchestrator and ship skills, and the CI workflow template

## Suggested Action

Define the two terms and use them everywhere:

- **Roadmap:** the long-term plan for the product. The `plan/roadmap/` folder holds it, with one subfolder per roadmap initiative.
- **Roadmap initiative:** a goal that delivers a string of feature builds. Each build merges into the initiative's own branch, and that branch merges to `main` in one PR.

An initiative moves through four states:

1. **Proposed.** An entry in `plan/roadmap/` states the goal and the candidate backlog entries.
2. **Charted.** R-A Chart turns it into ordered steps, with bumps and pre-approved decisions. The human approves the chart.
3. **Active.** R-B Activate cuts the initiative branch. Each step builds one feature and merges it into that branch.
4. **Delivered.** R-E Delivery raises the PR from the initiative branch to `main`. The human merges it.

Then do these tasks:

- Add both terms to a domain glossary in the pack, and explain them in `ravintio-zero/project-operations.md`.
- Rewrite prose in skills, standards, templates, and docs to use "roadmap initiative" for the charted unit.
- Rename paths, scripts, the branch pattern, and labels to match. P0 confirms each new name with the human.
- Replace the template's `draft | active | blocked | done` status with the four states above, and keep `blocked`.
- Write a migration for consumer projects that renames an existing draft folder and updates their CI branch pattern.
- Keep the `R-A` to `R-E` prefixes. "R" still stands for roadmap.

This feature runs as a normal feature with the human present, before the next roadmap initiative activates. A rename inside a running initiative would break its driver, which looks for the old names.

## Wanted outcome

The pack defines "roadmap" and "roadmap initiative" in one glossary. No skill, standard, template, or doc uses "roadmap" alone for the charted unit. A search test fails on a reintroduced use of the old names. The driver, the `merge-guard` hook, and CI work with the new branch pattern and paths, and their tests pass. A consumer project migrates with the new migration and keeps its open draft.

## Why Deferred

The human asked for it while charting the next roadmap initiative on 2026-10-25. It runs before that initiative activates.
