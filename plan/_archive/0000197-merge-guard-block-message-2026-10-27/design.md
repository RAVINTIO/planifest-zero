# Design - 0000197-merge-guard-block-message

## Feature
- Problem: `merge-guard` blocks a command that names a merge in text, but its message gives the wrong reason and no fix.
- Adoption mode: standard-iterative
- Feature ID: 0000197-merge-guard-block-message
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As an agent that writes a file with a heredoc, I get a block message that says the command names a merge in text and tells me to use the Write tool, so that I fix the call at once.
- Acceptance criteria confirmed: 3
- Constraints: the block set stays identical. No schema change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the hook fails closed and keeps every current block. Only message text changes.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): setup scripts, skills, hooks, standards, tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the text-versus-call block message and the over-4096 message gain Write tool advice. Tests that assert the old text change. New tests cover both messages. Docs that describe the block message change.
- Out: which commands block or pass. Skipping heredoc bodies or quoted text. Other hooks.
- Deferred: nothing deferred.

## Assumptions
- Line numbers in the backlog entry are approximate - impact if wrong: P2 locates each block by name.

## Risks
- A reworded message breaks a consumer that matches the old text. Likelihood low, impact low. Tests in this repo assert the old text and change with it.
- The new reason shows for a segment that is a real but malformed merge call. Likelihood medium, impact low. The text says the segment is not a bare `gh pr merge`, so it stays accurate.

## Dependencies
- Upstream: none
- Downstream: later initiative steps edit other files and do not depend on this change.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - name the real block reason | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 07:36 AM UTC
