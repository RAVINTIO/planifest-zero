---
title: "Requirement: REQ-002 - keep every attempt log"
summary: "The driver renames an existing step log to the next free attempt name before it opens a fresh log, and names the attempt logs in a stop line."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-002 - keep every attempt log

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Source:** US-002, US-003
**Priority:** must-have

## User Story

As a maintainer, I see the log of every earlier attempt after the driver re-runs a step, and I see the attempt logs named in the stop line, so that a retrospective can quote the first stop.

## Functional Requirements
- Before `openLog` opens `step-{n}.log`, it checks for an existing `step-{n}.log`. If one exists, it renames the file to `step-{n}.attempt-{k}.log`, where `k` is the lowest number whose attempt path does not exist.
- A regular file at an attempt path moves the search to `k+1`. A symlink at the attempt path, at the step log, at `plan`, or at the log folder stops the driver with `I-C Run: Blocked: refused a symlinked step log path`.
- The folder keeps mode 700 and each attempt file keeps mode 600. The rotation sets the mode on the renamed file if it differs.
- The driver then opens a fresh `step-{n}.log` as today, so the latest attempt keeps the same name.
- A first run leaves only `step-{n}.log`.
- Every stop line that carries `Log: {path}` also carries `Earlier: {paths}` when attempt logs for the step exist. The paths are root-relative and in attempt order.
- The driver header, `roadmap-standards.md`, and case (a) of `test-0000151-req-012-roadmap-step-logs.sh` state the new rule in place of "a rerun truncates the log".

## Acceptance Criteria
- [ ] AC-1: every run keeps the earlier logs
  - Given a step that runs three times under a stub `claude`
  - When the driver finishes the third run
  - Then `attempt-1` and `attempt-2` hold the first two outputs, `step-1.log` holds the third, each attempt file has mode 600, and a step that runs once leaves only `step-1.log`
- [ ] AC-2: a symlink at an attempt path stops the driver
  - Given a symlink at `step-1.attempt-1.log`
  - When the driver starts step 1 with an existing `step-1.log`
  - Then it prints the symlink refusal and renames nothing
- [ ] AC-3: the stop line names the attempt logs
  - Given two earlier attempt logs and a run that exits non-zero
  - When the driver prints the stop line
  - Then the line carries `Log: plan/.initiative-logs/step-1.log` and an `Earlier:` list of both attempt paths

## Dependencies
- none
