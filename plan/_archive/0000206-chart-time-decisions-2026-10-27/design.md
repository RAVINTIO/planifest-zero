# Design - 0000206-chart-time-decisions

## Feature
- Problem: Chart pre-approves schema changes and dependencies but not the other forks that stop a step, so a step stops for decisions that Chart could have taken.
- Adoption mode: standard-iterative
- Feature ID: 0000206-chart-time-decisions
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I approve a pre-mortem decision table at Chart, with a pre-approved answer, fallback scope, and bump effect for each likely fork, so that a step applies the answer without stopping.
  - US-002: As the human on the loop, I see a baseline for each performance target, a criterion critic result for each measurable criterion, and an environment check for each step at Chart, so that a target rests on measured cost and a margin that covers noise.
  - US-003: As the human on the loop, I see a step apply a matching table row, log it, and stop only for a fork the table doesn't cover, so that a forecast fork needs no human.
  - US-004: As the human on the loop, I see Chart turn each stop in the latest retrospectives into a table row, so that a stop does not repeat.
- Acceptance criteria confirmed: 4
- Constraints: Markdown and Bash only. No schema change. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: documentation and test changes only. A table row names no credential.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the Chart-time decisions section in the roadmap standards, three new tables in the initiative template, the I-C Run rule for applying a row, pointers in the initiative and orchestrator skills, tests, and living docs.
- Out: a script that builds the tables, replacing the schema and dependency approvals, and driver changes.
- Deferred: nothing deferred.

## Assumptions
- Step sessions read `initiative.md` - impact if wrong: a step cannot apply a row and stops, as today.
- The skill text total has room for a few lines under its 1720 budget - impact if wrong: the budget test fails and the rules move into the standards file.

## Risks
- A table row is too broad and approves a fork that deserves a human. Likelihood medium, impact medium. A row names one fork, and the human approves each row at Chart.
- The driver running this initiative started before this step, so later steps keep the old stage rules. Likelihood high, impact low. Steps 12 and 13 do not depend on the new rules.

## Dependencies
- Upstream: step 9 retrospectives. Chart reads `plan/retrospectives/`.
- Downstream: step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - chart-time rules and template tables | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - step-side application and skill pointers | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - worked example replaying roadmap 0000168 | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 12:10 p.m. UTC
