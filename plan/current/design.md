# Design - 0000241-watcher-false-events

## Feature
- Problem: The initiative watcher reports false stale warnings, old commits as new, and a wrong lock state, so the human can't tell progress from noise.
- Adoption mode: standard-iterative (only signal: `plan/_archive/` holds prior runs)
- Feature ID: 0000241-watcher-false-events
- Version: 0.31.1 (patch bump from 0.31.0, per the step row)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As an initiative owner, I want a stale line only when a commit is at least 15 minutes newer than the log, so that a fresh commit is not flagged
  - US-002: As an initiative owner, I want each stale state reported once, so that the warning does not repeat
  - US-003: As an initiative owner, I want a branch switch reported in one line, so that old commits do not show as new
  - US-004: As an initiative owner, I want the heartbeat to show the real lock state, so that it matches the driver
- Acceptance criteria confirmed: 4
- Constraints: no new dependency, no hook change, watcher writes no file
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: local script only. It runs fixed git argument arrays and refuses symlinks. Data classification: none held.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node ESM script, Bash tests, GitHub Actions, Build target: local
- Components: `ravintio-zero` - pack scripts, skills, standards, tests
- Data ownership: watcher state (in memory) -> `ravintio-zero`
- Deployment: none
- API versioning: not applicable
- Design decisions:
  - D-1: Stale needs `commit time - log mtime >= STALE_MS`. This replaces `commit time > log mtime`.
  - D-2: The watcher keeps a stale key (`{mtime}:{head sha}`). It prints a stale line only when the key differs from the last printed one.
  - D-3: The watcher decides new commits with `git merge-base --is-ancestor {last-seen} HEAD`. If true, it lists `git log {last-seen}..HEAD`. If false or the commit is unknown, it prints `I-C Run: event: branch changed to {branch}` once and records `HEAD`.
  - D-4: `--passes <n>` is a test aid. With `--once` it runs n passes in one process, then exits 0.
  - D-5: The lock state comes from the lock file on each pass. The heartbeat uses that value.

## Scope
- In: stale threshold, stale once, branch change line, lock state test, `--passes` aid, tests, watcher header, roadmap standards text
- Out: driver, skill, and hook changes, new event kinds
- Deferred: nothing

## Assumptions
- The heartbeat already reads the lock file on each pass - impact if wrong: the lock test fails and the fix goes in this step

## Risks
- A branch-change line hides a real run of new commits: likelihood low, impact low. The next pass lists commits again from the new `HEAD`.
- `git merge-base` is a new git call: likelihood low, impact low. It uses an argument array, as every git call does.

## Dependencies
- Upstream: step 2 (activity reader) edited the same file
- Downstream: step 12 and step 13 change the driver and the watcher
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - stale threshold | ravintio-implement | Small change with a test |
| REQ-002 - stale once | ravintio-implement | State change with a test |
| REQ-003 - branch change | ravintio-implement | Git call with a test |
| REQ-004 - lock state | ravintio-implement | Test of existing behaviour |

## Repo Instructions
custom-001 to custom-006 under `ravintio-overrides/instructions/`: work on a feat/ branch, commit granularly, delegate parallel work to subagents, push and raise the PR at ship, never merge to main, setup refresh approval for the exact command only.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 07:12 a.m. GMT
