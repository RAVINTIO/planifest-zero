# Design - 0000198-cap-echoed-plan-text

## Feature
- Problem: `ratchet-check.mjs` and `consistency-check.mjs` echo plan lines with no length cap, so a long or hostile line reaches the agent's context unchanged.
- Adoption mode: standard-iterative
- Feature ID: 0000198-cap-echoed-plan-text
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As an agent that a ratchet block stops, I see at most 200 characters of each removed line and a cut marker, so that a long or hostile line never floods my context.
  - US-002: As an agent that runs the consistency check, I see at most 200 characters of a story map row label in a finding and a cut marker, so that a long or hostile label never floods my context.
- Acceptance criteria confirmed: 6
- Constraints: the block set and the finding set stay identical. No schema change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: both programs keep their exit codes. The ratchet fails open on unexpected errors as before. Only echoed text shrinks.
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
- In: the `removed:` lines of the ratchet block message and the story map row label in two consistency findings are cut to 200 characters with a marker. One new test suite covers both programs. Docs that describe the printed text name the cap.
- Out: which writes the ratchet blocks. Which findings the consistency check raises. The 500-character reason cap. Findings that echo names, ids, or counts.
- Deferred: nothing deferred.

## Assumptions
- The cap counts characters of the echoed line and excludes the marker - impact if wrong: a test asserts a slightly different length, and P2 adjusts the test and the docs.
- The installed `.claude/hooks/enforcement/ratchet-check.mjs` matches the pack source and setup refreshes it - impact if wrong: the installed hook stays uncapped until the next setup run.

## Risks
- A cap edit changes the block set or an exit code. Likelihood low, impact medium. The existing suites guard exits and a new test asserts the exit code with a long line.
- A cap that splits a surrogate pair prints a broken character. Likelihood low, impact low. The cut counts code points.

## Dependencies
- Upstream: none
- Downstream: step 13 refreshes the installed hook copies. No other step depends on this change.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - cap the ratchet block message | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - cap the consistency finding | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 07:58 AM UTC
