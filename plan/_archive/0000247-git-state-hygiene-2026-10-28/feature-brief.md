---
title: "Feature Brief - git state hygiene"
summary: "Adds three rules that keep a step or subagent from changing git state it does not own: staging by path, committing id reservations at once, and no stash in a parallel batch."
status: "approved"
version: "0.1.0"
---
# Feature Brief - git state hygiene

**Feature ID:** 0000247-git-state-hygiene

Source: backlog entries 0000213, 0000224, and 0000231, pulled in by initiative 0000238 step 9. The entry folders are deleted in this run's commit after the brief.

## Business Goal

Three runs of initiative 0000195 changed git state they did not own. A step staged queued backlog entries. A session left an id reservation uncommitted, and another branch reused the id. A subagent stashed the uncommitted work of its siblings. Each case cost rework. The pack now sets a rule for each.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Stage by path in an initiative | As a maintainer, I see a step leave queued backlog entries untracked, so that each entry lands in its own commit. | must-have | 1 |
| Commit id reservations at once | As a maintainer, I find each id reservation in a commit as soon as it is made, so that a session on another branch never reuses the id. | must-have | 1 |
| No stash in a parallel batch | As a maintainer, I see subagents in a parallel batch leave git state alone, so that no subagent loses its siblings' uncommitted work. | must-have | 1 |

## Wanted outcome

- A step of an active initiative leaves queued backlog entries untracked, and a test fails if the rule is missing from the orchestrator skill or the ship skill.
- A test runs `reserve-id.mjs --commit` in a temp repo and finds the counter change in a new commit that holds `plan/backlog/.next-id` alone. A test reads the commit rule in the initiative, retrospective, and postmortem skills.
- A test checks that `agent-dispatch-standards.md` forbids `git stash` in a subagent during a parallel batch, states the reason, and keeps the parent's resume stash. Each prompt in the parallel dispatch skeleton forbids `git stash`.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the skills, the standards, the `reserve-id.mjs` script, and the tests |

### Data Ownership

No data store. The component owns the pack files and the `plan/backlog/.next-id` counter.

### Integration Points

`reserve-id.mjs --commit` calls `git` in the working directory.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node 20 script and Bash tests already in the pack |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A staging rule in `ravintio-orchestrator/SKILL.md` and `ravintio-ship/SKILL.md`.
- A `--commit` flag on `reserve-id.mjs`, and a commit rule in the initiative, retrospective, and postmortem skills.
- A `git stash` rule in `agent-dispatch-standards.md` and in the skeleton prompts.
- Three tests, docs, and the version bump.

### Out of Scope
- A change to `merge-guard`, `gate-write`, or another fail-closed hook.
- A PowerShell twin of `reserve-id.mjs`. The script is Node.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |
| Orchestrator skill size | 9,000 bytes or fewer | `test-0000151-req-011-orchestrator-references-split.sh` |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.

### Assumptions
- `git commit -- plan/backlog/.next-id` commits that path alone, even when other paths are staged. Impact if wrong: the commit holds extra files. The test checks it.

## Scenario Paths

**Happy path:** A step reserves ids with `--commit`, and the counter change sits in its own commit.

> The test reads the new commit's file list.

**First-run path:** `--commit` runs where the counter file is new and untracked.

> The commit adds the file.

**Error / sad path:** `--commit` runs outside a git repository, or the commit fails.

> The script prints one line to stderr and exits 1. The ids stay reserved in the counter, so none is reused.

**Cross-session continuity:** The reservation sits in a commit, so a session on another branch sees it after a merge.

> A git conflict on `.next-id` follows the existing rule in the roadmap standards.

## Acceptance Criteria

- [ ] The orchestrator and ship skills tell a step in an active initiative to stage by explicit path and leave other `plan/backlog/` entries untracked.
- [ ] `reserve-id.mjs --commit` commits `plan/backlog/.next-id` alone.
- [ ] The initiative, retrospective, and postmortem skills tell the agent to reserve with `--commit`.
- [ ] `agent-dispatch-standards.md` forbids `git stash` in a subagent during a parallel batch, with the reason.
- [ ] Each skeleton prompt forbids `git stash`, and the resume section still stashes.
