# Execution Plan - test-runner-coverage

> Every requirement must be traceable to a user story or acceptance criterion.

**Skill:** [spec-agent](../skills/planifest-spec-agent/SKILL.md)
**Feature:** 0000036-test-runner-coverage
**Wave:** not waved
**Version:** 0.4.3
**Status:** active

## Active Skills

| Skill | Scope | Purpose |
|-------|-------|---------|
| None | n/a | No capability skill applies. The work edits Bash, PowerShell, YAML, and markdown. |

## Functional Requirements Directory

| File | Requirement |
|------|------------|
| [req-001-stray-file-check.md](requirements/req-001-stray-file-check.md) | The runner names and fails on stray files. |
| [req-002-manifest-both-ways.md](requirements/req-002-manifest-both-ways.md) | The manifest check covers `.ps1` suites. |
| [req-003-powershell-discovery.md](requirements/req-003-powershell-discovery.md) | The runner runs or reports PowerShell suites. |
| [req-004-setup-ps1-runtime-suites.md](requirements/req-004-setup-ps1-runtime-suites.md) | PowerShell suites run `setup.ps1`. |
| [req-005-windows-ci-job.md](requirements/req-005-windows-ci-job.md) | CI runs the PowerShell suites on both hosts. |

## Build Order

1. req-001 and req-003 edit `run-tests.sh` in sequence. req-002 is independent.
2. req-004 needs req-003. Its suites first run in CI.
3. req-005 runs the req-004 suites on the PR.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Compatibility | Same pass and fail counts as today, plus one skip line, with no `pwsh` | req-003 suite |
| Robustness | 0 test files the runner neither runs nor reports | req-001 suite |
| CI time | The new job finishes in under 10 minutes | PR check duration |

## API and Data Summary

- No API and no data store.
- Component: `planifest-zero` (existing). Its manifest moves to 0.4.3.
