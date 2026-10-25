---
title: "Design - 0000173-workflow-governance-gates"
summary: "Confirmed design for four workflow metrics, pack thresholds, and a report-only governance gate at ship."
---
# Design - 0000173-workflow-governance-gates

## Feature
- Problem: the pipeline measures the product but not the workflow. A skill change cannot show that it improved quality.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000173-workflow-governance-gates
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 5

## Product Layer
- User stories:
  - US-001: As a maintainer, I run one script on a run's folder and get four workflow metrics, so that I can compare runs. (0000100)
  - US-002: As a maintainer, I set a threshold for each metric in the pack, so that a run that breaches one stands out. (0000100)
  - US-003: As a phase agent, I write one fixed line for each rework loop, design change, and gate correction, so that the script can count them. (0000100)
  - US-004: As a PR reviewer, I read the metrics and any breach in the build report and the PR description, so that I see how the workflow ran. (0000100)
- Acceptance criteria confirmed: 4 (feature brief)
- Constraints:
  - The gate reports and never blocks. The script exits 0 whenever it can read the build log.
  - The script counts fixed marker lines only. It never guesses from free text.
  - The script uses Node built-in modules only.
  - A run that predates the markers still gets a report. Metrics with no markers read 0.
- Integrations: none

## Architecture Layer
- Latency target: the script finishes in under 1 second on a build log of 1,000 lines.
- Availability target: not applicable
- Scalability target: not applicable
- Security: the script reads files in one folder and the pack standard. It writes nothing and runs no shell command. It prints counts and requirement ids, never line content.
- Data privacy: no regulated data
- Observability: the build report and the PR description carry the metrics table.
- Cost boundary: none

## Engineering Layer
- Stack: Markdown, Node.js (built-in modules only), and Bash. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.18.0 is a minor release.

## Component Paths
- `ravintio-zero/`
- `ravintio-overrides/`
- `.claude/`
- `.github/`
- `scripts/`
- `CLAUDE.md`
- `README.md`
- `product.yml`

## Scope
- In:
  - `ravintio-zero/scripts/workflow-metrics.mjs` reads `build-log.md` and every `loop-state-*.md` in a run folder. It prints a Markdown `## Workflow governance` section.
  - `ravintio-zero/standards/workflow-governance-standards.md` defines the four metrics, their marker lines, and a thresholds table that the script reads.
  - Marker lines: `Rework: REQ-{nnn}: {reason} ({timestamp})`, `Requirement change: {class}: {what} ({timestamp})`, and `Gate revised: P{N} ({timestamp}, {what changed})`. `Blocked:` keeps its existing form.
  - The implement and validate skills write `Rework:`. The mid-pipeline change reference writes `Requirement change:`. Each gate in a gated run writes `Gate revised:` when the human asks for a change.
  - Ship Step 5 adds the section to `build-report.md`. Ship Step 9 adds it to the PR body.
  - Version 0.18.0.
- Out:
  - The evaluation suite (backlog 0000174).
  - A blocking gate, or a run-mode switch that turns blocking on.
  - Metrics across runs.
- Deferred:
  - Nothing deferred.

## Assumptions
- Agents write the marker lines when the skill text tells them to. Impact if wrong: the metrics read low, and the report says each count comes from markers only.

## Risks
- A prose mention of `Blocked:` in the build log counts as a stop. Likelihood medium, impact low. Mitigation: the script counts a marker only at the start of a line or list item, outside fenced code.
- The skill size budgets fail when the marker rules land in `SKILL.md` files. Likelihood medium, impact low. Mitigation: keep each skill addition to one or two lines and point at the standard.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Workflow metrics script | ravintio-implement | New Node script with a Bash suite |
| Thresholds and report-only gate | ravintio-implement | New standard and script logic with a Bash suite |
| Metric markers in the build log | ravintio-implement | Skill text change with a text test |
| Governance report at ship | ravintio-implement | Ship skill text change with a text test |

## Repo Instructions

### custom-001-local-git-only.md

### Git Permissions
You may fetch, pull, push, and create pull requests (`gh pr create`) without asking each time. Work on a feat/ branch and push it to origin as you commit. Don't use git worktrees - ensure you are on a feat/ branch but work directly in the working directory.

Two actions are human-only, with no exception:

- Committing directly to `main`. Every change lands via a feature branch.
- Merging pull requests into `main`. The human on the loop reviews and merges.

One narrow exception: `gh pr merge --squash` for your own feature PR into `roadmap/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

Report back if any remote git or GitHub command fails for any reason.

### Commit Granularly, Continuously
Commit locally after every meaningful artifact write — do not batch changes waiting for a phase gate, an approval checkpoint, or task completion. A single requirement doc, ADR, TDD cycle, or config fix is a commit on its own; don't hold it pending a bigger, later commit. Uncommitted work in the working directory is unrecoverable progress — commit early and often so nothing sits unsaved.

### custom-002-prefer-subagent-decomposition.md

### Prefer Subagent Decomposition for Longer Tasks
When a task within any phase is long-running or spans multiple independent units of work (multiple requirements, multiple files with no cross-references, multiple independent searches or reviews), look actively for ways to split it into multiple subagents dispatched in parallel rather than working through the units sequentially in one context. This is a standing instruction, not a per-run choice - default to decomposing before defaulting to sequential inline work. The orchestrator's Parallelism Rules and Agent Dispatch Template (and each phase skill's own dispatch checklist) define the mechanics; this override raises the bar for when decomposition is attempted in the first place. If a task genuinely cannot be split (shared mutable state, one unit depends on another's output, or it is too small to justify subagent overhead), state the reason rather than defaulting to sequential work silently.

### custom-003-git-up-to-date-shorthand.md

# Shorthand: GUTD

**When the human sends "GUTD", treat it as shorthand for "git up to date": check out `main`, pull the latest, and check for any untracked files.**

## Rule

On receiving the literal token `GUTD` (case-insensitive):

1. `git status` first — per standard safety practice, stash or flag anything uncommitted before switching branches.
2. `git checkout main`.
3. Pull the latest from `origin/main`. If local `main` has diverged (local-only commits not on `origin/main`), do not silently force-reconcile — investigate what those commits are first, same as any other unexpected local state, and prefer a reversible step (e.g. a backup branch) over discarding them.
4. Report any untracked files in the working tree (`git status --porcelain` `??` entries) — list them for the human rather than silently ignoring or cleaning them.

## Why

Established 2026-08-02 as a shorthand for a routine sync check the human runs often. Folds in the untracked-files check by default, since a prior "checkout main and pull latest" request surfaced local `main` commits that had diverged from `origin/main` (a stray, unfinished P0 pipeline run started directly on `main`) — worth surfacing untracked/stray state every time, not just when asked.

### custom-004-ship-push-and-raise-pr.md

### Ship: push and raise the PR, never merge

In the ship phase, push every change and raise the pull request yourself, without asking. Push the feature branch, then run `gh pr create`. CI tags the merge commit on `main`. In the ship skill's push/PR decision, always take option [1].

Never merge the pull request into `main`, and never push or commit to `main`. Merging into `main` is human-only. The one exception is `gh pr merge --squash` for your own feature PR into `roadmap/*`, after validation finished clean and CI is green. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

If a push or `gh pr create` fails, report the exact error and stop. Don't retry with force or merge as a workaround.

### custom-005-delete-redundant-local-branches.md

### Delete redundant local branches

You may delete a redundant local branch at any time, without asking. A local branch is redundant when either of these is true:

- Its pull request has merged into `main`.
- `git branch -vv` shows its upstream as `gone` after `git fetch --prune`.

Squash merges leave the branch's commits off `main`, so `git branch -d` refuses them. Use `git branch -D` for a redundant branch.

Never delete the branch you're on, `main`, or a branch with commits that no pull request holds. If a branch has unpushed commits, list them for the human and keep the branch.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T12:30:09Z
