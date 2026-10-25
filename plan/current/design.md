---
title: "Design - 0000172-subagent-acceleration"
summary: "Confirmed design for a fast run speed, fast batches per phase, and phase timing in the build log."
---
# Design - 0000172-subagent-acceleration

## Feature
- Problem: each phase decides for itself when to split work across subagents, so a run with many independent units still moves slowly. The build log records no phase duration, so nobody can measure a gain.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000172-subagent-acceleration
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 4

## Product Layer
- User stories:
  - US-001: As a human on the loop, I choose a `fast` run speed at discovery, so that a run with many independent units finishes sooner. (0000110)
  - US-002: As a phase agent in a `fast` run, I dispatch my phase's listed parallel work units in one batch, so that independent work does not wait in line. (0000110)
  - US-003: As a maintainer, I read the agent count and wall-clock time of each phase in the build log and the build report, so that I can measure the gain. (0000110)
- Acceptance criteria confirmed: 3 (feature brief)
- Constraints:
  - `plan/.run-mode` keeps its two values, `gated` and `autonomous`. The speed lives in its own file, `plan/.run-speed`.
  - Phases run in order. A fast batch never starts phase N+1 work before phase N ends.
  - Every gate, exception stop, and progress marker stays as it is.
  - A missing `plan/.run-speed` means `standard`, so runs and roadmaps that predate it behave as before.
- Integrations: none

## Architecture Layer
- Latency target: not measured in this release. The build log gains the wall-clock time that a later release can compare.
- Availability target: not applicable
- Scalability target: not applicable
- Security: no new scripts, hooks, or shell calls. Fast batches pass `model` explicitly, as the tier table requires.
- Data privacy: no regulated data
- Observability: each build-log phase block records `End` and `Wall clock`. The build report lists both with the agent count.
- Cost boundary: a fast run may spawn more agents. Each still uses the tier the table gives.

## Engineering Layer
- Stack: Markdown and Bash. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.17.0 is a minor release.

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
  - The orchestrator asks a run-speed question after the run-mode question and writes `plan/.run-speed`. A roadmap step takes the roadmap's `**Speed:**` field, or `standard` when it is absent.
  - The dispatch standards define the fast batch and its rules.
  - The plan, implement, validate, and ship skills each list their fast batch units.
  - The ship skill deletes `plan/.run-speed` with the other sentinels.
  - The build-log template records `End` and `Wall clock` per phase and the run speed in the header. The build report lists them.
  - Version 0.17.0.
- Out:
  - Overlapping phases and per-requirement streams across phases.
  - A `fast` value in `plan/.run-mode`.
  - Any change to the roadmap driver script.
  - Other backlog entries.
- Deferred:
  - Nothing deferred.

## Assumptions
- Phase agents follow a listed batch more reliably than a general rule. Impact if wrong: fast runs dispatch no more agents than standard runs, and the build report shows it.

## Risks
- A fast batch dispatches two units that write the same file. Likelihood medium, impact medium. Mitigation: the dispatch standards require disjoint write sets in a batch, and the cannot-parallelise list still applies.
- A new sentinel file reaches a roadmap branch. Likelihood low, impact low. Mitigation: ship Step 8 deletes `plan/.run-speed` with the others, and a test checks it.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Run speed setting | ravintio-implement | Skill text change with a text test |
| Fast batches per phase | ravintio-implement | Skill and standard text change with a text test |
| Phase timing in the build log | ravintio-implement | Template and ship skill change with a text test |

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
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T11:40:00Z
