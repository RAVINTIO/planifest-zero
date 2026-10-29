---
title: "Feature Brief - refresh setup"
summary: "Chore: refresh the claude-code install so .claude/skills/ and the boot files match the pack."
status: "approved"
version: "0.1.0"
---
# Feature Brief - refresh setup

**Feature ID:** 0000253-refresh-setup

Source: initiative 0000238 step 15, a chore with no backlog entries.

## Business Goal

Steps 1 to 14 changed the pack skills and the boot rules. The installed copies in `.claude/skills/` and the generated `CLAUDE.md` can lag behind. The refresh brings them level, so the next session loads the current rules.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Refresh the install | As a maintainer, I run the refresh with the approved command, so that `.claude/skills/` and `CLAUDE.md` match the pack. | must-have | 1 |

## Target Architecture

No new component. The refresh runs `ravintio-zero/setup.sh claude-code --strict-orchestrator`, as override `custom-006` approves.

## Scope Boundaries

### In Scope
- Run `ravintio-refresh-setup` with the exact approved command.
- Confirm `.claude/skills/` matches `ravintio-zero/skills/`.
- Confirm the regenerated `CLAUDE.md` is 6,000 bytes or fewer with every override in force.
- Commit the regenerated tracked files and the patch version bump.

### Out of Scope
- Any change to a pack skill, hook, script, or test.
- Any flag other than `--strict-orchestrator`.

### Deferred
- Nothing deferred.

## Acceptance Criteria

- [ ] The command run is exactly `ravintio-zero/setup.sh claude-code --strict-orchestrator`.
- [ ] `.claude/skills/` matches `ravintio-zero/skills/`.
- [ ] `CLAUDE.md` is 6,000 bytes or fewer, with every override in force.
