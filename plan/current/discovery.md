---
title: "Discovery - 0000042-autonomous-mode-and-prefixes"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000042-autonomous-mode-and-prefixes

> Created at the start of discovery (P1), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` (assumed, only signal) |
| Detection signal | `plan/_archive/` holds feature dirs up to 0000041. `docs/about.md` exists. |
| Git pre-flight | Started on `main`, clean, level with `origin/main` after fetch. Branched to `feat/0000042-autonomous-mode-and-prefixes`. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.8.0`. `versionPolicy: max-component-version`. `releaseSize` absent, so the budget is medium (8 points).
- Prior features (`plan/_archive/`): latest 0000037 to 0000041 (self-hosting, setup hardening, park). 0000023 added the continuous-run gate rules and `test-0000023-req-001-continuous-run-p1-p3.sh`.
- Pending migrations: none.
- Repo instructions: `custom-001` to `custom-005` (git permissions, subagent decomposition, GUTD, push and raise PR at ship, delete redundant branches).
- Backlog: 0000095, 0000098, 0000099, 0000100, 0000110, 0000139, 0000142, all open. None pulled in.

## Findings relevant to this release

- "Continuous" appears in the orchestrator skill (run-mode question, restore, P2 to P4 gate rows), `validate-and-accept` SKILL.md, `pipeline-reference.md`, `getting-started.md`, `workflows/feature-pipeline.md`, and `test-0000023-req-001-continuous-run-p1-p3.sh`. `plan/.run-mode` stores `continuous` or `interactive`.
- `pipeline-reference.md:74` lets a continuous run skip P4 when nothing needs checking. The orchestrator and validate-and-accept skills say acceptance always stops. The two conflict.
- Prefix formats disagree. The orchestrator uses `D: Starting: ...`. `pipeline-reference.md` uses `PL: Starting, ...`. Prefixes carry no phase number, though the build log and hooks use P1 to P5.
- The orchestrator still says "P0 briefing" (line 227), a stale phase number.
- `product.yml` and `planifest-zero/component.yml` name the product "Planifest Framework". Planifest Framework is a separate product (`planifest/planifest-framework`).
- Installed copies under `.claude/skills/` mirror `planifest-zero/skills/` and refresh through setup.
- No hook in `planifest-zero/hooks/` parses `### P<n>:` headings, despite orchestrator Hard Limit 10. The hooks already say "Phase 0" in three messages (`check-design.mjs:52`, `gate-write.mjs:108`, `gate-write.mjs:123`).
- The installed `.claude/hooks/enforcement/` holds four files with no source in `planifest-zero/hooks/`: `check-telemetry-failures.mjs`, `check-telemetry-receipts.mjs`, and `phase-enum.mjs`, plus their wiring if any. `.claude/` is not tracked.
- About 28 non-test files and 23 test files cite a phase number. About 71 files contain "framework", many as generic uses such as the 22 `test-frameworks.md` standards.
