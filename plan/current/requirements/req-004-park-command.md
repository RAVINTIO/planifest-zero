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
- The backlog entry template gains `parked` as a status value and a `**Parked branch:**` field. A parked entry fills both.
- A parked entry reaches `main` only when the human merges the chore PR. Until then, a session on `main` does not see it.
- If `plan/current/design.md` does not exist, the phase reached is P1.
- The sentinels in `plan/` live on the feature branch only. Park removes nothing from `main`.
- If any push or `gh` call fails, park reports the exact error and stops. The working tree stays on the feature branch, and `park.md` stays committed locally.
- Park never merges a pull request, never commits to `main`, and never force-pushes.
- Park does not open a second park for another feature on the same working tree.

## Acceptance Criteria
- [ ] (a) The orchestrator skill has a Park Command section with the five steps in order. It states the P1 rule for a park before `design.md`, the stop-on-failure rule, and the never-merge, never-commit-to-`main`, never-force-push rule.
- [ ] (b) `planifest-zero/templates/park.template.md` holds phase reached, last artifact, head commit, and reason. The Framework Index and `bundle_templates` name it. The backlog entry template allows status `parked` and has a `**Parked branch:**` field.
- [ ] (c) Against a test remote, a successful park leaves `park.md` pushed on the feature branch, a `parked` entry naming that branch on the chore branch, and the working tree on `main`. A forced push failure leaves the working tree on the feature branch and `main` unchanged.

## Dependencies
- The backlog entry template, which this requirement extends with the `parked` status.
- Custom rule 001 permits push and `gh pr create` without asking. Merge stays human-only.
- req-005 reads the record and the entry this requirement writes.
