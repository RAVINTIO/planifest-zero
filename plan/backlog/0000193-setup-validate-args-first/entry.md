---
title: "Backlog Entry: 0000193 - setup must reject an invalid tool before any processing"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000193 - setup must reject an invalid tool before any processing

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

## Suggested Action

Check the tool argument straight after argument parsing, before any other processing in both scripts. That puts it ahead of the old-folder check and `initialize_repo`. A missing or unknown tool then exits 1 with no change to the repo.

The code to move:

- `setup.sh`: the check at lines 1135 to 1144 moves above the old-folder loop at line 1100.
- `setup.ps1`: the check at lines 1356 to 1364 moves above the old-folder loop at line 1331.

The usage text and the exit code stay as they are.

Add a test in each shell that runs setup with an unknown tool in a fresh temp repo. The test asserts exit 1, an unchanged tree, and an unset `core.hooksPath`.

## Wanted outcome

`setup.sh` and `setup.ps1` reject a missing or unknown tool straight after argument parsing. The run exits 1 and leaves the repo unchanged. In a fresh temp repo, a test in each shell runs setup with an unknown tool. It asserts exit 1, an unchanged tree, and an unset `core.hooksPath`.

## Why Deferred

No run is active. The human asked for the entry on its own, after a review of how setup handles an unsupported harness. It relates to these entries:

- `0000175-support-other-harnesses` would add valid tools but not change the check order.
- `0000194-setup-fail-on-retired-flags` makes retired flags fail at the same early point.
