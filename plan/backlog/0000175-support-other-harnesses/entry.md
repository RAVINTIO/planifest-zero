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

Feature 0000030 removed eight tool targets on purpose, to cut the pack down to Claude Code. The removed targets were Cursor, Windsurf, Cline, Codex, Copilot, Roo Code, OpenCode, and Antigravity. The 0000030 design in `plan/_archive/` shows what the old adapters covered.

## Suggested Action

Support Codex first. The human on the loop chose it on 2026-10-25. Codex reads `AGENTS.md`.

- Add `codex` to `VALID_TOOLS` in `setup.sh` and `setup.ps1`, and to the refresh-setup skill.
- Have setup write an `AGENTS.md` boot file and install the skills where Codex finds them.
- Map each enforcement hook to a Codex hook where one exists. Where none exists, fall back to an instruction in `AGENTS.md`, and say so in the setup output.
- Add `codex` to the CI test matrix.

## Wanted outcome

`setup.sh` and `setup.ps1` accept `codex`. For Codex, setup writes a boot file the harness loads and installs the skills where the harness finds them. Setup also reports which enforcement hooks are active and which fall back to instructions. A CI test runs setup for `codex` and checks the files it writes.

## Why Deferred

The human asked for it while roadmap 0000168 was running. It reverses part of the 0000030 scope decision, so it needs its own design.
