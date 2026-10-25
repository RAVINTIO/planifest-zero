---
title: "Security Report - faster-setup-ps1-tests"
summary: "Security review of the System.IO copy helpers in setup.ps1 and the timing file in the PowerShell test runner."
status: "draft"
version: "0.1.0"
---
# Security Report - faster-setup-ps1-tests

**Skill:** validate-and-accept
**Feature:** 0000171-faster-setup-ps1-tests
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero (`setup.ps1`, `tests/run-tests.ps1`, `tests/helpers/setup-workspace.ps1`, two new `test-0000171-*.ps1` suites, `component.yml`)
**Review scope:** code review | dependency audit | threat model

The review covers `git diff b52b209 HEAD -- ravintio-zero/`. No Critical or High finding exists. Four Low findings and three informational notes remain. Three of the four Low findings describe behaviour that `Copy-Item` already had, so the diff adds little new exposure.

The diff adds no dependency, no external process call, and no network call. A scan of the diff for credential patterns found none. The timing file holds only millisecond counts.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-001 | low | path traversal | `ravintio-zero/setup.ps1:96`, `:99` | `Directory.GetDirectories` and `Directory.GetFiles` with `AllDirectories` enumerate the pack source tree. On Windows PowerShell 5.1 (.NET Framework) the enumeration follows directory junctions. A junction planted inside `skills/*/scripts`, `assets`, `references`, `templates`, or `schemas` would copy files from outside the pack into the install. `Copy-Item -Recurse` followed links in the same way, so this is unchanged behaviour. I did not run the enumeration on PowerShell 7 here, so I make no claim about how it treats links. The attacker needs write access to the pack, which already allows editing the hooks that `setup.ps1` installs. | None in the helpers. The pack comes from a checkout the user trusts. Optionally skip entries with the `ReparsePoint` attribute, as `Copy-RavintioWorkflow` does at `setup.ps1:265`. | open |
| S-002 | low | path traversal | `ravintio-zero/setup.ps1:85`, `:100` | `File.Copy` with overwrite follows a symlink or hard link at the destination. If `.claude/skills/{name}/` or a file in it is a link to a location outside the project, the write lands there. `Copy-Item -Force` also followed destination links, so this is unchanged. A write path under `.claude/skills` needs prior write access to the project, and a person with that access can edit the files directly. | None added. `Remove-RetiredHooks` guards reparse points at `setup.ps1:677` and `:692` for deletes only. Optionally apply the same test to the destination folder before copying. | open |
| S-003 | low | path traversal | `ravintio-zero/setup.ps1:97`, `:100` | `Copy-RavintioTree` builds each destination with `$dir.Substring($prefix)` and `$file.Substring($prefix)`. The code assumes the enumerated path starts with `$SourceDir` plus a separator. The .NET enumeration returns paths under the root it received, so a `..` segment cannot appear in a result. The assumption breaks if a caller passes a `$SourceDir` that is not in the form the enumeration echoes back, for example a relative path. Both callers pass `Join-Path $ScriptDir` values, so no break occurs today. | None needed. Keep callers on absolute paths. | accepted |
| S-004 | low | injection | `ravintio-zero/tests/helpers/setup-workspace.ps1:79-80` | `Invoke-Setup` appends to whatever file `RAVINTIO_TIMING_FILE` names. If the variable holds a planted path in the caller's environment, the helper appends a line of digits and `CRLF` to that file. Only `ElapsedMilliseconds` is written, so the person who sets the variable cannot choose the content. The append can corrupt a text file or grow one. This is new behaviour, and only a person who already controls the test environment can use it. The runner always overwrites the variable with its own path at `tests/run-tests.ps1:31`. | None needed for CI. Optionally check that the path sits under the temp folder before the append. | open |
| S-005 | informational | data exposure | `ravintio-zero/tests/run-tests.ps1:28-29` | The timing file lives in the shared temp folder. Its name carries a random GUID (`NewGuid().ToString('N')`), so another local account cannot guess it. On Windows the temp folder is per user (`%TEMP%`), and the file inherits the user's ACL. On Linux and macOS the mode follows the umask, so it may be world-readable. The contents are millisecond counts, which carry no secret. The runner removes the file at `tests/run-tests.ps1:64`, including after a failed suite. A hard stop of the process leaves the file behind. This matches R-004. | Accepted, as R-004 records. | accepted |
| S-006 | informational | injection | `ravintio-zero/tests/run-tests.ps1:55-58` | The total parses untrusted lines safely. `Where-Object { $_ -match '^\d+$' }` keeps only digit lines and drops everything else. The cast `[long]$v` can overflow on a line of 19 or more digits. In that case PowerShell throws a terminating error under `$ErrorActionPreference = 'Stop'`, and the `finally` block still removes the file and restores the variable. The failure is loud and the run does not continue silently. The source is the helper in the same run, so no outside party writes these lines. | None needed. Optionally limit the pattern to `^\d{1,9}$`. | accepted |
| S-007 | informational | injection | `ravintio-zero/tests/test-0000171-req-003-timing-total.ps1:35`, `:78` | The suite builds fixture script text with string interpolation and writes it to a GUID-named folder under the temp path. The interpolated values are constants and paths the suite creates, so no external input reaches the generated code. The suite removes the folder and restores the variable in a `finally` block (`:88-89`). | None needed. | accepted |

## Checks with no finding

### Injection and external calls

- The diff adds no `Invoke-Expression`, no `Start-Process`, and no call to an external program. The existing child-host call in the test runner is unchanged in form.
- `Copy-RavintioItem` and `Copy-RavintioTree` pass paths as typed `[string]` parameters to .NET methods. No path goes through a shell or a wildcard parser. This removes the wildcard expansion that `Copy-Item -Path` applied to names with `[` or `*`. That change narrows the surface.
- `[System.IO.Path]::Combine` at `setup.ps1:82`, `:85` drops the first argument when the second is rooted. The second argument is `GetFileName` output, so it holds no separator and cannot be rooted. The manifest entries (`$tpl`, `$std`) pass through `Join-Path` first and then `GetFileName`, so a `..\` entry in a manifest copies by leaf name only and lands inside the destination folder.

### Credentials

- The diff holds no secret. The timing file and the fixtures contain digits and placeholder text only.
- Nothing in the diff reads, copies, or prints environment values other than `RAVINTIO_TIMING_FILE`.

### Dependencies

- No package manager file changes. The helpers use .NET APIs that Windows PowerShell 5.1 ships. The diff adds no module import.
- `component.yml` changes by one line and adds no executable surface.

### Data exposure

- The `[timing]` output goes to the host and not into captured data. It prints millisecond counts and a case count.
- The install tree stays the same as before, as `test-0000171-req-002-install-tree-parity.ps1` checks. No file gains a wider scope than `Copy-Item` gave it.

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | The .NET copy differs from `Copy-Item` on dot files or an existing target folder | mitigated | The tree parity suite compares installed files. Review of `setup.ps1:91-102` found no gap. The one difference is the link-following note in S-001. |
| R-002 | The CI total misses the 105 s target | open | An operational risk with no security effect. The P3 CI logs hold the totals. |
| R-003 | Windows PowerShell 5.1 lacks an API the copy uses | mitigated | Every call is a .NET Framework 4.5 API. The review found none outside that set. |
| R-004 | The timing file stays in the temp folder after a run | mitigated | `tests/run-tests.ps1:64` removes it in a `finally` block. See S-005 for the hard-stop case. |
| A-001 | Cmdlet overhead per file is at least as high on Windows as on macOS | open | A performance assumption with no security effect. |

New risks this review adds to the register: S-001, S-002, and S-004 as low security risks. Each is open and needs no action before merge.

## Top actions

1. Skip reparse points in `Copy-RavintioTree` if the pack could ever hold links (S-001). This matches the guard at `setup.ps1:265`.
2. Check that `RAVINTIO_TIMING_FILE` sits under the temp folder before the append (S-004).
3. Keep both callers of `Copy-RavintioTree` on absolute paths (S-003).

## Counts

- Critical: 0
- High: 0
- Unmitigated Critical or High: 0
