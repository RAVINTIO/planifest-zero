# Design - 0000189-name-the-roadmap-initiative

## Feature
- Problem: The pack uses "roadmap" for both the long-term plan and the charted set of feature steps that ships in one PR, so its words and names don't say which one they mean.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs, the latest 0000185-explain-strict-mode)
- Feature ID: 0000189-name-the-roadmap-initiative
- Version: 0.19.0 (minor bump from 0.18.1, confirmed at P0)
- Discovery: see `plan/current/discovery.md` (raw discovery findings. Do not embed them here. This document records confirmed decisions only)

## Product Layer
- User stories:
  - US-001: As a maintainer, I read one glossary that defines "roadmap" and "roadmap initiative" and the four initiative states, so that I use each word for one thing.
  - US-002: As a maintainer, I find the initiative under `initiative` names in paths, files, scripts, the branch pattern, env vars, logs, and telemetry, so that each name says what it holds.
  - US-003: As a maintainer, I see `I-A Chart:` to `I-E Delivery:` on initiative stage messages, so that the prefix names the initiative.
  - US-004: As a maintainer, I see an initiative's state as proposed, charted, active, delivered, or blocked, so that its status matches the lifecycle.
  - US-005: As a consumer, I run migration 0005 to move my drafts and CI pattern to the new names, so that an upgrade keeps my open drafts.
  - US-006: As a maintainer, I get a failing test when an old name comes back, so that the rename stays complete.
  - US-007: As the agent running the next initiative, I read open backlog entries in the new terms, so that no step needs to translate them.
- Acceptance criteria confirmed: 9 (see `feature-brief.md`)
- Constraints: no commits to `main`; Bash 3.2 and Windows PowerShell 5.1 compatibility; no active roadmap while this feature runs
- Integrations: none outside the pack. Inside it: the driver and `claude -p`, the `merge-guard` hook and `gh pr merge`, and the CI workflow template and GitHub Actions.

### Terms
- **Roadmap:** the long-term plan for the product. `plan/roadmap/` holds it, with one subfolder per roadmap initiative.
- **Roadmap initiative** ("initiative" after first mention): a goal that delivers a string of feature builds. Each build merges into the initiative's own branch, and that branch merges to `main` in one PR.
- **Initiative states:** proposed, charted, active, delivered, and blocked.

### Names
| Today | New |
|-------|-----|
| `roadmap/{id}-{slug}` branch | `initiative/{id}-{slug}` |
| `plan/current-roadmap/roadmap.md` | `plan/current-initiative/initiative.md` |
| `plan/roadmap/{id}-{slug}/roadmap.md` | `plan/roadmap/{id}-{slug}/initiative.md` |
| `ravintio-zero/scripts/roadmap-run.mjs` | `ravintio-zero/scripts/initiative-run.mjs` |
| `ravintio-zero/scripts/roadmap-labels.mjs` | `ravintio-zero/scripts/initiative-labels.mjs` |
| `ravintio-zero/templates/roadmap-entry.template.md` | `ravintio-zero/templates/initiative.template.md` |
| `plan/.roadmap-logs/` | `plan/.initiative-logs/` |
| `RAVINTIO_ROADMAP_MODEL`, `RAVINTIO_ROADMAP_MAX_TURNS` | `RAVINTIO_INITIATIVE_MODEL`, `RAVINTIO_INITIATIVE_MAX_TURNS` |
| Telemetry `work.kind=roadmap`, `ravintio.roadmap` | `work.kind=initiative`, `ravintio.initiative` |
| Prefixes `R-A` to `R-E` | `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, `I-E Delivery:` |

Unchanged: `roadmap-standards.md`, `ravintio.step`, historical test file names, `plan/_archive/`, and `plan/changelog/`.

## Architecture Layer
- Latency target: not applicable (no runtime service)
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth surface. The `merge-guard` hook keeps its rule, with the base pattern changed to `initiative/*`. Data classification: internal pack source, no personal data.
- Data privacy: no regulated data. Step logs keep mode 700 and 600 under the new folder name.
- Observability: standard defaults. Telemetry labels change names as in the Names table.
- Cost boundary: not constrained
- Rename completeness: 0 old names outside the allowlist, measured by the new search test
- Regression: full suite green on Linux, macOS, and Windows in CI, with no test removed

## Engineering Layer
- Stack: Markdown, Node.js ESM, Bash 3.2, PowerShell 5.1 and 7 / no database / no ORM / no IaC / no cloud / GitHub Actions CI / Build target: local
- Components: `ravintio-zero`, the pack: skills, standards, templates, scripts, hooks, tests, and docs
- Data ownership: `ravintio-zero` owns all pack files. No datasets.
- Deployment: consumers install the pack with `setup.sh` or `setup.ps1`. Setup copies `ravintio-zero/skills/` to `.claude/skills/`.
- API versioning: not applicable. The renames are a clean break. Migration `0005` moves consumers, and no aliases remain.

## Scope
- In:
  - The glossary and an explanation in `ravintio-zero/project-operations.md`.
  - Every rename in the Names table, across skills, standards, templates, scripts, hooks, the CI template, tests, docs, `ravintio-overrides/instructions/`, and `CLAUDE.md`.
  - Activation moves an initiative to `plan/current-initiative/initiative.md`.
  - Template status `proposed | charted | active | delivered | blocked`.
  - Prose uses "initiative" for the charted unit.
  - Migration `0005`, which stops while `plan/current-roadmap/` exists.
  - The driver stops and names the new variable when an old `RAVINTIO_ROADMAP_*` variable is set.
  - A search test for old names outside an allowlist.
  - New wording in the open backlog entries.
  - Refreshing `.claude/skills/` from `ravintio-zero/skills/`. The human pre-approved setup at P0, so the run refreshes it without stopping. The run stops instead when it recommends a context clear.
- Out:
  - The `ravintio-initiative` skill and its progress reports (backlog 0000182).
  - New prefix enforcement (backlog 0000181).
  - Aliases for old names.
  - Renaming `roadmap-standards.md` or historical test files.
  - Editing `plan/_archive/` or `plan/changelog/`.
- Deferred: nothing deferred.

## Assumptions
- This repo is the only consumer of the pack today - impact if wrong: another consumer must run migration `0005`, which the design already provides.
- No initiative is active while this feature runs - impact if wrong: a running driver would break on the new names.

## Risks
- A missed reference breaks the driver or `merge-guard` at the next activation. Likelihood medium, impact high. Mitigation: the search test, and a dry run of the driver against a stub initiative.
- `.claude/skills/` drifts from `ravintio-zero/skills/`. Likelihood high, impact medium. Mitigation: run setup after P2 (pre-approved at P0), then check the copies match.
- A rename breaks a Windows-only test path. Likelihood low, impact medium. Mitigation: run the PowerShell suites locally with `pwsh`, and treat Windows PowerShell 5.1 as CI-only.

## Dependencies
- Upstream: none
- Downstream: the next roadmap initiative, charted on 2026-10-25, activates under the new names after this feature merges.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - glossary and docs | ravintio-implementer | Docs-only change in `project-operations.md` and the pack docs |
| REQ-002 - renamed names | ravintio-implementer | File renames and reference updates across scripts, hooks, CI, and skills |
| REQ-003 - initiative prefixes | ravintio-implementer | String changes in skills, standards, and driver stop lines |
| REQ-004 - initiative states | ravintio-implementer | Template and standard edits |
| REQ-005 - consumer migration | ravintio-test-writer, ravintio-implementer | New migration with Bash and PowerShell scripts, test first |
| REQ-006 - old variable stop | ravintio-test-writer, ravintio-implementer | Driver behaviour change, test first |
| REQ-007 - old-name guard | ravintio-test-writer | A new search test with an allowlist |
| REQ-008 - open backlog entries | ravintio-implementer | Wording edits in `plan/backlog/` |

P1 sets the final requirement list.

## Repo Instructions
- custom-001-local-git-only: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging into `main` are human-only. The one exception is `gh pr merge --squash` for your own feature PR into `roadmap/*` (this feature renames the pattern to `initiative/*`). Commit granularly.
- custom-002-prefer-subagent-decomposition: split long tasks into parallel subagents by default, and state the reason when work runs in sequence.
- custom-003-git-up-to-date-shorthand: "GUTD" means check out `main`, pull, and list untracked files.
- custom-004-ship-push-and-raise-pr: at ship, push and raise the PR without asking. Never merge into `main`.
- custom-005-delete-redundant-local-branches: delete merged or upstream-gone local branches with `git branch -D`. Never delete the current branch, `main`, or a branch with unpushed commits.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 25 Oct 2026 @ 09:54 p.m. GMT
