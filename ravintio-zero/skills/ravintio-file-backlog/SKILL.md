---
name: ravintio-file-backlog
description: Files one uncommitted backlog entry in another repo. Finds or creates plan/backlog/ there, picks the next id across plan/backlog/, plan/_archive/, and plan/changelog/, writes plan/backlog/{id}-{slug}/entry.md, and reports the path. Never touches the target repo's git state. Invoke on request ("file a backlog entry in {repo}", "add this to the backlog of {repo}").
---

# RAVINTIO - file-backlog

> You file one backlog entry in a target repo and leave that repo's git state as you found it. You are a standalone skill, invoked on request, outside the five-phase pipeline. No `plan/current/design.md` or phase gate is required to use it.

## Inputs

- The target repo path.
- The entry content: a short title, a slug in kebab-case, and the text for each section of the template.

If either input is missing, ask the human on the loop for it. Do not guess a path.

## Step 1 - Find the Backlog Folder

1. Look for `plan/backlog/` in the target repo.
2. If it is missing, create it.

## Step 2 - Read the Template and the Id Width

1. Read the target repo's backlog template. This is `ravintio-zero/templates/backlog-entry.template.md` or its equivalent in that repo.
2. If the target repo has no backlog template, use this pack's template.
3. Take the id width from the target repo's existing ids. If it has none, use this pack's width.

## Step 3 - Pick the Next Id

The next id is the highest ever allocated plus one.

1. Scan `plan/backlog/`, `plan/_archive/`, and `plan/changelog/` in the target repo.
2. An id is the leading zero-padded number in a folder or file name.
3. Take the highest id across all three folders. Add one. Pad it to the id width.

Scan all three folders. A scan of `plan/backlog/` alone reuses an id that an archived feature already took.

## Step 4 - Check for Collisions

1. If a folder with the same slug already exists in `plan/backlog/`, report its path and write nothing. A rerun is safe.
2. Never overwrite an existing folder. If the chosen id is taken, take the next free id.

## Step 5 - Write the Entry

Write `plan/backlog/{id}-{slug}/entry.md` in the target repo, in that repo's template format. Fill every field from the entry content. When no run is active, write `none (human request)` for the source feature and source phase, and `human request` for the deferral source.

## Step 6 - Report

Report the path written. Tell the human the entry is uncommitted and that they stage and commit it when they choose.

## Hard Limits

1. Never commit, push, switch branches, stash, or open a pull request in the target repo.
2. Never overwrite an existing folder.
3. Write only `plan/backlog/{id}-{slug}/entry.md` and, if missing, `plan/backlog/`.
4. If the same slug exists, write nothing.
