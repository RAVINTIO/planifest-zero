# Design - 0000208-refresh-setup-record

## Feature
- Problem: Installed skills, `CLAUDE.md`, and the setup record lag the pack, and queued backlog entries sit uncommitted.
- Adoption mode: standard-iterative
- Feature ID: 0000208-refresh-setup-record
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As the human on the loop, I want a standing approval for one exact setup command, so that step sessions refresh setup without stopping
  - US-002: As a maintainer, I want the setup record and installed skills refreshed, so that they match the pack
  - US-003: As a maintainer, I want queued backlog entries committed, so that the working tree is clean
- Acceptance criteria confirmed: 4
- Constraints: Run only `ravintio-zero/setup.sh claude-code --strict-orchestrator`. Version bump patch from 0.29.0 to 0.29.1.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth change. Data classification: public repo docs. The override widens no guard.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: markdown and shell. Build target: none
- Components: none touched. Chore on pack config files.
- Data ownership: not applicable
- Deployment: not applicable
- API versioning: not applicable

## Scope
- In: override `custom-006`, setup refresh, commit queued backlog entries, version bump
- Out: backlog entry 0000174, changes to `setup.sh`
- Deferred: nothing deferred

## Assumptions
- `setup.sh` is idempotent - impact if wrong: the refresh changes more files than the record and `CLAUDE.md`

## Risks
- Refresh rewrites hooks in `.claude/` - likelihood low, impact medium. The files are gitignored.

## Dependencies
- Upstream: none
- Downstream: I-E Delivery
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - override file | ravintio-implementer | one file write |
| REQ-002 - setup refresh | ravintio-refresh-setup | standing approval covers the command |
| REQ-003 - queued entries | none | git commits |

## Repo Instructions
`ravintio-overrides/instructions/custom-001` to `custom-005`: local git rules, subagent decomposition, GUTD, ship push and PR, redundant branch deletion.

## Confirmation
Human confirmed this design before proceeding: yes (draft-accepted (initiative)) // Date and Time confirmed: 27 Oct 2026 @ initiative chart approval
