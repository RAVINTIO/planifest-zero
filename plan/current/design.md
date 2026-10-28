# Design - 0000242-size-cap-excludes-overrides

## Feature
- Problem: The size cap test counts the override block in the repo `CLAUDE.md`, so adding an override can fail a pack test.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000242-size-cap-excludes-overrides
- Version: 0.31.2 (patch bump from 0.31.1, per the step row)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a pack maintainer, I want the size cap to measure the boot file without the override block, so that adding an override never changes the result
  - US-002: As a pack maintainer, I want the cap set to the pack-only figure, so that a pack change that grows the boot file or `SKILL.md` still fails the test
- Acceptance criteria confirmed: 3
- Constraints: no new dependency, no hook change, no change to `setup.sh` or `setup.ps1`
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: test script only. It reads repo files and a temp copy. Data classification: none held.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash tests, GitHub Actions, Build target: local
- Components: `ravintio-zero` - pack scripts, skills, standards, tests
- Data ownership: size cap test -> `ravintio-zero`
- Deployment: none
- API versioning: not applicable
- Design decisions:
  - D-1: The test measures the repo `CLAUDE.md` with the lines from the `ravintio-overrides:instructions:start` marker to the `end` marker removed. It does not read `standard-boot.md`, so the test still checks the generated file.
  - D-2: The combined cap becomes 32,800 bytes. The pack-only sum is 32,697 bytes, which leaves 103 bytes of margin.
  - D-3: A helper function `pack_claude_bytes` takes a file path, so the test can measure a temporary copy with an added override block.

## Scope
- In: the strip in the size cap check, the new cap and its comment, two tests (override leaves the measure unchanged, pack growth fails), docs that name the cap
- Out: the `SKILL.md` cap, `setup.sh`, `setup.ps1`, boot templates, the `CLAUDE.md` cap
- Deferred: nothing

## Assumptions
- The repo `CLAUDE.md` outside the markers equals `standard-boot.md` - impact if wrong: the measure differs by a few bytes and the 103 byte margin absorbs it

## Risks
- The margin is too tight for step 5, which adds to `SKILL.md`: likelihood medium, impact low. Step 5 shrinks the Resume Detection section, and the Decisions table stops any step that fails a size cap.
- A marker line moves in a later setup change: likelihood low, impact low. The strip test fails and shows it.

## Dependencies
- Upstream: step 3 merged. Initiative 0000195 step 13 raised the cap this step replaces.
- Downstream: steps 6, 7, and 8 edit the same test file
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - pack-only measure | ravintio-implement | Small test change with a mutation check |
| REQ-002 - pack-only cap | ravintio-implement | Constant change with a test |

## Repo Instructions
custom-001 to custom-006 under `ravintio-overrides/instructions/`: work on a feat/ branch, commit granularly, delegate parallel work to subagents, push and raise the PR at ship, never merge to main, setup refresh approval for the exact command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 07:55 a.m. GMT
