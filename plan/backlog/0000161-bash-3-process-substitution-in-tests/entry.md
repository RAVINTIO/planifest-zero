---
title: "Backlog Entry: 0000161 - Test loops lose input on the macOS Bash 3.2"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000161 - Test loops lose input on the macOS Bash 3.2

**Source feature:** 0000160-ravintio-rebrand
**Source phase:** P3
**Deferral source:** discovered mid-flight
**Date filed:** 2026-10-24

---

## Problem

macOS ships Bash 3.2. On it, `done < <(grep ...)` inside a loop that runs many times stops yielding lines after a while, with no error. The 0000160 brand guard passed locally but failed in CI, which runs Bash 5. Its line check had silently skipped most files. 0000160 fixed the guard with `done <<< "$(...)"`.

These suites still use the pattern, so a local pass on macOS may be a false pass:

- `ravintio-zero/tests/regression/test-0000042-req-010-pack-wording-allowlist.sh`
- `ravintio-zero/tests/run-tests.sh`
- `ravintio-zero/tests/test-0000042-req-009-pack-identifiers.sh`
- `ravintio-zero/tests/test-0000042-req-010-pack-wording-allowlist.sh`
- `ravintio-zero/tests/test-0000160-req-001-pack-identifiers.sh`

## Suggested Action

Replace each `done < <(...)` in a loop with `done <<< "$(...)"` and skip empty lines. Consider a guard test that fails on the pattern under `tests/`.

## Why Deferred

Out of scope for the rename. CI runs Bash 5, so CI results stay correct.
