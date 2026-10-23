# Changelog (0000043-autonomous-roadmaps, 24 Oct 2026)

**Feature:** autonomous-roadmaps
**Version:** 0.10.0
**PR:** raised at P4 Ship

## What changed

Planifest Zero can now run a chain of feature steps from one human approval. The human charts a roadmap once, and a driver script runs each step through P0 to P4 to a squash merge and tag. It ends in one roadmap PR to `main`.

- req-001: a draft roadmap is filed at `plan/roadmap/{id}-{slug}/roadmap.md` on any branch, as a backlog entry is. Ids share the backlog sequence.
- req-002: R-A Chart plans a roadmap from a new idea or a draft. The human's confirmation is the single approval.
- req-003: R-B Activate cuts `roadmap/{id}-{slug}`, writes `plan/current-roadmap/roadmap.md`, and refuses without a remote, `gh` access, or when a roadmap is already active.
- req-004: a step's P0 builds the brief from its backlog entries and self-confirms the design and scope lock.
- req-005: R-D Advance raises the step PR against the roadmap branch, waits for green CI, and squash-merges it.
- req-006: the `merge-guard` hook blocks any `gh pr merge` unless it is a squash into a `roadmap/*` base. It fails closed when it cannot read the base.
- req-007: `planifest-zero/scripts/roadmap-run.mjs` runs each step as its own `claude -p` session, holds a lock, and stops on a block or a stalled position.
- req-008: R-E Delivery archives the roadmap and raises one PR to `main` that asks for a merge commit.
- req-009: a restarted driver resumes the same step. Stage prefixes `R-A Chart:` to `R-E Delivery:` sit beside P0 to P4.
- req-010: the merge carve-out text in the orchestrator, ship skill, and overrides allows the roadmap squash merge. Merging into `main` stays human-only.

New files: `planifest-zero/standards/roadmap-standards.md`, `planifest-zero/templates/roadmap-entry.template.md`, `planifest-zero/scripts/roadmap-run.mjs`, and `planifest-zero/hooks/enforcement/merge-guard.mjs`. Setup wires `merge-guard` on Bash `PreToolUse`, which brings the hook count to seven.

## Why

An autonomous run reached a PR, but a multi-release initiative still needed the human at every release. Backlog entries 0000098 and 0000099 asked for a roadmap area and for an autonomous multi-release run. Both are folded into this feature and deleted from the backlog.

Decisions:

- ADR-001: the stack stays as declared.
- ADR-002: drafts in `plan/roadmap/`, one active roadmap in `plan/current-roadmap/`.
- ADR-003: the agent may squash-merge its own step PR into `roadmap/*`. This amends the 0000042 merge rule.
- ADR-004: a Node driver runs each step in a fresh session.
- ADR-005: a roadmap step tags the squash commit after the merge.
- ADR-006: roadmap steps self-confirm, and stage prefixes R-A to R-E are added.

## Deviations

- In P2, the roadmap detail moved from the orchestrator and ship skills to `planifest-zero/standards/roadmap-standards.md`. The skills keep pointers. The 0000031 context-cost limit on skill text forced the move, and the tests for req-001 to req-005, req-008, and req-009 now read the standard.

## Validation results

Recorded at P3 Validate and P4 Ship.

Backlog filed during this run:

- 0000145: the driver discards each child session's output, so a blocked step leaves only the build log for diagnosis.

## Skipped phases

None
