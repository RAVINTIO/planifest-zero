# Design - 0000036-test-runner-coverage

## Feature
- Problem: `run-tests.sh` skips files that miss its glob without a word, and no PowerShell suite can run. Six `setup.ps1` functions have no test that executes them.
- Adoption mode: standard-iterative
- Feature ID: 0000036-test-runner-coverage
- Version: 0.4.3
- Discovery: see `plan/current/discovery.md` (raw P0 findings; do not embed them here; this document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I add a test file that misses the naming rule, so that the run fails and names the file.
  - US-002: As a maintainer, I promote a regression suite, so that a suite on disk with no manifest entry fails the run.
  - US-003: As a maintainer, I add a `test-*.ps1` suite, so that the runner runs it, or says loudly that it skipped it.
  - US-004: As a Windows user, I rely on `setup.ps1`, so that its main behaviours run under test on both PowerShell versions.
  - US-005: As a reviewer, I open a PR, so that CI runs the PowerShell suites on Windows PowerShell 5.1 and PowerShell 7.
- Acceptance criteria confirmed: 5 in the brief, refined per story at P1
- Constraints:
  - `planifest-framework/` is out of scope (0000033 ADR-001).
  - No `pwsh` locally. The PowerShell suites first run in CI, so P4 waits on the CI result.
  - This branch stacks on PR #9. Merge PR #9 first.
- Integrations: GitHub Actions.

## Architecture Layer
- Latency target: the new CI job finishes in under 10 minutes
- Availability target: not applicable
- Scalability target: not applicable
- Compatibility: with no stray files and no `pwsh`, `run-tests.sh` gives the same pass and fail counts as today, plus one skip line
- Robustness: 0 test files that the runner neither runs nor reports
- Security: no auth. The CI job uses the default read-only token and no secrets. Data classification: none.
- Data privacy: no regulated data
- Observability: runner console output, plus the CI job log
- Cost boundary: GitHub-hosted runners on the free tier for public repos

## Engineering Layer
- Stack: Bash 3.2+, Windows PowerShell 5.1 and PowerShell 7, Node 18+. Tests: Bash suites and plain PowerShell suites with a small assert helper. CI: GitHub Actions. Build target: local.
- Components: `planifest-zero` (existing component-pack).
- Data ownership: none.
- Deployment: not applicable.
- API versioning: not applicable.

## Runner rules (confirmed)

| Rule | Behaviour |
|------|-----------|
| Suite | `test-*.sh` or `test-*.ps1` directly in `tests/` or `tests/regression/` |
| Known non-suite | `README.md`, `run-tests.sh`, `run-tests.ps1`, files under `helpers/`, `regression/regression-manifest.json`, and `test-gate-write-windows.mjs` in either folder |
| Stray file | Any other file. The runner names it and exits 1 after running the suites |
| PowerShell suites | Run with `pwsh` when it exists. Otherwise one line names the skip count. With `PLANIFEST_REQUIRE_PWSH=1`, a missing `pwsh` fails the run |
| Manifest | Every regression suite on disk needs a manifest entry, and every entry needs a file |

`run-tests.ps1` runs only the PowerShell suites, under whichever host starts it. CI uses it on `windows-latest`, once with `powershell` (5.1) and once with `pwsh` (7).

## Scope
- In:
  - Stray-file pre-flight in `run-tests.sh`.
  - Manifest check in both directions.
  - `test-*.ps1` discovery in `run-tests.sh`, and a new `run-tests.ps1`.
  - `helpers/assert.ps1`.
  - PowerShell suites that run `setup.ps1` for the 0000035 behaviours and the 0000034 retired flags.
  - A `windows-powershell` CI job.
- Out:
  - `planifest-framework/`.
  - Running the bash suites in CI. The rename suite fails while `planifest-framework/` exists, so that job would stay red until backlog 0000097.
  - Pester.
  - The consumer copy of the workflow at `planifest-zero/hooks/planifest.yml`.
- Deferred:
  - Bash suites in CI, after backlog 0000097.

## Assumptions
- `setup.ps1` runs from a temporary copy of `planifest-zero/` on `windows-latest` - impact if wrong: the suites need a different workspace layout.
- `windows-latest` keeps Windows PowerShell 5.1 and `pwsh` 7 - impact if wrong: one CI leg fails to start.

## Risks
- R-001: The PowerShell suites fail in CI for reasons I can't reproduce locally. Likelihood: high. Impact: low. Mitigation: push early and read the CI log. Cap fixes at five attempts, then escalate.
- R-002: The stray-file check flags a file someone needs. Likelihood: low. Impact: low. Mitigation: the allowlist lives in one place with a comment.
- R-003: A PowerShell suite finds a real `setup.ps1` defect. Likelihood: medium. Impact: medium. Mitigation: fix it in this feature if small, otherwise file a backlog entry.

## Dependencies
- Upstream: PR #9 (0000035)
- Downstream: backlog 0000097 (bash suites in CI)

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - stray-file-check | planifest-codegen-agent | Runner pre-flight, TDD with a bash suite |
| REQ-002 - manifest-both-ways | planifest-codegen-agent | One check, TDD with a bash suite |
| REQ-003 - powershell-discovery | planifest-codegen-agent | Runner change plus `run-tests.ps1`, TDD with a bash suite |
| REQ-004 - setup-ps1-runtime-suites | planifest-codegen-agent | New PowerShell suites, verified in CI |
| REQ-005 - windows-ci-job | planifest-codegen-agent | Workflow job, verified by the PR run |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking, on a feat/ branch. Never commit to `main` or merge PRs. Commit granularly.
- `custom-002-prefer-subagent-decomposition.md`: split long or independent work into parallel subagents, or state why not.
- `custom-003-git-up-to-date-shorthand.md`: `GUTD` means check out `main`, pull, and report untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at P9, push and raise the PR without asking. Never merge. The human merges to `main`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 17 Oct 2026 @ 1:01 a.m. BST
