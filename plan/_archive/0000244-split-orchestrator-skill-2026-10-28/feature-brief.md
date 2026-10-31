---
title: "Feature Brief - split the orchestrator skill"
summary: "Move the task-bound orchestrator sections into reference files so the core SKILL.md is 9,000 bytes or fewer."
status: "approved"
version: "0.1.0"
---
# Feature Brief - split the orchestrator skill

**Feature ID:** 0000244-split-orchestrator-skill

> Built from backlog entry 0000236 by initiative 0000238 step 6. Entry folder deleted in the same commit.

## Business Goal

Every session that loads the orchestrator reads all 23,912 bytes of `SKILL.md`, whatever the task. Six task-bound sections make up 15,849 bytes of that. After this step the core holds only what every session needs, in 9,000 bytes or fewer, and no rule is lost. Entries 0000222 and later steps need the headroom.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Move task-bound sections | As a pack maintainer, I want the six task-bound sections in reference files, so that a session reads them only when it needs them | must-have | 1 |
| Move initiative prefixes | As a pack maintainer, I want the I-A to I-E prefix block in `roadmap-standards.md`, so that only initiative work reads it | must-have | 1 |
| Shorten the Pack Index | As an agent, I want one rule for template reads and one row per reference file, so that the index names each trigger | must-have | 1 |
| Update the tests | As a pack maintainer, I want the size test and the tests that grep `SKILL.md` to read the new locations, so that the suite passes with a 9,000 byte cap | must-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack skills, standards, setup, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Orchestrator skill and references | ravintio-zero | none |

### Integration Points

`setup.sh` installs every file under `references/`. No code changes.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Markdown, Bash tests |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Move How You Coach, Discovery Start Actions, Discovery Gate Checklist, Design Confirmation, Phase Invocation, and Exception Stops into new `references/orchestrator-*.md` files, line for line.
- Move the initiative stage prefix block to `roadmap-standards.md`, and keep one pointer line in `SKILL.md`.
- Replace the Pack Index template rows with one rule, keep the non-template rows, and add one row per new reference file with its trigger.
- Set the `SKILL.md` cap to 9,000 bytes and update `test-0000151-req-011-orchestrator-references-split.sh` and every test that greps a moved line.

### Out of Scope
- The combined `CLAUDE.md` plus `SKILL.md` cap (entry 0000214, done) and the size of `CLAUDE.md` (entry 0000222, step 7).
- Any wording change to a moved line.
- Changes to `merge-guard`, `gate-write`, or another fail-closed hook.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Size | `SKILL.md` is 9,000 bytes or fewer | `wc -c` in the size test |
| Fidelity | Every non-blank, non-heading base line is in `SKILL.md`, a reference file, or `roadmap-standards.md` | Existing no-lost-line check |

## Constraints and Assumptions

### Constraints
- No new dependency. No weakening of any hook. Lines move verbatim.
- The skill line cap of 1,720 lines still holds. Moving text out only lowers the count.

### Assumptions
- The orchestrator still points at each moved section, so a session finds it. Impact if wrong: the Pack Index test shows it.

## Scenario Paths

**Happy path:** A session loads the 9,000 byte core, then reads one reference file when the Pack Index trigger fires.

> Load core, read on trigger.

**First-run path:** A fresh P0 start reads the discovery start reference before the first coaching question.

> Trigger names the moment.

**Error / sad path:** A moved line goes missing. The no-lost-line check fails and names the line.

> Loss is caught by test.

**Cross-session continuity:** Resume Detection stays in the core, so a resumed session finds its phase.

> Not applicable beyond that.

## Acceptance Criteria

- [ ] `SKILL.md` is 9,000 bytes or fewer, and the size test asserts that cap.
- [ ] Every non-blank, non-heading line of the base fixture is in `SKILL.md`, a `references/orchestrator-*.md` file, or `roadmap-standards.md`.
- [ ] Each moved section's heading appears in exactly one reference file and not in `SKILL.md`.
- [ ] The Pack Index has one row for every file in `references/`, and each row names its trigger.
- [ ] `SKILL.md` keeps the headings Hard Limits, Phases and Response Prefixes, Resume Detection, and Pack Index (JIT Loading).
- [ ] Setup installs every new reference file, and each installed copy matches its source.
- [ ] The full test suite passes with no other cap raised.
