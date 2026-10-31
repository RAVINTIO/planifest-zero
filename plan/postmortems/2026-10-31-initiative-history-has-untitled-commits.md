---
title: "Postmortem: 2026-10-31 - initiative history has untitled commits"
summary: "A blameless record of why a failure got through earlier phases, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-10-31 - initiative history has untitled commits

**Trigger:** human request
**Feature:** none (initiative 0000238-backlog-clearance-two)
**Date:** 2026-10-31

## Summary

The initiative branch should show one squash commit per feature, so the merge commit to `main` reads as a list of features. Of its 38 first-parent commits, 15 are step squashes and 23 are direct commits with other titles. The merge commit `79acc85` carries all 38 to `main`, so the feature list is hard to read.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-10-27 | Chart reserves ids and files entries with direct commits on the initiative history | `e7dd1a2`, `6c8b84b`, `eebb205` |
| 2026-10-28 06:18 | Activate commits the plan on the initiative branch | `79cc2d5` |
| 2026-10-28 06:40 | Step 1 lands as squash `dc3a185`, titled as its feature with its PR number | PR #56 |
| 2026-10-28 07:33 to 13:13 | The coordinator commits backlog entries and the reactivation directly on the initiative branch | `05abbb9`, `723697a`, `f2838fa`, `f02d710` |
| 2026-10-28 19:38 | A fix for step 7 lands as its own squash with a `docs(...)` title | `f03b870` (PR #63) |
| 2026-10-28 22:15 | Step 13 commits its changelog PR number after its squash, directly on the initiative branch | `6f088d9` |
| 2026-10-29 00:05 to 01:22 | The coordinator commits the plan fix, seven backlog entries, an id reservation, the archive, and the retrospective directly | `8d0703d` to `04b9976` |
| 2026-10-29 | PR #72 to `main` lists all 38 commits | PR #72 |
| 2026-10-31 | PR #74 replaces PR #72 and lands as merge commit `79acc85` | `git log -1 79acc85` |

First missed chance to catch it: `e7dd1a2`, the first direct commit. No check requires each first-parent commit on `initiative/*` to come from a titled PR.

## 5 whys

1. Why is the history hard to read? 23 of the 38 first-parent commits on the initiative branch aren't feature squashes.
2. Why are there direct commits? The pack tells the coordinator to commit on the initiative branch. Examples are the activation, queued backlog entries, the archive, and the retrospective (`roadmap-standards.md` lines 386 to 389, `ravintio-initiative/SKILL.md` lines 82 and 89).
3. Why does the pack route that work there? It treats coordinator work as bookkeeping. Nothing in the standards says that every commit on `initiative/*` must arrive as a titled squash PR.
4. Why did nothing flag it? No hook, CI check, or delivery check reads the first-parent titles of the initiative branch. Branch rules on `origin` don't require a PR for `initiative/*`.
5. Why did it repeat? Initiative 0000195 had the same shape. 39 of its 55 first-parent commits weren't feature squashes, and no record captured it.

**Gap:** the roadmap standards allow direct commits on `initiative/*`, and no check enforces one titled squash per change.

## Actions

| Type | Action | Owner | Lives in | Verified by | Filed as |
|------|--------|-------|----------|-------------|----------|
| preventive | Route all coordinator and post-squash work through a titled PR into `initiative/*`. Never commit directly on the initiative branch. | roadmap standards, initiative skill, ship skill | `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/skills/ravintio-initiative/SKILL.md` | skill text tests | backlog entry 0000274 |
| detective | Fail a PR from `initiative/*` to `main` when a first-parent commit isn't a titled squash, and run the same check at I-E Delivery | CI, initiative skill | `.github/workflows/`, `ravintio-zero/scripts/` | check tests on a sample history | backlog entry 0000275 |

Initiative 0000238 can't be corrected now without rewriting `main` again.
