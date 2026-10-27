# Scope - reserve ids from a counter

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Version:** 0.21.0

## In Scope

- Add `ravintio-zero/scripts/reserve-id.mjs`, which reserves a block of ids from a counter file under an exclusive lock.
- Seed `plan/backlog/.next-id` at `0000210`.
- Replace the folder-scan rule with the counter in the file-backlog skill, the orchestrator's backlog pickup, both templates, `roadmap-standards.md`, and `agent-dispatch-standards.md`.
- State the copied-entry rule and the counter conflict answer.
- Add one test suite for the script and the docs, and update the two suites that assert the old wording.

## Out of Scope

- Renumbering any existing id.
- A hook or CI check that rejects a hand-written id.
- A scan of every git ref.
- Setup changes.

## Deferred

Nothing deferred.
