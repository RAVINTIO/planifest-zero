---
title: "Requirement: req-006 - merge-guard-hook"
summary: "A PreToolUse hook on Bash blocks any gh pr merge unless the PR base is roadmap/* and the flag is --squash."
status: "draft"
version: "0.1.0"
---
# Requirement: req-006 - merge-guard-hook

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Source:** US-008
**Priority:** must-have

## User Story

As a human on the loop, I rely on a hook that blocks any agent merge outside `roadmap/*`, so that `main` stays human-only.

## Functional Requirements
- A new hook, `planifest-zero/hooks/enforcement/merge-guard.mjs`, runs as a PreToolUse hook on the `Bash` tool.
  - It reads the hook JSON from stdin through `read-stdin.mjs`.
  - It reads the shell command from `tool_input.command`.
- A command that does not run `gh pr merge` passes with exit 0.
- A `gh pr merge` command passes only when both conditions hold:
  - The command carries the `--squash` flag.
  - The PR's base branch starts with `roadmap/`.
- Any other `gh pr merge` command is blocked with exit 2.
  - The message is human-readable and starts with `[Planifest]`.
  - The message names the rule: merges into `main` are human-only, and the agent may squash-merge only into `roadmap/*`.
- The hook reads the PR base by calling `gh pr view` itself.
  - The design assumes a Bash hook cannot read the base any other way, so this adds one network call per merge.
  - If `gh pr view` fails or returns no base, the hook cannot confirm `roadmap/*` and blocks the merge.
- The hook follows the existing exit-code convention.
  - An enforcement failure exits 2 with a message on stdout.
  - Any unexpected error, such as unparseable stdin, exits 0.
- `setup.sh` and `setup.ps1` register the hook as a `PreToolUse` entry with matcher `Bash`.
  - Registration is idempotent and matches the other enforcement hooks in event, matcher, and order across both scripts.
  - The existing hook-match patterns in both scripts cover `merge-guard`, so a refresh replaces the entry and keeps user hooks.

## Acceptance Criteria
- [ ] (a) A unit test in `planifest-zero/tests/` pipes hook JSON into `merge-guard.mjs` with a stub `gh` on `PATH`. A `gh pr merge --squash` for a `roadmap/*` base exits 0. A merge with base `main`, a merge without `--squash`, and a merge whose `gh pr view` fails each exit 2 with a `[Planifest]` message.
- [ ] (b) The same test shows that a non-merge Bash command, a non-Bash payload, and malformed stdin each exit 0.
- [ ] (c) A grep test finds `merge-guard` registered with matcher `Bash` under `PreToolUse` in both `setup.sh` and `setup.ps1`, and a parity check confirms the two entries match.

## Dependencies
- Design assumption: a Bash hook can read a PR's base before the merge runs. If wrong, the hook calls `gh pr view` itself, which this requirement already specifies.
- REQ-010 carries the governance text that permits the carve-out this hook enforces.
- Files in reach:
  - `planifest-zero/hooks/enforcement/merge-guard.mjs` (new)
  - `planifest-zero/hooks/enforcement/read-stdin.mjs` (reused, no change)
  - `planifest-zero/hooks/enforcement/gate-write.mjs` (convention reference, no change)
  - `planifest-zero/setup.sh`
  - `planifest-zero/setup.ps1`
  - `planifest-zero/tests/` (new merge-guard test script, and the existing hook parity suite if it counts hooks)

## Input Validation

- [ ] Input source: hook stdin field `tool_input.command`, and the PR base string returned by `gh pr view`
- [ ] Allowed character pattern: the hook only matches the command text against a `gh pr merge` pattern and never executes it, evaluates it, or passes it to a shell. The PR reference it extracts is limited to `[a-zA-Z0-9\-_./#:]`, and all other characters are stripped before use as a `gh pr view` argument.
- [ ] maximum length: 4096 characters of command text are inspected, content beyond this limit is truncated
- [ ] Failure behaviour: unparseable stdin or an absent command exits 0. A `gh pr merge` whose base cannot be read exits 2.
- [ ] Logging policy: sanitised value only in output. The block message names the base branch and never echoes the raw command.
