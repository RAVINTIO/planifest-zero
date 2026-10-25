---
title: "Requirement: REQ-001 - attribution-ban-text"
summary: "The boot template, commit standards, and ship skill ban AI attribution in PR descriptions and name the host lines."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - attribution-ban-text

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Source:** US-001 (backlog 0000166)
**Priority:** must-have

## User Story

As a maintainer, I see no AI attribution lines in any PR description, so that PRs follow the same rule as commits.

## Functional Requirements
- Today `ravintio-zero/templates/standard-boot.md` bans attribution in commit messages only. The Operational Directives and the `commit-msg` entry say nothing about PR descriptions.
- Today `ravintio-zero/standards/commit-standards.md` section 3, "No AI attribution", opens with "Commit messages MUST NOT attribute authorship". It does not mention PR descriptions or the host lines.
- Today `ravintio-zero/skills/ravintio-ship/SKILL.md` Step 9 says "PR bodies carry no AI attribution". It names no host lines and runs no check.
- `standard-boot.md` bans AI attribution in PR descriptions as well as commit messages.
- `commit-standards.md` section 3 applies to PR descriptions and lists the host lines to leave out.
- The ship skill Step 9 text lists the same host lines.
- The three files name these host lines:
  - `Generated with [Claude Code]`, with or without a robot emoji.
  - `Co-Authored-By:` naming an AI tool.
  - A `Claude-Session:` line or a claude.ai/code session link.

## Acceptance Criteria
- [ ] `standard-boot.md`, `commit-standards.md`, and the ship skill each state that PR descriptions carry no AI attribution.
- [ ] Each of the three files names all three host lines.
- [ ] `commit-standards.md` section 3 no longer limits the ban to commit messages.

## Dependencies
- None. REQ-002 supplies the check that enforces this text.
- REQ-003 wires the check into ship and CI.
