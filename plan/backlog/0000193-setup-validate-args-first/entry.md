---
title: "Backlog Entry: 0000193 - setup must reject a bad tool, unknown flag, or retired flag before it changes anything"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000193 - setup must reject a bad tool, unknown flag, or retired flag before it changes anything

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

Unknown flags already fail during argument parsing, before any change. Retired flags don't fail. Setup prints `! Warning: ignoring retired flag {flag}` and carries on. The human wants retired flags to fail too, so users remove them and learn that they don't work. These are the retired flags:

- `--structured-telemetry-mcp`
- `--context-mode-mcp`
- `--include-full-skill-library`
- `--backend-url`, in both the `--backend-url x` and `--backend-url=x` forms

Feature 0000034 chose the warning so an old refresh command still runs. See `plan/_archive/0000034-setup-hardening-2026-10-16/`. This entry reverses that decision.

## Suggested Action

Validate every argument before the first write in both scripts. Move the tool check to sit beside the flag parsing, ahead of the old-folder check and `initialize_repo`. Each of these cases then exits 1 with no change to the repo:

- a missing tool
- an unknown tool
- an unknown flag
- a retired flag

A retired flag gets its own error message. The message names the flag, says that it was removed and does nothing, and tells the user to remove it from the command. A `--backend-url` value never appears in the output.

Add a test in each shell that runs setup with a bad argument in a fresh temp repo. The test asserts exit 1, an unchanged tree, and an unset `core.hooksPath`.

These tests assert the warning today, so they need to change:

- `ravintio-zero/tests/test-0000034-req-001-retired-flags.sh`
- `ravintio-zero/tests/regression/test-0000034-req-001-retired-flags.sh`
- `ravintio-zero/tests/test-0000036-req-004-setup-ps1-flags.ps1`
- `ravintio-zero/tests/test-0000037-req-002-refresh-script-flags.sh`
- `ravintio-zero/tests/test-0000037-req-003-setup-record-move.sh`
- `ravintio-zero/tests/test-0000031-req-004-setup-execution.sh`

A tracked `plan/state/{tool}.md` record or a `.ravintio-setup-flags` marker might still hold a retired flag. The `ravintio-refresh-setup` skill already rejects such a record. Check that the refresh path then reports the retired flag plainly instead of failing setup with no explanation.

## Why Deferred

No run is active. The human asked for the entry on its own, after a review of how setup handles an unsupported harness. It relates to `0000175-support-other-harnesses`, which would add valid tools but not change the check order.
