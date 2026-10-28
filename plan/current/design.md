# Design - 0000251-driver-step-fixes

## Feature
- Problem: a step session passes `RAVINTIO_INITIATIVE_STEP=1` to every test, so hook tests fail, and the driver truncates the step log when it re-runs a step, so the first attempt's evidence is lost.
- Adoption mode: standard-iterative
- Feature ID: 0000251-driver-step-fixes
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I run the full suite inside a step session and see the same result as outside it, so that I do not rerun suites by hand.
  - US-002: As a maintainer, I see the log of every earlier attempt after the driver re-runs a step, so that a retrospective can quote the first stop.
  - US-003: As a maintainer, I see the earlier attempt logs named in the driver's stop line, so that I find them without listing the folder.
- Acceptance criteria confirmed: 5
- Constraints: no change to fail-closed hooks. No new library or service. The driver stays dependency-free and never uses a shell.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. Attempt logs keep the log folder rules: no symlinks, folder mode 700, file mode 600. The rotation renames within one folder and follows no link.
- Data privacy: no regulated data. Attempt logs hold the same content as a step log.
- Observability: the stop line names the attempt logs
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js driver with no dependencies, Bash and PowerShell runners, Bash tests, local build target
- Components: `ravintio-zero` (existing): driver, runners, roadmap standards, tests
- Data ownership: the component owns the pack files and the git-ignored log folder
- Deployment: files in the pack, installed by setup
- API versioning: not applicable
- Decision: the runners clear the variable once at the top, in their own process. A suite that needs the variable sets it for its own hook call. The per-suite `env -u` calls stay.
- Decision: `openLog` picks the lowest `k` for which `step-{n}.attempt-{k}.log` does not exist. A symlink at that path, at the step log, or at the folder stops the driver with the existing refusal. A regular file at the path moves the search to `k+1`.
- Decision: the rotation renames `step-{n}.log` and then opens a fresh log with `O_TRUNC`, as today. The latest attempt keeps the name `step-{n}.log`, so the watcher and the monitor read the same path.
- Decision: the stop line keeps `Log: {current}` and adds `Earlier: {attempt paths}` when attempt logs exist. The driver finds the attempts with one directory read.

## Scope
- In: runner change, `openLog` rotation, stop line, header and standards text, req-012 case (a), new tests, docs, version.
- Out: log content (entry 0000219), pruning or capping attempts, changes to fail-closed hooks, removal of per-suite `env -u`.
- Deferred: nothing deferred

## Assumptions
- Renaming a file keeps its mode - impact if wrong: the rotation sets mode 600 on the renamed file.
- A suite that needs the variable sets it for its own hook call - impact if wrong: that suite fails once, and the step adds the setting.

## Risks
- A suite relies on the inherited variable - likelihood low, impact low. The full suite under `RAVINTIO_INITIATIVE_STEP=1` finds it.
- Attempt files grow without bound across many re-runs - likelihood low, impact low. A re-run is rare, and the folder is git-ignored. Pruning is out of scope.
- The running driver predates this change - likelihood certain, impact low. The step 13 re-run behaviour applies only after a restart.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Runners clear the step variable | ravintio-implement | Two short edits and a Bash test |
| REQ-002 - Driver keeps every attempt log | ravintio-implement | One driver function, docs, and a Bash test with a stub claude |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 09:56 PM UTC
