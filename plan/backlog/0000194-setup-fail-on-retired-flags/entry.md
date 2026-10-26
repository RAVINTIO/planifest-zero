---
title: "Backlog Entry: 0000194 - setup must fail on a retired flag before any processing"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000194 - setup must fail on a retired flag before any processing

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-26

---

## Problem

`setup.sh` and `setup.ps1` accept retired flags. Setup prints `! Warning: ignoring retired flag {flag}` and carries on with the install. Users keep the flag in their commands and don't learn that it does nothing. These are the retired flags:

- `--structured-telemetry-mcp`
- `--context-mode-mcp`
- `--include-full-skill-library`
- `--backend-url`, in both the `--backend-url x` and `--backend-url=x` forms

Feature 0000034 chose the warning so an old refresh command still runs. See `plan/_archive/0000034-setup-hardening-2026-10-16/`. This entry reverses that decision.

Unknown flags already fail during argument parsing, before any change.

## Suggested Action

Make a retired flag exit 1 during argument parsing, before any other processing in both scripts. The repo stays unchanged. The error names the flag and says that it was removed and does nothing. It tells the user to remove the flag from the command. A `--backend-url` value never appears in the output.

Add a test in each shell that runs setup with each retired flag in a fresh temp repo. The test asserts exit 1, the error text, an unchanged tree, and an unset `core.hooksPath`.

These tests assert the warning today, so they need to change:

- `ravintio-zero/tests/test-0000034-req-001-retired-flags.sh`
- `ravintio-zero/tests/regression/test-0000034-req-001-retired-flags.sh`
- `ravintio-zero/tests/test-0000036-req-004-setup-ps1-flags.ps1`
- `ravintio-zero/tests/test-0000037-req-002-refresh-script-flags.sh`
- `ravintio-zero/tests/test-0000037-req-003-setup-record-move.sh`
- `ravintio-zero/tests/test-0000031-req-004-setup-execution.sh`

A tracked `plan/state/{tool}.md` record or a `.ravintio-setup-flags` marker might still hold a retired flag. The `ravintio-refresh-setup` skill already rejects such a record. Check that the refresh path then reports the retired flag plainly instead of failing setup with no explanation.

## Why Deferred

No run is active. The human asked for the entry on its own. It pairs with `0000193-setup-validate-args-first`, which moves the tool check to the same early point.
