# Changelog (0000196-setup-argument-checks, 27 Oct 2026)

**Feature:** setup argument checks
**Version:** 0.20.0
**PR:** pending, updated at Step 9

## What changed

- `setup.sh` and `setup.ps1` check the tool straight after argument parsing. An unknown tool exits 1 and leaves the repo unchanged. A missing tool still prints the usage text and exits 0.
- A retired flag exits 1 during argument parsing. The error names the flag, says that it does nothing, and tells the user to remove it. A `--backend-url` value never appears in the output.
- The `ravintio-refresh-setup` skill names a retired flag that a record or marker holds, and leaves it out of the command it proposes.
- New suites cover the tool check, the retired flags, and the refresh skill. Four existing suites now assert the error instead of the warning.
- ADR-002 supersedes 0000034 ADR-001.

## Why

A rejected run used to enable git hooks and add workflow files before it failed. A retired flag printed a warning, so users kept passing a flag that does nothing. Backlog entries 0000193 and 0000194 asked for the change.

## Deviations

- A missing tool keeps exit 0. The brief first said exit 1, but the entry says the usage text and exit code stay. The plan artifacts now match.
- The entry named six tests to change. Four needed it. Two assert that no record or script holds a retired flag, and they pass unchanged.

## Validation results

170 feature suites and 19 regression suites pass, including the PowerShell suites on local `pwsh`. The consistency check is clean. No critical or high security finding.

## Skipped phases

None.
