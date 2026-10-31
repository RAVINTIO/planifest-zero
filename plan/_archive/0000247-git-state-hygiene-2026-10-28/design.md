# Design - 0000247-git-state-hygiene

## Feature
- Problem: a step or subagent changes git state it does not own. A step stages queued backlog entries, a session leaves an id reservation uncommitted, and a subagent stashes its siblings' work.
- Adoption mode: standard-iterative
- Feature ID: 0000247-git-state-hygiene
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see a step leave queued backlog entries untracked, so that each entry lands in its own commit.
  - US-002: As a maintainer, I find each id reservation in a commit as soon as it is made, so that a session on another branch never reuses the id.
  - US-003: As a maintainer, I see subagents in a parallel batch leave git state alone, so that no subagent loses its siblings' uncommitted work.
- Acceptance criteria confirmed: 5
- Constraints: no change to fail-closed hooks. No new library or service.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. `--commit` runs `git` with fixed arguments and no shell.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node 20 script, Bash tests, Markdown pack files, local build target
- Components: `ravintio-zero` (existing): skills, standards, `reserve-id.mjs`, tests
- Data ownership: the component owns `plan/backlog/.next-id`
- Deployment: files in the pack, installed by setup
- API versioning: not applicable

## Scope
- In: staging rule in the orchestrator and ship skills. `--commit` flag and the commit rule in three skills. `git stash` rule in the dispatch standard and skeleton prompts. Three tests. Docs and version.
- Out: changes to fail-closed hooks. A PowerShell twin of the script.
- Deferred: nothing deferred

## Assumptions
- `git commit -- plan/backlog/.next-id` commits that path alone - impact if wrong: the commit holds extra files. The test checks it.

## Risks
- The skill additions push skill text past 1,720 lines - likelihood low, impact medium. The pack holds 1,509 lines and the additions run to 10 or fewer.
- The orchestrator addition pushes `SKILL.md` past 9,000 bytes - likelihood low, impact medium. It holds 7,985 bytes and the addition runs to about 250.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - stage by path | ravintio-implement | Edits two skills and adds a Bash test |
| REQ-002 - commit id reservations | ravintio-implement | Edits one Node script, three skills, and adds a Bash test |
| REQ-003 - no stash in a batch | ravintio-implement | Edits one standard and adds a Bash test |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 08:24 PM UTC
