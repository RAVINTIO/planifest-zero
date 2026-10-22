# Design - 0000041-setup-cleanup-and-park-hardening

## Feature
- Problem: The telemetry cleanup in both setup scripts reads `settings.json` before the shape check, so it misreports or rewrites a file setup rejects. The non-array warning prints hook values, and a failed park commit can leak the entry file.
- Adoption mode: standard-iterative (assumed, only signal: `plan/_archive/` and `docs/about.md` present)
- Feature ID: 0000041-setup-cleanup-and-park-hardening
- Version: 0.8.0 (minor, from 0.7.0, confirmed by the human)
- Run mode: continuous
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a person running `setup.sh`, I see only the shape check line when `settings.json` is not a settings object, so that the output names the real fault once. (0000127)
  - US-002: As a person running `setup.ps1`, I keep my `settings.json` unchanged when it is not a settings object, so that setup never rewrites a file it rejects. (0000128)
  - US-003: As a person running either setup script, I get a warning that names the event and the file but not the old value, so that a secret in a hook command never reaches the terminal or a log. (0000130)
  - US-004: As a human on the loop, I return to a clean feature branch when park's local add or commit fails, so that the parked entry never leaks into the feature branch. (0000129)
- Acceptance criteria confirmed: 5 (see `feature-brief.md`)
- Constraints:
  - 0000040 ADR-002 stands. The shape check line and exit 1 are unchanged.
  - 0000033 ADR-002 stands. The cleanup runs on every setup run and warns on a real failure. A skip on a non-object file is "nothing to clean", not a failure.
  - 0000033 req-004 stands. Setup never prints `settings.json` content or a parser message.
  - Park never merges, never commits to `main`, and never force-pushes.
- Integrations: git CLI (park only)

## Architecture Layer
- Latency target: not applicable (local tooling)
- Availability target: not applicable (local tooling)
- Scalability target: not applicable
- Security: no auth. `settings.json` is user configuration, classified internal. No setup output prints a hook value or file content.
- Data privacy: no regulated data
- Observability: standard defaults. Setup prints one fixed line per fault to stderr.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell 5.1 and 7, Node (inline scripts), JavaScript (`park.mjs`). Tests are shell and node scripts under `planifest-zero/tests/`, run by `run-tests.sh` and `run-tests.ps1`. CI is GitHub Actions. Build target: local.
- Components: `planifest-zero`, the framework pack of skills, hooks, templates, setup scripts, and tests.
- Data ownership:
  - setup owns the hook wiring in `.claude/settings.json`.
  - the orchestrator owns `plan/` working state.
- Deployment: files in the repo, installed into a target project by `setup.sh` or `setup.ps1`.
- API versioning: not applicable

### Telemetry cleanup skip (US-001, US-002)
- Both cleanups apply the 0000040 shape rule before they touch the file. The top level must be a plain object. `hooks` must be absent, `null`, or a plain object.
- If the rule fails, the cleanup prints nothing and writes nothing. The hook install step then prints the shape check line and exits 1.
- `setup.ps1` uses the same test as `Merge-EnforcementHookSettings`: the first non-space character is `{` and the parsed value is a `PSCustomObject`.
- Invalid JSON keeps today's behaviour in both scripts.

### Non-array warning (US-003)
- New text in both scripts: `  ! Warning: hooks.{event} in {file} is not an array. Setup replaced it with the Planifest entries.`
- The old value is no longer printed or saved.

### Park cleanup (US-004)
- In `finishPr`, if `git add` or the chore commit fails, run `git reset -q -- {entry}` and delete the written entry file. Then rethrow, so `onFeatureBranch` returns to the feature branch.
- The cleanup itself never throws over the original error.
- The source of truth is `planifest-zero/skills/`. Setup refreshes the installed copy under `.claude/skills/`.

## Scope
- In:
  - The telemetry cleanup skip in both setup scripts.
  - The non-array warning without the old value, in both setup scripts.
  - The park cleanup on a local add or commit failure.
- Out:
  - Retiring the legacy telemetry cleanup (0000095).
  - A backup file for the old non-array value.
  - Park's push and `gh` failure paths.
- Deferred: nothing deferred.

## Assumptions
- A failing `pre-commit` hook in a temporary repo forces the chore commit to fail. Impact if wrong: the park test needs another way to fail the commit, such as a read-only index.
- The PowerShell reading of 0000128 is correct, though nobody has run it. Impact if wrong: the new test passes before the fix, and the test writer must confirm RED in CI.

## Risks
- `pwsh` is missing on this machine, so PowerShell tests skip locally. Likelihood: high. Impact: medium. Mitigation: CI runs the PowerShell suite before acceptance.
- The two scripts' warning text drifts apart. Likelihood: low. Impact: low. Mitigation: parity tests assert the exact line in both.
- The two `park.mjs` copies drift apart. Likelihood: low. Impact: medium. Mitigation: P4 reruns setup to refresh the installed copy and checks the two with `diff`.

## Dependencies
- Upstream: 0000040 ADR-002 (shape check), 0000033 ADR-002 (telemetry cleanup), 0000037 ADR-003 (non-array hooks events).
- Downstream: 0000095 (retiring the cleanup) builds on this.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - setup-sh-cleanup-skip | planifest-implement | TDD change to the inline node step in `remove_legacy_telemetry_wiring` |
| REQ-002 - setup-ps1-cleanup-skip | planifest-implement | TDD change to `Remove-LegacyTelemetryWiring` |
| REQ-003 - non-array-warning-no-value | planifest-implement | TDD text change in both scripts with parity tests |
| REQ-004 - park-local-failure-cleanup | planifest-implement | TDD change to `finishPr` in `park.mjs` |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging PRs are human-only. Commit after every meaningful artifact.
- `custom-002-prefer-subagent-decomposition.md`: split long or multi-unit tasks into parallel subagents by default, and state the reason when a task cannot be split.
- `custom-003-git-up-to-date-shorthand.md`: "GUTD" means check out `main`, pull, and list untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at ship, push the branch and tag, and raise the PR without asking. Never merge.
- `custom-005-delete-redundant-local-branches.md`: delete a local branch whose PR merged or whose upstream is gone, with `git branch -D`.

## Confirmation
Human confirmed this design before proceeding: no // Date and Time confirmed: pending
