---
title: "Postmortem: 2026-10-31 - step 6 forced add committed driver files"
summary: "A blameless record of why a failure got through earlier phases, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-10-31 - step 6 forced add committed driver files

**Trigger:** Blocked stop
**Feature:** 0000244-split-orchestrator-skill (initiative 0000238, step 6)
**Date:** 2026-10-31

## Summary

Step 6 staged its first commit with `git add -f plan`. That swept ignored driver files into the commit, and the push was denied in P4. The step waited about four hours, until the human approved a history rewrite.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-10-28 14:21 | The step runs `git add -f plan` and commits `e71fbbe`. The commit holds 15 driver logs, `plan/.initiative-ack`, the runner lock, and a queued entry. | `plan/.initiative-logs/step-6.log`, `git show --name-only e71fbbe` |
| 2026-10-28 14:22 | Two more commits each add a driver log again | `6411464`, `12d6192` |
| 2026-10-28 14:53 | The push is denied, and the step prints `P4 Ship: Blocked:` | `plan/.initiative-logs/step-6.log` |
| 2026-10-28 18:36 | The coordinator rewrites the unpushed history to drop the files, with the human's approval, and raises PR #61 | PR #61 body, "Supervision note" |
| 2026-10-28 18:41 | PR #61 lands. The final tree is unchanged. | PR #61 |

Those paths were already ignored. `.gitignore` line 34 lists `plan/.initiative-ack`, and `.git/info/exclude` lists `plan/.initiative-logs/`. The step log gives no reason for `-f`.

First missed chance to catch it: `e71fbbe`. No hook checks a forced add, and no check runs before the push.

## 5 whys

1. Why was the push denied? The commits held driver logs that git ignores.
2. Why did ignored files reach a commit? The step ran `git add -f plan`, which stages ignored files.
3. Why did nothing stop the forced add? No pack rule forbids `git add -f`, and no hook checks it. The staging rule in `agent-dispatch-standards.md` line 117 covers subagent units only, and it names `git add -A` and `git add .`, not `-f`.
4. Why was it found so late? No check compares tracked files with the ignore rules before the push. The first check to see them was the push permission check.
5. Why did that cost four hours? A denied push stops the step until the human acts, and the fix needed a history rewrite.

**Gap:** no rule or hook stops a step from force-adding ignored files, and no check finds ignored files in a commit before the push.

## Actions

| Type | Action | Owner | Lives in | Verified by | Filed as |
|------|--------|-------|----------|-------------|----------|
| corrective | Rewrite the unpushed step 6 history to drop the driver files, keeping the final tree. Done on 2026-10-28 with the human's approval. | coordinator | `feat/0000244-split-orchestrator-skill` | tree unchanged, push accepted | PR #61 |
| preventive | Forbid `git add -f` and `git add --force` in step sessions, in the orchestrator rules and a PreToolUse Bash hook | orchestrator skill, hooks | `ravintio-zero/skills/ravintio-orchestrator/`, `ravintio-zero/hooks/` | hook tests | backlog entry 0000276 |
| detective | Fail ship and CI when `git ls-files -ci --exclude-standard` lists any file | ship skill, CI | `ravintio-zero/skills/ravintio-ship/`, `.github/workflows/` | CI test with an ignored file committed | backlog entry 0000276 |
