# Design - 0000202-improvement-loops

## Feature
- Problem: the TDD loop stops at the first green result, so a working solution is never reviewed for a simpler or cleaner design.
- Adoption mode: standard-iterative
- Feature ID: 0000202-improvement-loops
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I get up to 2 improvement cycles per requirement after GREEN, so that a working solution is simplified before it ships.
  - US-002: As the human on the loop, I read one `Improve:` marker per cycle that names the finding, the change, and the suite result, so that I can measure the gain.
- Acceptance criteria confirmed: 3
- Constraints: Node built-ins only. No schema change. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: documentation and test changes only. No new input is read.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: each cycle adds one reviewer dispatch, capped at 2 per requirement

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the improvement loop in the implement skill and the dispatch standard, the apply mode in the refactor skill, the `Improve:` marker in the workflow governance standard, the fast batch line, `component.yml`, the docs that name the TDD loop, and tests.
- Out: an improvement pass in P3, a metric or threshold in `workflow-metrics.mjs`, and a loop toggle.
- Deferred: nothing deferred.

## Assumptions
- A reviewer dispatched in a fresh context gives an independent read - impact if wrong: cycles find nothing and stop early, which costs one dispatch.

## Risks
- Cycles add cost to every requirement. Likelihood high, impact low. The cap is 2 and an empty finding stops the loop.
- A cycle changes behaviour. Likelihood low, impact medium. The refactor hard limits stay in force and the full suite must pass, or the change is reverted.

## Dependencies
- Upstream: none
- Downstream: step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - improvement loop in implement and refactor skills | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - Improve marker and docs | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 10:10 AM UTC
