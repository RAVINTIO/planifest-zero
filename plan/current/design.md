# Design - 0000205-initiative-skill

## Feature
- Problem: nothing coordinates an initiative from chart to delivery, so the human's session has no role, strict mode warns it, a resume can run one step twice, and the driver misses a block, advances early, and loses subagents.
- Adoption mode: standard-iterative
- Feature ID: 0000205-initiative-skill
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I talk to one `ravintio-initiative` session that charts, activates, watches, and delivers an initiative, so that I know what each step is doing.
  - US-002: As the human on the loop, I get a report at least every 5 minutes, at each phase end, and on request, so that I see progress without asking.
  - US-003: As the human on the loop, I see strict mode stay quiet in my session and in every step session, so that no session overwrites another's ack.
  - US-004: As the human on the loop, I see the driver stop on an archived `Blocked:` line, advance only after the merge, and keep step subagents running, so that no step is lost.
- Acceptance criteria confirmed: 10
- Constraints: Node built-ins only. No schema change. No new dependency. No guard weakens.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the watch script is read-only and prints identifiers and build log lines cut to 500 characters. The auto-trigger and presence hooks read only sentinel files. No guard changes.
- Data privacy: no regulated data
- Observability: watch script output, one line per event
- Cost boundary: the human's session runs the initiative skill for the whole initiative on the primary tier

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, hooks, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the `ravintio-initiative` skill, the resume split, the ack split, the auto-trigger change, a read-only watch script, three driver fixes plus a final report, the three-part docs, and the docs and tests that count skills.
- Out: chart-time decisions from past stops (backlog entry 0000186), changes to P0 to P4 of a step, and a monitor implementation.
- Deferred: nothing deferred.

## Assumptions
- A step's feature branch is merged into the initiative branch by the step session before the driver reads `position` - impact if wrong: the driver stops with a "not merged" line and the human restarts it.
- The host offers a background monitor tool - impact if wrong: the skill reports on each prompt and at phase ends only.

## Risks
- The driver that runs this initiative started before this step, so it keeps the old checks. Likelihood high, impact low. Step 13 reruns setup, and the next initiative uses the new driver.
- Reading `position` from the initiative branch ref breaks the existing driver tests that edit the working tree. Likelihood medium, impact medium. The driver falls back to the working tree outside a git repo, and tests use a temporary repo.
- The skill moves stage text out of the orchestrator and leaves a gap. Likelihood medium, impact medium. Tests pin that each stage has exactly one owner.

## Dependencies
- Upstream: step 4 counter (`reserve-id.mjs`) for queued entry ids.
- Downstream: step 11 (chart-time decisions) edits the skill's I-A Chart section. Step 13 reinstalls skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - driver fixes and final report | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - ack split and trigger hooks | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - watch script | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-004 - initiative skill and resume split | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-005 - living docs and skill count | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 11:35 AM UTC
