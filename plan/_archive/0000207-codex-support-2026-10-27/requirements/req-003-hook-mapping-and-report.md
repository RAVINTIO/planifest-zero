# Requirement: REQ-003 - the hook mapping and report

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0
**Source:** US-003
**Priority:** must-have

## User Story

As a developer who uses Codex, I see which enforcement hooks are active and which fall back to instructions, so that I know what the harness enforces.

## Functional Requirements
- Setup for `codex` copies `merge-guard.mjs` and `read-stdin.mjs` to `.codex/hooks/enforcement/`.
- Setup merges a `PreToolUse` group with matcher `Bash` into `.codex/hooks.json`. The command runs `merge-guard.mjs` from the repo root, found with `git rev-parse --show-toplevel`.
- A rerun leaves one `merge-guard` entry and keeps other entries in the file.
- If `.codex/hooks.json` is not valid JSON, setup prints one fixed line, writes nothing, and exits 1.
- Setup prints an active list, a fallback list, and a line to review the hooks with `/hooks`.
- `AGENTS.md` states each fallback rule as an instruction.

## Acceptance Criteria
- [ ] AC-1: merge-guard is wired
  - Given a project with no `.codex` folder
  - When you run `setup.sh codex` twice
  - Then `.codex/hooks.json` holds one `PreToolUse` `Bash` entry for `merge-guard`
- [ ] AC-2: the report names both lists
  - Given the same run
  - When a test reads the setup output
  - Then it lists `merge-guard` as active, `gate-write` as a fallback, and the `/hooks` review step
- [ ] AC-3: invalid JSON stops setup
  - Given a `.codex/hooks.json` that is not JSON
  - When you run `setup.sh codex`
  - Then setup exits 1, prints one fixed error line, and leaves the file unchanged

## Dependencies
- REQ-001, REQ-002
