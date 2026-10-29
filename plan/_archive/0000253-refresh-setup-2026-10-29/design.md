# Design - 0000253-refresh-setup

## Feature
- Problem: the installed skills and boot files lag the pack after steps 1 to 14.
- Adoption mode: standard-iterative
- Feature ID: 0000253-refresh-setup
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I run the approved refresh, so that the install matches the pack.
- Acceptance criteria confirmed: 3
- Constraints: the command must match override `custom-006` exactly.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no credentials. `refresh-delete-boot-files.sh` deletes only `CLAUDE.md` and `AGENTS.md`.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: bash (`setup.sh`), Markdown
- Components: `ravintio-zero` - the component pack
- Data ownership: `ravintio-zero` owns the pack files and the installed copies
- Deployment: local
- API versioning: not applicable

## Scope
- In: run the refresh, verify the skills match and `CLAUDE.md` size, commit the result, bump to 0.40.1.
- Out: any change to skills, hooks, scripts, or tests.
- Deferred: none

## Assumptions
- `plan/state/claude-code.md` is valid - impact if wrong: the command differs and the step stops.

## Risks
- Setup fails after the boot files are deleted - low likelihood, medium impact. The marker file records the pending attempt.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| refresh | ravintio-refresh-setup | The chore is this skill's job |

## Repo Instructions
- custom-001: local git only.
- custom-002: prefer subagent decomposition. This chore has one indivisible task.
- custom-004: ship pushes and raises the PR.
- custom-006: standing approval for `ravintio-zero/setup.sh claude-code --strict-orchestrator`.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 29 Oct 2026 @ 12:08 AM GMT
