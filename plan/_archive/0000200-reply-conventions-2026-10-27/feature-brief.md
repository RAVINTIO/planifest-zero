---
title: "Feature Brief - reply conventions"
summary: "Replies in an active run start with a valid prefix and report only what needs the human's attention."
status: "approved"
version: "0.1.0"
---
# Feature Brief - reply conventions

**Feature ID:** 0000200-reply-conventions

> Built from backlog entries 0000181 and 0000209 by initiative 0000195 step 5. The entry folders are deleted in the same commit.

## Business Goal

The human on the loop reads replies to learn which phase a session is in and what needs a decision. Two faults hurt that reading. Replies often lack the `P0 Discovery:` to `P4 Ship:` and `I-A Chart:` to `I-E Delivery:` prefixes, so the phase is unclear. This happened in a supervising session after the harness compacted its context. Replies also state that the agent followed a standing rule, such as leaving AI attribution out of a PR description. These lines add noise and hide the parts that need attention.

Only the orchestrator skill defines the prefixes today, and the harness truncates that skill on compaction. The boot file reloads at each session start and after each compaction. Putting the prefix table and one reporting rule in the boot file, restating the prefix in each phase skill, and adding a warning-only `Stop` hook makes both rules hold across a long session.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| State the prefix rule in every place a session reads | US-001: As the human on the loop, I see a valid phase or stage prefix on every reply in an active run, including after compaction and in a supervising session, so that I know which phase a reply belongs to. | must-have | 1 |
| Warn when a reply lacks a prefix | US-002: As the human on the loop, I get a warning when a reply in an active run lacks a valid prefix, and the misses are logged, so that I can measure how often the rule fails. | must-have | 1 |
| Report only what needs attention | US-003: As the human on the loop, I read replies that state results, deviations, failures, and decisions only, so that routine compliance with a standing rule does not hide what needs me. | must-have | 1 |

## Waves

One wave. The release holds three features.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All | The boot file, the five skills, and the hook carry the rules, and the hook test passes in both setup scripts |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Setup scripts, skills, hooks, standards, and tests |

### Data Ownership

`ravintio-zero` owns every file, including the new hook and its miss log. No datastore.

### Integration Points

The hook reads the Claude Code `Stop` hook payload on stdin. Setup writes its entry into `.claude/settings.json`.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js (ESM) and Bash and PowerShell |
| Runtime | node, bash, pwsh |
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
- The prefix table, the status form, and a prefix for out-of-phase work in `ravintio-zero/templates/standard-boot.md`.
- The reporting rule in the boot file and the orchestrator skill. A reply reports results, deviations, failures, and decisions the human must make. It does not report compliance with a standing rule, unless the rule blocked an action or the agent departed from it.
- A one-line prefix reminder in the opening lines of the plan, implement, validate-and-accept, and ship skills.
- A `Stop` hook `check-reply-prefix.mjs` that warns when a reply in an active run lacks a valid prefix, and logs each miss.
- Setup wiring for the hook in `setup.sh` and `setup.ps1`, the parity suite, the self-description in `component.yml`, and the docs that list the hooks.
- Tests for the hook and for the doc text.

### Out of Scope
- A hook that blocks a reply. The hook warns and exits 0.
- Checking the reporting rule by hook. Reply content cannot be tested reliably.
- Changing the existing phase and stage prefixes.
- Support for tools other than Claude Code.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Never blocks a turn | The hook exits 0 on every input, including a malformed payload and a missing transcript | A test feeds each case and asserts the exit code |
| Silent outside a run | The hook prints nothing when `plan/.orchestrator-active` is absent | A test runs the hook in a directory with no sentinel |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of the orchestrator apply. No schema change.
- The hook uses Node built-ins only.
- The hook exits 0 in every case, as the other hooks do for unexpected errors.

### Assumptions
- The `Stop` payload carries `transcript_path`, and the transcript is JSONL with the last assistant text reachable. If the payload shape differs, the hook exits 0 and stays silent. Impact if wrong: the warning never fires.
- The boot file reloads after compaction. The backlog entry states this.

## Scenario Paths

**Happy path:** In an active run, a reply that starts with `P2 Implement: Starting: write the hook` produces no warning.

> A valid prefix passes silently.

**First-run path:** In a repo with no `plan/.orchestrator-active`, the hook prints nothing and logs nothing.

> No run, no check.

**Error / sad path:** A reply that starts with plain text in an active run makes the hook print a warning, append one line to the miss log, and exit 0. A malformed payload exits 0 with no output.

> Warn, log, never block.

**Cross-session continuity:** The prefix table and the reporting rule sit in the boot file, so each session start and each compaction reloads them. The miss log accumulates across sessions.

> The boot file carries the rule, and the log carries the evidence.

## Acceptance Criteria

- [ ] The boot file holds the prefix table, the status form, an out-of-phase prefix, and the reporting rule.
- [ ] The plan, implement, validate-and-accept, and ship skills restate the prefix in their opening lines.
- [ ] A hook test feeds replies with and without a prefix and checks the warning and the log line.
- [ ] The hook exits 0 for a malformed payload and prints nothing when no run is active.
- [ ] `setup.sh` and `setup.ps1` wire the same `Stop` entry, and the parity suite passes.
- [ ] The orchestrator skill states that a reply never reports compliance with a standing rule.
