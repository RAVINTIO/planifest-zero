---
title: "Discovery - 0000043-autonomous-roadmaps"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000043-autonomous-roadmaps

> Created at the start of discovery (P0), before the first coaching question, in every adoption mode.
> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.
> Unreadable signal: say so, and coaching proceeds.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds feature directories (latest `0000042-autonomous-mode-and-prefixes-2026-10-23`) |
| Git pre-flight | Branch `feat/0000043-autonomous-roadmaps` cut from `main` at `1d21190` after PR #20 merged. Redundant branch `feat/0000042-autonomous-mode-and-prefixes` deleted. Working tree clean. |
| Skills inbox | empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.9.0`
- Prior features (`plan/_archive/`): 0000030 to 0000042. The latest, 0000042, added the `gated` and `autonomous` run modes and the P0 to P4 prefixes.
- Constraining ADRs (unless superseded):
  - 0000042 ADR-002: gated and autonomous run modes. Autonomous runs to a raised PR. Five exception stops apply to both modes.
  - 0000040 ADR-005: park keeps the work on the feature branch.
- Component / data-ownership map (`docs/`): one component, `planifest-zero`, a component pack of skills, hooks, templates, and standards.
- Repo instructions (`planifest-overrides/instructions/`): five files.
  - `custom-001-local-git-only.md`: merging pull requests is human-only, with no exception.
  - `custom-002-prefer-subagent-decomposition.md`
  - `custom-003-git-up-to-date-shorthand.md`
  - `custom-004-ship-push-and-raise-pr.md`
  - `custom-005-delete-redundant-local-branches.md`

## Backlog

| Entry | Status | Relevance |
|-------|--------|-----------|
| 0000095-retire-legacy-telemetry-cleanup | open | none |
| 0000098-roadmap-area-in-plan | open | core: roadmap record |
| 0000099-autonomous-multi-release-initiative | open | core: chain runner across cleared sessions. Its text cites a stale `P9`. |
| 0000100-workflow-quality-and-governance-gates | open | related, not required |
| 0000110-subagent-acceleration | open | related, not required |
| 0000139-setup-sh-read-only-settings-stack-trace | open | none |
| 0000142-park-entry-path-follows-symlinks | open | none |
| 0000143-stale-installed-hooks | open | none |
| 0000144-ship-sentinel-commit-after-pr | open | none |

Backlog id high-water mark: `0000144`.

## Release sizing

- `releaseSize` in `product.yml`: absent, so the `medium` budget of 8 points applies.
- Candidate estimate: 11 points.
  - Roadmap record: M (2)
  - Chain runner: L (4)
  - Roadmap branch: M (2)
  - Agent merge into `roadmap/*`: M (2)
  - Final roadmap PR to `main`: S (1)
- The human chose one feature over the recommended split.

## Constraints found

- The ship skill raises its PR against the default base branch. It has no notion of a roadmap base.
- The orchestrator and `custom-001-local-git-only.md` make merging human-only. Agent merge into `roadmap/*` needs a narrow carve-out.
- The `gh` token holds the `gist`, `read:org`, and `repo` scopes. It can create a repo in the `planifest` organisation but lacks `delete_repo`.
