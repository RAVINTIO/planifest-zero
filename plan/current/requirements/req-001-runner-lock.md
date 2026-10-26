---
title: "Requirement: req-001 - runner lock"
summary: "The driver uses plan/.initiative-runner.lock as its lock file."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - runner lock

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000192-rename-runner-lock-and-archive
**Source:** US-001
**Priority:** must-have

## User Story

As a maintainer, I find the driver lock at `plan/.initiative-runner.lock`, so that its name matches the other initiative names.

## Functional Requirements
- The driver takes `plan/.initiative-runner.lock` before it spawns a step and removes it when it stops.
- A pre-existing lock at that path stops a second driver, and the driver leaves the lock untouched.
- The driver adds `plan/.initiative-runner.lock` to `.git/info/exclude` once.
- The driver no longer reads or writes the old `roadmap-runner` lock.

## Acceptance Criteria
- [ ] AC-1: Lock taken and released
  - Given a stub active initiative
  - When the driver runs a step and stops
  - Then `plan/.initiative-runner.lock` existed during the run and is gone afterwards
- [ ] AC-2: Existing lock stops a second driver
  - Given `plan/.initiative-runner.lock` already exists
  - When the driver starts
  - Then it exits non-zero, spawns no step, and leaves the lock contents unchanged
- [ ] AC-3: Lock path excluded once
  - Given two driver runs in one repo
  - When each run finishes
  - Then `.git/info/exclude` holds `plan/.initiative-runner.lock` exactly once

## Dependencies
- None
