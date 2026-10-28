# Design - 0000239-test-suite-reliability

## Feature
- Problem: a call to an undefined `assert_*` function lets a suite pass, and the installed-copies check fails in every initiative step.
- Adoption mode: standard-iterative
- Feature ID: 0000239-test-suite-reliability
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see a suite fail when it calls an undefined `assert_*` function, so that a negative check never runs as no check
  - US-002: As a step session, I see no failure from a stale installed copy, so that acceptance evidence stays free of repeated notes
- Acceptance criteria confirmed: 5
- Constraints: no new dependency. Bash 3.2 (macOS) compatible helpers.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. Test helpers only read local files.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: none

## Engineering Layer
- Stack: bash tests, markdown. Build target: local
- Components: `ravintio-zero` (pack)
- Data ownership: none
- Deployment: none
- API versioning: not applicable

## Scope
- In: `assert_not_contains`, undefined-assert failure, stale-install skip helper, req-014 section (c), docs
- Out: setup changes, other suites
- Deferred: none

## Assumptions
- `command_not_found_handle` runs in a forked child, so a counter there is lost. The handler records failures in a temp file that `print_summary` reads - impact if wrong: undefined calls pass again. A test covers it.

## Risks
- A suite that sets its own `command_not_found_handle` loses the guard - likelihood low, impact low.
- The skip hides a real stale install during an initiative - likelihood low, impact low. `ravintio-refresh-setup` runs in the last step.

## Dependencies
- Upstream: none
- Downstream: every Bash suite sources `helpers/assert.sh`
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - undefined assert fails, `assert_not_contains` | ravintio-implement | One TDD cycle on one helper |
| REQ-002 - stale-install skip | ravintio-implement | One helper and one test edit |

## Repo Instructions
custom-001 to custom-006 in `ravintio-overrides/instructions/`: local git only, prefer subagent decomposition, GUTD shorthand, ship pushes and raises the PR, delete redundant branches, standing setup refresh approval.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 12:00 PM GMT

Version: 0.30.2 (patch from 0.30.1, per the initiative row)
Run mode: autonomous
