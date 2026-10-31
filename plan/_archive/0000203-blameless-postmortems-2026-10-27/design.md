# Design - 0000203-blameless-postmortems

## Feature
- Problem: the pipeline fixes a failure and moves on, so nothing records why earlier phases let it through and the same kind of failure returns.
- Adoption mode: standard-iterative
- Feature ID: 0000203-blameless-postmortems
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I get one postmortem record per `Blocked:` stop or CI failure, with a timeline and a 5 whys chain that ends at a process or tool gap, so that the same failure does not return.
  - US-002: As the human on the loop, I find each action filed as a backlog entry or a repo instruction, so that nothing stays unread.
  - US-003: As the human on the loop, I see the build report list the run's postmortems, so that I can find them.
- Acceptance criteria confirmed: 3
- Constraints: Node built-ins only. No schema change. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: documentation and test changes only. A record names no credential and no person.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: one postmortem per stop, written by the primary-tier agent

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the `ravintio-postmortem` skill, a record template, the orchestrator trigger and catalogue row, the build report line in the ship skill, the docs that count skills, `component.yml`, and tests.
- Out: a trigger-detection script, a postmortem for a fixed P3 finding with no stop, and a ship block on a missing postmortem.
- Deferred: nothing deferred.

## Assumptions
- The orchestrator can read `Blocked:` and `Resolved:` lines from the build log - impact if wrong: the trigger never fires, and the human requests a postmortem by hand.

## Risks
- A chain blames a person or an agent. Likelihood medium, impact medium. The skill rejects any chain that ends there.
- The skill adds cost to every stop. Likelihood high, impact low. A postmortem runs once per stop.

## Dependencies
- Upstream: none
- Downstream: step 9 retrospectives read postmortems. Step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - postmortem skill and record template | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - orchestrator trigger, ship report line, and docs | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 10:40 AM UTC
