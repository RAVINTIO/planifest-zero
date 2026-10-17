# Design - 0000038-setup-hook-filter-fixes

## Feature
- Problem: Rerunning setup can delete a user's own hook command, and the two setup scripts remove different `UserPromptSubmit` entries.
- Adoption mode: standard-iterative (assumed, the only signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000038-setup-hook-filter-fixes
- Version: 0.5.1 (patch: a bug fix with no change to the installed hook set)
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001 (0000112): As a user with my own hook in a shared entry, I rerun setup, so that my command survives and only the Planifest commands change.
  - US-002 (0000111): As a user on any platform, I run either setup script, so that both remove the same entries from my `settings.json`.
- Acceptance criteria confirmed: 5 (see `feature-brief.md`)
- Constraints:
  - Settings writes stay atomic (0000034 ADR-002).
  - The case-sensitive, path-boundary module match stays (0000035 S-004).
  - Both scripts stay at parity (0000035 ADR-001).
- Integrations: none

## Architecture Layer
- Latency target: not applicable (a local setup script)
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. Setup edits only the consumer's own `settings.json`. Its contents are never logged. The change narrows what setup deletes.
- Data privacy: no regulated data
- Observability: standard defaults. Setup prints its existing status lines.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell (5.1 and 7), inline Node JavaScript / GitHub Actions / Build target: local
- Components: `planifest-zero`, the framework. `setup.sh` and `setup.ps1` change, with their tests.
- Data ownership: none. The consumer owns `.claude/settings.json`.
- Deployment: ships as framework files. Consumers rerun setup.
- API versioning: not applicable

### Filter rule (both scripts, both events)
1. For each entry, remove each command that runs a Planifest module of that event at a path boundary.
2. If the entry had commands and none remain, drop the entry.
3. Otherwise keep the entry with its remaining commands, in their order.
4. Append the fresh Planifest entries, as today.

`PreToolUse` modules: `gate-write`, `ratchet-check`, and `em-dash-guard`. `UserPromptSubmit` modules: `auto-trigger-orchestrator`, `check-orchestrator-presence`, and `check-design`.

## Scope
- In:
  - Per-command filtering of `PreToolUse` and `UserPromptSubmit` in both scripts.
  - The path-boundary rule for `UserPromptSubmit` in `setup.sh`.
  - Planted-entry cases in `.sh` and `.ps1` suites.
- Out:
  - The telemetry cleanup, which already filters per command.
  - Other hook events.
- Deferred:
  - A user script with a Planifest basename in another folder, such as `/home/u/tools/gate-write.mjs`. Setup still removes it. Nothing is blocked.

## Assumptions
- No user relies on setup removing their non-Planifest commands. Impact if wrong: a stale user command stays, and the user removes it by hand.

## Risks
- R-001 (technical, likelihood medium, impact medium): Windows PowerShell 5.1 unwraps a one-item array when it rebuilds `entry.hooks`. Mitigation: build the array with `@()` and test on 5.1 in CI.
- R-002 (technical, likelihood low, impact medium): rerun idempotence breaks, so a Planifest entry appears twice. Mitigation: a run-twice case in both suites.
- R-003 (operational, likelihood medium, impact low): `pwsh` isn't installed locally, so only CI proves the `.ps1` suite. Mitigation: open a draft PR early so CI runs during P3.

## Dependencies
- Upstream: none
- Downstream: every consumer that reruns setup

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| req-001 - per-command-filter | planifest-implement | TDD change to both setup scripts, with test-writer and implementer subagents |
| req-002 - userpromptsubmit-parity | planifest-implement | TDD change to `setup.sh`, with a planted-entry parity case |

## Repo Instructions
- custom-001: fetch, pull, push, and `gh pr create` without asking. Never commit to `main` and never merge.
- custom-002: prefer parallel subagents for independent work, or state why not.
- custom-003: `GUTD` means check out `main`, pull, and list untracked files.
- custom-004: in the ship phase, push the branch and tag and raise the PR. Never merge.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 17 Oct 2026 @ 10:05 p.m. UTC
