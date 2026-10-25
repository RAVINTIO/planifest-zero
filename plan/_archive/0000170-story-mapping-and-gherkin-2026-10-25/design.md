# Design - 0000170-story-mapping-and-gherkin

## Feature
- Problem: P1 never checks the user stories for gaps, so a story the brief missed never becomes a requirement. Acceptance criteria are free text, so tests can't map to them line by line.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `docs/about.md` exists)
- Feature ID: 0000170-story-mapping-and-gherkin
- Discovery: see `plan/current/discovery.md`
- Roadmap: `0000168-backlog-clearance`, step 2

## Product Layer
- User stories:
  - US-001: As a maintainer, I get a story map from P1 that lays out activities and steps, so that a story the brief missed shows up as a gap. (0000165)
  - US-002: As a test writer, I read each acceptance criterion as `Given`, `When`, and `Then` lines, so that each test maps to one criterion line by line. (0000165)
  - US-003: As a maintainer, I get a consistency check that flags a malformed Gherkin criterion, so that the format holds without review. (0000165)
  - US-004: As a maintainer, I get a consistency check that flags a gap between the story map and the requirements, so that no mapped step goes unbuilt. (0000165)
  - US-005: As a maintainer, I see the ratchet guard each Gherkin step line, so that a loop can't weaken a criterion by editing a step. (0000165)
- Acceptance criteria confirmed: 4 (feature brief)
- Constraints:
  - P1 owns the mapping pass. P0 keeps its current coaching order.
  - A criterion stays one checkbox line, so the test writer and the P3 coverage table keep their unit. The three-criteria limit counts checkbox lines. Gherkin steps don't count.
  - The checks read `plan/current/` only. Archived runs keep their old format.
  - A gap the brief states or implies becomes a story and a requirement. Any other gap goes to the scope's out-of-scope list, and P1 asks the human about it in a gated run.
- Integrations: none

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: the ratchet hook reads tool input as untrusted text. The new parsing adds no shell calls and no output of file content.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained

## Engineering Layer
- Stack: Node.js ESM, Bash, Markdown. Build target local.
- Components: `ravintio-zero`, the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning in 0.x. 0.15.0 is a minor release.

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
  - `ravintio-zero/templates/story-map.template.md`: a backbone table of activities, steps, stories, and requirements.
  - The plan skill runs the mapping pass before it writes requirements, and lists the story map in its default artifact set.
  - `requirement.template.md` writes each criterion as `- [ ] AC-{n}: {name}` with indented `Given`, `When`, and `Then` lines. `And` and `But` continue the step above.
  - `consistency-check.mjs` flags a criterion that lacks `Given`, `When`, or `Then`, or holds them out of order.
  - `consistency-check.mjs` flags a missing story map when requirements exist, a requirement whose story is not in the map, and a map row with no requirement or gap.
  - `ratchet-check.mjs` guards Gherkin step lines in `## Acceptance Criteria`.
  - The 0000016 consistency-check and ratchet fixtures move to the Gherkin format, in the feature and regression copies.
  - Version 0.15.0.
- Out:
  - Rewriting criteria in archived runs.
  - A Gherkin test runner such as Cucumber.
  - Other backlog entries.
- Deferred:
  - Nothing deferred.

## Assumptions
- Plain Markdown lines are enough for Gherkin. No `.feature` files are needed. Impact if wrong: a later release adds an export.

## Risks
- Consumer runs in flight fail the new checks on old-format criteria. Likelihood medium, impact low. Mitigation: the finding names the expected format, and the fix is a text edit.
- The ratchet parser misreads a step line and blocks a valid write. Likelihood low, impact medium. Mitigation: tests for strengthening, weakening, and disarmed writes with Gherkin content.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| Story map pass and template | ravintio-implement | Skill and template edits with structure tests |
| Gherkin criteria template | ravintio-implement | Template and skill edits with structure tests |
| Gherkin consistency rule | ravintio-implement | Script change with fixture tests |
| Story map consistency rule | ravintio-implement | Script change with fixture tests |
| Ratchet Gherkin guard | ravintio-implement | Hook change with stdin fixture tests |

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
Human confirmed this design before proceeding: draft-accepted (roadmap) // Date and Time confirmed: 2026-10-25T04:41:44Z
