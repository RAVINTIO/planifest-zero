---
title: "Discovery - 0000244-split-orchestrator-skill"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000244-split-orchestrator-skill

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and source sits beside it. Only signal. |
| Git pre-flight | Branch `feat/0000244-split-orchestrator-skill` cut from `initiative/0000238-backlog-clearance-two` at 83c73da. Initiative step: no main sync question. |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` holds no `SKILL.md`) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.32.0`. Step bump is `minor`, so the target is `0.33.0`.
- Prior features (`plan/_archive/`): latest is 0000243-session-start-detection (2026-10-28), step 5 of this initiative.
- Component map: one component, `ravintio-zero`. Touched files: the orchestrator `SKILL.md`, new `references/orchestrator-*.md` files, `roadmap-standards.md`, and tests that read `SKILL.md`.
- Repo instructions: `ravintio-overrides/instructions/custom-001` to `custom-006`.
- Backlog entry 0000236 has a Wanted outcome section. Pulled in, folder deleted in the same commit.
- `SKILL.md` is 23,912 bytes on 2026-10-28 after step 5 (the entry measured 27,779). Resume Detection is already 344 bytes. The target is 9,000 bytes or fewer.
- Task-bound sections still inline: How You Coach (1,442), Discovery Start Actions (5,505), Discovery Gate Checklist (1,355), Design Confirmation (1,719), Phase Invocation (3,193), Exception Stops (2,635). Together 15,849 bytes.
- Pack Index is 2,144 bytes. The initiative stage prefix block sits in Phases and Response Prefixes (2,058 bytes).
- 39 files in `ravintio-zero/tests/` mention `orchestrator/SKILL.md`.
- Pending migrations: 0004 and 0005. Both have an `Applies when:` condition that is false in the pack source.
- Decisions rows for step 6: none. Size cap rows stop any step that fails a cap, and only steps 4, 6, and 7 may change one. Step 6 sets the `SKILL.md` cap to 9,000 bytes.
- The skill line cap is 1,720 lines.
