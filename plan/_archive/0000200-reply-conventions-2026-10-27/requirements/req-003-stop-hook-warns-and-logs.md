# Requirement: REQ-003 - Stop hook warns and logs

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I get a warning when a reply in an active run lacks a valid prefix, and the misses are logged, so that I can measure how often the rule fails.

## Functional Requirements
- `ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` is a `Stop` hook. It reads the payload on stdin and takes the last assistant text from the JSONL file at `transcript_path`.
- The hook checks the first line of the reply against the valid prefixes: `P0 Discovery:` to `P4 Ship:`, `I-A Chart:` to `I-E Delivery:`, and `Supervise:`. The phase name `Validate and Accept` is not valid, since messages use `P3 Validate:`.
- If the reply lacks a valid prefix, the hook prints JSON `{"systemMessage": "..."}` that names the missing prefix, appends one line to `plan/.prefix-misses.log` with a timestamp and the first 80 characters of the reply, and exits 0.
- If `plan/.orchestrator-active` is absent, the hook prints nothing, logs nothing, and exits 0.
- The hook exits 0 on every other input, including a malformed payload, a missing transcript, and a transcript with no assistant text.

## Acceptance Criteria
- [ ] AC-1: a miss warns and logs
  - Given `plan/.orchestrator-active` exists and the last reply starts with plain text
  - When the hook runs
  - Then it exits 0, prints a `systemMessage` that names the missing prefix, and appends one line to `plan/.prefix-misses.log`
- [ ] AC-2: a valid prefix passes silently
  - Given `plan/.orchestrator-active` exists and the last reply starts with `P2 Implement: Starting: write the hook`
  - When the hook runs
  - Then it exits 0, prints nothing, and writes no log line
- [ ] AC-3: the hook never blocks
  - Given no sentinel, a malformed payload, or a missing transcript
  - When the hook runs
  - Then it exits 0 and prints nothing

## Dependencies
- None
