---
title: "Feature Brief - session start detection"
summary: "Run Resume Detection signals as a tested script at session start, and shrink the Resume Detection section of the orchestrator skill."
status: "approved"
version: "0.1.0"
---
# Feature Brief - session start detection

**Feature ID:** 0000243-session-start-detection

> Built from backlog entry 0000237 by initiative 0000238 step 5. Entry folder deleted in the same commit.

## Business Goal

The orchestrator carries out 12 Resume Detection checks by hand from a 4,324-byte section of `SKILL.md`. Most checks only test whether a file or a build log line exists. An agent can skip or misread one, and no test covers that reading. After this step a script reports the signals, the session start hook injects them, and `SKILL.md` keeps a rule of 400 bytes or fewer. Entry 0000236 (step 6) depends on the space this frees.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Signal script | As a pack maintainer, I want a script that prints one fixed line per resume signal, so that tests cover what the agent reads | must-have | 1 |
| Hook injection | As an agent starting a session, I want the findings in context before any skill loads, so that I act on a tested list | must-have | 1 |
| Short rule and reference | As a pack maintainer, I want Resume Detection in `SKILL.md` cut to a short rule that points at a reference file, so that the skill has room to shrink | must-have | 1 |
| Initiative skill findings | As a person running an initiative, I want the initiative skill to use the same findings, so that driver lock and position checks are tested too | should-have | 1 |

## Waves

One wave. All features ship together.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Pack scripts, hooks, skills, standards, tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| Resume signal script and reference | ravintio-zero | none |

### Integration Points

The hook `auto-trigger-orchestrator.mjs` runs the script as a child process with a timeout. The script reads repo files and writes nothing.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM), Bash tests |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- `ravintio-zero/scripts/resume-detect.mjs`, one fixed line per signal, in the order of the current 12 checks.
- `auto-trigger-orchestrator.mjs` runs it and injects the lines with the load instruction. A failure or timeout injects `resume detection did not run`.
- `references/orchestrator-resume-detection.md` holds every line of the current section. `SKILL.md` Resume Detection becomes 400 bytes or fewer and the Pack Index names the reference.
- The initiative skill reads the same findings, including the driver lock and the initiative position.
- Tests for the conditions in the entry's Wanted outcome.

### Out of Scope
- Splitting the rest of the orchestrator `SKILL.md` (step 6).
- Changes to `merge-guard`, `gate-write`, or any other fail-closed hook.
- Any change to the strict-mode hook beyond keeping its initiative rule in step.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Safety | The script prints no part of any repo file's text | Fixture with instruction text in `pause.md` and the build log |
| Latency | The script finishes in 2 seconds or fewer on a repo fixture | Timeout in the hook, tested |

## Constraints and Assumptions

### Constraints
- No new dependency. No weakening of any hook. Hook output reaches the agent as system context, so it carries fixed text, ids, and repo-relative paths only.

### Assumptions
- The 12 checks in `SKILL.md` stay the source of the order. Impact if wrong: the order test fails and shows it.

## Scenario Paths

**Happy path:** The hook runs the script, injects its lines, and the agent acts on each finding in order, reading that check's section in the reference.

> Script, inject, act.

**First-run path:** A fresh repo prints `no resume signals`.

> One line.

**Error / sad path:** The script exits non-zero or times out. The hook still injects the load instruction and `resume detection did not run`, and the skill runs every check from the reference.

> A failed run never reads as no signals.

**Cross-session continuity:** The script is stateless and reads the files that survive a session.

> Not applicable.

## Acceptance Criteria

- [ ] For each of the 12 checks, a fixture with the signal prints its line and a fixture without it does not.
- [ ] Findings print in the order of the current checks, and a fixture with no signals prints `no resume signals`.
- [ ] A fixture whose `pause.md` or build log holds instruction text prints no part of that text.
- [ ] If the script fails or times out, the hook output holds the load instruction and `resume detection did not run`.
- [ ] A step session and an initiative session get the same findings with the right skill name.
- [ ] Resume Detection in `SKILL.md` is 400 bytes or fewer, the Pack Index names the reference, and the reference holds every line of the old section.
