---
title: "Backlog Entry: 0000108 - run the Bash suites in CI"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future P0."
status: "open"
---
# Backlog Entry: 0000108 - run the Bash suites in CI

**Source feature:** 0000036-test-runner-coverage
**Source phase:** P6
**Deferral source:** deliberate scope decision
**Date filed:** 2026-10-17

---

## Problem

CI runs the PowerShell suites on Windows, but no Bash suite. The Bash suites run only when someone runs `run-tests.sh` locally. A PR can break one and still show green checks.

## Suggested Action

After backlog 0000097 makes the rename suite pass, add a job on `ubuntu-latest` that runs `bash planifest-zero/tests/run-tests.sh` with `PLANIFEST_REQUIRE_PWSH=1`. The image includes `pwsh`, so that one job also runs the PowerShell suites on Linux. Give it `contents: read` and a pinned checkout, like `windows-powershell`.

## Why Deferred

See 0000036 ADR-003. A job that fails on every PR until 0000097 lands would teach reviewers to ignore it.
