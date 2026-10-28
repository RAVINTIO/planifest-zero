---
title: "Discovery - 0000239-test-suite-reliability"
summary: "Raw discovery findings for initiative 0000238 step 1."
---
# Discovery - 0000239-test-suite-reliability

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `docs/about.md` exists |
| Git pre-flight | `feat/0000239-test-suite-reliability` cut from `initiative/0000238-backlog-clearance-two`, tree clean |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` has no `SKILL.md`) |

## Mode Findings

### Standard Iterative

- Current version (`product.yml`): `0.30.1`
- Prior features (`plan/_archive/`): initiative 0000195 steps 1 to 15, latest `0000218-strict-hook-follows-active-skill` (2026-10-27).
- Constraining decisions: none touch the test helpers. `helpers/assert.sh` is sourced by every Bash suite.
- Component / data-ownership map: component `ravintio-zero` only. No data store.
- Repo instructions: `custom-001` to `custom-006` in `ravintio-overrides/instructions/`
- Backlog: entries 0000211 and 0000212 belong to this step. Out of scope: 0000174, 0000220, 0000221.
- Installed-copy checks: `test-0000151-req-014` section (c) compares installed skills with the pack. `test-0000151-req-011` section (c) installs into a temp workspace, so it is unaffected.
- Migrations: 0004 and 0005 stay pending, because their `Applies when:` conditions are false in the pack source.
