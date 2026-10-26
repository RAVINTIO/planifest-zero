---
title: "Discovery - 0000192-rename-runner-lock-and-archive"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000192-rename-runner-lock-and-archive

> Created at the start of discovery (P0), before the first coaching question.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds prior runs, the latest 0000189-name-the-roadmap-initiative |
| Git pre-flight | `feat/0000189-name-the-roadmap-initiative at 4d74fc7. The human asked for this run on the open branch and PR #37.` |
| Skills inbox | `empty (.gitkeep only)` |

## Mode Findings

### Standard Iterative

- Current version: `0.19.0` on this branch, not yet released. The last release tag is `v0.18.1`.
- Prior features: 0000189-name-the-roadmap-initiative renamed every name in its design Names table. 0000043 and 0000151 built the driver, its lock, and the delivery check.
- Constraining ADRs:
  - 0000043 ADR-004 driver script, fresh session per step
  - 0000189 ADR-002 clean break with migration
  - 0000189 ADR-005 old-name guard allowlist
- Open backlog: 0000174 to 0000186 (left for the next initiative), 0000190 (merge-guard), 0000191 (this run).

## Backlog pickup

- 0000191 rename the runner lock and delivery archive folder: pulled in by the human.

## Release budget

- `product.yml` sets no `releaseSize`, so no budget applies. This run holds one entry.

## Pending migrations

- 0004 and 0005 stay pending in the pack source. Their `Applies when:` conditions are false here.
