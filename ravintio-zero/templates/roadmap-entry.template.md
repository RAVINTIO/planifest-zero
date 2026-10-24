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
>
> `## Schema changes` lists each step's predicted data change. The human approves the rows at
> Chart. See Chart-time schema approval in `ravintio-zero/standards/roadmap-standards.md`.
>
> `## Dependencies` lists each step's predicted library or service. The human approves the rows
> at Chart. See Chart-time dependency approval in the same file.

**Goal:** {{What the whole chain delivers, in one or two sentences.}}
**Branch:** roadmap/{{id}}-{{slug}}
**Status:** {{draft | active | blocked | done}}
**Position:** {{number of the next step to run, for example 1}}

## Stop conditions

- {{A condition that halts the chain, for example a step blocks or a CI run fails twice.}}

## Schema changes

**Unpredicted additive changes:** {{pre-approved | stop}}

| Step | Component | Change | Kind |
|------|-----------|--------|------|
| 1 | {{component id, or none}} | {{the predicted data change, or none}} | {{additive, destructive, or none}} |

## Dependencies

| Step | Name | Kind | Purpose |
|------|------|------|---------|
| 1 | none | none | {{the library or service the step adds, or none. Kind is library, service, or none}} |

## Steps

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|
| 1 | {{feature id}} | {{backlog ids}} | minor | | pending |
