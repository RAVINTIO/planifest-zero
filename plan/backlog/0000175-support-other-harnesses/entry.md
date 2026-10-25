---
title: "Backlog Entry: 0000175 - support agent harnesses other than Claude Code"
summary: "A human-requested capability, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000175 - support agent harnesses other than Claude Code

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

RAVINTIO Zero installs for Claude Code only. `setup.sh` sets `VALID_TOOLS="claude-code"`, and `setup.ps1` matches it. The boot file, the skills folder, and the enforcement hooks all target `.claude/`. A team that uses another agent harness can't install the pipeline.

Feature 0000030 removed eight tool targets on purpose, to cut the framework down to Claude Code. The removed targets were Cursor, Windsurf, Cline, Codex, Copilot, Roo Code, OpenCode, and Antigravity. The 0000030 design shows what the old adapters covered, under `plan/_archive/0000030-framework-cut-down-2026-08-22/`.

## Suggested Action

Pick the harnesses to support first, for example Codex and Cursor, which read `AGENTS.md`. For each one, decide how setup installs the boot file and skills. Then decide how each enforcement hook maps to that harness's hook or rule system. Where a harness has no hooks, fall back to instruction-based enforcement and say so in the setup output. Add each tool to `VALID_TOOLS`, the refresh-setup skill, and the CI test matrix.

## Wanted outcome

`setup.sh` and `setup.ps1` accept at least one tool besides `claude-code`. For that tool, setup writes a boot file the harness loads and installs the skills where the harness finds them. Setup also reports which enforcement hooks are active and which fall back to instructions. A CI test runs setup for each supported tool.

## Why Deferred

The human asked for it while roadmap 0000168 was running. It reverses part of the 0000030 scope decision, so it needs its own design.
