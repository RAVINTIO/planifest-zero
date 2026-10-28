---
title: "Acceptance Evidence - 0000239-test-suite-reliability"
summary: "CI results, security findings, and execution evidence for the PR."
---
# Acceptance Evidence - 0000239-test-suite-reliability

## Checks

- Library audit: no new library.
- Semantic check: `node ravintio-zero/scripts/consistency-check.mjs` reports clean. Each requirement has a suite named by its ID.
- Tests: `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh` ran with `RAVINTIO_INITIATIVE_STEP` unset. Result: 201 feature suites and 19 regression checks passed, 0 failed. PowerShell suites ran under `pwsh`.
- Lint, typecheck, build: not applicable to this pack.
- Self-correct cycles: 0 in P3. Two rework items in P2 are in the build log.

## Security

0 critical, 0 high, 3 low findings. See `security-report.md`.

## Execution evidence

All five criteria verified by running the software. See `verification-report.md`. Criterion `not-verifiable`: none.

## Note

`test-0000151-req-014` section (c) now prints `SKIP` in an active initiative. Before this change it failed in every step.
