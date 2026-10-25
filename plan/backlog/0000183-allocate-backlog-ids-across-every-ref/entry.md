---
title: "Backlog Entry: 0000183 - reserve ids from a counter file"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000183 - reserve ids from a counter file

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

Keep the next free id in a counter file, and reserve ids from it before any entry is written. The human on the loop chose this design over scanning every ref, because a counter needs no search.

- `plan/backlog/.next-id` holds one seven-digit number. Seed it with one above the highest id in use when the feature ships.
- One script, `ravintio-zero/scripts/reserve-id.mjs`, reserves ids. To reserve `qty` ids, it:
  1. takes an exclusive lock beside the file
  2. reads the next free id, `n`
  3. writes `n + qty`
  4. releases the lock
  5. returns ids `n` to `n + qty - 1`
- Backlog entries, feature ids, and roadmap ids all reserve from this counter.
- `ravintio-file-backlog`, the orchestrator, and roadmap charting call the script rather than scanning folders.
- A copy from another repo reserves a new local id and names its source id in the text. Each repo keeps its own sequence.
- If two branches reserve the same ids, git shows a merge conflict on `.next-id`. Keep the higher value and renumber the entries on the branch that merges second. This answer is pre-approved.
- Update the backlog and roadmap templates, which describe the "highest ever allocated + 1" rule.

## Wanted outcome

Every new id comes from `plan/backlog/.next-id`. Tests check these conditions:

- Reserving 4 ids from `0000188` returns `0000188` to `0000191` and leaves `0000192` in the file.
- Two reservations started at once return ids that don't overlap.
- A copied entry gets a local id and names its source id.

## Why Deferred

The human on the loop asked for it as a backlog entry. It changes the backlog template and the file-backlog skill, so it needs its own design.
