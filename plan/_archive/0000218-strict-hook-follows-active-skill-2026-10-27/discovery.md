---
title: "Discovery - 0000218-strict-hook-follows-active-skill"
summary: "Raw discovery findings for initiative 0000195 step 15."
---
# Discovery - 0000218-strict-hook-follows-active-skill

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | `feat/0000218-strict-hook-follows-active-skill` cut from `initiative/0000195-backlog-clearance` |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` has no `SKILL.md`) |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.30.0`
- Prior features (`plan/_archive/`): steps 1 to 14 of initiative 0000195, latest `0000217-verify-codex-setup` (2026-10-27). Step 10 `0000205-initiative-skill` added the two-skill banner and the ack split.
- Constraining decisions: 0000205 REQ-002 gives the step session `RAVINTIO_INITIATIVE_STEP=1` and the human session `plan/.initiative-ack`. The auto-trigger hook already ignores the lock. The strict-mode hook still reads the lock.
- Component / data-ownership map: component `ravintio-zero` only. No data store.
- Repo instructions: `custom-001` to `custom-006` in `ravintio-overrides/instructions/`
- Backlog: entry 0000215 belongs to this step. Entry 0000174 is out of scope.
- Past retrospectives: newest is `0000217-verify-codex-setup-2026-10-27`.
- Migrations: 0004 and 0005 stay pending, because their `Applies when:` conditions are false in the pack source.
