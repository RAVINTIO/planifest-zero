# Requirement: REQ-002 - bootstrap and seed the counter

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Source:** US-001
**Priority:** must-have

## User Story

As an agent that files an entry or starts a feature, I reserve ids from `plan/backlog/.next-id` with one script, so that two sessions never take the same id.

## Functional Requirements
- If the counter is missing, the script exits 1 and says so. With `--init` it creates the file from the highest id in `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/` next to the file, plus one, and then reserves.
- `plan/backlog/.next-id` ships in this repo holding `0000210`.

## Acceptance Criteria
- [ ] AC-1: bootstrap
  - Given a folder with no counter and an archive entry numbered 0000041
  - When the script runs with `--init`
  - Then it prints 0000042 and the file holds 0000043
- [ ] AC-2: missing counter
  - Given a folder with no counter
  - When the script runs without `--init`
  - Then it exits 1 and creates no file
- [ ] AC-3: shipped seed
  - Given this repo
  - When `plan/backlog/.next-id` is read
  - Then it holds a seven-digit number of at least 0000210

## Dependencies
- REQ-001
