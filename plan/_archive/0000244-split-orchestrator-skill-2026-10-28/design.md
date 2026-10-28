# Design - 0000244-split-orchestrator-skill

## Feature
- Problem: Every session reads all 23,912 bytes of the orchestrator `SKILL.md`, though 15,849 bytes apply only at one moment in a run.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000244-split-orchestrator-skill
- Version: 0.33.0 (minor bump from 0.32.0, per the step row)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I want the six task-bound sections in reference files, so that a session reads them only when it needs them
  - US-002: As a pack maintainer, I want the I-A to I-E prefix block in `roadmap-standards.md`, so that only initiative work reads it
  - US-003: As an agent, I want one rule for template reads and one row per reference file, so that the index names each trigger
  - US-004: As a pack maintainer, I want the size test and the tests that grep `SKILL.md` to read the new locations, so that the suite passes with a 9,000 byte cap
- Acceptance criteria confirmed: 7
- Constraints: no new dependency, no weakening of any hook, lines move verbatim
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: documentation moves only. No code runs. Data classification: none held.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown, Bash tests, GitHub Actions, Build target: local
- Components: `ravintio-zero` - pack skills, standards, setup, tests
- Data ownership: orchestrator skill and references -> `ravintio-zero`
- Deployment: none
- API versioning: not applicable
- Design decisions:
  - D-1: New reference files: How You Coach goes to `orchestrator-p0-coaching.md`, Discovery Start Actions to `orchestrator-p0-start-actions.md`, Discovery Gate Checklist and Design Confirmation to `orchestrator-p0-gate.md`, Phase Invocation to `orchestrator-phase-invocation.md`, Exception Stops to `orchestrator-exception-stops.md`.
  - D-2: Each moved section keeps its heading and lines verbatim in exactly one reference file.
  - D-3: The initiative stage prefix block moves to `roadmap-standards.md`. `SKILL.md` keeps the prefix table, the status form, and one pointer line.
  - D-4: The Pack Index template rows become one rule: before you write an artifact, read `ravintio-zero/templates/{artifact}.template.md`. Rows that do not follow the pattern stay.
  - D-5: Each new reference file gets a Pack Index row that names its trigger.
  - D-6: The `SKILL.md` cap becomes 9,000 bytes. Tests that grep a moved line read `SKILL.md`, `references/`, and `roadmap-standards.md` together.

## Scope
- In: moves, pointers, index rows, cap and test updates
- Out: the combined cap, `CLAUDE.md` size, any wording change, any fail-closed hook change
- Deferred: nothing

## Assumptions
- Each moved section is read only at its trigger - impact if wrong: a session misses a rule, so the Pack Index triggers name the exact moment

## Risks
- A moved rule goes unread because its trigger is vague: likelihood medium, impact medium. Each row names a concrete moment, and the no-lost-line check proves no loss.
- 39 tests read `SKILL.md` and may fail after the move: likelihood high, impact low. Plan lists them up front.

## Dependencies
- Upstream: step 5 merged
- Downstream: step 7 needs the headroom
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Section moves | ravintio-implement | Text moves checked by the no-lost-line test |
| Test updates | ravintio-implement | One suite at a time |

## Repo Instructions
custom-001 to custom-006 under `ravintio-overrides/instructions/`: work on a feat/ branch, commit granularly, delegate parallel work to subagents, push and raise the PR at ship, never merge to main, setup refresh approval for the exact command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 14:25 GMT
