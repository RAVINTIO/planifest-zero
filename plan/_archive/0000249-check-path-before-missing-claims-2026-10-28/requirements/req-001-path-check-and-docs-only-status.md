---
title: "Requirement: REQ-001 - PATH check and docs-only status"
summary: "The validate-and-accept skill requires a PATH search before a missing-program report, and gives a docs-only claim its own status."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - PATH check and docs-only status

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000249-check-path-before-missing-claims
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a maintainer, I see the validate-and-accept skill require a `PATH` search with its output before any report says a program is missing, and give a claim that only documentation backs the status `unverified (docs only)`, so that neither a false "missing" claim nor a docs-only claim reaches the acceptance evidence as fact.

## Functional Requirements
- `ravintio-validate-and-accept/SKILL.md` tells the agent to run `command -v {program}` before a report says a program is missing.
- The rule then names the common install folders `/opt/homebrew/bin`, `/usr/local/bin`, and `~/.local/bin`, and says to record each command and its found or not-found result in the acceptance evidence.
- The per-criterion outcomes list defines `unverified (docs only)` for a claim that rests on documentation alone, and says it never counts as `verified`.
- The acceptance evidence rules ask for the `PATH` check commands and a list of the unverified claims by name.
- The evidence records the command and a found or not-found result. It never holds raw command output, so a public PR stays free of environment values.

## Acceptance Criteria
- [ ] AC-1: the skill holds the PATH search rule
  - Given the validate-and-accept skill
  - When the test reads it
  - Then it finds `command -v`, `/opt/homebrew/bin`, `/usr/local/bin`, and `~/.local/bin`
- [ ] AC-2: the skill defines the docs-only status
  - Given the validate-and-accept skill
  - When the test reads it
  - Then it finds `unverified (docs only)` and a statement that it never counts as `verified`
- [ ] AC-3: the evidence rules ask for the search and the list
  - Given the acceptance gate section of the skill
  - When the test reads it
  - Then it finds the `PATH` check commands and the list of unverified claims

## Dependencies
- none
