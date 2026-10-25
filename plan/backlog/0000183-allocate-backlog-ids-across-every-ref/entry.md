---
title: "Backlog Entry: 0000183 - allocate backlog ids across every ref"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000183 - allocate backlog ids across every ref

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

When an agent copies a backlog entry into another repo, it can take an id that the target repo already used. The template's rule is "highest ever allocated + 1". `ravintio-file-backlog` scans `plan/backlog/`, `plan/_archive/`, and `plan/changelog/` in the working tree only, so it misses ids that exist only in these places:

- another branch, such as an open feature branch in a peer session
- an entry that was deleted on pickup, which lives only in git history
- a copy made from the other repo, which keeps the source repo's id

Both repos show this. Backlog id 0000026 appears twice in each repo's history, once as `0000026-ai-writing-tells-style-guard` and once as `0000026-document-backlog-id-sequence-convention`. The human on the loop reported that earlier cross-repo copies clashed with historic items in the same way.

On 2026-10-25, a RAVINTIO Framework session and the 0000172 step session both filed entries in this repo. Only a message between the sessions kept them from both taking 0000183. RAVINTIO Framework backlog 0000271 holds the same entry.

## Suggested Action

Allocate the next id as one more than the highest id found anywhere in the target repo. That covers:

- `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/` in the working tree
- the same folders on every local and remote branch, after a `git fetch`
- every `plan/backlog/{id}-*/entry.md` path that git history ever added

Put this in one script that both repos ship, and use it in `ravintio-file-backlog` and any cross-repo copy. A copied entry always gets a new id in the target repo and names its source id in the text. Add a test that plants a higher id on a second branch and in deleted history, and checks that the script picks one above both.

## Why Deferred

The human on the loop asked for it as a backlog entry. It changes the backlog template and the file-backlog skill, so it needs its own design.
