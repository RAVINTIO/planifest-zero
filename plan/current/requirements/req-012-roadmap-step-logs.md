---
title: "Requirement: req-012 - roadmap-step-logs"
summary: "The roadmap driver writes each step's output to a per-step log excluded from git, and every stop after a step names that log."
status: "draft"
version: "0.1.0"
---
# Requirement: req-012 - roadmap-step-logs

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-007 (backlog 0000145)
**Priority:** should-have

## User Story

As a maintainer, I read a per-step log when a roadmap step blocks, so that I can diagnose what the headless session did.

## Functional Requirements
- The driver writes the child's stdout and stderr to `plan/.roadmap-logs/step-{position}.log`.
  - The driver creates `plan/.roadmap-logs/` before the first step if it is missing.
  - Both streams go to the same file in arrival order.
  - `runStep` changes `stdio` from `['ignore', 'ignore', 'inherit']` to pipes. It still sets stdin to `ignore`.
- Each step start truncates its log.
  - A rerun of the same position replaces the earlier log. The stop line always names the log of the latest attempt.
- The driver still copies the child's stderr to its own stderr as before.
  - The child's stdout stays out of the driver's stdout, so the Monitor stream keeps one line per stage.
- The driver adds `plan/.roadmap-logs/` to `.git/info/exclude` in the same call that excludes the lock.
  - It skips quietly outside a git work tree.
  - It adds the line once. Reruns do not duplicate it.
- Every stop line raised after a step starts ends with `Log: plan/.roadmap-logs/step-{position}.log`.
  - That covers a failed spawn, a non-zero exit, an open block, a stalled position, an inactive status after the step, and a signal during a step.
  - Stops before any step starts have no log and do not name one.
- If the driver cannot create or open the log, it stops with `R-C Run: Blocked: could not open the step log`, releases the lock, and launches no `claude`.
- The driver never prints log content to its stdout.

## Acceptance Criteria
- [ ] (a) After a two-step stub run, `plan/.roadmap-logs/step-1.log` and `step-2.log` exist and each holds the stub's stdout and stderr lines.
- [ ] (b) After a stub run that fails, blocks, or stalls, the single `R-C Run: Blocked:` line ends with `Log: plan/.roadmap-logs/step-{position}.log` and that file exists.
- [ ] (c) Rerunning a blocked step with a shorter stub output leaves a log with only the new output.
- [ ] (d) The stub's stderr text appears on the driver's stderr, and its stdout text does not appear on the driver's stdout.
- [ ] (e) In a git fixture, `.git/info/exclude` holds `plan/.roadmap-logs/` exactly once after two runs, and `git status --porcelain` lists no log file.
- [ ] (f) In a fixture where `plan/.roadmap-logs` is a regular file, the driver exits 1 with the log-open stop line, releases the lock, and runs no step.
- [ ] (g) A stop before the first step, such as an inactive roadmap or an existing lock, prints no `Log:` suffix.
- [ ] (h) `roadmap-standards.md` and the driver header comment name `plan/.roadmap-logs/` and the truncate rule.

## Dependencies
- REQ-006 changes the same `claude` call. Build it first.
- Risk: a log may hold file content the session read. The folder stays out of git, and nothing here uploads it.
- Files in reach:
  - `planifest-zero/scripts/roadmap-run.mjs` (edit `runStep`, `excludeLock`, and the stop lines)
  - `planifest-zero/standards/roadmap-standards.md` (add the log folder to the driver section)
  - `planifest-zero/tests/test-0000043-req-007-roadmap-driver.sh` (adjust any stop-line match that now has a suffix)
  - `planifest-zero/tests/test-0000043-req-012-progress-markers-and-resume.sh` (adjust any stop-line match that now has a suffix)
  - `planifest-zero/tests/test-0000151-req-012-roadmap-step-logs.sh` (new)

## Input Validation

- [ ] Input source: the sanitised `position` value, and the child's stdout and stderr
- [ ] Allowed character pattern: `position` matches `^[1-9][0-9]{0,2}$` before it forms the log path. Child output is written as bytes and never interpreted
- [ ] maximum length: 3 digits for `position` in the file name. The log has no size cap
- [ ] Failure behaviour: a log that cannot open stops the driver as the functional requirement states
- [ ] Logging policy: the driver prints only the log path. It never prints log content
