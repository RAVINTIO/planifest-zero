---
title: "Discovery - 0000241-watcher-false-events"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000241-watcher-false-events

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs and source sits beside it. Only signal. |
| Git pre-flight | Branch `feat/0000241-watcher-false-events` cut from `initiative/0000238-backlog-clearance-two` at 1d4bde8. Initiative step: no main sync question. |
| Skills inbox | empty (`ravintio-zero/skills-inbox/` not present) |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.31.0`. Step bump is `patch`, so the target is `0.31.1`.
- Prior features (`plan/_archive/`): latest is 0000240-stream-step-session-activity (2026-10-28), step 2 of this initiative. It edited the same watcher file.
- Component map: one component, `ravintio-zero`. Touched files: `ravintio-zero/scripts/initiative-watch.mjs`, the watcher tests, and `ravintio-zero/standards/roadmap-standards.md`.
- Repo instructions: `ravintio-overrides/instructions/custom-001` to `custom-006`.
- Backlog entry 0000216 has a Wanted outcome section with four conditions. Pulled in, folder deleted in the same commit.
- Decisions rows for step 3: the planned driver restart. It happens at I-D Advance, after this step merges.
- Skill line cap: 1,687 of 1,720 lines. This step adds no skill text.
- Watcher state: the stale check fires when a commit is newer than the log by any amount and the log is older than 15 minutes. It repeats on every pass. Commit tracking reads the last 100 commits and treats an unknown last-seen commit as "all new". The lock state is read with `existsSync` on each pass.
