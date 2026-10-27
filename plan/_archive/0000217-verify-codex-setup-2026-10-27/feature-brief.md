---
title: "Feature Brief - verify codex setup"
summary: "Checks the codex setup target against the real Codex program."
status: "approved"
version: "0.1.0"
---
# Feature Brief - verify codex setup

**Feature ID:** 0000217-verify-codex-setup

## Business Goal

Step 12 added the `codex` setup target but could not run Codex. This step runs the real program against a fresh repo, so the claims that Codex loads `AGENTS.md` and skills and that `merge-guard` blocks a merge rest on evidence. If a check fails, the step fixes the target.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Verify codex setup | As a maintainer, I run the codex target against real Codex, so that I know it loads the pack and blocks merges. | must-have | 1 |

## Scope Boundaries

### In Scope
- Run `setup.sh codex` in a fresh temp repo and run `codex exec` twice there.
- Record commands, outputs, and the Codex version in the acceptance evidence.
- On a failure, fix the `codex` target and add a test that reproduces it.

### Out of Scope
- Changing the `codex` target when both checks pass.
- Adding Codex to CI. The checks make model calls and run locally only.

### Deferred
- None.

## Acceptance Criteria

- [ ] AC-1: Codex loads `AGENTS.md` and names at least one RAVINTIO skill from `.agents/skills/`.
- [ ] AC-2: `merge-guard` blocks `gh pr merge 1 --merge` with exit 2, and the stub `gh` log stays empty.
- [ ] AC-3: The acceptance evidence records the commands, outputs, and the Codex version.
- [ ] AC-4: If a check fails, a test reproduces the failure and passes after the fix, and the bump rises to minor.
