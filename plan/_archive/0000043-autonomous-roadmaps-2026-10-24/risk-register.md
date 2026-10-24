---
title: "Risk Register - autonomous-roadmaps"
summary: "Technical, operational, and security risks with their mitigations."
status: "active"
version: "0.9.0"
---
# Risk Register - autonomous-roadmaps

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that identifies a new risk)
**Feature:** 0000043-autonomous-roadmaps
**Version:** 0.9.0
**Overall Risk Level:** high

> Every entry must be specific to this feature. Do not produce generic risks.

## Risks

Rows R-001 to R-005 come from the design's Risks section. Rows R-006 to R-009 come from its Assumptions section, logged at likelihood medium.

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | security | The agent merges into the wrong base. | low | high | merge-guard blocks `gh pr merge` unless the PR base is `roadmap/*` and the flag is `--squash`. `main` branch protection applies in the test repo. | open |
| R-002 | operational | A child `claude -p` session prompts for permission and stops. | medium | medium | The driver detects a stalled `position` and stops with the step named. | open |
| R-003 | operational | A parent Claude session edits the working tree while the driver runs. | medium | high | The lock file at `plan/.roadmap-runner.lock`, and Activate's instructions to the parent session. | open |
| R-004 | operational | The human squash-merges the roadmap PR and orphans the step tags. | medium | low | The roadmap PR body asks for a merge commit, not a squash. | open |
| R-005 | operational | The acceptance run costs more tokens than expected. | high | low | Use a small CRUD app and four short steps. | open |
| R-006 | technical | Assumption: `claude -p` in a child process inherits the repo's hooks and the user's auth. If wrong, the driver can't run steps, and the chain runner needs another launch method. | medium | high | The acceptance run in the throwaway repo runs the driver end to end, so a failure shows before ship. | open |
| R-007 | technical | Assumption: `--permission-mode auto` lets a step finish with no prompt. If wrong, steps stall or end early. | medium | medium | The driver detects a stalled `position` and stops with the step named, as R-002 describes. | open |
| R-008 | operational | Assumption: the test repo allows squash merges and merge commits. If wrong, R-D Advance or the final merge fails. | medium | medium | Change the test repo settings to allow squash merges and merge commits before the acceptance run. | open |
| R-009 | technical | Assumption: a Bash hook can read a PR's base before the merge runs. If wrong, merge-guard must call `gh pr view` itself, which adds a network call per merge. | medium | low | merge-guard calls `gh pr view` itself, which the design names as the fallback. Each merge makes one extra network call. | open |
