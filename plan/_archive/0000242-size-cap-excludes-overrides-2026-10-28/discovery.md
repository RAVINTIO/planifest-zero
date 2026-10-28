---
title: "Discovery - 0000242-size-cap-excludes-overrides"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000242-size-cap-excludes-overrides

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and source sits beside it. Only signal. |
| Git pre-flight | Branch `feat/0000242-size-cap-excludes-overrides` cut from `initiative/0000238-backlog-clearance-two` at 723697a. Initiative step: no main sync question. |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` not present) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.31.1`. Step bump is `patch`, so the target is `0.31.2`.
- Prior features (`plan/_archive/`): latest is 0000241-watcher-false-events (2026-10-28), step 3 of this initiative.
- Component map: one component, `ravintio-zero`. Touched files: `ravintio-zero/tests/test-0000151-req-011-orchestrator-references-split.sh` and the docs that name its cap.
- Repo instructions: `ravintio-overrides/instructions/custom-001` to `custom-006`.
- Backlog entry 0000214 has a Wanted outcome section. Pulled in, folder deleted in the same commit.
- Size cap today: `SKILL.md` 27,779 bytes plus repo `CLAUDE.md` 10,317 bytes is 38,096 against a 38,200 cap. The override block between the `ravintio-overrides:instructions` markers in `CLAUDE.md` is 5,399 bytes. `CLAUDE.md` without that block is 4,918 bytes, which equals `ravintio-zero/templates/standard-boot.md`.
- Pack-only sum: 27,779 + 4,918 = 32,697 bytes.
- The `.ps1` twin of the test names no size cap, so only the `.sh` test changes.
- Decisions rows for step 4: size cap rows allow step 4 to change a cap. No other row applies.
