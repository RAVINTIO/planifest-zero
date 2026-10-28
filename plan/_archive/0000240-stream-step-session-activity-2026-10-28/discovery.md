---
title: "Discovery - 0000240-stream-step-session-activity"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000240-stream-step-session-activity

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and `src/`-style source sits beside it. Only signal. |
| Git pre-flight | Branch `feat/0000240-stream-step-session-activity` cut from `initiative/0000238-backlog-clearance-two` at dc3a185. Initiative step: no main sync question. |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` not present) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.30.2`. Step bump is `minor`, so the target is `0.31.0`.
- Prior features (`plan/_archive/`): latest is 0000239-test-suite-reliability (2026-10-28), step 1 of this initiative.
- Constraining ADRs: initiative-driver ADR-004 of 0000043 (fresh `claude -p` session per step). Step logs hold child stdout and stderr, mode 600, and the driver never prints them.
- Component map: one component, `ravintio-zero` (`ravintio-zero/component.yml`). Touched files: `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/scripts/initiative-watch.mjs`, `ravintio-zero/skills/ravintio-initiative/SKILL.md`, `ravintio-zero/standards/roadmap-standards.md`.
- Repo instructions: `ravintio-overrides/instructions/custom-001` to `custom-006` (local git rules, subagent decomposition, GUTD, ship push and PR, branch deletion, setup refresh approval).
- Backlog entry 0000219 has a Wanted outcome section. Pulled in, folder deleted in the same commit.
- Decisions row for step 2: use `--output-format stream-json --verbose`, reader in `initiative-watch.mjs`, stream poll lowered to 10 seconds.
- Skill line cap: 35 lines of headroom under 1,720 lines on 2026-10-28. Orchestrator `SKILL.md` must not grow (21 bytes headroom).
