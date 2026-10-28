# Design - 0000249-check-path-before-missing-claims

## Feature
- Problem: a P3 report can say a program is missing without a `PATH` search, and a claim backed by documentation alone can read as `verified`.
- Adoption mode: standard-iterative
- Feature ID: 0000249-check-path-before-missing-claims
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see the validate-and-accept skill require a `PATH` search with its output before any report says a program is missing, so that a false "missing" claim does not reach the acceptance evidence.
  - US-002: As a maintainer, I see a claim that only documentation backs get the status `unverified (docs only)` and a named line in the report, so that it never reads as `verified`.
- Acceptance criteria confirmed: 3
- Constraints: no change to fail-closed hooks. No new library or service.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. The change adds prose and a Bash test. The evidence rule keeps raw output out of a possibly public PR.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown pack files, Bash tests, local build target
- Components: `ravintio-zero` (existing): validate-and-accept skill, test
- Data ownership: the component owns the pack files
- Deployment: files in the pack, installed by setup
- API versioning: not applicable

## Scope
- In: `PATH` search rule, `unverified (docs only)` status, and acceptance evidence rules in the validate-and-accept skill. One test. Docs and version.
- Out: a script for the search. Changes to fail-closed hooks. Changes to the verification report and acceptance evidence templates.
- Deferred: nothing deferred

## Assumptions
- The three install paths in the entry cover the hosts that run this pack - impact if wrong: a program in another folder reads as missing. The rule says to search common paths, so it names them as examples.

## Risks
- The skill additions push skill text past 1,720 lines - likelihood low, impact medium. The pack holds 1,526 lines and the additions run to 12 or fewer.
- The new status confuses the per-criterion outcomes list - likelihood low, impact low. The skill puts it beside `verified`, `failed`, and `not-verifiable`, and the test checks its wording.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - PATH check and docs-only status | ravintio-implement | Edits one skill and adds a Bash test |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 09:17 PM UTC
