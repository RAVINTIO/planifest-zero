---
title: "Requirement: REQ-001 - name the real block reason"
summary: "merge-guard says that a command names a merge in text, and tells the agent to use the Write tool."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - name the real block reason

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000197-merge-guard-block-message
**Source:** US-001
**Priority:** must-have

## User Story

As an agent that writes a file with a heredoc, I get a block message that says the command names a merge in text and tells me to use the Write tool, so that I fix the call at once.

## Functional Requirements
- `parsePlain()` in `merge-guard.mjs` rejects a segment that holds merge words and is not a bare `gh pr merge` call with this reason: `The command names a merge in text that isn't a merge call. Write files with the Write tool, not a shell command.`
- A segment that fails the quoting check keeps its reason and adds the same Write tool advice.
- The over-4096 reason becomes `The command is over 4096 characters. Write files with the Write tool, not a shell command.`
- The hook blocks and passes exactly the commands it blocked and passed before. Only message text changes.

## Acceptance Criteria
- [ ] AC-1: heredoc that names the merge command
  - Given a Bash command under 4096 characters that writes a heredoc with a line naming `gh pr merge`
  - When the hook runs
  - Then it exits 2 and the message says the command names a merge in text and names the Write tool
- [ ] AC-2: long command
  - Given the same command padded to over 4096 characters
  - When the hook runs
  - Then it exits 2 and the message says the command is over 4096 characters and names the Write tool
- [ ] AC-3: block set unchanged
  - Given the existing merge-guard suite
  - When it runs against the changed hook
  - Then every test passes, apart from tests that assert the old message text

## Dependencies
- None
