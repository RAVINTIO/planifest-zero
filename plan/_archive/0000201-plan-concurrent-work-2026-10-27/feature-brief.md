---
title: "Feature Brief - plan concurrent work"
summary: "Every execution plan lays out which work units run at once, which run in sequence, and why."
status: "approved"
version: "0.1.0"
---
# Feature Brief - plan concurrent work

**Feature ID:** 0000201-plan-concurrent-work

> Built from backlog entry 0000180 by initiative 0000195 step 6. The entry folder is deleted in the same commit.

## Business Goal

Runs are slower than they need to be because the plan does not say which work can run at once. The dispatch standard names units that may run in parallel, and `fast` run speed batches dispatch per phase. But the execution plan holds no list of units, dependencies, or batches. The orchestrator decides batch by batch and often falls back to a chain. In feature 0000039 of the RAVINTIO framework, the human had to ask "Can you use subagents to accelerate?" before independent work moved into one batch.

Adding a concurrency section to every execution plan, and a consistency check that fails a plan without it, makes the batches a planned decision. Sequential work then needs a stated reason.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Plan the batches | US-001: As the human on the loop, I see a concurrency plan in every execution plan, and in any re-plan after a reopened phase, so that I know which work runs at once before the work starts. | must-have | 1 |
| Default to concurrent, justify sequence | US-002: As the human on the loop, I get concurrent dispatch for any two units with no dependency and no shared write target, and a stated reason for each unit that runs in sequence, so that sequence is a decision and not a habit. | must-have | 1 |
| Check the plan | US-003: As the human on the loop, I get a consistency check that fails an execution plan with no concurrency section or with an unjustified sequential unit, so that no plan reaches the gate without batches. | must-have | 1 |

## Waves

One wave. The release holds three features.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All | The template, the plan and implement skills, the dispatch standard, and the consistency check carry the rule, and the new test passes |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, templates, standards, scripts, and tests |

### Data Ownership

`ravintio-zero` owns every file. No datastore.

### Integration Points

None. The consistency check reads `plan/current/execution-plan.md` from disk.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM) and Bash |
| Runtime | node, bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | pack shell test suites (`run-tests.sh`, `run-tests.ps1`) |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A `## Concurrency plan` section in `ravintio-zero/templates/execution-plan.template.md` and its guide. The section holds a table of units with their dependencies, write targets, batch, and the reason for any unit that runs alone.
- A plan skill rule: write the section, and rewrite it in any re-plan after a reopened phase. A line in `orchestrator-mid-pipeline-changes.md` points to it.
- A dispatch standard rule: concurrent by default when two units have no dependency and no shared write target, and a recorded reason when work runs in sequence. The implement skill dispatches by the plan's batches.
- A consistency check 8 in `consistency-check.mjs` that fails a plan with no section, a malformed table, a sequential unit with no reason, two units in one batch that share a write target, and a dependency on a later batch.
- The `component.yml` responsibility line, the docs that list consistency checks, and tests.

### Out of Scope
- A hook that blocks dispatch that departs from the plan.
- Changes to `fast` batches or to `plan/.run-speed`.
- Changing the unit of dispatch for phases other than P1 and P2.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Check runtime | the consistency check adds no network call and no model call | code review |

## Constraints and Assumptions

### Constraints
- Node built-ins only. No schema change. No new dependency.

### Assumptions
- Plans written before this release have no concurrency section, and the check applies only to the plan in `plan/current/`. Archived plans are untouched.

## Scenario Paths

**Happy path:** The plan skill writes `execution-plan.md` with a concurrency table. Units 1 and 2 share batch 1, unit 3 depends on both and sits in batch 2 with a reason. The consistency check passes and the implement phase dispatches batch 1 in one message.

> Plan skill writes the table, the check passes, implement dispatches by batch.

**First-run path:** A repo with no earlier plan runs the same flow. The template supplies the section, so the first plan has it.

> The template supplies the section from the first plan.

**Error / sad path:** The plan has no section, or a unit alone in its batch has an empty reason. The check prints a finding and exits 1. The plan skill fixes the table and re-runs the check.

> The check prints a finding that names the unit and exits 1.

**Cross-session continuity:** The table lives in `execution-plan.md`, a tracked file in `plan/current/`. A session that resumes reads the batches from the file. A reopened phase rewrites the table, and the check runs again.

> The batches survive a session change in `execution-plan.md`.

## Acceptance Criteria

- [ ] The execution plan template and guide hold a concurrency section with the unit table.
- [ ] The plan skill requires the section in each plan and each re-plan, and the dispatch standard states the default and the reason rule.
- [ ] The consistency check fails a plan with no section, a missing sequential reason, a shared write target in one batch, or a dependency on a later batch.
