---
title: "Design - 0000171-faster-setup-ps1-tests"
summary: "Confirmed design for a faster setup.ps1 skill copy and a CI timing total."
---
# Design - 0000171-faster-setup-ps1-tests

## Feature
- Problem: `setup.ps1` takes about 75% of the PowerShell CI suite time, at about 1.9 s a case. Its skill copy makes one cmdlet call per file for 544 files.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000171-faster-setup-ps1-tests
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 3

## Product Layer
- User stories:
  - US-001: As a maintainer, I wait less for the Windows CI jobs, so that a pull request gets its PowerShell result sooner. (0000159)
  - US-002: As a consumer, I run `setup.ps1` and get the same installed files as before, only faster, so that a refresh costs less time. (0000159)
  - US-003: As a maintainer, I read one timing total per run from `run-tests.ps1`, so that I can check the speed target without summing log lines. (0000159)
- Acceptance criteria confirmed: 3 (feature brief)
- Constraints:
  - The installed tree keeps the same paths and bytes under both hosts. That includes dot files and the SKILL.md BOM behaviour of each host.
  - Console output of `setup.ps1` stays line for line the same.
  - `setup.sh` is out of scope. The target covers the Windows jobs only.
  - Timing lines go to the host, never into the data a test captures (0000151 req-015).
- Integrations: none

## Architecture Layer
- Latency target: total `setup.ps1` time across both Windows CI jobs under 105 s, from 210 s. The CI timing lines measure it.
- Availability target: not applicable
- Scalability target: not applicable
- Security: the copy reads only the pack folder and writes only under the project root, as before. It adds no shell calls.
- Data privacy: no regulated data
- Observability: `run-tests.ps1` prints a `[timing]` total for `setup.ps1` across the run.
- Cost boundary: not constrained

## Engineering Layer
- Stack: PowerShell 5.1 and 7, Bash, Markdown. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.16.0 is a minor release.

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
  - `Copy-RavintioSkills` copies files and folders with `System.IO` calls in place of `Copy-Item`, `Test-Path`, and `New-Item`.
  - `Install-EnforcementHooks` copies hook modules the same way.
  - A test checks the installed skill tree against the bundle rules, file by file and byte for byte, under both hosts.
  - `Invoke-Setup` appends each `setup.ps1` time to a file that `run-tests.ps1` names. The runner prints the total and case count.
  - Version 0.16.0.
- Out:
  - `setup.sh` and the Bash suites.
  - Sharing one setup run across test cases. Few cases share a starting state.
  - The workspace copy in the test helper.
  - Other backlog entries.
- Deferred:
  - Nothing deferred.

## Assumptions
- Cmdlet overhead per file is at least as high on Windows as on macOS, so the local 8x copy gain carries over. Impact if wrong: the CI total misses 105 s, and the step stops with `Blocked:` before merge.

## Risks
- The .NET copy differs from `Copy-Item` on a case such as dot files or an existing target folder. Likelihood medium, impact medium. Mitigation: the tree test compares every file against the bundle rules under both hosts.
- The CI total misses the target. Likelihood low, impact medium. Mitigation: R-D Advance reads the totals from the step PR's CI logs before the merge.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Fast skill and hook copy | ravintio-implement | Script change with tree parity tests |
| CI timing total | ravintio-implement | Test runner and helper change with an output test |

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

In the ship phase, push every change and raise the pull request yourself, without asking. Push the feature branch and the release tag, then run `gh pr create`. In the ship skill's push/PR decision, always take option [1].

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
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T05:22:00Z
