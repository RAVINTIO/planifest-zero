# Acceptance evidence - 0000171-faster-setup-ps1-tests

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 3 requirements, 8 criteria. REQ-002 and REQ-003 each have a suite named for the requirement. REQ-001 is measured, not unit-tested. |
| Full suite, local Bash 3.2 and `pwsh` 7 under `env -i` | 145 feature and 19 regression suites pass |
| Windows PowerShell 5.1 | Not available locally. The `windows-powershell` CI job runs every suite under it on this PR. |
| Self-correction cycles | 0 in P3 |

P2 fixed one suite failure before P3. A new `setup.ps1` comment used a word the pack wording test bans, in a .NET version name. The comment now names Windows PowerShell 5.1 instead.

## Speed

| Measure | Before | After |
|---------|--------|-------|
| `Copy-RavintioSkills`, macOS `pwsh` 7, 5 runs | about 470 ms | about 90 ms |
| Whole `setup.ps1` run, macOS `pwsh` 7, 5 runs | about 966 ms | about 571 ms |
| Both Windows CI jobs, `setup.ps1` total | 210.1 s (run `40106508296`) | Read from this PR's `[timing] setup.ps1 total` lines before merge |

REQ-001 AC-1 passes only if the two CI totals sum to under 105 s.

## Security

There are no critical or high findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 the folder copy follows a junction in the pack source (`setup.ps1:96,99`) | Low | Accepted. `Copy-Item -Recurse` did the same before. |
| S-002 `File.Copy` follows a destination link under `.claude/skills` (`setup.ps1:85,100`) | Low | Accepted. `Copy-Item -Force` did the same, and it needs write access to the project. |
| S-003 the tree copy assumes each path starts with the source folder (`setup.ps1:97,100`) | Low | Accepted. Both callers pass absolute paths. |
| S-004 a planted `RAVINTIO_TIMING_FILE` gets digits appended (`tests/helpers/setup-workspace.ps1:79-80`) | Low | Accepted. Test harness only, and the runner sets the variable itself. |
| S-005 timing file in the temp folder (`tests/run-tests.ps1:28-29,64`) | Informational | Accepted. It holds numbers only, and the runner deletes it. |
| S-006 a 19-digit line overflows the total (`tests/run-tests.ps1:55-58`) | Informational | Accepted. The run fails loudly, and cleanup still runs. |
| S-007 generated stub suites in the req-003 suite | Informational | Accepted. They hold constants only. |

No dependency, shell call, or credential joined the pack.

## Execution evidence

- Twin workspaces ran the old `setup.ps1` from `b52b209` and the new one. Both installed 544 skill files, 4 of them dot files, with the same file list and bytes. Only `.ravintio-manifest` differs, because it holds each workspace's absolute path.
- Both runs printed the same 82 lines of output, and the 8 hook files match.
- A hand-edited installed template matched its source again after a rerun.
- `run-tests.ps1` with stub suites that append 100 and 250 printed `[timing] setup.ps1 total: 350 ms over 2 cases` in both output modes. With a failing stub it exited 1, and the timing file was gone in both cases.
- Two `Invoke-Setup` calls appended two whole-number lines to the timing file.

## Environment note

The local runs used `pwsh` 7 only. The Windows PowerShell 5.1 half of REQ-002 AC-1 runs in CI.
