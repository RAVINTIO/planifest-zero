# Design - 0000218-strict-hook-follows-active-skill

## Feature
- Problem: the strict-mode hook reads the driver lock to pick a skill, so the human's session can get the orchestrator banner while an initiative is active.
- Adoption mode: standard-iterative
- Feature ID: 0000218-strict-hook-follows-active-skill
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a human on an active initiative, I get the initiative banner in my session, so that the orchestrator never takes over a step
  - US-002: As a maintainer, I find `plan/.initiative-ack` git-ignored, so that a step session never commits the human's ack
- Acceptance criteria confirmed: 6
- Constraints: hooks never exit 2 and never block. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. The hooks only read local files. The ack file is git-ignored so it cannot be committed.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: none

## Engineering Layer
- Stack: node (`.mjs` hooks), bash and PowerShell tests, markdown. Build target: local
- Components: `ravintio-zero` (pack)
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: skill-owner rule in both hooks, `.gitignore` entry, tests, docs that describe the lock rule
- Out: driver, lock, ack contents, `plan/.orchestrator-ack` ignoring
- Deferred: none

## Assumptions
- The driver sets `RAVINTIO_INITIATIVE_STEP=1` in every step session - impact if wrong: a step session gets the initiative banner. The 0000205 suite already relies on it.

## Risks
- The auto-trigger hook no longer requires an empty `plan/current/`, so a human session with an active initiative and open step artifacts names the initiative skill - likelihood low, impact low. That is the wanted behaviour.
- A stale `status: active` after delivery - likelihood low, impact medium. I-E Delivery sets the status, so the rule follows it.

## Dependencies
- Upstream: 0000205-initiative-skill
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - skill-owner rule in both hooks | ravintio-implement | One TDD cycle on two small files |
| REQ-002 - ignore `plan/.initiative-ack` | ravintio-implement | One line and one assertion |

## Repo Instructions
custom-001 to custom-006 in `ravintio-overrides/instructions/`: local git only, prefer subagent decomposition, GUTD shorthand, ship pushes and raises the PR, delete redundant branches, standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 27 Oct 2026 @ 07:10 PM GMT

Version: 0.30.1 (patch from 0.30.0, per the initiative row)
Run mode: autonomous
