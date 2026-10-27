---
title: "Discovery - 0000217-verify-codex-setup"
summary: "Raw discovery findings for initiative 0000195 step 14."
---
# Discovery - 0000217-verify-codex-setup

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | `feat/0000217-verify-codex-setup` cut from `initiative/0000195-backlog-clearance`, in sync with origin |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` has no `SKILL.md`) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.29.1`
- Prior features (`plan/_archive/`): steps 1 to 13 of initiative 0000195, latest `0000208-refresh-setup-record` (2026-10-27). Step 12 `0000207-codex-support` added the `codex` target.
- Constraining ADRs: 0000207 ADR-002 wires only `merge-guard` as a Codex hook. Every other hook stays an instruction in `AGENTS.md`.
- Component / data-ownership map: component `ravintio-zero` only. No data store.
- Repo instructions: `custom-001` to `custom-006` in `ravintio-overrides/instructions/`
- Backlog: no entry belongs to this step (chore). Entry 0000174 is out of scope.
- Past retrospectives: newest is `0000208-refresh-setup-record-2026-10-27`. Step 12 acceptance noted that no Codex program was available, so the hooks.json shape and the exit 2 contract rest on the Codex docs.
- Tools: `/opt/homebrew/bin/codex` is `codex-cli 0.163.0`.
- Migrations: 0004 and 0005 stay pending, because their `Applies when:` conditions are false in the pack source.
