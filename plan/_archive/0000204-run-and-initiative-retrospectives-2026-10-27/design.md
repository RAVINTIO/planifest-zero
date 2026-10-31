# Design - 0000204-run-and-initiative-retrospectives

## Feature
- Problem: the build report lists metrics but no step reviews what helped and what to change, and an initiative ends with no review across its steps, so lessons stay in build logs that nobody rereads.
- Adoption mode: standard-iterative
- Feature ID: 0000204-run-and-initiative-retrospectives
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I get one blameless retrospective for every shipped run, with at least one thing to keep and one to change, so that the next run does not repeat the same friction.
  - US-002: As the human on the loop, I get one post-initiative retrospective in the initiative pull request to `main`, with the charted-versus-shipped comparison and the friction that repeated across steps, so that I review the whole initiative in one place.
  - US-003: As the human on the loop, I find each change filed as a backlog entry or a repo instruction that names its source retrospective, so that nothing stays unread.
  - US-004: As the human on the loop, I see P0 discovery and initiative charting read the latest retrospectives, so that past lessons shape the next plan.
- Acceptance criteria confirmed: 4
- Constraints: Node built-ins only. No schema change. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: documentation and test changes only. A record names no credential and no person.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: one retrospective per run and one per initiative, written by the primary-tier agent

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the `ravintio-retrospective` skill with a run mode and an initiative mode, a record template, the ship hook for the run retrospective, the I-E Delivery hook for the initiative retrospective, the P0 and I-A Chart reads, the docs that count skills, `component.yml`, and tests.
- Out: a script that gathers retrospective data, a ship block on a missing retrospective, and the chart-time decisions that backlog entry 0000186 covers.
- Deferred: nothing deferred.

## Assumptions
- The ship step can read the archived build log, the postmortems, and the `Rework:` lines - impact if wrong: the retrospective omits evidence, and the human requests a rerun.
- I-E Delivery runs on the initiative branch with every step tag and `initiative.md` readable - impact if wrong: the charted-versus-shipped comparison has gaps, and the record says so.

## Risks
- A retrospective blames a person or an agent. Likelihood medium, impact medium. The skill rejects any observation that does.
- The skill adds cost to every run. Likelihood high, impact low. One record per run and one per initiative.
- The driver that runs this initiative started before this step, so its own I-E Delivery keeps the old stage rules. Likelihood high, impact low. Step 13 reruns setup, and the human runs the initiative retrospective by hand if delivery skips it.

## Dependencies
- Upstream: step 8 postmortems. The retrospective reads `plan/postmortems/`.
- Downstream: step 11 (chart-time decisions) reads retrospectives. Step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - retrospective skill and record template | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - ship and I-E Delivery hooks, P0 and chart reads | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - living docs and skill count | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 11:10 AM UTC
