---
title: "Design - 0000185-explain-strict-mode"
summary: "Confirmed design for a strict mode section that explains the acknowledgement file, with links that reach it."
---
# Design - 0000185-explain-strict-mode

## Feature
- Problem: no doc says what `plan/.orchestrator-ack` holds or why it has that name. The getting-started link for strict mode lands on the sentinel section instead.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000185-explain-strict-mode
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 6

## Product Layer
- User stories:
  - US-001: As a pack user, I read one section in `project-operations.md` and learn what strict mode does and what `plan/.orchestrator-ack` holds, so that the banner and the file make sense. (0000184)
  - US-002: As a pack user, I follow the strict mode link from `getting-started.md` or `README.md` and land on that section, so that I find it without searching. (0000184)
- Acceptance criteria confirmed: 4 (feature brief)
- Constraints:
  - Docs only. No hook, skill, or script changes.
  - The text matches what `check-orchestrator-presence.mjs` does today, including the active-pipeline condition and the timestamp fallback.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: docs only. The text names no credential and changes no hook.
- Data privacy: no regulated data
- Observability: not applicable
- Cost boundary: none

## Engineering Layer
- Stack: Markdown and Bash. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.18.1 is a patch release.

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
  - Rewrite the body of `## Strict Orchestrator Mode` in `ravintio-zero/project-operations.md` from the backlog entry's draft. The section already sits after **Orchestrator Sentinel**, so the rewrite replaces it rather than adding a second section.
  - The rewrite adds two facts the draft omits: the hook acts only while `plan/.orchestrator-active` exists, and it asks for a timestamp when it has no session id.
  - Point the `getting-started.md` strict mode row and the `README.md` `--strict-orchestrator` row at `project-operations.md#strict-orchestrator-mode`.
  - Define `plan/.orchestrator-strict` and `plan/.orchestrator-ack` in the run's domain glossary.
  - A Bash test checks the section and both links.
  - Version 0.18.1.
- Out:
  - Changes to the hook, the orchestrator skill, or the ship skill.
  - The roadmap driver case itself. Backlog entry 0000182 holds it.
  - A rewrite of the strict mode section in `pipeline-reference.md`.
- Deferred:
  - Nothing deferred.

## Assumptions
- The anchor `#strict-orchestrator-mode` stays stable because the heading text stays the same. Impact if wrong: the two links break, and the test fails.

## Risks
- The new text drifts from hook behaviour. Likelihood low, impact low. Mitigation: discovery read the hook, and P3 verification checks each claim against it.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Strict mode section | ravintio-implement | Docs change with a text test |
| Links to the strict mode section | ravintio-implement | Docs change with a text test |

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
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T13:04:00Z
