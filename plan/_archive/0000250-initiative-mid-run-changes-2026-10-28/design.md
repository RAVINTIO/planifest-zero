# Design - 0000250-initiative-mid-run-changes

## Feature
- Problem: a repo instruction that arrives mid-run has no route in the initiative skill, and a step that changes the driver, the watcher, or the initiative skill leaves later steps on the old code.
- Adoption mode: standard-iterative
- Feature ID: 0000250-initiative-mid-run-changes
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see the initiative skill add a repo instruction that I ask for mid-run to the scope of the current or next pending step in `initiative.md`, so that a step writes the override and `gate-write` stays as it is.
  - US-002: As a maintainer, I see the driver stop after a merged step that changed `initiative-run.mjs`, `initiative-watch.mjs`, or the initiative skill, and name the changed files, so that the next step runs the new code.
  - US-003: As a maintainer, I see the initiative skill restart the driver and the watcher when the driver prints the restart stop, so that I do not have to ask.
- Acceptance criteria confirmed: 5
- Constraints: no change to fail-closed hooks. No new library or service. The driver stays dependency-free.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. The driver adds two `git` calls with argument arrays and no shell. The routing rule keeps instruction writes inside a step, so `gate-write` still gates them.
- Data privacy: no regulated data
- Observability: the restart stop is one output line that names the files
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js driver with no dependencies, Markdown pack files, Bash tests, local build target
- Components: `ravintio-zero` (existing): driver, initiative skill, roadmap standards, tests
- Data ownership: the component owns the pack files
- Deployment: files in the pack, installed by setup
- API versioning: not applicable
- Decision: the driver stops for a restart and does not respawn itself. A respawned driver would run detached from the background task that the human's session watches, and it would lose the lock handoff and the output stream. A stop keeps one process per task.
- Decision: the change check compares the initiative branch ref before and after each step with `git diff --name-only`, limited to the three paths. If either ref is unreadable, the check is skipped.

## Scope
- In: routing rule, change check and restart stop, restart rule, standards and docs, tests, version.
- Out: a self-respawning driver. Changes to fail-closed hooks. Changes to the watcher. Checks on other files.
- Deferred: nothing deferred

## Assumptions
- The initiative branch ref moves when a step merges - impact if wrong: the check sees no change, and the existing "not merged" stop applies.

## Risks
- The skill additions push skill text past 1,720 lines - likelihood low, impact medium. The pack holds 1,530 lines and the additions run to about 12.
- A false restart stops a run for no reason - likelihood low, impact low. The check is limited to three exact paths, and a test covers a step that changes none.
- The running driver predates this change, so it does not stop after step 12 - likelihood certain, impact low. The build report tells the human to restart the driver before step 13.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Routing rule and restart rule in the initiative skill | ravintio-implement | Edits one skill and adds a Bash test |
| REQ-002 - Driver change check and restart stop | ravintio-implement | Edits the driver and adds a Bash test with a stub claude |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 09:36 PM UTC
