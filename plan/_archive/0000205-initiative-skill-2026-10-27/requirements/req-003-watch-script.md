# Requirement: REQ-003 - watch script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-002
**Priority:** must-have

## User Story

As the human on the loop, I get a report at least every 5 minutes, at each phase end, and on request, so that I see progress without asking.

## Functional Requirements
- `ravintio-zero/scripts/initiative-watch.mjs` is read-only. It writes no file and runs no `git` command that changes state.
- Every 30 seconds it reads `plan/current/build-log.md`, the newest archived build log, and `git log` of the current branch. It prints one line per event.
- Events are a new phase `Complete:` line, a `Blocked:` line, a `Resolved:` line, and a new commit. When it moves to a new build log, it also prints the `Complete:` lines already there.
- It prints a stale-log line when the step has a commit newer than the build log and the build log has not changed for 15 minutes.
- It prints a heartbeat every 5 minutes with the step, the phase, the last build log line cut to 200 characters, the time since the last change, and whether the driver lock is held.
- Flags `--once` (one pass, then exit) and `--root <dir>` support tests. Each line is cut to 500 characters.
- The script exits 0 when the driver lock is gone and the initiative file is gone, after one last line.

## Acceptance Criteria
- [ ] AC-1: event lines
  - Given a temporary repo whose build log gains a `Complete:` line, a `Blocked:` line, and a `Resolved:` line
  - When the script runs with `--once` after each change
  - Then it prints one `I-C Run:` event line for each new line and nothing for an unchanged log
- [ ] AC-2: heartbeat and stale log
  - Given a build log last changed 16 minutes ago and a newer commit
  - When the script runs with `--once`
  - Then it prints a stale-log line and a heartbeat that names the step and the lock state
- [ ] AC-3: read-only
  - Given a temporary repo
  - When the script runs with `--once`
  - Then `git status --porcelain` and the file hashes are the same as before

## Dependencies
- None
