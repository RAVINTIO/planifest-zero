---
title: "Requirement: req-011 - exception-stop-records-and-redaction"
summary: "Exception stops leave a build-log record, acceptance evidence carries no raw output, and a credential stops the run."
status: "draft"
version: "0.1.0"
---
# Requirement: req-011 - exception-stop-records-and-redaction

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-001, US-002, security findings F-002, F-003, and F-004
**Priority:** must-have

## User Story

As a human on the loop, I want an autonomous run to keep its stops and its secrets safe, so that a restart or a public PR never bypasses me.

## Functional Requirements
- At every exception stop, the agent appends `Blocked: {exception} ({ISO-8601 timestamp})` to the build log and commits it before the stop.
  - When the human resolves the stop, the agent appends `Resolved: {exception} ({ISO-8601 timestamp}, {decision})`.
  - On resume, a `Blocked:` line with no later `Resolved:` line shows the stop again. The run does not move on in either mode.
- Acceptance evidence lists results, counts, and `file:line` cites only.
  - It never holds raw command output, environment values, or file contents.
  - Before `gh pr create`, ship scans the PR body for credential patterns. A match is a credential exception stop.
- A possible credential is a fifth exception stop in both modes.
  - The agent stops before the commit and before any push.
  - The message is `{prefix} Blocked: possible credential in {path}. Remove it or confirm it is not a secret.`

## Acceptance Criteria
- [ ] (a) The orchestrator logs each exception stop with a `Blocked:` line and a later `Resolved:` line. Resume refuses to pass an unresolved `Blocked:` line.
- [ ] (b) Validate-and-accept forbids raw output, environment values, and file contents in acceptance evidence. Ship scans the PR body for credentials before `gh pr create`.
- [ ] (c) The Exception Stops table has a fifth row for a possible credential. It stops before the commit and any push.

## Dependencies
- REQ-002 defines the exception stops that this requirement extends.
- REQ-003 defines the resume rule that this requirement extends.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md`
  - `planifest-zero/skills/planifest-validate-and-accept/SKILL.md`
  - `planifest-zero/skills/planifest-ship/SKILL.md`
  - `planifest-zero/pipeline-reference.md`, `planifest-zero/workflows/feature-pipeline.md`, and `docs/architecture-overview.md`
