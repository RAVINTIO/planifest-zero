---
title: "Requirement: req-002 - ship-sentinels-before-pr"
summary: "Ship clears the pipeline sentinels in a commit before it pushes, so no PR carries them, and Step 7 states when the tag is pushed."
status: "draft"
version: "0.1.0"
---
# Requirement: req-002 - ship-sentinels-before-pr

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-002
**Priority:** must-have

## User Story

As a maintainer, I merge a ship PR that carries no pipeline sentinels, so that `main` stays clean.

## Functional Requirements
- `planifest-zero/skills/planifest-ship/SKILL.md` clears the sentinels before the step that pushes.
  - The new order is Step 7 tag, Step 8 clear sentinels, Step 9 PR, Step 10 final gate.
  - Step 8 deletes `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode` if present, stages the deletions, and commits.
  - Step 8 confirms with `git ls-files` that none remain tracked.
- Step 8 reads the run mode before it deletes `plan/.run-mode`. Step 10 uses that value.
- The sentinel commit comes before the push in every run mode and for both PR options.
  - Option [1] pushes the branch and raises the PR after the sentinel commit.
  - Option [2] clears the sentinels first, then prints the PR title and description. The human pushes later.
- The tag follows the PR choice.
  - When the agent raises the PR (option [1]), Step 9 pushes the tag with the branch.
  - In option [2], the agent does not push the tag. The human pushes it.
  - Step 7 states this. For a roadmap step, Step 7 keeps the sentence "Local only. Do not push the tag."
- Step headings stay sliceable by a fixed heading line: `### Step 8: Clear sentinels`, `### Step 9: PR`, and `### Step 10: Final gate`.
- `planifest-zero/standards/roadmap-standards.md` R-D Advance refers to the new step number for clearing sentinels. Its behaviour does not change, because it already clears sentinels before the PR.
- The override `planifest-overrides/instructions/custom-004-ship-push-and-raise-pr.md` stays consistent with Step 9. It pushes the branch and the tag, then raises the PR.
- The credential scan, the push-failure stop, and the merge-is-human-only rule keep their text and their position before `gh pr create`.

## Acceptance Criteria
- [ ] (a) In `SKILL.md`, the line numbers of the headings rise in this order: Step 7, Step 8 clear sentinels, Step 9 PR, Step 10 final gate. No other `### Step` heading is renumbered.
- [ ] (b) The Step 9 PR section mentions pushing the tag in option [1], and the Step 7 section no longer says that no tag is ever pushed outside a roadmap step.
- [ ] (c) The Step 8 section names all three sentinel paths and the `git ls-files` check, and Step 10 still says to use the run mode read before the deletion, with the correct step number.
- [ ] (d) A scripted run of the Step 8 commands in a temp repo that tracks the three sentinels leaves none tracked and creates one commit before a `git push` to a local bare remote. The pushed branch holds none of the sentinels.
- [ ] (e) The R-D Advance section in `roadmap-standards.md` names the clear-sentinels step by its new number and still places it before `gh pr create`.
- [ ] (f) Every assertion in the four pinned tests still runs after the update, and each only changes where the old and new step order differ. The tests are `test-0000023-req-002-marker-commit-lifecycle.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000042-req-002-gate-and-exception-stops.sh`, and `test-0000037-req-005-override-phase-names.sh`. No assertion is deleted or loosened.
- [ ] (g) The credential-scan and push-failure text still sit in the Step 9 section, and the merge-guard hook tests still pass.

## Dependencies
- Backlog source 0000144 (`plan/current/backlog-sources/0000144-ship-sentinel-commit-after-pr.md`) holds the finding.
- The 0000023 marker lifecycle, the 0000042 run-mode gates, and the 0000043 R-D Advance stage set the behaviour this requirement keeps.
- Files in reach:
  - `planifest-zero/skills/planifest-ship/SKILL.md` (Steps 7 to 10 and the Roadmap steps section)
  - `planifest-zero/standards/roadmap-standards.md` (R-D Advance, step 2)
  - `planifest-overrides/instructions/custom-004-ship-push-and-raise-pr.md`
  - `planifest-zero/tests/test-0000023-req-002-marker-commit-lifecycle.sh` (slices by `### Step 9: Clear sentinels` to `### Step 10`)
  - `planifest-zero/tests/test-0000043-req-005-roadmap-advance.sh` (asserts "Local only. Do not push the tag." and step order)
  - `planifest-zero/tests/test-0000042-req-002-gate-and-exception-stops.sh` (slices by `### Step 8: PR` and `### Step 10: Final gate`)
  - `planifest-zero/tests/test-0000037-req-005-override-phase-names.sh`
  - `planifest-zero/tests/test-0000151-req-002-ship-sentinels-before-pr.sh` (new)
