---
title: "Requirement: req-001 - drop-telemetry-ci-job"
summary: "Detailed requirements for this specific functional feature."
status: "active"
version: "0.5.0"
---
# Requirement: req-001 - drop-telemetry-ci-job

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000037-self-host-on-planifest-zero
**Source:** US-003
**Priority:** must-have

## User Story

As the maintainer, I remove the `validate-telemetry-schema` CI job, so that CI guards nothing the product no longer has.

## Functional Requirements
- Delete the whole `validate-telemetry-schema` job from `.github/workflows/planifest.yml`, from its key to the end of the file.
- Remove the `windows-powershell` comment lines that say the Bash suites stay out of CI while the old folder exists. Keep the lines that describe the job.
- Leave the `validate-branch`, `self-description-check`, and `windows-powershell` jobs and the workflow `permissions` block unchanged.
- Add the suite `planifest-zero/tests/test-0000037-req-001-drop-telemetry-ci-job.sh`. If no repo workflow sits next to `planifest-zero/`, it skips, as `test-0000036-req-005-windows-ci-job.sh` does.
- Build the old folder name in that suite by concatenation, so the suite itself doesn't fail rename case (b).

## Acceptance Criteria
- [ ] `.github/workflows/planifest.yml` has no `validate-telemetry-schema` key and no `PLANIFEST_TELEMETRY_URL` (AC 5).
- [ ] The workflow has no `secrets.` reference.
- [ ] The workflow has no line that names the old framework folder.
- [ ] The `validate-branch`, `self-description-check`, and `windows-powershell` jobs still exist.
- [ ] The req-001 suite passes, and `test-0000036-req-005-windows-ci-job.sh` still passes.

## Dependencies
- None. It runs in parallel with req-002, req-003, req-005, and req-009 at P3.
