# Design - 0000035-powershell-setup-parity

## Feature
- Problem: A Windows install made with `setup.ps1` lacks two of the six enforcement hooks that `setup.sh` wires. `setup.ps1` also fails on Windows PowerShell 5.1, ignores flag case, and turns a scalar hook value into an array. Both scripts can leave `settings.json.planifest-tmp` behind after a hard stop.
- Adoption mode: standard-iterative
- Feature ID: 0000035-powershell-setup-parity
- Version: 0.4.2
- Discovery: see `plan/current/discovery.md` (raw P0 findings; do not embed them here; this document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a Windows user, I run `setup.ps1`, so that it wires the same six enforcement hooks as `setup.sh`.
  - US-002: As a user with a hand-edited `settings.json`, I run `setup.ps1`, so that the legacy cleanup leaves a non-array hook value as it was.
  - US-003: As a Windows user on the built-in PowerShell 5.1, I run `setup.ps1`, so that it adds `Agent` to `allowedTools` without a PowerShell 7 feature.
  - US-004: As a maintainer, I pass a flag in the wrong case to `setup.ps1`, so that it fails as `setup.sh` does.
  - US-005: As a user, I re-run setup after a hard stop, so that no `settings.json.planifest-tmp` stays behind.
- Acceptance criteria confirmed: 5 in the brief, refined per story at P1
- Constraints:
  - `planifest-framework/` is out of scope (0000033 ADR-001).
  - No `pwsh` on the dev machine or in CI, so PowerShell checks stay static.
  - This branch stacks on PR #7. Merge PR #7 first.
- Integrations: none new.

## Architecture Layer
- Latency target: not applicable (one-off CLI run)
- Availability target: not applicable
- Scalability target: not applicable
- Compatibility: a `setup.sh` run writes byte-identical `settings.json` to 0.4.1. A `setup.ps1` run writes the same hook entries as `setup.sh`, in the same order.
- Robustness: 0 leftover `settings.json.planifest-tmp` files after a completed run
- Security: no auth. Data classification: local project config, not sensitive.
- Data privacy: no regulated data
- Observability: standard defaults (setup's console output)
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+ for inline JSON edits. Tests: Bash suites through `planifest-zero/tests/run-tests.sh`. CI: GitHub Actions. Build target: local.
- Components: `planifest-zero` (existing component-pack), the Planifest product.
- Data ownership: `planifest-zero` writes the target project's `.claude/settings.json`, as today. No new data.
- Deployment: not applicable.
- API versioning: not applicable. `setup.ps1` flags become case-sensitive, which matches `setup.sh`.

## Hook entries (confirmed)

`setup.ps1` writes the same shape as `setup.sh`:

| Event | Matcher | Command |
|-------|---------|---------|
| `PreToolUse` | `Write`, then `Edit` | `gate-write.mjs` |
| `PreToolUse` | `Write`, then `Edit` | `ratchet-check.mjs` |
| `PreToolUse` | `Write`, then `Edit` | `em-dash-guard.mjs` |
| `UserPromptSubmit` | `.*` | `auto-trigger-orchestrator.mjs`, then `check-orchestrator-presence.mjs`, then `check-design.mjs` |

A re-run removes any earlier entry that names one of these modules, including the old single `Write|Edit` entry, before it adds the fresh ones.

## PowerShell 5.1 (confirmed)

`setup.ps1` supports Windows PowerShell 5.1 and PowerShell 7. `Merge-AllowedTools` reads `settings.json` with plain `ConvertFrom-Json` and edits the object, so it needs no `-AsHashtable`.

## Scope
- In:
  - `setup.ps1` wires `ratchet-check` and `em-dash-guard`, in the `setup.sh` entry shape.
  - A static parity suite that compares the hook modules each script wires.
  - `Remove-LegacyTelemetryWiring` skips a non-array event value.
  - `Merge-AllowedTools` drops `-AsHashtable`.
  - The `setup.ps1` flag `switch` becomes case-sensitive.
  - Both scripts remove a leftover `.claude/settings.json.planifest-tmp` at the start of each run.
- Out:
  - `planifest-framework/`.
  - A `pwsh` test runner (backlog 0000084).
  - Non-array guards in `Merge-EnforcementHookSettings` for events other than the two it writes.
  - The `setup.sh` filter, which still keeps a `Write|Edit` entry that an older `setup.ps1` wrote.
- Deferred:
  - Runtime tests of `setup.ps1`. Until a `pwsh` runner exists, every PowerShell change gets static checks only.

## Assumptions
- Windows PowerShell 5.1 parses the rest of `setup.ps1` - impact if wrong: 5.1 users still hit a parse error elsewhere.
- `ConvertFrom-Json` returns a JSON array as `[object[]]` in both PowerShell versions - impact if wrong: the non-array check skips real arrays.
- The leftover path is always `.claude/settings.json.planifest-tmp` in the project - impact if wrong: a leftover beside a symlink target stays.

## Risks
- R-001: PowerShell changes ship without running tests. Likelihood: medium. Impact: medium. Mitigation: static checks, plus a manual Windows check in the PR test plan.
- R-002: Case-sensitive flags break a user who typed `--Strict-Orchestrator`. Likelihood: low. Impact: low. Mitigation: setup prints `Unknown flag` and exits 1, which names the problem.
- R-003: A re-run of `setup.ps1` on a project set up by an older `setup.ps1` duplicates `gate-write`. Likelihood: medium. Impact: medium. Mitigation: the filter matches by command name on any matcher, and a suite checks it.

## Dependencies
- Upstream: PR #7 (0000034), which adds `Write-SettingsAtomic`
- Downstream: backlog 0000097

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - six-hooks-on-windows | planifest-codegen-agent | Hook entries in `setup.ps1`, TDD with a static parity suite |
| REQ-002 - scalar-hook-values | planifest-codegen-agent | One guard in `setup.ps1`, TDD with a static suite |
| REQ-003 - powershell-5-1 | planifest-codegen-agent | One function rewrite, TDD with a static suite |
| REQ-004 - flag-case | planifest-codegen-agent | One keyword, TDD with a static suite |
| REQ-005 - leftover-temp-file | planifest-codegen-agent | One removal in each script, TDD with a runtime bash suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking, on a feat/ branch. Never commit to `main` or merge PRs. Commit granularly.
- `custom-002-prefer-subagent-decomposition.md`: split long or independent work into parallel subagents, or state why not.
- `custom-003-git-up-to-date-shorthand.md`: `GUTD` means check out `main`, pull, and report untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at P9, push and raise the PR without asking. Never merge. The human merges to `main`.

## Confirmation
Human confirmed this design before proceeding: pending
