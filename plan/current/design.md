# Design - 0000037-self-host-on-planifest-zero

## Feature
- Problem: this repo runs its pipeline on the old `planifest-framework/` copy, which keeps the rename suite failing and retired telemetry in CI.
- Adoption mode: standard-iterative
- Feature ID: 0000037-self-host-on-planifest-zero
- Version: 0.4.4 (patch, from 0.4.3)
- Run mode: continuous
- Discovery: see `plan/current/discovery.md` (raw P0 findings; do not embed them here; this document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As the maintainer, I delete `planifest-framework/` from the repo, so that the rename suite passes in full.
  - US-002: As the maintainer, I keep this repo's setup record at `plan/state/claude-code.md`, so that it matches what `planifest-zero/setup.sh` writes.
  - US-003: As the maintainer, I remove the `validate-telemetry-schema` CI job, so that CI guards nothing the product no longer has.
- Acceptance criteria confirmed: 10, listed in `feature-brief.md`
- Constraints:
  - Never commit to `main`, and never merge.
  - After the deletion, this run's remaining phases read each `planifest-framework/{path}` from `planifest-zero/{path}`.
- Integrations: GitHub Actions

## Architecture Layer
- Latency target: not applicable. The run changes repo files and CI only.
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth surface. Removing the telemetry job removes the only CI step that reads a secret. Data classification: public repo files.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell, and Node.js scripts / no database / no ORM / no IaC / no cloud / local compute / GitHub Actions CI / no build target
- Components: `planifest-zero`, the shipped framework. The run changes only its tests and tests README. The other files sit at repo level.
- Data ownership: no component owns data
- Deployment: none. The repo is the product.
- API versioning: not applicable

## Requirements
| ID | Slug | Change |
|----|------|--------|
| req-001 | drop-telemetry-ci-job | Remove the `validate-telemetry-schema` job and the comment that names the old folder. |
| req-002 | refresh-script-flags | Remove `--structured-telemetry-mcp` from `refresh-planifest-zero-dir.ps1`. |
| req-003 | setup-record-move | Write `plan/state/claude-code.md` with an empty `flags` array. Remove `planifest-overrides/setup-config/`. |
| req-004 | remove-old-framework | Update `planifest-zero/tests/README.md`. Point `core.hooksPath` at `planifest-zero/hooks`, then `git rm -r planifest-framework/`. |
| req-005 | override-phase-names | Reword `custom-004-p9-push-and-raise-pr.md` to name the ship phase, which the five-phase pipeline has, in place of P9. |

P3 runs req-004 last, so the old installed skills keep their source files until the final commit.

## Scope
- In:
  - the four requirements above, each with a suite
  - the living docs and version records for 0.4.4
- Out:
  - Running the Bash suites in CI. Backlog 0000108 covers it.
  - Changes to the five-phase pipeline in `planifest-zero/`.
  - Rewriting historical records under `plan/` or `docs/decisions-index.md`.
- Deferred:
  - The local reinstall of `.claude/` and `CLAUDE.md` with `planifest-zero/setup.sh claude-code`. The human runs it after merging, because setup prunes the old skills that this run uses. The next feature then runs on the five-phase pipeline.

## Assumptions
- No phase from P4 to P9 needs the four files that `planifest-zero/` lacks. Impact if wrong: that phase reads a missing file and must stop for direction.
- Setup rewrites `writtenAt` in `plan/state/claude-code.md` on every run. That diff is expected, and the maintainer commits it with the reinstall.
- `planifest-zero/setup.sh` reads `plan/state/claude-code.md` and carries no retired flag forward. Impact if wrong: the post-merge reinstall replays a retired flag, which warns and installs nothing.

## Risks
- R-001: a file in the repo still needs `planifest-framework/` after the deletion. Likelihood: low. Impact: medium. The rename suite and a full local run catch it.
- R-002: a session resets after the deletion and reloads skills that cite old paths. Likelihood: high. Impact: low. The constraint above maps each path to `planifest-zero/`.
- R-004: the installed `auto-trigger-orchestrator` hook looks for `planifest-framework/`. After req-004, a new session doesn't load the orchestrator on its own. Likelihood: high. Impact: low. The human loads the `planifest-orchestrator` skill by name, as `CLAUDE.md` directs for tools without the hook.
- R-005: git reads its hooks from `planifest-framework/hooks`. A deletion without the `core.hooksPath` change switches off `commit-msg` with no error. Likelihood: certain without req-004's first step. Impact: high. req-004 changes the path first, and its suite checks it.
- R-006: CI doesn't run the Bash suites, so only the local run proves the rename suite passes. Likelihood: certain. Impact: low. P4 records the local run, and backlog 0000108 closes the gap.
- R-003: the human squash-merges PR #9 or PR #10 and GitHub closes this stacked PR. Likelihood: high. Impact: low. The fix is a cherry-pick onto a branch from `main`, with no force push.

## Dependencies
- Upstream: 0000035 and 0000036, both merged to `main`.
- Downstream: backlog 0000108, and every later feature in this repo.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| req-001 - drop-telemetry-ci-job | planifest-codegen-agent | Workflow edit with a static suite |
| req-002 - refresh-script-flags | planifest-codegen-agent | One-line script edit with a static suite |
| req-003 - setup-record-move | planifest-codegen-agent | Record move with a suite that runs setup in a copy |
| req-004 - remove-old-framework | planifest-codegen-agent | Deletion proven by the existing rename suite |
| req-005 - override-phase-names | planifest-codegen-agent | One-file wording edit with a static suite |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking, on a feat/ branch. Never commit to `main` or merge PRs. Commit granularly.
- `custom-002-prefer-subagent-decomposition.md`: split long or independent work into parallel subagents, or state why not.
- `custom-003-git-up-to-date-shorthand.md`: `GUTD` means check out `main`, pull, and report untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at P9, push and raise the PR without asking. Never merge. The human merges to `main`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 17 Oct 2026 @ 02:58 a.m. BST
