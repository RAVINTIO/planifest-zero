---
title: "Requirement: REQ-001 - Plain merge command in ship"
summary: "The ship skill gives the squash-merge line as a plain line to copy, with a literal PR number and no substitution."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-001 - Plain merge command in ship

**Skill:** [implement](../skills/ravintio-implement/SKILL.md)
**Feature:** 0000248-ship-merge-and-wall-clocks
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I see the ship skill give one plain merge line with a literal PR number, so that `merge-guard` allows the first attempt.

## Functional Requirements
- `ravintio-ship/SKILL.md` holds the line `gh pr merge --squash --delete-branch {n}` in the `## Initiative steps` section.
- The section states that `{n}` is the literal PR number from the `gh pr create` output, and forbids command substitution, variables, and pipes on that line.
- I-D Advance step 4 in `roadmap-standards.md` carries the same wording.
- `merge-guard` source and its tests stay unchanged.

## Acceptance Criteria
- [ ] AC-1: ship skill holds the line and the rule
  - Given the ship skill
  - When the test reads its Initiative steps section
  - Then it finds the merge line, the literal-number statement, and the ban on substitution
- [ ] AC-2: merge-guard allows the line
  - Given a stub `gh` that reports an `initiative/x` base
  - When the guard reads `gh pr merge --squash --delete-branch 52`
  - Then it exits 0
- [ ] AC-3: merge-guard is unchanged
  - Given the branch diff against the initiative branch
  - When P3 lists changed files with `git diff --name-only`
  - Then neither `merge-guard.mjs` nor its test file appears

## Dependencies
- none
