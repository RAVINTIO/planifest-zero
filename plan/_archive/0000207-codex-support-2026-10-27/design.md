# Design - 0000207-codex-support

## Feature
- Problem: RAVINTIO Zero installs for Claude Code only, so a team that uses Codex can't install the pipeline.
- Adoption mode: standard-iterative
- Feature ID: 0000207-codex-support
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a developer who uses Codex, I run `setup.sh codex` or `setup.ps1 codex`, so that the pack installs for my harness.
  - US-002: As a developer who uses Codex, I get an `AGENTS.md` boot file and skills in `.agents/skills`, so that Codex loads the pipeline rules and skills.
  - US-003: As a developer who uses Codex, I see which enforcement hooks are active and which fall back to instructions, so that I know what the harness enforces.
  - US-004: As a pack maintainer, I run a CI test that installs for `codex` and checks the files, so that a change cannot break the target.
- Acceptance criteria confirmed: 4
- Constraints: Bash, PowerShell, Node.js, and Markdown only. No schema change. No new dependency. The Claude Code install stays unchanged.
- Integrations: the Codex harness conventions, taken from its official docs on 2026-10-27: `AGENTS.md`, `.agents/skills`, and `.codex/hooks.json`.

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: setup writes only inside the project. The hook command runs a pack script. No credential is read or written.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, Node.js, Markdown / no database / no IaC / GitHub Actions CI / Build target: local
- Components: `ravintio-zero` (component-pack): skills, templates, standards, scripts, setup, and tests
- Data ownership: `ravintio-zero` owns every file
- Deployment: copied into consumer repos by setup
- API versioning: not applicable

## Scope
- In: the `codex` tool target in `setup.sh`, `setup.ps1`, and the refresh-setup skill, a Codex boot template, skills in `.agents/skills`, the `merge-guard` hook in `.codex/hooks.json`, a setup report of active and fallback hooks, tests, a CI step, and living docs.
- Out: other harnesses, hooks whose Codex input contract the docs don't state, and changes to the Claude Code install.
- Deferred: wiring `gate-write`, `ratchet-check`, `em-dash-guard`, and the prompt and stop hooks for Codex. The Codex docs don't state the `apply_patch` input shape or the prompt context format. Those hooks stay instructions in `AGENTS.md` until a later feature confirms them.

## Assumptions
- `.codex/hooks.json` follows the shape in the Codex docs: `hooks`, then the event, then matcher groups with `type` and `command` handlers - impact if wrong: Codex ignores the file, and `AGENTS.md` still states the rule.
- A hook that exits 2 with its reason on stderr blocks a `Bash` call in Codex - impact if wrong: `merge-guard` does not block, and the merge rule stays in `AGENTS.md`.
- Hook commands may run from a directory other than the repo root - impact if wrong: none, the command finds the root with `git rev-parse`.

## Risks
- The Codex hook contract changes. Likelihood medium, impact low. `AGENTS.md` repeats every rule that a hook enforces.
- A user doesn't trust the project hooks in Codex, so no hook runs. Likelihood medium, impact medium. Setup prints the `/hooks` review step.
- The shared setup scripts regress the Claude Code install. Likelihood low, impact high. Existing setup tests run unchanged in CI.

## Dependencies
- Upstream: step 11 chart-time decisions.
- Downstream: step 13 refreshes the setup record and reinstalls skills.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - codex tool target | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-002 - boot file and skills | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-003 - hook mapping and report | ravintio-implement | TDD loop with tests and docs landing together |
| REQ-004 - codex CI check | ravintio-implement | TDD loop with tests and docs landing together |

## Repo Instructions
Five files in `ravintio-overrides/instructions/` (`custom-001` to `custom-005`) apply: local git only, subagent decomposition, GUTD shorthand, push and raise PR in ship, delete redundant local branches.

## Confirmation
Human confirmed this design before proceeding: no // draft-accepted (initiative). Date and Time confirmed: 27 Oct 2026 @ 12:50 p.m. UTC
