# Changelog (0000171-faster-setup-ps1-tests, 25 Oct 2026)

**Feature:** faster-setup-ps1-tests
**Version:** 0.15.1
**PR:** [#32](https://github.com/RAVINTIO/ravintio-zero/pull/32)

## What changed

`setup.ps1` copies skill and hook files with `System.IO` calls, and `run-tests.ps1` prints a `setup.ps1` timing total. The installed files stay the same, and the release adds no dependency.

- req-001: the speed target. Total `setup.ps1` time across both Windows CI jobs must fall from 210 s to under 105 s. Locally, the skill copy fell from about 470 ms to about 90 ms.
- req-002: `Copy-RavintioSkills` and `Install-EnforcementHooks` copy through the new `Copy-RavintioItem` and `Copy-RavintioTree` helpers. A new suite checks the installed skill tree against the bundle rules, file by file, under each host.
- req-003: `Invoke-Setup` appends each setup time to the file that `RAVINTIO_TIMING_FILE` names. `run-tests.ps1` prints `[timing] setup.ps1 total: {ms} ms over {n} cases` and deletes the file.

## Why

The 0000151 timing lines showed `setup.ps1` took about 75% of the PowerShell suite time. A profile showed the skill copy took most of each run, at one cmdlet call per file for 544 files.

## Deviations

None. P2 also reworded a new `setup.ps1` comment, because it used a word the pack wording test bans.

## Validation results

- 145 feature and 19 regression suites pass under macOS Bash 3.2 and `pwsh` 7 with `env -i`. CI runs Windows PowerShell 5.1.
- 7 of 8 acceptance criteria verified by execution. The CI total for req-001 is read from this PR's Windows jobs before the merge.
- Security review: overall low, with no critical or high findings.

## Skipped phases

None
