---
title: "Scope - rename-runner-lock-and-archive"
summary: "Boundaries for the runner lock and archive folder renames."
status: "draft"
version: "0.1.0"
---
# Scope - rename-runner-lock-and-archive

**Skill:** plan
**Feature:** 0000192-rename-runner-lock-and-archive
**Version:** 0.19.0

## In Scope

- The driver lock moves to `plan/.initiative-runner.lock`.
- I-E Delivery archives to `plan/_archive/{id}-{slug}-initiative-{date}/`.
- The driver's delivery check reads both archive folder forms.
- The old-name guard flags both old names.
- Tests and `docs/architecture-overview.md` use the new names.

## Out of Scope

- Renaming existing folders in `plan/_archive/`.
- A consumer migration. The lock is transient, and the delivery check reads both forms.
- Backlog 0000190 and entries 0000174 to 0000186.

## Deferred

Nothing deferred.
