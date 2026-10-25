---
title: "Security Report - faster-setup-ps1-tests"
summary: "Security review of the System.IO copy helpers, the bundled-file prune step in setup.sh and setup.ps1, the pack path check, and the timing file in the PowerShell test runner."
status: "draft"
version: "0.2.0"
---
# Security Report - faster-setup-ps1-tests

**Skill:** validate-and-accept
**Feature:** 0000171-faster-setup-ps1-tests
**Version:** 0.2.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** medium
**Components reviewed:** ravintio-zero (`setup.sh`, `setup.ps1`, `tests/run-tests.ps1`, `tests/helpers/setup-workspace.ps1`, five new `test-0000171-*` suites, skill sources, `component.yml`), `docs/`
**Review scope:** code review | dependency audit | threat model | execution tests of the prune step

The review covers `git diff b52b209..HEAD -- ravintio-zero/ docs/` at `82d886a`. This second review adds the requirement change of 2026-10-25 (REQ-004 to REQ-006) and the UTF-8 read fix in `setup.ps1`.

No Critical or High finding exists. Two Medium findings sit in the new prune step, and neither is mitigated:

- S-008: the Bash prune splits names on a newline, so a planted name deletes a file in the caller's folder.
- S-009: both scripts prune through a symlinked skill folder and delete user files outside the project.

Commit `d22c8ff` fixes S-008 to S-011. No critical, high, or medium finding remains open.

Both need prior write access to `.claude/skills/`, and a fresh clone with no manifest runs the prune. Six Low findings and four informational notes remain. Execution tests in temporary workspaces confirmed each prune finding (see `verification-report.md`, REQ-004).

The diff adds no dependency, no network call, and no new external program call. A scan of the diff for credential patterns found none. The timing file holds only millisecond counts.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-008 | medium | path traversal | `ravintio-zero/setup.sh:114-119`, `:122-127` | `prune_bundled_files` reads `find` output one line at a time. A file name that holds a newline splits into two lines. The second part stays relative, because the `${path#"$dest_dir"/}` strip does not match it. `[ -e "$src_dir/$rel" ]` then fails and `rm -f "$path"` deletes that name in the caller's current folder. `setup.sh` never changes folder, so that is usually the project root. A test planted `x`, a newline, then `victim.txt` under `ravintio-plan/assets/`. `setup.sh claude-code` deleted `victim.txt` from the project root. `setup.ps1` kept it. Reach is one file name per planted entry, in the current folder only, because a name cannot hold `/`. The attacker needs to create a file under `.claude/skills/*/assets` or `references`. | Fixed in `d22c8ff`. The prune no longer reads names from the install. It deletes only `assets/templates/{name}`, `assets/schemas/{name}`, and `references/{name}` for names in the pack folder. A test plants a newline name and checks the outside file stays. | fixed |
| S-009 | medium | path traversal | `ravintio-zero/setup.sh:97`, `:102-131`; `ravintio-zero/setup.ps1:120-122`, `:131-155` | The prune checks for a link at `{skill}/assets` and `{skill}/references` but not at `.claude/skills/{skill}` itself. If the skill folder is a symlink or junction to a folder outside the project, the prune walks the target. It deletes every file there under `assets/` and `references/` that the skill source lacks. A test linked `.claude/skills/ravintio-plan` to an outside folder holding `assets/user.md` and `references/user.md`, then deleted the manifest. Both scripts deleted both files. The copy step already wrote through such a link before this change (S-002). The delete is new. With a manifest present, the manifest cleanup removes the link first, so nothing outside is touched. | Fixed in `d22c8ff`. Both scripts skip the prune when the skill folder or a subfolder is a link. A test links a skill folder to an outside folder and checks its pack-named files stay. | fixed |
| S-010 | low | data exposure | `ravintio-zero/setup.sh:117`; `ravintio-zero/setup.ps1:137` | The prune deletes every file in an installed `assets/` or `references/` folder that the skill source lacks, not only the pack copies an older install bundled. It prints no line for a deleted file. A test confirmed that a user note in `ravintio-plan/references/` is deleted. A rerun with a manifest already removes each whole skill folder, so the prune adds deletion only to a rerun without a manifest. REQ-004 keeps every file of the skill's own source folder, and the test confirmed it. | Fixed in `d22c8ff`. The prune deletes only names that exist in the pack folder, so a user file stays. A test checks a user note in `references/`. | fixed |
| S-011 | low | path traversal | `ravintio-zero/setup.ps1:134-139`; `ravintio-zero/setup.sh:109-113` | The two scripts differ when a skill root holds a plain file named `assets` or `references`. `setup.ps1` deletes it. `setup.sh` keeps it. A test confirmed both results. REQ-004 asks both scripts to produce the same tree. The difference touches only a name that no install creates. | Fixed in `d22c8ff`. Both scripts now keep a plain file named `assets` or `references`, because the prune touches only named files inside those folders. | fixed |
| S-012 | low | injection | `ravintio-zero/tests/test-0000171-req-006-pack-path-check.sh:41`, `:83` | `check_pack_paths` passes `$files` to `awk` unquoted. A skill file name with a space or a glob character splits into words or expands. The worst result is a wrong pass or fail of the check. The input is the pack's own `skills/` folder, which no outside party writes. | None needed. Optionally use `find -print0` with `xargs -0`. | accepted |
| S-001 | low | path traversal | `ravintio-zero/setup.ps1:96`, `:99` | `Directory.GetDirectories` and `Directory.GetFiles` with `AllDirectories` enumerate the pack source tree. On Windows PowerShell 5.1 (.NET Framework) the enumeration follows directory junctions. A junction planted inside a skill source folder would copy files from outside the pack into the install. `Copy-Item -Recurse` followed links in the same way, so this is unchanged behaviour. The attacker needs write access to the pack, which already allows editing the hooks that `setup.ps1` installs. `setup.sh` uses `cp -R`, which copies a source link as a link. | None in the helpers. The pack comes from a checkout the user trusts. Optionally skip entries with the `ReparsePoint` attribute. | open |
| S-002 | low | path traversal | `ravintio-zero/setup.ps1:85`, `:100`; `ravintio-zero/setup.sh:93` | `File.Copy` with overwrite and `cp -R` follow a symlink at the destination. If `.claude/skills/{name}/` or a file in it links outside the project, the write lands there. The old copy code did the same, so this is unchanged. A write path under `.claude/skills` needs prior write access to the project. S-009 adds a delete to the same precondition. | None added. Apply the S-009 link check before the copy too. | open |
| S-003 | low | path traversal | `ravintio-zero/setup.ps1:97`, `:100` | `Copy-RavintioTree` builds each destination with `$dir.Substring($prefix)` and `$file.Substring($prefix)`. The code assumes the enumerated path starts with `$SourceDir` plus a separator. A relative `$SourceDir` would break that. The one caller, `setup.ps1:116`, passes `Get-ChildItem` `FullName` values, so no break occurs today. | None needed. Keep the caller on absolute paths. | accepted |
| S-004 | low | injection | `ravintio-zero/tests/helpers/setup-workspace.ps1:79-80` | `Invoke-Setup` appends to whatever file `RAVINTIO_TIMING_FILE` names. A planted path gets a line of digits and `CRLF` appended. The person who sets the variable cannot choose the content. Only a person who already controls the test environment can use it. The runner always overwrites the variable with its own path at `tests/run-tests.ps1:31`. | None needed for CI. Optionally check that the path sits under the temp folder before the append. | open |
| S-005 | informational | data exposure | `ravintio-zero/tests/run-tests.ps1:28-29` | The timing file lives in the shared temp folder under a random GUID name. On Linux and macOS the mode follows the umask, so it may be world-readable. The contents are millisecond counts, which carry no secret. The runner removes the file at `tests/run-tests.ps1:64`, including after a failed suite. A hard stop of the process leaves the file behind. This matches R-004. | Accepted, as R-004 records. | accepted |
| S-006 | informational | injection | `ravintio-zero/tests/run-tests.ps1:55-58` | The total keeps only digit lines. The cast `[long]$v` can overflow on a line of 19 or more digits. PowerShell then throws a terminating error, and the `finally` block still removes the file. The source is the helper in the same run. | None needed. Optionally limit the pattern to `^\d{1,9}$`. | accepted |
| S-007 | informational | injection | `ravintio-zero/tests/test-0000171-req-003-timing-total.ps1:35`, `:78` | The suite builds fixture script text with string interpolation. The interpolated values are constants and paths the suite creates, so no outside input reaches the generated code. The suite cleans up in a `finally` block (`:88-89`). | None needed. | accepted |
| S-013 | informational | path traversal | `ravintio-zero/setup.ps1:1101-1103`; `ravintio-zero/setup.sh:826-829` | The UTF-8 fix makes Windows PowerShell 5.1 decode `.ravintio-manifest` as UTF-8. Before, a project path with non-ASCII characters decoded wrongly, and the rerun cleanup skipped it. The cleanup now removes those folders, which matches `setup.sh`. Both scripts delete each manifest path recursively and trust the manifest. That trust predates this diff. Setup adds `.claude/` to `.gitignore`, so a clone does not carry a manifest by default. | None in this diff. Consider limiting manifest paths to the skills folder in a later change. | accepted |

## Checks with no finding

### Prune step and links

- In `setup.sh`, `find` runs without `-L` and lists links with `-type l`. `rm -f` on a link removes the link and never its target. A test confirmed this for a folder link, a file link, and an `assets` folder replaced by a link.
- In `setup.ps1`, `Remove-BundledFiles` checks `ReparsePoint` on each folder before it walks into it (`setup.ps1:143-146`). It deletes a linked folder with a non-recursive `Directory.Delete`, which removes the link only. The same tests passed under `pwsh` 7.
- Neither script follows a dangling link. Both remove it when the source lacks it.
- Each delete compares against the skill's own source folder. A test confirmed every file of `ravintio-orchestrator`, including `assets/.gitkeep` and `references/`, stayed after a prune.
- Outside S-008 and S-009, each delete stays inside `.claude/skills/{skill}/assets` or `references`.

### Pack path check

- The new Bash suites run no `eval` and no network call. `check_pack_paths` passes data to `awk` as files, never as program text. Fixtures live in a `mktemp -d` folder that an `EXIT` trap removes.

### Injection and external calls

- The diff adds no `Invoke-Expression`, no `Start-Process`, and no new call to an external program. `setup.sh` already called `cp`, `find`, and `rm`.
- `Copy-RavintioItem` and `Copy-RavintioTree` pass paths as typed `[string]` parameters to .NET methods. No path goes through a shell or a wildcard parser.
- The removal of the SKILL.md path rewrite removes one regex replace over skill text. That narrows the surface.

### Credentials

- The diff holds no secret. The timing file and the fixtures contain digits and placeholder text only.
- Nothing in the diff reads, copies, or prints environment values other than `RAVINTIO_TIMING_FILE`.

### Dependencies

- No package manager file changes. The PowerShell helpers use .NET APIs that Windows PowerShell 5.1 ships. The diff adds no module import.
- `component.yml` and `docs/` changes add no executable surface.

### Data exposure

- The `[timing]` output goes to the host and not into captured data. It prints millisecond counts and a case count.
- An install now writes 24 skill files in place of 544, and no pack copy leaves `ravintio-zero/`.

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | The .NET copy differs from `Copy-Item` on dot files or an existing target folder | mitigated | Both scripts install the same tree, dot files included. The REQ-002 and REQ-004 suites check it under both hosts. |
| R-002 | The CI total misses the 105 s target | mitigated | CI run `40182095593` totals 98.2 s, under the target. |
| R-003 | Windows PowerShell 5.1 lacks an API the copy uses | mitigated | Every call is a .NET Framework 4.5 API. CI run `40182095593` passed the 5.1 job. |
| R-004 | The timing file stays in the temp folder after a run | mitigated | `tests/run-tests.ps1:64` removes it in a `finally` block. See S-005 for the hard-stop case. |
| A-001 | Cmdlet overhead per file is at least as high on Windows as on macOS | closed | The CI total met the target. |

New risks this review adds to the register: S-008 and S-009 as medium security risks, and S-010 and S-011 as low ones. Each is open.

## Top actions

1. Make `prune_bundled_files` safe for any file name: `find -print0` with `read -r -d ''`, and a `$dest_dir/` prefix check before `rm` (S-008).
2. Skip the prune in both scripts when `.claude/skills/{skill}` is a link or junction (S-009). Apply the same check before the copy (S-002).
3. Align `setup.sh` and `setup.ps1` on a plain file named `assets` or `references` (S-011).
4. Limit the prune to pack file names, or print each removal (S-010).

## Counts

- Critical: 0
- High: 0
- Medium: 2 (both open)
- Unmitigated Critical or High: 0
