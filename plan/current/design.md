# Design - 0000034-setup-hardening

## Feature
- Problem: A refresh of any install made before 0000033 fails, because `planifest-zero` setup exits 1 on retired flags. Setup can also leave `.claude/settings.json` truncated if a write stops partway.
- Adoption mode: standard-iterative
- Feature ID: 0000034-setup-hardening
- Version: 0.4.1
- Discovery: see `plan/current/discovery.md` (raw P0 findings; do not embed them here; this document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a user refreshing an install made before 0000033, I run setup with my recorded flags, so that setup warns about each retired flag, skips it, and completes.
  - US-002: As a maintainer, I pass a tool name to `setup.sh`, so that only an exact match to a valid tool runs, the same as `setup.ps1`.
  - US-003: As a user, I run setup, so that an interrupted write never leaves `.claude/settings.json` truncated.
  - US-004: As a user without `node` on the `PATH`, I run `setup.sh`, so that it tells me it skipped the settings cleanup.
  - US-005: As a maintainer, I start a pipeline run, so that P0 raises no false stale-marker flag from the root `.feature-id`.
  - US-006: As a human filing a backlog idea, I set the deferral source to `human request`, so that the entry matches the template.
- Acceptance criteria confirmed: 3 in the brief, refined per story at P1
- Constraints:
  - `planifest-framework/` is out of scope (0000033 ADR-001).
  - 0000030 ADR-001 rejected silent no-ops. Retired flags become loud no-ops, which needs a superseding ADR at P2.
  - No `pwsh` on the dev machine or in CI.
- Integrations: `planifest-refresh-setup` replays recorded flags into setup. The skill stays unchanged.

## Architecture Layer
- Latency target: not applicable (one-off CLI run)
- Availability target: not applicable
- Scalability target: not applicable
- Compatibility: a run with only current flags writes byte-identical `settings.json` to 0.4.0
- Robustness: 0 truncated `settings.json` files when a write fails
- Security: no auth. Retired flag values, including the `--backend-url` URL, are never run, echoed into a command, or written to disk. Data classification: local project config, not sensitive.
- Data privacy: no regulated data
- Observability: standard defaults (setup's console output)
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+ for inline JSON edits. Tests: Bash suites through `planifest-zero/tests/run-tests.sh`. CI: GitHub Actions. Build target: local.
- Components: `planifest-zero` (existing component-pack), the Planifest product.
- Data ownership: `planifest-zero` writes the target project's `.claude/settings.json` and flags marker, as today. No new data.
- Deployment: not applicable. Users copy or clone `planifest-zero/` and run setup.
- API versioning: not applicable. The CLI flag contract widens: retired flags warn and continue.

## Retired flags (confirmed)

| Flag | Removed by | Handling |
|------|-----------|----------|
| `--structured-telemetry-mcp` | 0000033 | Warn once, skip |
| `--backend-url <url>` | 0000033 | Warn once, skip it, and skip the next argument if it doesn't start with `--`. With no value, warn and exit 0 |
| `--context-mode-mcp` | 0000030 | Warn once, skip |
| `--include-full-skill-library` | 0000030 | Warn once, skip |

Any other unknown flag still prints `Unknown flag` and exits 1.

## Atomic settings writes (confirmed)

- Every `settings.json` write in `setup.sh` and `setup.ps1` writes `settings.json.planifest-tmp` in the same folder, then renames it over `settings.json`.
- Each run overwrites any leftover temporary file. A failed write removes it and leaves the original intact.
- Each write keeps its current failure behaviour, whether that is a warning or a stop.
- The boot file and flags marker stay non-atomic. A rerun rewrites them whole.

## Scope
- In:
  - Retired flags warn and continue in both setup scripts.
  - `setup.sh` validates the tool name by exact match.
  - Atomic `settings.json` writes in both setup scripts.
  - `setup.sh` warns when `node` is missing and `settings.json` exists, so the cleanup is skipped.
  - Delete the root `.feature-id`.
  - Add `human request` as a fourth deferral source in `planifest-zero/templates/backlog-entry.template.md`.
- Out:
  - `planifest-framework/`.
  - Changes to `planifest-refresh-setup`.
  - Atomic writes for files other than `settings.json`.
  - PowerShell parity gaps in 0000090 and 0000094.
- Deferred:
  - A `pwsh` test runner. Until it exists, PowerShell changes get static checks only.

## Assumptions
- Old markers list retired flags as plain strings, with `backendUrl` in its own field - impact if wrong: a flag form setup doesn't recognise still exits 1.
- A rename within one folder is atomic on supported file systems - impact if wrong: a stop during the rename could still lose the file.
- `setup.sh` already rewrites the marker with current flags only - impact if wrong: every later refresh warns again.

## Risks
- R-001: PowerShell changes ship without running tests. Likelihood: medium. Impact: medium. Mitigation: static checks in the suites, as in 0000033.
- R-002: Accepting retired flags hides a typo near a retired name. Likelihood: low. Impact: low. Mitigation: only exact names match, and each prints a warning.
- R-003: Atomic writes change `settings.json` bytes, for example the trailing newline. Likelihood: low. Impact: medium. Mitigation: a byte-identical comparison against 0.4.0 output.

## Dependencies
- Upstream: none
- Downstream: `planifest-refresh-setup` (replays flags), and backlog 0000097 (needs 0000092 fixed first)

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - retired-flags | planifest-codegen-agent | Arg parsing changes in both setup scripts, TDD with a suite |
| REQ-002 - exact-tool-name | planifest-codegen-agent | One check in `setup.sh`, TDD with a suite |
| REQ-003 - atomic-settings-writes | planifest-codegen-agent | Write sites in both scripts, TDD with a forced-failure suite |
| REQ-004 - missing-node-warning | planifest-codegen-agent | One warning in `setup.sh`, TDD with a suite |
| REQ-005 - stray-feature-id | planifest-codegen-agent | File deletion plus a suite assertion |
| REQ-006 - human-request-source | planifest-codegen-agent | Template edit plus a suite assertion |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking, on a feat/ branch. Never commit to `main` or merge PRs. Commit granularly.
- `custom-002-prefer-subagent-decomposition.md`: split long or independent work into parallel subagents, or state why not.
- `custom-003-git-up-to-date-shorthand.md`: `GUTD` means check out `main`, pull, and report untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at P9, push and raise the PR without asking. Never merge. The human merges to `main`.

## Confirmation
Human confirmed this design before proceeding: no // Date and Time confirmed: pending
