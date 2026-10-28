---
title: "Discovery - 0000247-git-state-hygiene"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000247-git-state-hygiene

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000247-git-state-hygiene`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.35.0`.
- Prior features: 0000244, 0000245, 0000246, all archived 2026-10-28.
- Constraining ADRs: none touch git state rules.
- Component map: one component, `ravintio-zero`.
- Backlog entries: 0000213, 0000224, 0000231.
  - 0000213: the ship skill (`ravintio-ship/SKILL.md` step 4) says `git add` everything. The orchestrator skill has no staging rule. The orchestrator `SKILL.md` is 7,985 bytes against a 9,000-byte cap.
  - 0000224: `ravintio-zero/scripts/reserve-id.mjs` has no commit option. The retrospective (line 61), postmortem (line 56), and initiative (line 75) skills reserve ids and leave the counter uncommitted.
  - 0000231: `ravintio-zero/standards/agent-dispatch-standards.md` has no rule against `git stash` in a subagent. The skeleton prompts under `## Agent Dispatch Template` carry no git rule. `### Resuming an interrupted unit` tells the parent to stash and must keep doing so.
- Tests that hold counts and caps: skill text 1,720 lines (`test-0000031-req-003-five-phases.sh`), orchestrator `SKILL.md` 9,000 bytes (`test-0000151-req-011-orchestrator-references-split.sh`), reserve-id (`test-0000199-req-001-003-reserve-ids-from-counter.sh`).
- Version: chart sets a minor bump, so 0.36.0.

## Past retrospectives

- 0000195: the source retrospective for entries 0000224 and 0000231.
- 0000207: the source retrospective for entry 0000213.
