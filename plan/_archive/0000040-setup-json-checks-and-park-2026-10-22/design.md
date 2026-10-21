# Design - 0000040-setup-json-checks-and-park

## Feature
- Problem: Setup can report enforcement hooks as installed while leaving a non-object `settings.json` unchanged, and no command shelves a part-finished feature.
- Adoption mode: standard-iterative (assumed, only signal: `plan/_archive/` and `docs/about.md` present)
- Feature ID: 0000040-setup-json-checks-and-park
- Version: 0.7.0 (minor, from 0.6.0, because park is a new capability)
- Run mode: continuous
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a person running `setup.sh`, I get one fixed error line and exit 1 when `settings.json` is valid JSON but not a settings object, so that I never believe the hooks are installed when they are not. (0000121)
  - US-002: As a person running `setup.ps1`, I get the same fixed error line when `settings.json` is valid JSON that PowerShell cannot read as a settings object, so that the message names the real fault. (0000120)
  - US-003: As a person running `setup.ps1`, I get a prompt failure on very deep nesting, so that the strict JSON check never slows with the square of the depth. (0000122)
  - US-004: As a human on the loop, I say "park" and the orchestrator shelves the feature on its branch, files a backlog entry, and returns me to `main`, so that I can start other work without losing progress. (0000101)
  - US-005: As a human on the loop, I pick up a parked entry at a later P1 and either resume it or discard its branch, so that parked work is never lost or left behind silently. (0000101)
- Acceptance criteria confirmed: 8 (see `feature-brief.md`)
- Constraints:
  - 0000039 ADR-002 stands. Invalid JSON keeps its existing message.
  - 0000033 req-004 stands. Setup never prints `settings.json` content or a parser message.
  - Park never merges, never commits to `main`, and never force-pushes.
- Integrations: git and `gh` CLI (park only)

## Architecture Layer
- Latency target: `Test-JsonText` on 100,000 levels of nesting finishes in under 5 seconds. Cost grows linearly with input length.
- Availability target: not applicable (local tooling)
- Scalability target: not applicable
- Security: no auth. `settings.json` is user configuration, classified internal. No error path prints file content.
- Data privacy: no regulated data
- Observability: standard defaults. Setup prints one fixed line per failure to stderr.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell 5.1 and 7, Node (inline scripts and hooks), Markdown skills. Tests are shell and node scripts under `planifest-zero/tests/`, run by `run-tests.sh` and `run-tests.ps1`. CI is GitHub Actions. Build target: local.
- Components: `planifest-zero`, the framework pack of skills, hooks, templates, setup scripts, and tests.
- Data ownership:
  - setup owns the hook wiring in `.claude/settings.json`.
  - the orchestrator owns `plan/` working state, including `park.md`.
- Deployment: files in the repo, installed into a target project by `setup.sh` or `setup.ps1`.
- API versioning: not applicable

### Shape check (US-001, US-002, US-003)
- Shared message: `! Error: {path} is valid JSON but not a settings object setup can read. Fix it and rerun setup.`
- Both scripts exit 1 with that line when the top level is not a plain object, or `hooks` is present and not a plain object. A `hooks` value of `null` counts as absent, as today.
- `setup.ps1` also exits 1 with that line on case-duplicate keys and on nesting deeper than 1024.
- `setup.sh` accepts case-duplicate keys, because node reads them. This difference is deliberate.
- The check runs before any write, so every failure leaves the file unchanged.
- `Test-JsonText` tracks depth with an integer and a `[System.Collections.Generic.Stack[char]]`, and fails at depth 1024.

### Park (US-004, US-005)
1. Write `plan/current/park.md` from a new `park.template.md`: phase reached, last artifact, head commit, reason. Commit it and push the feature branch.
2. Cut `chore/park-{feature-id}` from `main`. Add a backlog entry whose status is `parked` and that names the branch. Push it and run `gh pr create`.
3. Check out `main`. The sentinels live on the feature branch only, so `main` needs no cleanup.
4. If any push or `gh` call fails, report the exact error and stop with the working tree on the feature branch.

At P1 backlog pickup, a `parked` entry offers resume or discard:
- Resume checks out the branch, merges `origin/main`, and restores state from `park.md` as resume detection does for `pause.md`.
- Discard deletes the branch locally and on `origin` only after the human confirms.
- Resume detection that finds `park.md` with no chore PR finishes step 2.

## Scope
- In:
  - The shared shape check in both setup scripts.
  - The linear `Test-JsonText` with a depth cap of 1024.
  - The park command, its template, and parked-entry handling at P1.
- Out:
  - `setup.sh` rejecting case-duplicate keys.
  - Reverting commits on `main`.
  - More than one parked feature per working tree at a time.
- Deferred: nothing deferred.

## Assumptions
- `gh` is installed and authenticated when park runs. Impact if wrong: park stops at step 2 with the branch pushed, and the human files the PR.
- PowerShell 7 and 5.1 both throw on case-duplicate keys in `ConvertFrom-Json`. Impact if wrong: the 0000120 test needs a version guard.

## Risks
- The `setup.sh` and `setup.ps1` messages drift apart. Likelihood: low. Impact: medium. Mitigation: parity tests assert the exact line in both.
- Park leaves a half-done state if the session ends mid-step. Likelihood: low. Impact: medium. Mitigation: resume detection finishes step 2 from `park.md`.
- `pwsh` is missing on the review machine, so PowerShell tests skip locally. Likelihood: high. Impact: medium. Mitigation: CI runs the PowerShell suite.

## Dependencies
- Upstream: 0000039 ADR-002 (invalid-JSON message), 0000037 ADR-003 (non-array hooks events).
- Downstream: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - setup-sh-shape-check | planifest-implement | TDD change to the inline node step in `setup.sh` |
| REQ-002 - setup-ps1-shape-check | planifest-implement | TDD change to `Merge-EnforcementHookSettings` in `setup.ps1` |
| REQ-003 - linear-json-check | planifest-implement | TDD rewrite of `Test-JsonText` with a depth cap |
| REQ-004 - park-command | planifest-implement | Orchestrator skill section, template, and contract tests |
| REQ-005 - parked-pickup | planifest-implement | Orchestrator resume and backlog-pickup text, with contract tests |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging PRs are human-only. Commit after every meaningful artifact.
- `custom-002-prefer-subagent-decomposition.md`: split long or multi-unit tasks into parallel subagents by default, and state the reason when a task cannot be split.
- `custom-003-git-up-to-date-shorthand.md`: "GUTD" means check out `main`, pull, and list untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at ship, push the branch and tag, and raise the PR without asking. Never merge.
- `custom-005-delete-redundant-local-branches.md`: delete a local branch whose PR merged or whose upstream is gone, with `git branch -D`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 21 Oct 2026 @ 06:25 p.m. BST
