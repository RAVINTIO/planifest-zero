# Design - 0000169-release-hygiene

## Feature
- Problem: PR descriptions can carry AI attribution because only commits are checked. Release tags name feature-branch commits that a squash merge leaves off `main`.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000169-release-hygiene
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 1

## Product Layer
- User stories:
  - US-001: As a maintainer, I see no AI attribution lines in any PR description, so that PRs follow the same rule as commits. (0000166)
  - US-002: As a maintainer, I get setup to turn off the host's attribution lines, so that the agent never writes them in the first place. (0000166)
  - US-003: As a maintainer, I see every release tag on a commit that `git log main` shows, so that a tag always names shipped code. (0000167)
- Acceptance criteria confirmed: 4 (feature brief)
- Constraints:
  - The check never prints the PR body. It names the line number and the rule only.
  - CI passes the PR body through an environment variable, never through `${{ }}` inside a `run:` script.
  - Only the `release-tag` job gets `contents: write`. Every other job keeps `contents: read`.
  - Setup never overwrites an `attribution` value that a human set.
  - Roadmap R-D Advance keeps tagging the squash commit on the roadmap branch.
- Integrations: GitHub Actions (`pull_request` and `push` events)

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the PR body is untrusted input. It reaches the check only through an environment variable and a file. The tag job checks out `main` with a write token and runs only repo code from `main`.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell 5.1 and 7, Node.js ESM, Markdown, GitHub Actions YAML. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.14.0 is a minor release.

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
  - The boot template, `commit-standards.md`, and the ship skill ban attribution in PR descriptions. They name `Generated with [Claude Code]`, `Co-Authored-By:`, and `Claude-Session:` lines.
  - `ravintio-zero/scripts/check-attribution.mjs` reads a file or stdin and exits 1 on an attribution line, 0 otherwise. The `commit-msg` hook gains the same host-line patterns.
  - Ship Step 9 runs the check on the PR body before `gh pr create`. The `validate-branch` job runs it on the PR description in both workflow files.
  - `setup.sh` and `setup.ps1` set `attribution` to `{"commit": "", "pr": ""}` in `.claude/settings.json` when the key is absent.
  - `ravintio-zero/scripts/release-tag.mjs` tags `HEAD` with `v{version}` from `product.yml`, falling back to `docs/about.md`. It skips when the tag exists and pushes a new tag.
  - A `release-tag` job runs on a push to `main` in both workflow files. The PR jobs run only on `pull_request`.
  - Ship Step 7 no longer creates a tag. Steps 9 and 10, `roadmap-standards.md`, `pipeline-reference.md`, and `custom-004` describe the new flow.
  - Version 0.14.0.
- Out:
  - Moving existing tags.
  - Updating a consumer's existing workflow file.
  - Other backlog entries.
- Deferred:
  - Nothing deferred.

## Assumptions
- Claude Code honours `attribution.commit` and `attribution.pr` set to empty strings. Impact if wrong: the host keeps asking for the lines, and the check and hook still catch them.
- `GITHUB_TOKEN` with `contents: write` can push a tag in this repo and in consumer repos. Impact if wrong: the job fails visibly, and the human tags by hand.

## Risks
- A PR body crafted to inject shell code reaches a `run:` script. Likelihood low, impact high. Mitigation: pass the body only through `env:` and a temporary file, and test the YAML for `github.event.pull_request.body` inside `run:`.
- The check matches a PR that discusses attribution, such as this one. Likelihood high, impact low. Mitigation: match whole attribution lines, not words, and keep this run's PR body free of the literal lines.
- Guarding PR jobs with `if:` skips a required check on `main` pushes. Likelihood low, impact low. Mitigation: branch protection reads PR checks only.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Attribution ban text | ravintio-implement | Doc edits with structure tests |
| Attribution check script and hook | ravintio-implement | New script with TDD |
| Attribution check in ship and CI | ravintio-implement | Skill and YAML edits with tests |
| Setup attribution setting | ravintio-implement | Setup change on two shells with parity tests |
| Release tag script | ravintio-implement | New script tested against a local bare remote |
| Release tag CI job and ship flow | ravintio-implement | YAML, skill, and doc edits with tests |

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
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T03:35:00Z
