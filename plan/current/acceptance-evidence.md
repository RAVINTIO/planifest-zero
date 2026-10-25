# Acceptance evidence - 0000171-faster-setup-ps1-tests

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 6 requirements, 15 criteria. REQ-002 to REQ-006 each have a suite named for the requirement. REQ-005 shares the REQ-006 suite. REQ-001 is measured in CI, not unit-tested. |
| Full Bash suite, local Bash 3.2 under `env -i` | 148 feature and 19 regression suites pass |
| PowerShell suites, local `pwsh` 7 | 16 suites pass |
| Windows PowerShell 5.1 | Not available locally. All five CI jobs passed on run `40182095593`, including the `windows-powershell` job. |
| Self-correction cycles | 0 in either P3 run |

P2 fixed one suite failure before the first P3. A new `setup.ps1` comment used a word the pack wording test bans, in a .NET version name. The comment now names Windows PowerShell 5.1 instead.

## Speed

| Measure | Before | After |
|---------|--------|-------|
| `Copy-RavintioSkills`, macOS `pwsh` 7, 5 runs | about 1368 ms | about 18 ms |
| Both Windows CI jobs, `setup.ps1` total | 210.1 s (run `40106508296`) | 98.2 s (run `40182095593`) |

REQ-001 AC-1 passes. Run `40182095593` totals 53244 ms on Windows PowerShell 5.1 and 44930 ms on `pwsh` 7, over 55 cases each. The sum is under the 105 s target.

## Security

There are no critical or high findings. The overall rating is medium, from two open medium findings in the new prune step.

| Finding | Severity | Status |
|---------|----------|--------|
| S-008 the Bash prune splits names on a newline, so a planted name deletes a file in the caller's folder (`setup.sh:114-119`) | Medium | Open. Not mitigated. |
| S-009 both scripts prune through a symlinked skill folder and delete files outside the project (`setup.sh:102-131`, `setup.ps1:131-155`) | Medium | Open. Not mitigated. |
| S-010 the prune deletes any file a user added to an installed `assets/` or `references/` folder, without output (`setup.sh:117`, `setup.ps1:137`) | Low | Open |
| S-011 the scripts differ on a plain file named `assets` or `references` in a skill root (`setup.ps1:134-139`, `setup.sh:109-113`) | Low | Open |
| S-012 the path check passes file names to `awk` unquoted (`tests/test-0000171-req-006-pack-path-check.sh:83`) | Low | Accepted. Test only. |
| S-001 the folder copy follows a junction in the pack source (`setup.ps1:96,99`) | Low | Accepted. `Copy-Item -Recurse` did the same before. |
| S-002 the copy follows a destination link under `.claude/skills` (`setup.ps1:85,100`, `setup.sh:93`) | Low | Accepted. The old copy did the same, and it needs write access to the project. |
| S-003 the tree copy assumes each path starts with the source folder (`setup.ps1:97,100`) | Low | Accepted. The one caller passes absolute paths. |
| S-004 a planted `RAVINTIO_TIMING_FILE` gets digits appended (`tests/helpers/setup-workspace.ps1:79-80`) | Low | Accepted. Test harness only, and the runner sets the variable itself. |
| S-005 timing file in the temp folder (`tests/run-tests.ps1:28-29,64`) | Informational | Accepted. It holds numbers only, and the runner deletes it. |
| S-006 a 19-digit line overflows the total (`tests/run-tests.ps1:55-58`) | Informational | Accepted. The run fails loudly, and cleanup still runs. |
| S-007 generated stub suites in the req-003 suite | Informational | Accepted. They hold constants only. |
| S-013 the UTF-8 manifest read now removes non-ASCII paths on Windows PowerShell 5.1 (`setup.ps1:1101-1103`) | Informational | Accepted. It matches `setup.sh`. |

S-008 and S-009 both need prior write access to `.claude/skills/`. Fix S-008 before a release, because a fresh clone has no manifest and runs the prune. No dependency, network call, or credential joined the pack.

## Execution evidence

- Fresh workspaces ran `setup.sh claude-code` and `setup.ps1 claude-code`. Each skill folder held exactly its 24 source files, byte for byte, in both trees. The two trees matched, and neither output held a bundle line.
- An install from `b52b209` held 544 files, among them 362 bundled templates and 106 bundled standards. A rerun with each branch script removed every bundled copy and kept every skill file. The same held with the manifest deleted, so the new prune did the work.
- The prune removed planted links in `assets/` and `references/` and left every link target intact, under both scripts.
- The 8 hook files match their sources. The output names the 13 skills in source order. Against `b52b209`, only the 26 bundle lines left the output.
- A hand-edited installed file matched its source again after a rerun, with and without the manifest.
- `run-tests.ps1` with stub suites that append 100 and 250 printed a total of 350 ms over 2 cases in both output modes. With a failing stub it exited 1, and the timing file was gone in both cases.
- Two `Invoke-Setup` calls appended two whole-number lines to the timing file.
- The pack path check failed on a short path and named the file, line, and path. It failed on a missing full path and named it. It passed on the real skills. No SKILL.md holds a bundle field.

## Environment note

The local runs used Bash 3.2 and `pwsh` 7 on macOS. The Windows PowerShell 5.1 halves of REQ-002 AC-1 and REQ-004 AC-1 ran in CI run `40182095593`.
