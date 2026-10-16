# Architecture Overview

Last updated: 0000033-remove-telemetry-mcp

## What this repo is

This repo is the Planifest framework itself. It holds one component, `planifest-zero`, which other projects install into their working tree.

The framework is not a service. It has no runtime of its own. It ships four things:

1. **Skills.** Markdown instructions that Claude Code auto-discovers from `.claude/skills/`. Twelve skills drive the five-phase pipeline.
2. **Hooks.** Node `.mjs` scripts that Claude Code invokes synchronously at tool-call boundaries. Enforcement hooks block or annotate. Git hooks guard commits and pushes. No hook makes an outbound network call.
3. **Standards, templates, and schemas.** The reference material that skills bundle at install time.
4. **Setup scripts.** `setup.sh` and `setup.ps1` copy the above into a target project and wire `.claude/settings.json`.

---

## Pipeline

The pipeline runs five phases. There is one route: every change is a feature change, and a small change is a small run. Each agent response carries its phase prefix.

| Phase | Prefix | Owning skill |
|-------|--------|--------------|
| Discovery | `D:` | planifest-orchestrator |
| Plan | `PL:` | planifest-plan |
| Implement | `IM:` | planifest-implement |
| Validate and accept | `VA:` | planifest-validate-and-accept |
| Ship | `SH:` | planifest-ship |

The implement phase dispatches a TDD trio per requirement: planifest-test-writer, planifest-implementer, and planifest-refactor. Four support skills complete the set of twelve: planifest-loop-runner, planifest-optimise-agent, planifest-migrator, and planifest-refresh-setup.

---

## Install flow

Setup targets Claude Code only. It copies skills and hooks into `.claude/`, prunes retired skills, writes the boot file, and wires the git hooks.

```
planifest-zero/          setup.sh claude-code          target project
├── skills/          ──────────────────────────────────▶   .claude/skills/
├── templates/       ── bundled per skill frontmatter ──▶   .claude/skills/*/assets/
├── standards/       ── bundled per skill frontmatter ──▶   .claude/skills/*/references/
├── workflows/       ──────────────────────────────────▶   .claude/commands/
├── hooks/enforcement/ ────────── always ──────────────▶   .claude/hooks/enforcement/
└── templates/standard-boot.md ───────────────────────▶   CLAUDE.md
```

Skills bundle selectively. Each `SKILL.md` declares `bundle_templates` and `bundle_standards` in its frontmatter, and setup copies only those files. A skill with no manifest gets everything.

Boot files are disposable build outputs. Every run regenerates `CLAUDE.md` from the template, then re-appends the contents of `planifest-overrides/instructions/` between sentinel markers. Durable local customisation lives in the overrides directory, never in the boot file.

---

## Setup-config record

`setup.sh` and `setup.ps1` write the tracked record of active setup flags to `plan/state/{tool}.md`, creating the folder when it is absent. The record and the gitignored flags marker hold `tool`, `flags`, and `writtenAt`. The `planifest-refresh-setup` skill reads and validates that record before falling back to the gitignored marker and hook inference.

---

## Enforcement model

Enforcement is deterministic where it can be, and instructional where it cannot.

**Deterministic.** A hook exits 2 with a human-readable message and Claude Code blocks the tool call. `gate-write` blocks writes to `src/` without a confirmed design. `ratchet-check` blocks weakening edits to an active loop's artifacts. `em-dash-guard` rejects U+2014 in scoped prose paths.

**Instructional.** Skills tell the agent what to do. The orchestrator's hard limits, the one-question-at-a-time rule, and the phase gates all rely on the agent following its instructions.

Every hook fails open on an unexpected error. Exit 0 with no output means the tool call proceeds. That is deliberate: a broken hook must never stop a session.

---

## Upgrade cleanup

Every setup run retracts telemetry wiring that an earlier install left in the target project. It runs before the enforcement hook install, so that install writes `.claude/settings.json` last. Setup removes these items when present:

- hook entries in `.claude/settings.json` whose command runs a retired telemetry module as `<module>.mjs` at a path boundary
- hook entries whose matcher or command names `mcp__structured-telemetry-mcp__emit_event`
- the `.claude/telemetry-enabled` sentinel
- the `plan/.telemetry-failures/` and `plan/.telemetry-receipts/` directories

The module match is case-sensitive. Setup prints one line per removal and stays silent when nothing is present. A failed removal prints a warning and setup carries on.

---

## Version derivation

`product.yml` holds the product-level version manifest. Under `versionPolicy: max-component-version`, `scripts/product-version.mjs` reads each listed `component.yml` live and takes the highest. Nothing caches a version, so the list only changes when a component is added or removed.

This project has one component and keeps `product.yml` anyway. Its top-level `id` gives the product a stable name for versioning and for attributing archived runs, wherever the repo is cloned. The orchestrator hard-stops at discovery when that `id` is missing.

The five phase names live in prose in `planifest-zero/pipeline-reference.md`. No module encodes them.
