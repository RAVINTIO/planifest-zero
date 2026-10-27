---
title: "Feature Brief - initiative skill"
summary: "Add a ravintio-initiative skill that coordinates an initiative from chart to delivery, and fix three initiative driver bugs."
status: "approved"
version: "0.1.0"
---
# Feature Brief - initiative skill

**Feature ID:** 0000205-initiative-skill

## Business Goal

Nothing coordinates an initiative from start to finish. The orchestrator coordinates one feature, and the driver starts one step session after another. The human's session has no defined role, so roadmap 0000168 showed five problems: no final report, strict-mode warnings in the human's session, an unsafe resume of a running step, no progress view, and backlog entries that landed in a step PR. The driver also missed a `Blocked:` line in an archived build log, advanced before the merge, and lost step subagents after 10 minutes. Source: backlog entry 0000182.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Initiative skill | As the human on the loop, I talk to one `ravintio-initiative` session that charts, activates, watches, and delivers an initiative, so that I know what each step is doing. | must-have | 1 |
| Progress reports | As the human on the loop, I get a report at least every 5 minutes, at each phase end, and on request, so that I see progress without asking. | must-have | 1 |
| Separate ack files | As the human on the loop, I see strict mode stay quiet in my session and in every step session, so that no session overwrites another's ack. | must-have | 1 |
| Safe driver | As the human on the loop, I see the driver stop on an archived `Blocked:` line, advance only after the merge, and keep step subagents running, so that no step is lost. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, hooks, standards, scripts, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js and Bash |
| Testing | Bash test scripts under `ravintio-zero/tests/` |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- A `ravintio-initiative` skill that owns I-A Chart, I-B Activate, progress reports, backlog queueing, and I-E Delivery. The orchestrator and ship skills keep I-C Run and I-D Advance.
- Split resume detection: the orchestrator never resumes an initiative, and the initiative skill never resumes a step.
- Split ack files: `plan/.initiative-ack` for the initiative skill and `plan/.orchestrator-ack` for a step session. The strict-mode hook accepts either.
- The auto-trigger hook loads the initiative skill for initiative work and the orchestrator for feature work.
- A read-only watch script that prints one line per event and a heartbeat every 5 minutes, for a Claude Code monitor.
- Driver fixes: read the newest archived build log, advance only after the merge, set `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` unless already set, and print a final report that names each step.
- The three-part table and run sequence in `ravintio-zero/standards/roadmap-standards.md` and `ravintio-zero/project-operations.md`.
- The docs and tests that count skills.

### Out of Scope
- Chart-time decisions from past stops, which backlog entry 0000186 covers.
- Changing how a step session builds a feature (P0 to P4).
- A Claude Code monitor implementation. The skill starts the watch script with the host's monitor tool.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Skill size | The new skill file stays under 120 lines | A test counts the lines |
| Report cadence | At least one report every 5 minutes while the driver runs | The watch script heartbeat interval is 300 seconds |

## Constraints and Assumptions

### Constraints
- Node built-ins only. No new dependency. No schema change.
- The skill file and scripts pass the pack prose and em dash guards.
- The merge-guard hook stays as it is. No change weakens a guard.

### Assumptions
- The skill text budget in test 0000031 and the skill counts in four tests change with the new skill, and the tests state the new values.
- The driver that runs this initiative started before this step, so its own behaviour does not change until it restarts.

## Scenario Paths

**Happy path:** The human asks for an initiative. The initiative skill charts it, cuts the branch, starts the driver and the watch script, and reports. When the driver exits, the skill archives the initiative, raises the PR to `main`, and gives the final report with the PR URL.

> Self-confirmed (initiative).

**First-run path:** A repo with no earlier initiative has no driver lock and no queue folder. The skill creates `plan/.initiative-queue/` on the first queued entry and says no earlier initiative exists.

> Self-confirmed (initiative).

**Error / sad path:** If a step ends with a `Blocked:` line, in `plan/current/` or in the newest archive, the driver stops and the skill reports the stop with the step log path. The skill never resumes the step.

> Self-confirmed (initiative).

**Cross-session continuity:** If the human's session ends, a new session finds an active initiative. If the driver lock is held, the skill reports and watches. If the lock is free, the skill offers to restart the driver. State lives in `initiative.md`, the build logs, and git.

> Self-confirmed (initiative).

## Acceptance Criteria

- [ ] The `ravintio-initiative` skill exists, owns I-A Chart, I-B Activate, and I-E Delivery, and names the reports it gives.
- [ ] The orchestrator resumes no initiative, and the initiative skill resumes no step.
- [ ] The strict-mode hook stays quiet when `plan/.initiative-ack` or `plan/.orchestrator-ack` holds the session id.
- [ ] The auto-trigger hook loads the initiative skill when an initiative is active and no step runs, and the orchestrator otherwise.
- [ ] The watch script prints an event line for a new phase `Complete:`, `Blocked:`, or `Resolved:` line, a stale-log line after 15 minutes, and a heartbeat every 5 minutes.
- [ ] A `Blocked:` line in the newest archived build log stops the driver.
- [ ] The driver moves on only after the merge commit exists on the initiative branch.
- [ ] Each step session's environment holds `CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS=0` unless the parent set it.
- [ ] A driver run with a stub step session prints a final report that names each step.
- [ ] `roadmap-standards.md` and `project-operations.md` hold the three-part table and the run sequence.
