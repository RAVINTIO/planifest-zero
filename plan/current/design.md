# Design - 0000199-reserve-ids-from-counter

## Feature
- Problem: ids for backlog entries, features, and initiatives come from a folder scan that misses ids on other branches, deleted entries, and copies from other repos, so two sessions can take the same id.
- Adoption mode: standard-iterative
- Feature ID: 0000199-reserve-ids-from-counter
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As an agent that files an entry or starts a feature, I reserve ids from `plan/backlog/.next-id` with one script, so that two sessions never take the same id.
  - US-002: As an agent that copies an entry from another repo, I reserve a new local id and name the source id in the text, so that each repo keeps its own sequence and no id clashes.
- Acceptance criteria confirmed: 8
- Constraints: Node built-ins only. Seven-digit ids. No schema change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the script refuses a symlinked counter and a malformed counter, and it writes only the counter file and its lock. A failure leaves the counter unchanged.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js and Bash / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): setup scripts, skills, hooks, standards, tests, and scripts
- Data ownership: `ravintio-zero` owns every file, including `plan/backlog/.next-id`
- Deployment: copied into consumer repos by setup. The script runs from `ravintio-zero/scripts/`.
- API versioning: not applicable

## Scope
- In: `reserve-id.mjs`, the seeded counter, the six docs that state the scan rule, the copied-entry rule, and one test suite.
- Out: renumbering existing ids, a hook or CI check on hand-written ids, a scan of every git ref, and setup changes.
- Deferred: nothing deferred.

## Assumptions
- A merge conflict on `.next-id` resolves by keeping the higher value and renumbering the later branch. The human pre-approved this in backlog 0000183 - impact if wrong: two entries share an id until someone renumbers one.
- Sessions in one repo share a working tree or commit the counter with each reservation - impact if wrong: peer sessions on separate clones reserve the same ids and git reports a conflict on merge.

## Risks
- A stale lock from a stopped process blocks reservation. Likelihood low, impact low. The script exits non-zero and names the lock path, and the human removes it.
- Two branches reserve the same ids. Likelihood medium, impact low. Git shows a conflict on `.next-id` and the pre-approved answer applies.
- A doc keeps the scan rule. Likelihood low, impact medium. A test greps the six docs.

## Dependencies
- Upstream: none
- Downstream: step 10 (initiative skill) queues entries with ids from this counter. Step 13 refreshes the installed skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - reserve ids with a script | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - call the counter from every id rule | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 08:25 AM UTC
