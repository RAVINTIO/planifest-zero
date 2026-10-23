---
title: "Roadmap: {{id}} - {{short-title}}"
summary: "{{One sentence: what this roadmap delivers.}}"
status: "draft"  # draft | active | blocked | done
---
# Roadmap: {{id}} - {{short-title}}

> Path: `plan/roadmap/{id}-{slug}/roadmap.md` for a draft, one folder per draft. `{id}` is a
> zero-padded seven-digit number and `{slug}` is kebab-case. An active roadmap lives at
> `plan/current-roadmap/roadmap.md`.
>
> **`{id}` shares the backlog's sequence.** Next `{id}` = highest ever allocated + 1, across
> `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/`.
>
> `Bump` takes `major`, `minor`, or `patch`. Leave it empty for the default, `minor`.
> `position` names the next step to run.

**Goal:** {{What the whole chain delivers, in one or two sentences.}}
**Branch:** roadmap/{{id}}-{{slug}}
**Status:** {{draft | active | blocked | done}}
**Position:** {{next step to run, for example step 1}}

## Stop conditions

- {{A condition that halts the chain, for example a step blocks or a CI run fails twice.}}

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | {{feature id}} | {{backlog ids}} | minor | | pending |
