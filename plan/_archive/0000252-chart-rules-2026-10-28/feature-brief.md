---
title: "Feature Brief - chart rules"
summary: "Adds three chart rules: a guard-widening check, a plan for each step confirmation, and a record of whether a step may skip P1."
status: "approved"
version: "0.1.0"
---
# Feature Brief - chart rules

**Feature ID:** 0000252-chart-rules

Source: backlog entries 0000223, 0000225, and 0000234, pulled in by initiative 0000238 step 14. Their entry folders are deleted in the commit after this brief.

## Business Goal

Initiative 0000195 showed three gaps at chart. A first draft widened a fail-closed guard and only the human's review caught it. A chore step stopped for a confirmation that chart never listed, and the branch sat idle for about five hours. Three steps skipped P1 with no chart row that allowed it. Chart gets one rule for each gap, so the human decides each one at chart and no step session decides it alone.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Check each entry against the guards | As a maintainer, I see chart name the guard and the new forms when an entry widens what a fail-closed hook lets through, and ask me to approve each widening on its own, so that no chart weakens a guard unseen. | must-have | 1 |
| Plan each step confirmation | As a maintainer, I see chart list each confirmation that a step's skills ask for and record a pre-approval with the exact command or plan a human stop, so that no step session waits for an answer that nobody gives. | must-have | 1 |
| Record whether a step may skip P1 | As a maintainer, I see chart record a `yes` or `no` and a reason for P1 per step, and a step with no `yes` row stop when it would skip P1, so that no step skips a phase alone. | must-have | 1 |

## Wanted outcome

- A test reads the guard-widening rule in the I-A Chart section of `roadmap-standards.md`. The rule names `merge-guard`, `gate-write`, and `ratchet-check`, covers any other fail-closed hook, and needs a separate human approval for each widening entry. The same rule appears in the initiative skill.
- A test reads the confirmation rule in the I-A Chart section. The `## Decisions` table in the initiative template has a row form for a step confirmation.
- The initiative template has a P1 skip field per step with a reason. The roadmap standard states which steps chart may mark as skippable. A step with no `yes` row stops with `I-C Run: Blocked`. A build log line for a skipped P1 names the chart row.
- Every hook suite in `ravintio-zero/tests/` passes unchanged, and no file under `ravintio-zero/hooks/` changes.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the standards, the template, the skills, and the tests |

### Data Ownership

No data store. The component owns the pack files.

### Integration Points

None. The change adds text to Markdown files and tests that read them.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown for the rules. Bash for the tests |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- A guard-widening rule in the I-A Chart section of `roadmap-standards.md` and in the initiative skill.
- A confirmation rule in the I-A Chart section, and a confirmation row form in the `## Decisions` table of the initiative template.
- A `## P1 skips` section in the initiative template, a rule on which steps chart may mark `yes`, a stop rule for a step with no `yes` row, and a build log line rule.
- Tests, component docs, and the version bump.

### Out of Scope
- A change to any hook, including `merge-guard`, `gate-write`, and `ratchet-check`.
- A change to the driver or the watcher.
- A change to the `## Steps` table, which the driver parses.
- Rewriting the active initiative's own `initiative.md`.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |
| Orchestrator `SKILL.md` size | 9,000 bytes or fewer | `test-0000151-req-011-orchestrator-references-split.sh` |

## Constraints and Assumptions

### Constraints
- No file under `ravintio-zero/hooks/` changes.

### Assumptions
- The driver reads only the `## Steps` table of `initiative.md`, so a new section is safe.

## Scenario Paths

**Happy path:** The human charts an initiative. Chart flags a widening entry, lists a skill confirmation, and fills the `## P1 skips` table. The human approves each, and the steps run with no stop.

> A chart that follows the three rules asks the human three kinds of question and records each answer in `initiative.md`.

**First-run path:** An initiative charted before this release has no `## P1 skips` section.

> Such a step with no `yes` row stops with `I-C Run: Blocked` if it would skip P1. A missing table counts as an empty one.

**Error / sad path:** The human declines a widening, or a confirmation has no command to pre-approve.

> Chart strikes the entry or plans a human stop for that step.

**Cross-session continuity:** A step session restarts after a stop.

> It reads the `## P1 skips` table from `initiative.md` again. No state lives outside the file.

## Acceptance Criteria

- [ ] The guard-widening rule names three guards, covers any other fail-closed hook, and needs a separate approval.
- [ ] The confirmation rule and the template row form exist.
- [ ] The P1 skip field, the skippable-step rule, the stop rule, and the build log line rule exist.
- [ ] No hook file changes and every hook suite passes unchanged.
