---
title: "Requirement: req-002 - gate-and-exception-stops"
summary: "Gated runs stop at the P1 to P4 gates, autonomous runs stop at none, and both modes stop on four exceptions."
status: "draft"
version: "0.1.0"
---
# Requirement: req-002 - gate-and-exception-stops

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a human on the loop, I want each run mode to stop at known points, so that I know when the agent waits for me and when it blocks on a problem.

## Functional Requirements
- In `gated`, the run stops for human confirmation at the P1, P2, P3, and P4 gates.
  - The P4 gate comes before the PR, as today.
- In `autonomous`, the run stops at none of the P1, P2, P3, or P4 gates.
  - P3 puts its acceptance evidence in the PR description instead of a gate.
  - P4 raises the PR and ends with `P4 Ship: Complete: PR #{n} ready for your review`.
  - The agent never merges the PR and never commits to `main`.
- Both modes stop on these exceptions:
  - A requirement or check still fails after 5 attempts.
  - P2 needs a schema change.
  - The P3 security review finds an unmitigated critical or high issue.
  - A push or `gh pr create` fails.
- Each exception stop prints a message that starts with `Blocked:` and names the action the human needs to take.
  - Work stays committed and pushed before the stop.
  - After the human acts, the run resumes in the same mode.

## Acceptance Criteria
- [ ] (a) In `gated`, the orchestrator and phase skills stop at each of the P1, P2, P3, and P4 gates.
- [ ] (b) In `autonomous`, no phase skill stops at those gates. P3 writes acceptance evidence to the PR description, and P4 ends with `P4 Ship: Complete: PR #{n} ready for your review`.
- [ ] (c) In both modes, each of the four exceptions stops the run with a `Blocked:` message naming the action needed. Work is committed and pushed, and the run resumes in the same mode.

## Dependencies
- REQ-001 supplies the `gated` and `autonomous` values that this requirement acts on.
- REQ-004 to REQ-006 (phase numbers and prefixes) supply the phase numbers and prefixes used here.
- Files in reach:
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md`
  - `planifest-zero/skills/planifest-validate-and-accept/SKILL.md` (no current match, but it owns the P3 gate, evidence, and security stop)
  - `planifest-zero/skills/planifest-ship/SKILL.md`
  - `planifest-zero/skills/planifest-migrator/SKILL.md` (matches only the word "interactively" in prose, so check it and change nothing unless it names a run mode)
