# Design - 0000151-hardening-efficiency-and-ci

## Feature
- Problem: Ten open backlog items leave a security gap in park, sentinels leaking to `main`, hidden hook reasons, high token cost, and slow CI.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds feature directories, latest `0000043-autonomous-roadmaps-2026-10-24`)
- Feature ID: 0000151-hardening-efficiency-and-ci
- Version: `0.10.0` to `0.11.0` (minor)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)
- Backlog sources: `plan/current/backlog-sources/` holds the ten pulled-in entries.

## Product Layer
- User stories: one per feature in `plan/current/feature-brief.md`, US-001 to US-010.
- Requirements:

| Requirement | Backlog | Decision |
|-------------|---------|----------|
| REQ-001 park-symlink-containment | 0000142 | Resolve the entry folder with `realpathSync` after the chore checkout. Refuse if any part of the path is a symlink or escapes the real `plan/backlog/`. Check before `mkdirSync`, `writeFileSync`, and the `rmSync` cleanup. |
| REQ-002 ship-sentinels-before-pr | 0000144 | Clear the sentinels in a commit before Step 8 pushes, as roadmap runs already do. Step 10 keeps the run mode read before the deletion. Step 7 pushes the tag when the agent raises the PR (option [1]). |
| REQ-003 hook-block-reasons-on-stderr | 0000146 | `gate-write`, `em-dash-guard`, and `ratchet-check` write each block reason to stderr and stdout, as `merge-guard` does. One test per hook reads stderr on a block. |
| REQ-004 prune-retired-hooks | 0000143 | Setup deletes installed hooks named on the retired list, in `setup.sh` and `setup.ps1`. `phase-enum` joins the list. Setup never deletes a hook absent from that list. |
| REQ-005 setup-write-error-line | 0000139 | One catch in the shared `writeSettings` prints a fixed line with the relative path and exits 1. It covers the hook install and `merge_allowed_tools`. `setup.ps1` prints the same line. |
| REQ-006 roadmap-step-model-and-turn-cap | 0000148 (1) | `roadmap-run.mjs` passes `--model` (`PLANIFEST_ROADMAP_MODEL`, default `sonnet`) and `--max-turns` (`PLANIFEST_ROADMAP_MAX_TURNS`). Reaching the cap stops with `R-C Run: Blocked:`. |
| REQ-007 dispatch-model-tiers | 0000148 (2) | Replace stale model IDs with `sonnet` and `haiku`. Every Agent call passes `model`. TDD dispatches use the subagent skill's tier, and a haiku unit that fails twice retries on sonnet. |
| REQ-008 quiet-test-output | 0000148 (3) | `PLANIFEST_TEST_QUIET=1` hides PASS lines and banners. It keeps every FAIL line, its detail, the failing suite name, the summary, and the exit codes. Skills that run the full suite use it. |
| REQ-009 context-size-at-gates | 0000148 (4) | At each phase gate in an interactive run, the orchestrator reports context size and recommends `/clear` past about 150,000 tokens. |
| REQ-010 webfetch-via-subagent | 0000148 (5) | The dispatch standard routes a WebFetch of a full reference page through a sonnet or haiku subagent that returns an extract. |
| REQ-011 orchestrator-references-split | 0000148 (6) | Move rarely used orchestrator sections into `references/` files listed in the Pack Index. Keep every rule. Measure the starting context before and after. |
| REQ-012 roadmap-step-logs | 0000145 | The driver writes each step's stdout and stderr to `plan/.roadmap-logs/step-{position}.log`, excluded through `.git/info/exclude`. Every stop line names the log. |
| REQ-013 roadmap-telemetry-labels | 0000149 | The driver appends percent-encoded roadmap labels to any existing `OTEL_RESOURCE_ATTRIBUTES` in the child env. |
| REQ-014 chart-clarity-and-dependency-stop | 0000147 | R-A Chart checks each entry is clear enough to draft from and collects an approved dependency list in `roadmap.md`. A sixth exception stop fires in every run when work adds a library or service missing from the approved list (`design.md` in an interactive run, `roadmap.md` in a roadmap step). |
| REQ-015 faster-powershell-ci | 0000150 | Run the 5.1 and 7 suites as a two-entry matrix. Add per-case timing output. Keep the PowerShell suites on Linux. |

- Acceptance criteria confirmed: drafted per requirement at P1 from the backlog sources and the decisions above.
- Constraints: no quality gate gets weaker. Edit sources under `planifest-zero/`, then rerun setup.
- Integrations: Claude Code hook protocol, `claude` CLI print mode, GitHub Actions.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. Park must never write or delete outside the repo through a symlink. Telemetry labels hold identifiers only. Data classification: internal tooling, no user data.
- Data privacy: no regulated data
- Observability: per-step roadmap logs and telemetry labels (REQ-012, REQ-013), per-case CI timing (REQ-015)
- Cost boundary: quiet full suite under 10 KB of output. Headless steps default to Sonnet.

## Engineering Layer
- Stack: Bash, PowerShell 5.1 and 7, Node ESM, Markdown / no database / no ORM / no IaC / no cloud / CI: GitHub Actions / Build target: local
- Components: `planifest-zero`, a component pack of skills, hooks, scripts, templates, standards, and setup.
- Data ownership: `planifest-zero` owns `plan/` working files and the hook wiring in `.claude/settings.json`.
- Deployment: copied into projects by `setup.sh` and `setup.ps1`.
- API versioning: not applicable
- Approved dependencies: none. This run adds no library or service.

## Scope
- In: REQ-001 to REQ-015, `setup.ps1` parity, the second unguarded write in `merge_allowed_tools`, and `ratchet-check.mjs`.
- Out: backlog 0000095, 0000100, and 0000110. New hooks or phases.
- Deferred: batching PowerShell test cases per process, unless P2 timing shows start-up dominates.

## Assumptions
- Claude Code reads only stderr from a PreToolUse hook that exits 2 - impact if wrong: REQ-003 changes nothing for agents.
- The `claude` CLI accepts `--model` and `--max-turns` in print mode - impact if wrong: REQ-006 needs another mechanism.
- Claude Code may ignore a skill-level `model` field - impact if wrong: none, P1 checks and REQ-007 passes `model` on each Agent call regardless.

## Risks
- Moving orchestrator text to `references/` breaks tests that grep `SKILL.md`. Likelihood high, impact medium. Mitigation: update those tests to read the new file, never drop an assertion.
- The CI matrix breaks `test-0000036-req-005` literal checks. Likelihood certain, impact low. Mitigation: update the test to the matrix shape.
- Reordering ship steps breaks 0000023, 0000042, and 0000043 order tests. Likelihood certain, impact low. Mitigation: update them to the new order.
- The release is about 19 points against an 8-point budget. Likelihood medium, impact medium. The human accepted it.

## Dependencies
- Upstream: PR #22 adds backlog 0000150 to `main`. This branch already holds it.
- Downstream: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 to REQ-015 | planifest-implement | Each is a scripted or prose change with a bash or PowerShell test, through the TDD loop. |

## Repo Instructions
Five files in `planifest-overrides/instructions/`:
- `custom-001-local-git-only.md`: merging into `main` and committing to `main` are human-only.
- `custom-002-prefer-subagent-decomposition.md`: decompose into parallel subagents by default.
- `custom-003-git-up-to-date-shorthand.md`: `GUTD` means check out `main`, pull, and list untracked files.
- `custom-004-ship-push-and-raise-pr.md`: push the branch and the tag, then raise the PR. Never merge.
- `custom-005-delete-redundant-local-branches.md`: delete merged or gone local branches without asking.

## Confirmation
Human confirmed this design before proceeding: no // Date and Time confirmed: pending
