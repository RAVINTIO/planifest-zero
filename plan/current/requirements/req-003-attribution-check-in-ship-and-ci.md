---
title: "Requirement: REQ-003 - attribution-check-in-ship-and-ci"
summary: "Ship and the validate-branch CI job run the attribution check on the PR description."
status: "active"
version: "0.1.0"
---
# Requirement: REQ-003 - attribution-check-in-ship-and-ci

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000169-release-hygiene
**Source:** US-001 (backlog 0000166)
**Priority:** must-have

## User Story

As a maintainer, I see no AI attribution lines in any PR description, so that PRs follow the same rule as commits.

## Functional Requirements
- Today ship Step 9 scans the PR body for credential patterns before `gh pr create` and runs no attribution check.
- Today the `validate-branch` job in `.github/workflows/ravintio.yml` and in the consumer template `ravintio-zero/hooks/ravintio.yml` reads no PR body.
- Ship Step 9 writes the PR body to a temporary file. It runs `check-attribution.mjs` on that file before `gh pr create`, next to the credential scan.
- If the check fails, the agent removes the attribution lines and reruns the check.
- If the check still fails, ship stops with `P4 Ship: Blocked: attribution line in the PR body.`
- The `validate-branch` job in both workflow files runs the check on the PR description.
- The job passes the body only through `env:`, for example `PR_BODY: ${{ github.event.pull_request.body }}`. It writes the body to a temporary file.
- No `run:` script interpolates `github.event.pull_request.body`.
- An empty PR body passes.

## Acceptance Criteria
- [ ] The ship skill Step 9 orders a temporary file, the attribution check, and the stop message `P4 Ship: Blocked: attribution line in the PR body.` before `gh pr create`.
- [ ] Both workflow files run the check in `validate-branch` with the body in an `env:` entry, and no `run:` block contains `github.event.pull_request.body`.
- [ ] The CI step passes for an empty body and fails for a body with an attribution line.

## Dependencies
- REQ-002 provides `check-attribution.mjs`.
- REQ-001 sets the ban text that ship repeats.
