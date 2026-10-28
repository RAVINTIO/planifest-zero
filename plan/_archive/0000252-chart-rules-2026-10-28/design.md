# Design - 0000252-chart-rules

## Feature
- Problem: chart has no rule that checks an entry for a guard widening, lists the confirmations a step's skills ask for, or records whether a step may skip P1. Each gap let a step or a draft decide alone in initiative 0000195.
- Adoption mode: standard-iterative
- Feature ID: 0000252-chart-rules
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I see chart name the guard and the new forms when an entry widens what a fail-closed hook lets through, and ask me to approve each widening on its own, so that no chart weakens a guard unseen.
  - US-002: As a maintainer, I see chart list each confirmation that a step's skills ask for and record a pre-approval with the exact command or plan a human stop, so that no step session waits for an answer that nobody gives.
  - US-003: As a maintainer, I see chart record a `yes` or `no` and a reason for P1 per step, and a step with no `yes` row stop when it would skip P1, so that no step skips a phase alone.
- Acceptance criteria confirmed: 9
- Constraints: no change to any hook. No new library or service. The `## Steps` table keeps its columns, because the driver parses it.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: no auth. No data classification change. The widening rule makes chart stricter, and no hook changes.
- Data privacy: no regulated data
- Observability: the P1 skip stop is one `I-C Run: Blocked` line, and the build log quotes the chart row
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown pack files and Bash tests, local build target
- Components: `ravintio-zero` (existing): roadmap standards, initiative template, initiative skill, orchestrator session commands reference, tests
- Data ownership: the component owns the pack files
- Deployment: files in the pack, installed by setup
- API versioning: not applicable
- Decision: the P1 skip record is a new `## P1 skips` section in the initiative template, not a new `## Steps` column. The driver counts rows in `## Steps`, so a new column risks the parser, and a separate section leaves it alone.
- Decision: the stop rule lives in I-C Run of the roadmap standards and in the Phase Skip Protocol reference. The orchestrator `SKILL.md` has 902 bytes of headroom and needs no edit.
- Decision: a step confirmation is a row in `## Decisions` whose Fork column starts with `Confirmation:` and names the skill and its step. This keeps one table and needs no parser change.

## Scope
- In: the three chart rules, the template changes, the stop rule, the build log rule, tests, docs, version.
- Out: any hook change. Any driver or watcher change. A new `## Steps` column. A change to the active initiative's own file.
- Deferred: nothing deferred

## Assumptions
- The driver reads only the `## Steps` table of `initiative.md` - impact if wrong: a new section breaks the step count, and the driver test fails.

## Risks
- The skill text passes 1,720 lines - likelihood low, impact medium. The pack holds 1,540 lines and the additions run to about 10.
- An initiative charted before this release has no `## P1 skips` section - likelihood certain, impact low. A missing table counts as an empty one, so a step that skips P1 stops.
- The guard wording reads as a hook change - likelihood low, impact medium. A test checks that no file under `ravintio-zero/hooks/` changes.

## Dependencies
- Upstream: none
- Downstream: none
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - Guard-widening chart rule | ravintio-implement | Edits two Markdown files and adds a Bash test |
| REQ-002 - Step confirmation chart rule | ravintio-implement | Edits one standard and one template and adds a Bash test |
| REQ-003 - P1 skip record and stop | ravintio-implement | Edits the template, the standard, and one reference and adds a Bash test |

## Repo Instructions
Four files in `ravintio-overrides/instructions/` apply: `custom-001-local-git-only`, `custom-002-prefer-subagent-decomposition`, `custom-004-ship-push-and-raise-pr`, `custom-006-standing-setup-refresh-approval`. Each is read from that folder.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 10:17 PM UTC
