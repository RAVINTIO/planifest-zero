---
title: "Feature Brief - autonomous-roadmaps"
summary: "Roadmap plans that chain backlog-driven features on a long-running roadmap branch, run autonomously from R-A Chart to R-E Delivery."
status: "approved"
version: "0.10.0"
---
# Feature Brief - autonomous-roadmaps

**Feature ID:** 0000043-autonomous-roadmaps

## Business Goal

A pipeline run delivers one feature, and a human must start every run. Work that spans several features has no home in `plan/` and no way to run end to end. This feature adds roadmap plans that order backlog entries into steps. The agent then runs every step to a squash merge on a roadmap branch, and the human merges one roadmap PR into `main`.

Pulls in backlog entries 0000098 (roadmap area in plan) and 0000099 (autonomous multi-release initiative).

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Roadmap drafts | As a human on the loop, I file a draft roadmap in `plan/roadmap/` on any branch, so that long-term intent has a home. | must-have | 1 |
| R-A Chart | As a human on the loop, I chart a roadmap from an idea or a draft, so that I approve the whole chain once. | must-have | 1 |
| R-B Activate | As a human on the loop, I activate a charted roadmap, so that its branch and state exist and the driver can start. | must-have | 1 |
| R-C Run | As a human on the loop, I let each step run P0 to P4 with no coaching stops, so that the chain runs without me. | must-have | 1 |
| R-D Advance | As a human on the loop, I let the agent squash-merge a green step into the roadmap branch and tag it, so that the next step builds on it. | must-have | 1 |
| R-E Delivery | As a human on the loop, I receive one roadmap PR to `main`, so that I review and merge the whole chain once. | must-have | 1 |
| Driver script | As a human on the loop, I start one driver that runs each step in a fresh session, so that context stays clean across steps. | must-have | 1 |
| Merge guard | As a human on the loop, I rely on a hook that blocks any agent merge outside `roadmap/*`, so that `main` stays human-only. | must-have | 1 |

## Waves

One wave. The human chose one feature over the recommended split, so the whole flow can be tested together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| planifest-zero | component-pack | existing | Skills, hooks, templates, standards, and scripts for the pipeline |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| `plan/roadmap/`, `plan/current-roadmap/` | planifest-zero | none |

### Integration Points

| From | To | Method | Contract |
|------|-----|--------|----------|
| driver script | Claude Code CLI | process | `claude -p --permission-mode auto`, one session per step |
| ship skill | GitHub | `gh` CLI | `gh pr create --base roadmap/*`, `gh pr checks`, `gh pr merge --squash` |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown skills, JavaScript (Node ESM), Bash, PowerShell |
| Runtime | Node |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | Bash test scripts under `planifest-zero/tests/` |
| IaC | none |
| Cloud | none |
| Compute | local |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `plan/roadmap/{id}-{slug}/roadmap.md` drafts and `roadmap-entry.template.md`, with ids shared with the backlog sequence
- R-A Chart to R-E Delivery stages and their `R-A` to `R-E` prefixes
- `plan/current-roadmap/` for the active roadmap and its state
- Self-confirmed P0 for roadmap steps, with a per-step version bump
- PR against `roadmap/*`, squash merge after green CI, and tag after merge
- `merge-guard` PreToolUse hook, registered by `setup.sh` and `setup.ps1`
- `roadmap-run.mjs` driver with a lock file, offered by R-B Activate
- Acceptance test in a throwaway repo in the `planifest` organisation

### Out of Scope
- A local-git merge path for repos with no remote
- Merging the roadmap PR into `main`, which stays human-only
- Running more than one active roadmap per working tree
- Scheduled cloud routines as a chain runner

### Deferred
- Workflow quality gates (backlog 0000100). Nothing is blocked.
- Subagent acceleration (backlog 0000110). Nothing is blocked.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Autonomy | Zero human prompts between R-B Activate and R-E Delivery in a clean four-step roadmap | Count of human inputs in the P3 acceptance run |
| Safety | Zero agent merges into any base other than `roadmap/*` | merge-guard tests plus the acceptance run's PR history |
| Recoverability | A stopped driver resumes the same step on restart with no manual state edits | Acceptance run: stop the driver mid-step, then restart it |

## Scenario Paths

**Happy path:**

> Chart a four-step roadmap from `main` and activate it. The driver runs each step in its own session to a squash merge and tag. The run ends with one roadmap PR to `main`.

**First-run path:**

> With no roadmap folder or draft, Chart writes a new plan from the template with the next shared id. Chart stops on a missing backlog entry. Activate refuses without a remote or `gh` access.

**Error / sad path:**

> An exception stop in a step logs `Blocked:`, pushes, and exits. The driver stops when `position` does not move and leaves the roadmap `active`. The next run resumes that step. Red or pending CI at Advance is the same stop.

**Cross-session continuity:**

> All state lives in git. The next run resumes a step through normal resume detection, or starts the step at `position`. The roadmap update rides in the step's squash commit.

## Acceptance Criteria

- [ ] A draft roadmap filed on a feature branch reaches `main` with that branch's PR, and R-A Chart offers it for pickup.
- [ ] R-B Activate cuts `roadmap/{id}-{slug}` from `main`, writes `plan/current-roadmap/`, and deletes the draft in one commit.
- [ ] Each step's PR targets the roadmap branch, merges with a squash after green CI, and carries a tag on the squash commit.
- [ ] Each step's version follows the step's bump from the roadmap branch's version.
- [ ] merge-guard blocks `gh pr merge` for any base other than `roadmap/*` and allows it for `roadmap/*`.
- [ ] The driver runs each step in a fresh `claude -p` session and stops on `Blocked:` or a stalled `position`.
- [ ] R-E Delivery archives the roadmap and raises one PR to `main` that asks for a merge commit.
- [ ] In a throwaway repo, two normal features build a basic CRUD app, then a four-step roadmap runs from R-B Activate to R-E Delivery with no human input.
