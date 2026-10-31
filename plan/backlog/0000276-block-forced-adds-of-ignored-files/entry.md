---
title: "Backlog Entry: 0000276 - block forced adds of ignored files"
summary: "A postmortem action, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000276 - block forced adds of ignored files

**Source feature:** none (initiative 0000238 postmortems)
**Source phase:** none (human request)
**Deferral source:** postmortem `plan/postmortems/2026-10-31-step-6-forced-add-committed-driver-files.md`
**Date filed:** 2026-10-31

---

## Problem

Initiative 0000238 step 6 ran `git add -f plan` and committed 15 driver logs, `plan/.initiative-ack`, the runner lock, and a queued entry in `e71fbbe`. The push was denied, and the step stopped for about four hours until a history rewrite.

No pack rule forbids `git add -f`. The staging rule in `agent-dispatch-standards.md` line 117 covers subagent units only. No check finds ignored files in a commit before the push.

Most driver paths are ignored only through `.git/info/exclude`, which a fresh clone lacks. CI would not see them as ignored.

## Suggested Action

- Add a rule to the orchestrator skill. A step never runs `git add -f` or `git add --force`.
- Add a PreToolUse Bash hook that blocks a forced add. This makes the guards stricter. It must not let anything pass that a hook blocks today.
- List every driver path in the tracked `.gitignore`, not only in `.git/info/exclude`.
- Make ship and CI fail when `git ls-files -ci --exclude-standard` lists a file.

## Wanted outcome

No step commits an ignored file. Tests check these conditions:

- The hook blocks `git add -f plan` and `git add --force plan`.
- The hook still allows `git add plan/current`.
- `.gitignore` lists `plan/.initiative-logs/`, `plan/.initiative-queue/`, and `plan/.initiative-runner.lock`.
- The CI check fails a branch with a committed ignored file.

## Why Deferred

The postmortem found it after initiative 0000238 was delivered. No run is active.
