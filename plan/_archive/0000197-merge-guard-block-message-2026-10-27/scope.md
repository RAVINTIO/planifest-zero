---
title: "Scope - merge-guard block message"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - merge-guard block message

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000197-merge-guard-block-message
**Version:** 0.20.1

## In Scope

- Change the block reason for a segment that holds merge words and is not a bare `gh pr merge` call.
- Add Write tool advice to the quoting reason and to the over-4096 reason.
- Change the tests that assert the old message text, and add tests for the new messages.
- Update the docs that describe the block message.

## Out of Scope

- Which commands the hook blocks or passes.
- Skipping heredoc bodies or quoted text.
- Any other hook.

## Deferred

Nothing deferred.
