---
title: "Discovery - 0000243-session-start-detection"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000243-session-start-detection

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and source sits beside it. Only signal. |
| Git pre-flight | Branch `feat/0000243-session-start-detection` cut from `initiative/0000238-backlog-clearance-two` at 616f4d0. Initiative step: no main sync question. |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` not present) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.31.2`. Step bump is `minor`, so the target is `0.32.0`.
- Prior features (`plan/_archive/`): latest is 0000242-size-cap-excludes-overrides (2026-10-28), step 4 of this initiative.
- Component map: one component, `ravintio-zero`. Touched files: `ravintio-zero/hooks/enforcement/auto-trigger-orchestrator.mjs`, a new `ravintio-zero/scripts/resume-detect.mjs`, the orchestrator `SKILL.md` and a new reference file, the initiative skill, and tests.
- Repo instructions: `ravintio-overrides/instructions/custom-001` to `custom-006`.
- Backlog entry 0000237 has a Wanted outcome section. Pulled in, folder deleted in the same commit.
- Resume Detection in `SKILL.md` is 4,324 bytes by `awk` from the heading to the next heading. The target is 400 bytes or fewer. `SKILL.md` is 27,779 bytes against a 27,800-byte cap.
- Pending migrations: 0004 and 0005. Both have an `Applies when:` condition that is false in the pack source.
- Decisions rows for step 5: the script runs inside `auto-trigger-orchestrator.mjs`, on the prompt where it injects the load instruction. Size cap rows stop any step that fails a cap, and only steps 4, 6, and 7 may change one.
- The skill line cap is 1,720 lines with 35 lines of headroom. Step 5 adds skill text.
