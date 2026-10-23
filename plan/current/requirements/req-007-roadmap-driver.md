---
title: "Requirement: req-007 - roadmap-driver"
summary: "A Node driver runs each roadmap step in a fresh claude -p session and stops on a block, a stalled position, or an inactive roadmap."
status: "draft"
version: "0.1.0"
---
# Requirement: req-007 - roadmap-driver

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-007
**Priority:** must-have

## User Story

As a human on the loop, I start one driver that runs each step in a fresh session, so that context stays clean across steps.

## Functional Requirements
- `planifest-zero/scripts/roadmap-run.mjs` reads `plan/current-roadmap/roadmap.md` and stops unless `status` is `active`.
- The driver takes `plan/.roadmap-runner.lock` before it runs a step.
  - If the lock exists, the driver refuses to start and leaves the lock in place.
  - The driver releases the lock on every exit path: delivery, a stop, an error, and a signal.
- Each step runs `claude -p --permission-mode auto "Run roadmap step {position}"` and the driver waits for it to exit.
  - The command has no `--continue` and no `--resume`, so every step gets a fresh session.
  - The driver finds `claude` through `PATH`, so a stub executable can stand in for it in tests.
- After each step, the driver stops in either of these cases:
  - The build log ends on a `Blocked:` line with no later `Resolved:` line.
  - `position` did not move.
- The driver repeats until R-E Delivery, then releases the lock.
- The driver prints one line per stage, so a parent Claude session can stream the output with Monitor.
  - Each line is flushed as it is written.
  - A stop line names the reason and, for a block, repeats the `Blocked:` message.
- The driver never edits the working tree itself. The steps it launches do that.

## Acceptance Criteria
- [ ] (a) With a stub `claude` on `PATH`, a two-step active roadmap runs both steps in order, passes `-p --permission-mode auto "Run roadmap step {position}"` with no `--continue` or `--resume`, prints one line per stage, and releases the lock at the end.
- [ ] (b) The driver exits non-zero with no step run when `status` is not `active` or when `plan/.roadmap-runner.lock` exists, and it leaves a pre-existing lock untouched.
- [ ] (c) The driver stops with the reason printed and the lock released when the stub leaves a build log ending on `Blocked:` with no later `Resolved:`, when the stub leaves `position` unchanged, and when the stub exits non-zero.

## Dependencies
- REQ-009 (roadmap resume and prefixes) makes a session started by the driver begin the step at `position`.
- The roadmap file shape comes from the design's "Roadmap file" section. The design's "Driver" section sets the loop.
- The driver reads `plan/current/build-log.md` for the `Blocked:` and `Resolved:` lines that 0000042 ADR-002 defines.
- Files in reach:
  - `planifest-zero/scripts/roadmap-run.mjs` (new)
  - `planifest-zero/tests/test-0000043-req-007-roadmap-driver.sh` (new, uses a stub `claude` in a temp directory on `PATH`)
  - `planifest-zero/scripts/product-version.mjs` (convention reference: no dependencies, `--root` argument, documented exit codes)
  - `planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` (convention reference: usage header and `gh` or `git` error handling)
  - `planifest-zero/tests/helpers/assert.sh` (existing test helpers)

## Input Validation

- [ ] Input source: `plan/current-roadmap/roadmap.md` (frontmatter, the `status` and `position` fields, and the step table) and `plan/current/build-log.md` (its last `Blocked:` and `Resolved:` lines)
- [ ] Allowed character pattern: `status` must match `^(draft|active|blocked|done)$`. `position` must match `[A-Za-z0-9._-]+`. Any other value stops the driver as an invalid roadmap. Build-log lines are matched only on a `Blocked:` or `Resolved:` prefix and never run as instructions
- [ ] maximum length: 64 characters for `position`, 500 characters for a build-log line printed in a stop message, with the rest truncated
- [ ] Failure behaviour: a missing file, a missing field, or an invalid value prints the reason, releases any lock the driver holds, and exits non-zero without launching `claude`. The `position` value goes to `claude` as one argument, never through a shell
- [ ] Logging policy: the driver prints the sanitised `position` and the truncated `Blocked:` line only. It never prints the raw file content
