# Design - 0000217-verify-codex-setup

## Feature
- Problem: the `codex` setup target has never run against real Codex.
- Adoption mode: standard-iterative
- Feature ID: 0000217-verify-codex-setup
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I run the codex target against real Codex, so that I know it loads the pack and blocks merges
- Acceptance criteria confirmed: 4
- Constraints: Codex calls run locally only, never in CI. A stub `gh` ensures nothing reaches GitHub.
- Integrations: Codex CLI (`/opt/homebrew/bin/codex`)

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Temp repo outside this repo. Stub `gh` on `PATH`. No credential in context.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: model calls on the human's OpenAI account, pre-approved in the initiative Dependencies table

## Engineering Layer
- Stack: bash, node, markdown. Build target: local
- Components: `ravintio-zero` (pack). The `codex` target changes only if a check fails.
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: run both Codex checks, record evidence, fix the target if a check fails
- Out: CI use of Codex, changes when both checks pass
- Deferred: none

## Assumptions
- Codex is installed and signed in - impact if wrong: the checks cannot run and the step stops as Blocked.

## Risks
- Codex does not trust or load the project hooks without human review - likelihood medium, impact high. Fix the target or record the limit.
- Model output varies between runs - likelihood medium, impact low. The check reads the skill names and the stub log.

## Dependencies
- Upstream: 0000207-codex-support
- Downstream: none
- Approved dependencies: Codex CLI (`/opt/homebrew/bin/codex`), service, local only

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - verify-codex-setup | ravintio-implement | One chore, no TDD cycle unless a check fails |

## Repo Instructions
custom-001 to custom-006 in `ravintio-overrides/instructions/`: local git only, prefer subagent decomposition, GUTD shorthand, ship pushes and raises the PR, delete redundant branches, standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 27 Oct 2026 @ 06:36 PM GMT

Version: 0.29.2 (patch from 0.29.1, rises to minor if a check fails)
Run mode: autonomous
