---
title: "Verification report: 0000171-faster-setup-ps1-tests"
summary: "Execution verification of eight acceptance criteria across REQ-001 to REQ-003."
status: "active"
version: "0.1.0"
---
# Verification report - 0000171-faster-setup-ps1-tests

All checks ran on branch `feat/0000171-faster-setup-ps1-tests` (macOS, `pwsh` 7 at `/opt/homebrew/bin/pwsh`). Every fixture lived under `/tmp/v171`, and I removed it afterwards. No source file changed. This report is the only file added.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 7 |
| failed | 0 |
| not-verifiable | 1 |

Total: 8 criteria across REQ-001 to REQ-003. Two points need a reader's attention:

- **Windows PowerShell 5.1.** It is unavailable on this Mac. Every check ran under `pwsh` 7. The .NET Framework 4.5 API constraint in REQ-002 is not exercised here, and CI covers it.
- **CI total.** REQ-001 AC-1 reads the step pull request's CI logs, so it cannot run locally.

## Outcome per criterion

| REQ | AC | Outcome | Method |
|---|---|---|---|
| REQ-001 | AC-1 | not-verifiable | Needs the CI logs of the step pull request |
| REQ-001 | AC-2 | verified | Timed `Copy-RavintioSkills` in the old and new `setup.ps1`, 5 runs each |
| REQ-002 | AC-1 | verified | Ran old and new `setup.ps1` in twin workspaces and compared trees, bytes, and output |
| REQ-002 | AC-2 | verified | Edited an installed template by hand and reran setup |
| REQ-002 | AC-3 | verified | Compared hook bytes and the `+ {skill}/SKILL.md` lines against the old run and the source |
| REQ-003 | AC-1 | verified | Ran a copy of `run-tests.ps1` over two stub suites |
| REQ-003 | AC-2 | verified | Called `Invoke-Setup` twice with the timing variable set |
| REQ-003 | AC-3 | verified | Ran the runner over a failing stub suite |

## REQ-001

- **AC-1: not-verifiable.** The sum of the two `[timing] setup.ps1 total` values comes from the CI logs of both Windows jobs. The step pull request does not exist yet. Read it in R-D Advance.
- **AC-2: verified.** I copied each `setup.ps1` and wrapped the `Copy-RavintioSkills` call in a `Stopwatch` that prints to stderr. The "before" script came from `git show b52b209:ravintio-zero/setup.ps1`. Each run used a fresh empty `.claude` folder.

| Script | Run times (ms) | Average (ms) |
|---|---|---|
| Before (`b52b209`) | 498, 436, 424, 455, 535 | 469.6 |
| After (branch head) | 86, 82, 100, 89, 84 | 88.2 |

The after average is 18.8 percent of the before average. The limit is 50 percent. The slowest after run (100 ms) is also under half of the fastest before run (424 ms).

## REQ-002

Method: two workspaces from `mktemp`-style folders under `/tmp/v171`. Each held a copy of `ravintio-zero/`, an empty `.claude` folder, and `git init -q`. One ran the branch `setup.ps1`. The other ran the `b52b209` version. Both ran `pwsh -NoProfile -File ravintio-zero/setup.ps1 claude-code`.

- **AC-1: verified.** Both runs exited 0.
  - `find skills -type f` listed 544 files in each tree, including 4 dot files. The two lists are identical.
  - `shasum` over all 544 files matched for 543 files. The one difference is `skills/.ravintio-manifest`.
  - The manifest holds absolute workspace paths. After I replaced each workspace path with a placeholder, the two manifests matched. The difference is the workspace path and not the copy logic.
  - `run-tests` coverage aside, 13 `SKILL.md` files matched the old run byte for byte, so the path rewrite is unchanged.
- **AC-2: verified.** I appended a line to `about.template.md` under `ravintio-file-backlog/assets/templates/`. Its hash changed. After a second `setup.ps1 claude-code` run (exit 0), the hash matched its source again. The full `skills` hash list then matched the list from the first run.
- **AC-3: verified.**
  - All 8 files under `.claude/hooks/` matched the old run and had the same bytes.
  - Stdout was 82 lines in each run. `diff` of the two outputs reported no difference. Neither output held the workspace path.
  - The output held 13 `+ {skill}/SKILL.md` lines. They named the same 13 skills as `ravintio-zero/skills/`, in the same order.

## REQ-003

Method: a temp folder held a copy of `ravintio-zero/tests/run-tests.ps1` and two stub `test-*.ps1` suites. Each stub appended its value to `RAVINTIO_TIMING_FILE` and recorded that path in a side file.

- **AC-1: verified.** The stubs appended 100 and 250. The runner exited 0 and printed `[timing] setup.ps1 total: 350 ms over 2 cases` before the summary block. A quiet-mode run (`RAVINTIO_TEST_QUIET=1`) printed the same total line. The path from the side file no longer existed after the run.
- **AC-2: verified.** I dot-sourced `ravintio-zero/tests/helpers/setup-workspace.ps1` and set `RAVINTIO_TIMING_FILE` to an empty file. `New-SetupWorkspace` and two `Invoke-Setup` calls with `@('claude-code')` both returned code 0. The file held 2 lines, and both were whole numbers. `Remove-AllWorkspaces` ran afterwards.
- **AC-3: verified.** With the second stub set to exit 1, the runner exited 1. It printed `PowerShell suites: 1 passed, 1 failed.` and `failed: test-b.ps1`. It still printed the total line (350 ms over 2 cases). The timing file named in the side file no longer existed.

## Failures

None.
