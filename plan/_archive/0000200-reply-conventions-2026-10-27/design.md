# Design - 0000200-reply-conventions

## Feature
- Problem: replies in an active run often lack a phase or stage prefix, and they report routine compliance with standing rules. Only the orchestrator skill defines the prefixes, and the harness truncates it on compaction.
- Adoption mode: standard-iterative
- Feature ID: 0000200-reply-conventions
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the human on the loop, I see a valid phase or stage prefix on every reply in an active run, including after compaction and in a supervising session, so that I know which phase a reply belongs to.
  - US-002: As the human on the loop, I get a warning when a reply in an active run lacks a valid prefix, and the misses are logged, so that I can measure how often the rule fails.
  - US-003: As the human on the loop, I read replies that state results, deviations, failures, and decisions only, so that routine compliance with a standing rule does not hide what needs me.
- Acceptance criteria confirmed: 6
- Constraints: Node built-ins only. The hook warns and never blocks. No schema change.
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: the hook reads the transcript path from the payload and writes only the miss log. It never prints reply text beyond the first line, and it exits 0 on every error.
- Data privacy: no regulated data
- Observability: the miss log holds one line per miss with a timestamp and the first 80 characters of the reply
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js, Bash, and PowerShell / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): setup scripts, skills, hooks, standards, tests, and scripts
- Data ownership: `ravintio-zero` owns every file, including the new hook and its miss log
- Deployment: copied into consumer repos by setup. Setup wires the hook into `.claude/settings.json` under `Stop`.
- API versioning: not applicable

## Scope
- In: the boot-file prefix table and reporting rule, the orchestrator reporting rule, a prefix line in four phase skills, the `check-reply-prefix.mjs` Stop hook, its wiring in both setup scripts, the parity suite, the docs that list hooks, and tests.
- Out: a blocking hook, a hook check of the reporting rule, changes to existing prefixes, and tools other than Claude Code.
- Deferred: nothing deferred.

## Assumptions
- The `Stop` payload carries `transcript_path` to a JSONL transcript, and the last assistant text block is the reply - impact if wrong: the warning never fires, and the hook stays silent.
- The boot file reloads at each session start and after compaction - impact if wrong: the rule drops after compaction, as the backlog entry describes.

## Risks
- The hook warns on a valid reply because the payload shape differs. Likelihood low, impact low. The hook only warns, and the miss log lets the human spot a false rate.
- Setup scripts drift on the new entry. Likelihood medium, impact medium. The parity suite compares both.
- The boot file grows and a later step trims it. Likelihood low, impact low. A test greps the table.

## Dependencies
- Upstream: none
- Downstream: step 13 refreshes the installed skills and hooks.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - prefix table and reporting rule in boot file and orchestrator | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - prefix line in phase skills | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - Stop hook warns and logs | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-004 - setup wiring and parity | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 09:00 AM UTC
