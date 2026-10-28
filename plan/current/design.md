# Design - 0000248-ship-merge-and-wall-clocks

## Feature
- Problem: agents build the ship merge line with command substitution and `merge-guard` blocks it. Ship also archives build logs with blank or wrong wall clocks.
- Adoption mode: standard-iterative
- Feature ID: 0000248-ship-merge-and-wall-clocks
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see the ship skill give one plain merge line with a literal PR number, so that `merge-guard` allows the first attempt.
  - US-002: As a maintainer, I see ship stop before archive when a phase block has a blank or wrong time, so that archived build logs always hold usable wall clocks.
- Acceptance criteria confirmed: 5
- Constraints: no change to fail-closed hooks. No new library or service.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. The script reads one local file and runs no shell.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node 20 script, Bash tests, Markdown pack files, local build target
- Components: `ravintio-zero` (existing): ship skill, roadmap standards, `build-log-check.mjs`, tests
- Data ownership: the component owns the pack files
- Deployment: files in the pack, installed by setup
- API versioning: not applicable

## Scope
- In: plain merge line in the ship skill and I-D Advance step 4. `build-log-check.mjs` and a ship step that runs it before Archive. A skipped-phase note in the build log template. Two tests. Docs and version.
- Out: changes to fail-closed hooks. Changes to `consistency-check.mjs`. A PowerShell twin of the script.
- Deferred: nothing deferred

## Assumptions
- Build log timestamps use ISO-8601 UTC - impact if wrong: the check reports an unreadable timestamp and ship stops. The test covers it.

## Risks
- The ship skill additions push skill text past 1,720 lines - likelihood low, impact medium. The pack holds 1,512 lines and the additions run to 10 or fewer.
- The check rejects a valid log from a resumed or skipped run - likelihood medium, impact low. The skipped-phase line and the test fixtures cover the known shapes.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - plain merge command | ravintio-implement | Edits one skill and one standard, and adds a Bash test |
| REQ-002 - build log check | ravintio-implement | Adds one Node script, edits the ship skill and a template, and adds a Bash test |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 08:30 PM UTC
