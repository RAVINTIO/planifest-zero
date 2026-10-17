# Changelog (0000036-test-runner-coverage, 17 Oct 2026)

**Feature:** Test runner coverage
**Pipeline run:** P0 to P9 completed. No phases skipped.
**PR:** https://github.com/planifest/planifest-zero/pull/10

## What Was Built

The test runner now reports everything it doesn't run, and `setup.ps1` runs under test on Windows. This release delivers backlog 0000084:

- **Stray-file check:** `run-tests.sh` names every file under `tests/` that is neither a suite nor on its known list, and fails the run.
- **PowerShell suites:** the runner runs `test-*.ps1` with `pwsh`, or prints how many it skipped. `PLANIFEST_REQUIRE_PWSH=1` turns the skip into a failure. A new `run-tests.ps1` runs only the PowerShell suites.
- **`setup.ps1` runtime suites:** two suites run `setup.ps1` in temporary projects. They cover the six hooks, re-runs, UTF-8, the leftover file, retired flags, and flag case.
- **Windows CI:** a `windows-powershell` job runs the suites under Windows PowerShell 5.1 and PowerShell 7.
- **Manifest:** the regression manifest check now covers `.ps1` suites.

The first Windows run found a defect from 0.4.1. On PowerShell 7, `--backend-url=https://x` exited 1 and printed part of the URL. `setup.ps1` now skips the split value and never prints a tool name that isn't a plain name.

## Artifacts Produced

- `discovery.md`, `design.md`, `build-log.md`, `feature-brief.md`
- `execution-plan.md`, `scope.md`, `risk-register.md`, `domain-glossary.md`
- `requirements/req-001` to `req-005` (five files)
- `adr/ADR-001` to `ADR-003` (three files)
- `security-report.md`, `recommendations.md`, `iteration-log.md`

## Decisions

- **ADR-001:** Stray test files fail the run.
- **ADR-002:** PowerShell suites use a plain assert helper, with no Pester.
- **ADR-003:** CI runs the PowerShell suites on Windows under both hosts. Bash suites stay out of CI for now.

## Skipped Phases

None
