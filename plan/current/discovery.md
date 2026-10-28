---
title: "Discovery - 0000245-boot-rules-into-skills"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000245-boot-rules-into-skills

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000245-boot-rules-into-skills`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.33.0` in frontmatter. The table row still reads `0.32.0`.
- Prior features: 0000242 (size cap excludes overrides), 0000243 (session start detection), 0000244 (split orchestrator skill), all archived 2026-10-28.
- Constraining ADRs: the boot files are disposable build outputs (0000029 ADR-001). Setup regenerates them each run and re-applies overrides.
- Component map: one component, `ravintio-zero`.
- Backlog entry: 0000222. `CLAUDE.md` measures 10,317 bytes. The target is 6,000 bytes or fewer, with every override in force.
- Boot template: `ravintio-zero/templates/standard-boot.md` holds 4,918 bytes. `codex-boot.md` holds 5,308 bytes.
- Overrides in `ravintio-overrides/instructions/`: six files, 5,299 bytes in total. `ravintio-overrides/capability-skills/` does not exist yet.
- Setup: `append_override_instructions` in `ravintio-zero/setup.sh` appends every override to the boot file. `copy_capability_skills` copies capability skills. `setup.ps1` carries the same functions.
- Chart decision for step 7: an override names its target skill in a `target:` frontmatter field. Setup appends it to that installed skill. An override with no target goes to the boot file.
- Version: chart sets a minor bump, so 0.34.0.

## Past retrospectives

- 0000244: tests read orchestrator text through one helper (entry 0000261), and stage run files by path (entry 0000213, step 9).
- 0000243: same helper finding.
- 0000242: test backlog wording at filing (entry 0000260).
- Carry forward: moved text breaks tests that read the old location. Move text verbatim and check against a fixture.
