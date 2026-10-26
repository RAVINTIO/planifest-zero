---
title: "Backlog Entry: 0000193 - setup must reject a bad tool or flag before it changes anything"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000193 - setup must reject a bad tool or flag before it changes anything

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-26

---

## Problem

`setup.sh` and `setup.ps1` check the tool name too late. A run with an unknown tool, such as `codex`, `cursor`, or `open-code`, exits with code 1. Before that exit, setup has already changed the repo:

1. `initialize_repo` (`Initialize-RavintioRepo`) creates the repo structure and `.gitignore` if they're missing.
2. `activate_guardrails` (`Invoke-RavintioGuardrails`) sets `git config core.hooksPath ravintio-zero/hooks`. It also adds `.github/workflows/ravintio.yml` and `.gitattributes` if they're missing.
3. If `--strict-orchestrator` is present, setup writes `plan/.orchestrator-strict`.
4. The tool check runs and prints `Unknown tool: {name}`.

See `ravintio-zero/setup.sh:1110-1144` and the matching block in `ravintio-zero/setup.ps1`. An existing install hides the effect because the files exist already. In a fresh repo, a rejected run turns on the git hooks and adds workflow files, but installs no skills or `CLAUDE.md`.

Unknown flags already fail during argument parsing, before any change. Retired flags print a warning and carry on, which is the intended behaviour.

## Suggested Action

Validate every argument before the first write in both scripts. Move the tool check to sit beside the flag parsing, ahead of the old-folder check and `initialize_repo`. A missing tool, an unknown tool, or an unknown flag then exits 1 with no change to the repo. Add a test in each shell that runs setup with a bad tool in a fresh temp repo. The test asserts exit 1, an unchanged tree, and an unset `core.hooksPath`.

## Why Deferred

No run is active. The human asked for the entry on its own, after a review of how setup handles an unsupported harness. It relates to `0000175-support-other-harnesses`, which would add valid tools but not change the check order.
