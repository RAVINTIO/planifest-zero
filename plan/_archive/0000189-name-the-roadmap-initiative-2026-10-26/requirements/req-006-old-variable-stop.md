---
title: "Requirement: req-006 - old variable stop"
summary: "The driver stops and names the new variable when an old variable is set."
status: "draft"
version: "0.1.0"
---
# Requirement: req-006 - old variable stop

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I find the initiative under `initiative` names in paths, files, scripts, the branch pattern, env vars, logs, and telemetry, so that each name says what it holds.

This requirement covers the env var part of US-002 for a maintainer who still sets an old name.

## Functional Requirements
- The driver reads only `RAVINTIO_INITIATIVE_MODEL` and `RAVINTIO_INITIATIVE_MAX_TURNS`.
- If `RAVINTIO_ROADMAP_MODEL` or `RAVINTIO_ROADMAP_MAX_TURNS` is set and non-empty, the driver stops before it spawns a step. The stop line names the old variable and its replacement.
- The driver drops the `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS` fallbacks. Either one stops the driver in the same way.
- The stop line is `I-C Run: Blocked: {old} is no longer read. Set {new} instead.`

## Acceptance Criteria
- [ ] AC-1: Old model variable stops the driver
  - Given `RAVINTIO_ROADMAP_MODEL=sonnet` and a stub active initiative
  - When the driver starts
  - Then it exits non-zero, prints `RAVINTIO_ROADMAP_MODEL` and `RAVINTIO_INITIATIVE_MODEL`, and spawns no step
- [ ] AC-2: Old turn cap variable stops the driver
  - Given `RAVINTIO_ROADMAP_MAX_TURNS=40` and a stub active initiative
  - When the driver starts
  - Then it exits non-zero, prints `RAVINTIO_ROADMAP_MAX_TURNS` and `RAVINTIO_INITIATIVE_MAX_TURNS`, and spawns no step
- [ ] AC-3: New variables work
  - Given `RAVINTIO_INITIATIVE_MODEL=sonnet` and `RAVINTIO_INITIATIVE_MAX_TURNS=40`
  - When the driver starts a step
  - Then it passes that model and turn cap to `claude -p`

## Dependencies
- REQ-002 renames the driver.
