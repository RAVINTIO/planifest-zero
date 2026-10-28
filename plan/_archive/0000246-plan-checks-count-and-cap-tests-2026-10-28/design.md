# Design - 0000246-plan-checks-count-and-cap-tests

## Feature
- Problem: the plan phase never names the tests that hold skill counts, skill-text budgets, size caps or backlog entry ids, so each run loops on rework.
- Adoption mode: standard-iterative
- Feature ID: 0000246-plan-checks-count-and-cap-tests
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I read the tests that hold counts, budgets, caps and ids in the execution plan, so that a run ends with no rework loop for those causes.
- Acceptance criteria confirmed: 3
- Constraints: no change to fail-closed hooks. No new library or service.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash tests, Markdown pack files, local build target
- Components: `ravintio-zero` (existing): plan skill, execution plan template, tests
- Data ownership: none
- Deployment: files in the pack, installed by setup
- API versioning: not applicable

## Scope
- In: Test impact scan in the plan skill. Test impact section in the execution plan template. A plan test. Docs and version.
- Out: a scan script. Changes to existing cap tests beyond count updates.
- Deferred: nothing deferred

## Assumptions
- The four test families in discovery are the ones the entry means - impact if wrong: the scan misses a test.

## Risks
- The plan skill addition pushes skill text past 1,720 lines - likelihood low, impact medium. Headroom is 35 lines and the addition is 15 or fewer.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - test impact scan | ravintio-implement | Edits pack Markdown and one Bash test |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 07:43 PM UTC
