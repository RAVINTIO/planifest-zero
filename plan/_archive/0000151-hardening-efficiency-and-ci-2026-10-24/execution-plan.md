# Execution Plan - hardening-efficiency-and-ci

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [plan](../../planifest-zero/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Version:** 0.11.0
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | | No capability skill applies |

## Decisions referenced

| ADR | Decision |
|-----|----------|
| ADR-001 | Stack unchanged |
| ADR-002 | Hooks write block reasons to stderr and stdout |
| ADR-003 | Ship clears sentinels before the PR, and the tag goes with the branch |
| ADR-004 | A dependency exception stop applies in every run |
| ADR-005 | The roadmap driver's child contract: model, turn cap, step logs, telemetry labels |
| ADR-006 | Rarely used orchestrator sections move to `references/` |
| ADR-007 | Setup prunes retired hooks by a names list |
| ADR-008 | Park refuses any symlink in the entry path |

## Functional Requirements Directory

Each file follows the naming convention `req-{NNN}-{kebab-slug}.md` and the [Requirement Template](../../planifest-zero/templates/requirement.template.md). Each file lists its own files in reach and new test file.

| File | Requirement | Source |
|------|------------|--------|
| [req-001-park-symlink-containment.md](requirements/req-001-park-symlink-containment.md) | Park refuses symlinked entry paths | US-001 |
| [req-002-ship-sentinels-before-pr.md](requirements/req-002-ship-sentinels-before-pr.md) | Ship clears sentinels before the PR | US-002 |
| [req-003-hook-block-reasons-on-stderr.md](requirements/req-003-hook-block-reasons-on-stderr.md) | Block reasons reach stderr | US-003 |
| [req-004-prune-retired-hooks.md](requirements/req-004-prune-retired-hooks.md) | Setup prunes retired hooks | US-004 |
| [req-005-setup-write-error-line.md](requirements/req-005-setup-write-error-line.md) | One fixed line for a settings write error | US-005 |
| [req-006-roadmap-step-model-and-turn-cap.md](requirements/req-006-roadmap-step-model-and-turn-cap.md) | Roadmap steps take a model and a turn cap | US-006 |
| [req-007-dispatch-model-tiers.md](requirements/req-007-dispatch-model-tiers.md) | Dispatch passes real model tiers | US-006 |
| [req-008-quiet-test-output.md](requirements/req-008-quiet-test-output.md) | Quiet test mode | US-006 |
| [req-009-context-size-at-gates.md](requirements/req-009-context-size-at-gates.md) | Context size advice at gates | US-006 |
| [req-010-webfetch-via-subagent.md](requirements/req-010-webfetch-via-subagent.md) | Large WebFetch pages go through a subagent | US-006 |
| [req-011-orchestrator-references-split.md](requirements/req-011-orchestrator-references-split.md) | Orchestrator reference files | US-006 |
| [req-012-roadmap-step-logs.md](requirements/req-012-roadmap-step-logs.md) | Per-step roadmap logs | US-007 |
| [req-013-roadmap-telemetry-labels.md](requirements/req-013-roadmap-telemetry-labels.md) | Roadmap telemetry labels | US-008 |
| [req-014-chart-clarity-and-dependency-stop.md](requirements/req-014-chart-clarity-and-dependency-stop.md) | Chart clarity check and dependency stop | US-009 |
| [req-015-faster-powershell-ci.md](requirements/req-015-faster-powershell-ci.md) | PowerShell CI matrix and timing | US-010 |

## Non-functional requirements

| NFR | Target | Requirement |
|-----|--------|-------------|
| CI duration | `windows-powershell` wall time below the slower of today's two steps | REQ-015 |
| Test output size | A passing full run in quiet mode prints under 10 KB | REQ-008 |
| Starting context | Orchestrator `SKILL.md` at least 25% smaller, with no rule lost | REQ-011 |
| Security | No write or delete outside the repo through a symlink in `park.mjs` | REQ-001 |

## API and data summary

- No API. No OpenAPI specification applies.
- No new data store. The driver writes step logs to `plan/.roadmap-logs/`, which `.git/info/exclude` keeps out of commits.
- `roadmap.md` gains a `## Dependencies` table. `design.md` gains an approved-dependencies field.

## Implementation order

All agents share one working tree. Requirements that share a file run in sequence inside a track. Tracks run in parallel, and each agent edits only its own sections.

### Batch 1: seven parallel tracks

| Track | Sequence | Shared file | Reason |
|-------|----------|-------------|--------|
| A: setup | REQ-004, REQ-005 | `setup.sh`, `setup.ps1` | Both edit the setup scripts. |
| B: hooks | REQ-003 | `planifest-zero/hooks/enforcement/` | No overlap. |
| C: park | REQ-001 | `park.mjs` | No overlap. |
| D: ship | REQ-002 | ship `SKILL.md`, R-D Advance text | No overlap with the driver sections of `roadmap-standards.md`. |
| E: driver | REQ-006, REQ-012, REQ-013 | `roadmap-run.mjs`, driver tests | All three change the one spawn site. |
| F: dispatch and tests | REQ-007, REQ-010, REQ-008 | `agent-dispatch-standards.md`, `assert.*`, `run-tests.*` | REQ-007 and REQ-010 edit the same standard. |
| G: CI | REQ-015 | workflow, `setup-workspace.ps1` | Track F edits `run-tests.ps1`, so REQ-015 leaves that file alone or runs after REQ-008. |

### Batch 2: orchestrator, in sequence

REQ-014, then REQ-009, then REQ-011. All three edit the orchestrator `SKILL.md`. REQ-011 moves sections, so it runs last, once every other edit has landed.

## Completion

- Rerun `bash planifest-zero/setup.sh claude-code` so the `.claude/` copies match the sources.
- Run the full suite in quiet mode, then once in full for the P3 evidence.
