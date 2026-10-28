# Execution Plan - git state hygiene

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000247-git-state-hygiene
**Version:** 0.36.0
**Status:** active

## Active Skills

None.

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-stage-by-path.md](requirements/req-001-stage-by-path.md) | The orchestrator and ship skills stage by explicit path in an active initiative |
| [req-002-commit-id-reservations.md](requirements/req-002-commit-id-reservations.md) | `reserve-id.mjs --commit` commits the counter, and three skills call it |
| [req-003-no-stash-in-batch.md](requirements/req-003-no-stash-in-batch.md) | The dispatch standard and skeleton prompts forbid `git stash` in a batch |

## Non-Functional Requirements

| ID | Category | Requirement | Target | Measurement |
|----|----------|------------|--------|-------------|
| NFR-001 | Size | Pack skill text stays under its cap | 1,720 lines or fewer | `test-0000031-req-003-five-phases.sh` |
| NFR-002 | Size | The orchestrator skill stays under its cap | 9,000 bytes or fewer | `test-0000151-req-011-orchestrator-references-split.sh` |

## API Summary

None. The feature builds no API.

## Data Model Summary

None. The feature owns no data beyond the `plan/backlog/.next-id` counter.

## Component Interactions

The change edits files in one component, `ravintio-zero`. `reserve-id.mjs --commit` calls `git` in the working directory.

## Test impact

| Cause | Test | Unit |
|-------|------|------|
| Skill-text budget (edits to five `SKILL.md` files) | `test-0000031-req-003-five-phases.sh`, `test-0000206-req-002-step-application.sh` | U-001, U-002 |
| Skill count (no skill added) | none found | none |
| Size cap on an edited skill (orchestrator) | `test-0000151-req-011-orchestrator-references-split.sh` | U-001 |
| Pulled-in entry ids 0000213, 0000224, 0000231 | none found | none |
| Edit to the ship skill git add step | `test-0000025-req-002-ship-agent-p7-git-add.sh` | U-001 |
| Edit to the dispatch standard | `test-0000172-req-002-fast-batches.sh`, `test-0000043-req-012-progress-markers-and-resume.sh` | U-003 |
| Edit to `reserve-id.mjs` | `test-0000199-req-001-003-reserve-ids-from-counter.sh` | U-002 |

## Concurrency plan

| Unit | Depends on | Writes | Batch | Sequential reason |
|------|-----------|--------|-------|-------------------|
| U-001 | none | `ravintio-zero/skills/ravintio-orchestrator/SKILL.md`, `ravintio-zero/skills/ravintio-ship/SKILL.md`, `ravintio-zero/tests/test-0000247-req-001-stage-by-path.sh` | 1 | none |
| U-002 | none | `ravintio-zero/scripts/reserve-id.mjs`, `ravintio-zero/skills/ravintio-initiative/SKILL.md`, `ravintio-zero/skills/ravintio-retrospective/SKILL.md`, `ravintio-zero/skills/ravintio-postmortem/SKILL.md`, `ravintio-zero/tests/test-0000247-req-002-commit-id-reservations.sh` | 1 | none |
| U-003 | none | `ravintio-zero/standards/agent-dispatch-standards.md`, `ravintio-zero/tests/test-0000247-req-003-no-stash-in-batch.sh` | 1 | none |

## Assumptions

| ID | Assumption | Impact if Wrong |
|----|-----------|----------------|
| A-001 | `git commit -- plan/backlog/.next-id` commits that path alone | The commit holds extra files. The test checks it |

## Open Questions

None.
