# Design - 0000043-autonomous-roadmaps

## Feature
- Problem: work that spans several features has no home in `plan/`, and every pipeline run needs a human to start it.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds feature directories)
- Feature ID: 0000043-autonomous-roadmaps
- Version: `0.9.0` to `0.10.0` (minor)
- Discovery: see `plan/current/discovery.md`
- Backlog pulled in: 0000098, 0000099
- Release size: 11 points against the `medium` budget of 8. The human chose one feature over a split.

## Product Layer
- User stories:
  - US-001: As a human on the loop, I file a draft roadmap in `plan/roadmap/` on any branch, so that long-term intent has a home.
  - US-002: As a human on the loop, I chart a roadmap from an idea or a draft, so that I approve the whole chain once.
  - US-003: As a human on the loop, I activate a charted roadmap, so that its branch and state exist and the driver can start.
  - US-004: As a human on the loop, I let each step run P0 to P4 with no coaching stops, so that the chain runs without me.
  - US-005: As a human on the loop, I let the agent squash-merge a green step into the roadmap branch and tag it, so that the next step builds on it.
  - US-006: As a human on the loop, I receive one roadmap PR to `main`, so that I review and merge the whole chain once.
  - US-007: As a human on the loop, I start one driver that runs each step in a fresh session, so that context stays clean across steps.
  - US-008: As a human on the loop, I rely on a hook that blocks any agent merge outside `roadmap/*`, so that `main` stays human-only.
- Acceptance criteria confirmed: 8 (see `feature-brief.md`)
- Constraints:
  - Merging into `main` stays human-only in every mode.
  - The agent merges only into `roadmap/*`, only with `--squash`, and only after a clean P3 and green CI.
  - Roadmap ids share the backlog's seven-digit sequence.
  - One active roadmap per working tree.
- Integrations: Claude Code CLI (`claude -p`), GitHub (`gh`)

### Roadmap lifecycle

| Stage | Prefix | What happens | Where |
|-------|--------|--------------|-------|
| Chart | `R-A Chart:` | Write a new plan from an idea, or pick up a draft from `plan/roadmap/` (pull-in, leave, or discard). Coach steps, order, bumps, and stop conditions. The human's confirmation approves the roadmap. | `main` |
| Activate | `R-B Activate:` | Check for a remote, `gh` access, and no existing `roadmap/{id}-*` branch on `origin`. Cut `roadmap/{id}-{slug}` from `main`. Write `plan/current-roadmap/roadmap.md` with `status: active` and delete the draft folder in one commit. Push. Offer to start the driver in the background. | roadmap branch |
| Run | `R-C Run:` | Cut the step's feature branch from the roadmap branch. Run P0 to P4 in `plan/current/`. P0 builds the brief from the step's backlog entries and self-confirms design and scope lock as `draft-accepted (roadmap)`. It stops only when an entry is too vague to draft from. | feature branch |
| Advance | `R-D Advance:` | P4 raises the PR with `--base roadmap/{id}-{slug}`. The same PR sets the step to `merged`, fills `Version`, and moves `position` on. Wait for green CI, run `gh pr merge --squash`, fetch, tag the squash commit, and push the tag. | roadmap branch |
| Delivery | `R-E Delivery:` | After the last step, move `plan/current-roadmap/` to `plan/_archive/{id}-{slug}-roadmap-{date}/`. Raise the roadmap PR to `main`. The PR body asks for a merge commit, not a squash. | roadmap branch |

Filing a draft roadmap has no prefix. It happens on any branch and in any phase, as filing a backlog entry does. The agent may suggest a draft and help the human structure it.

### Roadmap file

`roadmap.md` holds frontmatter (`title`, `summary`, `status`), then these fields and a step table:

- `goal`
- `branch`
- `status`: `draft`, `active`, `blocked`, or `done`
- `position`: the next step to run
- stop conditions
- `Unpredicted additive changes`: `pre-approved` or `stop`, the answer to Chart's fallback question
- a `## Schema changes` table with `Step`, `Component`, `Change`, and `Kind` (`additive`, `destructive`, or `none`). The human approves its rows at Chart. Added at P3 by a human-confirmed design change.

| Step | Feature id | Backlog entries | Bump | Version | Status |
|------|------------|-----------------|------|---------|--------|

`Bump` takes `major`, `minor`, or `patch`, with `minor` as the default. At each step's P0, the agent applies the bump to the roadmap branch's version. The existing downgrade block applies.

### Message prefixes

| Set | Prefix |
|-----|--------|
| Roadmap | `R-A Chart:` |
| Roadmap | `R-B Activate:` |
| Roadmap | `R-C Run:` |
| Roadmap | `R-D Advance:` |
| Roadmap | `R-E Delivery:` |
| Phase | `P0 Discovery:` |
| Phase | `P1 Plan:` |
| Phase | `P2 Implement:` |
| Phase | `P3 Validate:` |
| Phase | `P4 Ship:` |

Both sets use the form `{prefix} {Status}: {one-liner}`. The `R-A` to `R-E` labels are stage letters, not phase numbers, so Hard Limit 10 still holds.

### Driver

`planifest-zero/scripts/roadmap-run.mjs` loops these steps:

1. Read `plan/current-roadmap/roadmap.md`. Stop if `status` isn't `active`.
2. Take `plan/.roadmap-runner.lock`. Refuse to start if the lock exists.
3. Run `claude -p --permission-mode auto "Run roadmap step {position}"` and wait for it to exit.
4. Stop if the build log ends on a `Blocked:` line with no later `Resolved:` line, or if `position` didn't move.
5. Repeat until R-E Delivery, then release the lock.

The driver prints one line per stage, so a parent Claude session can stream it with Monitor. A foreground Bash call times out after 10 minutes, so a Claude session must run the driver as a background task. The parent session must not edit the working tree while the driver runs.

### Session start

Resume detection checks `plan/current-roadmap/` before `plan/current/`:

- If a roadmap is `active` and `plan/current/` holds artifacts, resume that step through normal resume detection.
- If a roadmap is `active` and `plan/current/` is empty, start the step at `position`.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security:
  - merge-guard, a PreToolUse hook on Bash, blocks `gh pr merge` unless the PR's base is `roadmap/*` and the flag is `--squash`.
  - The exception stops in the 0000042 run-mode ADR apply to every step, including the credential stop.
  - Data classification: no regulated data. The pack holds no secrets.
- Data privacy: no regulated data
- Observability: the driver prints one line per stage. Each step's build log records `R-C Run:` and `R-D Advance:` lines.
- Cost boundary: not constrained. The P3 acceptance run makes six full pipeline runs, and the CRUD app stays small to limit cost.

## Engineering Layer
- Stack: Markdown skills, Node ESM scripts and hooks, Bash and PowerShell setup, Bash tests, GitHub Actions CI. Build target: local.
- Components: `planifest-zero`, the component pack of skills, hooks, templates, standards, and scripts.
- Data ownership: `planifest-zero` owns `plan/roadmap/` and `plan/current-roadmap/`.
- Deployment: copied into consumer repos by `setup.sh` and `setup.ps1`.
- API versioning: not applicable

## Component Paths
- `planifest-zero/`
- `planifest-overrides/`
- `docs/`
- `.github/`

Added at P3. These are the confirmed component's paths, so gate-write can match them. P2 subagents wrote through Bash when gate-write blocked them, because this section was missing.


## Scope
- In:
  - Roadmap drafts, `roadmap-entry.template.md`, and shared ids
  - R-A Chart to R-E Delivery and their prefixes
  - `plan/current-roadmap/`
  - Self-confirmed P0 for roadmap steps, with a per-step bump
  - Chart-time approval of predicted schema changes, with an opt-in fallback for unpredicted additive changes
  - PR against `roadmap/*`, squash merge after green CI, tag after merge
  - merge-guard, registered by `setup.sh` and `setup.ps1`
  - `roadmap-run.mjs` with a lock file, offered by R-B Activate
  - Carve-out text in `custom-001-local-git-only.md`, `custom-004-ship-push-and-raise-pr.md`, and the orchestrator's merge rule
  - Acceptance test in a throwaway repo in the `planifest` organisation
- Out:
  - A local-git merge path for repos with no remote
  - Merging the roadmap PR into `main`
  - More than one active roadmap per working tree
  - Scheduled cloud routines as a chain runner
- Deferred:
  - Workflow quality gates (backlog 0000100). Nothing is blocked.
  - Subagent acceleration (backlog 0000110). Nothing is blocked.

## Assumptions
- `claude -p` in a child process inherits the repo's hooks and the user's auth - impact if wrong: the driver can't run steps, and the chain runner needs another launch method.
- `--permission-mode auto` lets a step finish with no prompt - impact if wrong: steps stall or end early, and the driver stops on a stalled `position`.
- The test repo allows squash merges and merge commits - impact if wrong: R-D Advance or the final merge fails, and the test repo settings need changing.
- A Bash hook can read a PR's base before the merge runs - impact if wrong: merge-guard must call `gh pr view` itself, which adds a network call per merge.

## Risks
- The agent merges into the wrong base. Likelihood: low. Impact: high. Mitigation: merge-guard, plus `main` branch protection in the test repo.
- A child session prompts for permission and stops. Likelihood: medium. Impact: medium. Mitigation: the driver detects a stalled `position` and stops with the step named.
- A parent Claude session edits the working tree while the driver runs. Likelihood: medium. Impact: high. Mitigation: the lock file, and Activate's instructions to the parent session.
- The human squash-merges the roadmap PR and orphans the step tags. Likelihood: medium. Impact: low. Mitigation: the PR body asks for a merge commit.
- The acceptance run costs more tokens than expected. Likelihood: high. Impact: low. Mitigation: a small CRUD app and four short steps.

## Dependencies
- Upstream: 0000042 run modes and exception stops, the backlog model, the park model, and the ship skill's PR step.
- Downstream: backlog 0000100 and 0000110 may build on roadmaps.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - roadmap-drafts | planifest-implement | Template, folder, and shared-id rules with grep tests |
| REQ-002 - roadmap-chart | planifest-implement | New orchestrator stage with pickup and coaching rules |
| REQ-003 - roadmap-activate | planifest-implement | Orchestrator stage with branch, preflight, and driver offer |
| REQ-004 - roadmap-step-discovery | planifest-implement | Self-confirmed P0 and per-step bump in the orchestrator |
| REQ-005 - roadmap-advance | planifest-implement | Ship skill changes for base, squash merge, and tag timing |
| REQ-006 - merge-guard-hook | planifest-implement | New Node hook with unit tests and setup registration |
| REQ-007 - roadmap-driver | planifest-implement | New Node script with lock and stop rules, tested with a stub `claude` |
| REQ-008 - roadmap-delivery | planifest-implement | Archive and roadmap PR in the ship skill |
| REQ-009 - roadmap-resume-and-prefixes | planifest-implement | Resume detection and prefix tables in the orchestrator and `pipeline-reference.md` |
| REQ-010 - merge-carve-out-governance | planifest-implement | Prose changes to the orchestrator merge rule, `custom-001`, and `custom-004` |
| REQ-011 - chart-time-schema-approval | planifest-implement | Chart and step rules in the roadmap standard, the template table, and grep tests. Added at P3 |

P1 may split these further to meet the three-criteria limit per requirement.

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging PRs are human-only. Commit after every meaningful artifact. This run adds the `roadmap/*` merge carve-out.
- `custom-002-prefer-subagent-decomposition.md`: split long or multi-unit tasks into parallel subagents by default, and state the reason when a task cannot be split.
- `custom-003-git-up-to-date-shorthand.md`: "GUTD" means check out `main`, pull, and list untracked files.
- `custom-004-ship-push-and-raise-pr.md`: at ship, push the branch and tag, and raise the PR without asking. Never merge.
- `custom-005-delete-redundant-local-branches.md`: delete a local branch whose PR merged or whose upstream is gone, with `git branch -D`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 23 Oct 2026 @ 11:47 p.m. BST
