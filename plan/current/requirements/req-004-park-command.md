---
title: "Requirement: req-004 - park-command"
summary: "The orchestrator parks a part-finished feature on its branch, files a backlog entry through a chore PR, and returns the human to main."
status: "active"
version: "0.1.0"
---
# Requirement: req-004 - park-command

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Source:** US-004 (backlog 0000101)
**Priority:** must-have

## User Story

As a human on the loop, I say "park", so that the orchestrator shelves the feature on its branch, files a backlog entry, and returns me to `main` without losing progress.

## Functional Requirements
- The orchestrator skill gains a Park Command section next to the Pause Command. It runs when the human says "park" or similar.
- A new template, `planifest-zero/templates/park.template.md`, defines the park record. It holds four fields: phase reached, last artifact, head commit, and reason.
  - The Framework Index lists the template under "A park record".
  - The orchestrator frontmatter `bundle_templates` list includes it.
- Park runs these steps in order:
  1. Read the park template and write `plan/current/park.md` on the feature branch. Fill all four fields.
  2. Commit `park.md` and push the feature branch.
  3. Cut `chore/park-{feature-id}` from `main`. Add a backlog entry from the backlog template with status `parked` that names the feature branch.
  4. Push the chore branch and run `gh pr create`.
  5. Check out `main`.
- If `plan/current/design.md` does not exist, the phase reached is P1.
- The sentinels in `plan/` live on the feature branch only. Park removes nothing from `main`.
- If any push or `gh` call fails, park reports the exact error and stops. The working tree stays on the feature branch, and `park.md` stays committed locally.
- Park never merges a pull request, never commits to `main`, and never force-pushes.
- Park does not open a second park for another feature on the same working tree.

## Acceptance Criteria
- [ ] The orchestrator skill contains a Park Command section with the five steps above in that order.
- [ ] `planifest-zero/templates/park.template.md` exists and holds phase reached, last artifact, head commit, and reason.
- [ ] The Framework Index and `bundle_templates` both name `park.template.md`.
- [ ] The skill states that park before `design.md` exists records phase P1.
- [ ] The skill states that park never merges, never commits to `main`, and never force-pushes.
- [ ] The skill states that a failed push or `gh` call reports the exact error and stops on the feature branch.
- [ ] After a successful park against a test remote, `park.md` is committed and pushed on the feature branch, the chore branch holds a `parked` backlog entry naming that branch, and the working tree is on `main`.
- [ ] After a forced push failure, the working tree is still on the feature branch and `main` is unchanged.

## Dependencies
- The backlog entry template, which this requirement extends with the `parked` status.
- Custom rule 001 permits push and `gh pr create` without asking. Merge stays human-only.
- req-005 reads the record and the entry this requirement writes.
