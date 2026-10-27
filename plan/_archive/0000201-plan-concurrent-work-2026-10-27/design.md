# Design - 0000201-plan-concurrent-work

## Feature
- Problem: the execution plan does not say which work units run at once, so the orchestrator picks batches one phase at a time and often works in sequence.
- Adoption mode: standard-iterative
- Feature ID: 0000201-plan-concurrent-work
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I see a concurrency plan in every execution plan, and in any re-plan after a reopened phase, so that I know which work runs at once before the work starts.
  - US-002: As the human on the loop, I get concurrent dispatch for any two units with no dependency and no shared write target, and a stated reason for each unit that runs in sequence, so that sequence is a decision and not a habit.
  - US-003: As the human on the loop, I get a consistency check that fails an execution plan with no concurrency section or with an unjustified sequential unit, so that no plan reaches the gate without batches.
- Acceptance criteria confirmed: 3
- Constraints: Node built-ins only. No schema change. No new dependency.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the check reads files under `plan/current/` and prints finding text. It echoes unit names through the existing 200-character cap.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the `## Concurrency plan` section in the execution plan template and guide, the plan skill rule, the mid-pipeline re-plan pointer, the dispatch standard rule, the implement skill batch rule, consistency check 8, the `component.yml` line, the docs that list the checks, and tests.
- Out: a blocking hook on dispatch, changes to `fast` batches or `plan/.run-speed`, and phases other than P1 and P2.
- Deferred: nothing deferred.

## Assumptions
- The plan skill is the only writer of `execution-plan.md` - impact if wrong: a plan written elsewhere skips the section and the check fails it, which is the wanted outcome.
- Existing consistency tests build fixtures without `execution-plan.md` - impact if wrong: check 8 breaks them. The check skips a missing file, so they pass.

## Risks
- Check 8 flags valid plans because the table format is strict. Likelihood medium, impact low. The template shows the exact columns and the guide gives a worked example.
- The plan lists batches the implement phase ignores. Likelihood medium, impact medium. The implement skill and the dispatch standard both name the plan as the source and require a recorded reason for a departure.
- Archived plans lack the section. Likelihood high, impact low. The check reads `plan/current/` only.

## Dependencies
- Upstream: none
- Downstream: step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - concurrency section in template, guide, plan skill | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - default and reason rule in dispatch standard and implement skill | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - consistency check 8 | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 09:45 AM UTC
