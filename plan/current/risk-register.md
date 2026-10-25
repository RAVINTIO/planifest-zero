---
title: "Risk Register - release-hygiene"
summary: "Security, technical, and operational risks for the PR attribution check and the release-tag job, with their mitigations."
status: "draft"
version: "0.1.0"
---
# Risk Register - release-hygiene

**Skill:** plan
**Feature:** 0000169-release-hygiene
**Version:** 0.14.0
**Overall Risk Level:** high

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | A PR body crafted to inject shell code reaches a `run:` script. | low | high | Pass the body only through `env:` and a temporary file. Test the YAML for `github.event.pull_request.body` inside `run:`. | open |
| R-002 | technical | The check matches a PR that discusses attribution, such as this one. | high | low | Match whole attribution lines, not words. Keep this run's PR body free of the literal lines. | open |
| R-003 | operational | Guarding PR jobs with `if:` skips a required check on `main` pushes. | low | low | Branch protection reads PR checks only. | open |
| R-004 | technical | Claude Code does not honour `attribution.commit` and `attribution.pr` set to empty strings. | medium | medium | The host keeps asking for the lines. The check and the `commit-msg` hook still catch them. | open |
| R-005 | operational | `GITHUB_TOKEN` with `contents: write` cannot push a tag in this repo or in consumer repos. | medium | medium | The job fails visibly. The human tags the commit by hand. | open |

## Assumptions Logged as Risks

Documented assumptions from the design are logged here with likelihood: medium.

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | Claude Code honours `attribution.commit` and `attribution.pr` set to empty strings. Tracked as R-004. | The host keeps asking for the lines. The check and hook still catch them. | open |
| A-002 | `GITHUB_TOKEN` with `contents: write` can push a tag in this repo and in consumer repos. Tracked as R-005. | The job fails visibly. The human tags by hand. | open |
