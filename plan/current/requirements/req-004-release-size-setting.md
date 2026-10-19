---
title: "Requirement: req-004 - release-size-setting"
summary: "A maintainer sets releaseSize in product.yml, and discovery fills each release to the matching point budget."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - release-size-setting

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000039-setup-hardening-release-sizing
**Source:** US-004 (backlog 0000109)
**Priority:** must-have

## User Story

As a maintainer, I set `releaseSize` in `product.yml`, so that discovery fills each release to the budget I chose.

## Functional Requirements
- `product.yml` accepts an optional `releaseSize` field with the values `small`, `medium`, and `large`.
- Each value sets a budget in points: `small` is 4, `medium` is 8, and `large` is 14.
- If `releaseSize` is absent, discovery uses `medium`.
- Discovery estimates a size class for each candidate story:
  - S: 1 to 2 files touched, 1 point.
  - M: 3 to 6 files touched, 2 points.
  - L: 7 or more files touched, 4 points.
- Discovery recommends a fill of candidates up to the budget. The human confirms the fill.
- If the candidates exceed the budget, discovery recommends a split.
- If `releaseSize` holds an unknown value, discovery notes it, uses the `medium` budget, and asks the human to fix the field.
- The orchestrator skill, the feature brief template, and the feature brief guide point to the setting. None of them states the fixed 3-story rule.

## Acceptance Criteria
- [ ] The orchestrator skill defines `releaseSize`, the three size classes, the three budgets, and the `medium` default.
- [ ] The orchestrator skill tells discovery to note an unknown `releaseSize` value and use `medium`.
- [ ] No skill or template in `planifest-zero/` states the fixed 3-story rule.

## Dependencies
- None. The orchestrator only reads `releaseSize` from `product.yml`. The consumer owns the file.
- ADR-004 records where the setting lives.
