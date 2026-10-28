# Design - 0000243-session-start-detection

## Feature
- Problem: The orchestrator carries out 12 Resume Detection checks by hand from a 4,324-byte section of `SKILL.md`. No test covers the agent's reading, and the section blocks the size cut in step 6.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000243-session-start-detection
- Version: 0.32.0 (minor bump from 0.31.2, per the step row)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I want a script that prints one fixed line per resume signal, so that tests cover what the agent reads
  - US-002: As an agent starting a session, I want the findings in context before any skill loads, so that I act on a tested list
  - US-003: As a pack maintainer, I want Resume Detection in `SKILL.md` cut to a short rule that points at a reference file, so that the skill has room to shrink
  - US-004: As a person running an initiative, I want the initiative skill to use the same findings, so that driver lock and position checks are tested too
- Acceptance criteria confirmed: 6
- Constraints: no new dependency, no weakening of any hook, fixed text only in hook output
- Integrations: none

## Architecture Layer
- Latency target: the script finishes within 2 seconds, and the hook stops it at that timeout
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the script reads repo files and writes nothing. It prints fixed messages, strictly patterned ids, and repo-relative paths. Data classification: none held.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM, Bash tests, GitHub Actions, Build target: local
- Components: `ravintio-zero` - pack scripts, hooks, skills, standards, tests
- Data ownership: resume signal script and reference -> `ravintio-zero`
- Deployment: none
- API versioning: not applicable
- Design decisions:
  - D-1: `ravintio-zero/scripts/resume-detect.mjs` takes the project directory as its first argument and prints one line per finding in the order of the 12 checks. With no finding it prints `no resume signals`.
  - D-2: The script never prints file text. An id that fails its pattern prints `unreadable`.
  - D-3: `auto-trigger-orchestrator.mjs` runs the script with a 2 second timeout on the prompt where it injects the load instruction. A non-zero exit or timeout injects `resume detection did not run`.
  - D-4: The hook keeps its current rule. It emits the findings only with the load instruction.
  - D-5: `references/orchestrator-resume-detection.md` holds the 12 checks, one section each. `SKILL.md` Resume Detection becomes a rule of 400 bytes or fewer.
  - D-6: The initiative skill reads the same lines. Initiative-only findings (driver lock, position) print when an initiative is active.

## Scope
- In: the script, the hook change, the reference file, the short rule, the initiative skill change, tests
- Out: splitting the rest of `SKILL.md` (step 6), any change to `merge-guard`, `gate-write`, or another fail-closed hook, the strict-mode hook beyond keeping its initiative rule in step
- Deferred: nothing

## Assumptions
- The 12 checks stay the source of the order - impact if wrong: the order test fails and shows it

## Risks
- The hook fails closed on a script fault: likelihood low, impact medium. The fixed `resume detection did not run` line makes the skill run every check.
- The skill line cap (35 lines of headroom) is tight: likelihood medium, impact low. The new rule is shorter than the section it replaces, and the reference file is not a skill.

## Dependencies
- Upstream: step 4 merged
- Downstream: step 6 needs the space this frees
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Script and fixtures | ravintio-implement | TDD loop, one test per signal |
| Hook change | ravintio-implement | Test with a stubbed failing script |
| Reference and short rule | ravintio-implement | Text and size tests |

## Repo Instructions
custom-001 to custom-006 under `ravintio-overrides/instructions/`: work on a feat/ branch, commit granularly, delegate parallel work to subagents, push and raise the PR at ship, never merge to main, setup refresh approval for the exact command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 13:50 GMT
