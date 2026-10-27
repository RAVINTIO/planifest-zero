# Design - 0000196-setup-argument-checks

## Feature
- Problem: `setup.sh` and `setup.ps1` change the repo before they reject an unknown tool, and they accept retired flags with a warning.
- Adoption mode: standard-iterative
- Feature ID: 0000196-setup-argument-checks
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I run setup with a missing or unknown tool and the run exits 1 with no change to the repo, so that a rejected run never enables hooks or adds workflow files.
  - US-002: As a maintainer, I run setup with a retired flag and the run exits 1 with an error that names the flag, so that I remove a flag that does nothing.
  - US-003: As a maintainer, I refresh setup from a record that holds a retired flag and the refresh names that flag, so that I know why setup refused.
- Acceptance criteria confirmed: 6
- Constraints: reverses 0000034 ADR-001 (warn on retired flags). No schema change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. A `--backend-url` value never appears in output.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash and PowerShell / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): setup scripts, skills, hooks, standards, tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: tool check moves ahead of any repo change in both shells. Retired flags exit 1 during parsing. Six existing tests change. New per-shell tests cover the unknown tool and each retired flag. The refresh skill names a retired flag. Docs that describe the warning change.
- Out: new valid tools (0000175). Changes to usage text or the tool-check exit code. Unknown-flag handling.
- Deferred: nothing deferred.

## Assumptions
- Backlog line numbers are approximate - impact if wrong: P2 locates each block by name instead.
- A tool name that starts with `--` fails parsing as an unknown flag - impact if wrong: the tool check still rejects it.

## Risks
- A refresh command or CI job that still passes a retired flag now fails. Likelihood medium, impact low. The error names the flag and tells the user to remove it.
- PowerShell and Bash drift in error text. Likelihood low, impact low. Parity assertions in both suites.

## Dependencies
- Upstream: none
- Downstream: initiative step 2 onward edits other files and does not depend on this change.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - tool check first | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - retired flags fail | ravintio-implement | Same loop, changes six existing tests |
| REQ-003 - refresh names retired flag | ravintio-implement | Skill text change with a test |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 07:10 AM UTC
