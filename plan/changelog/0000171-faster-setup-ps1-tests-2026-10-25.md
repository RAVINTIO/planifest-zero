# Changelog (0000171-faster-setup-ps1-tests, 25 Oct 2026)

**Feature:** faster-setup-ps1-tests
**Version:** 0.16.0
**PR:** [#32](https://github.com/RAVINTIO/ravintio-zero/pull/32)

## What changed

Setup no longer copies pack templates, standards, or schemas into each skill. Skills read them from `ravintio-zero/` by full path. A fresh install writes 25 skill files in place of 535, on every platform. `setup.ps1` also copies with `System.IO` calls and reads text as UTF-8, and `run-tests.ps1` prints a `setup.ps1` timing total. The release adds no dependency.

- req-001: the speed target. Mean `setup.ps1` time per case across both Windows CI jobs fell from 1893 ms to 926 ms, under the 946 ms target.
- req-002: `Copy-RavintioSkills` and `Install-EnforcementHooks` copy through the new `Copy-RavintioItem` and `Copy-RavintioTree` helpers. A suite checks each installed skill against its source folder, file by file, under each host.
- req-003: `Invoke-Setup` appends each setup time to the file that `RAVINTIO_TIMING_FILE` names. `run-tests.ps1` prints `[timing] setup.ps1 total: {ms} ms over {n} cases` and deletes the file.
- req-004: `setup.sh` and `setup.ps1` install only each skill's own folder. A rerun removes the pack copies an older install left, at the exact paths that install used. It skips links and keeps user files.
- req-005: every skill names a pack file by its full `ravintio-zero/...` path. The `bundle_templates` and `bundle_standards` frontmatter fields are gone. Four skills gained a **Pack files** list of full paths in their place.
- req-006: a Bash suite fails when a skill names a pack file by a short path or a bare name, or names one that does not exist.

## Why

The 0000151 timing lines showed `setup.ps1` took about 75% of the PowerShell suite time. The first change, a `System.IO` copy, reached only 158.5 s. A profile on the Windows CI runners showed the skill copy still took about 720 ms per install. 511 of the 535 files it wrote were copies of 60 pack files, and no skill read them.

## Deviations

- The human added req-004 to req-006 during R-D Advance, after the first CI run missed the speed target (ADR-004). The version moved from the charted patch, 0.15.1, to a minor bump, 0.16.0, because the change alters what setup installs.
- The human changed the req-001 target from a 105 s total to a time per case, half the baseline. The final run totalled 105.5 s, but this release added 4 PowerShell cases per job.
- `setup.ps1` read text with no encoding, so Windows PowerShell 5.1 decoded UTF-8 as ANSI and corrupted six installed skills. The reads now use UTF-8. The bug predates this feature.
- P3 found that the first rerun clean-up could delete files outside the project (S-008, S-009). The clean-up now deletes only named pack paths and skips links.

## Validation results

- 148 feature and 19 regression Bash suites pass under macOS Bash 3.2 with `env -i`. All 16 PowerShell suites pass under `pwsh` 7. CI runs Windows PowerShell 5.1 and `pwsh` 7 on Windows.
- All 15 acceptance criteria pass, verified by execution. The req-001 figure comes from CI run `40183923397`.
- Security review: no critical or high findings. S-008 to S-011 are fixed. S-012 (low) is accepted.

## Skipped phases

None
