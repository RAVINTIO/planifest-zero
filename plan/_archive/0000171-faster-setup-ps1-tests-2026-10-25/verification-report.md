---
title: "Verification report: 0000171-faster-setup-ps1-tests"
summary: "Execution verification of fifteen acceptance criteria across REQ-001 to REQ-006."
status: "active"
version: "0.2.0"
---
# Verification report - 0000171-faster-setup-ps1-tests

All checks ran on branch `feat/0000171-faster-setup-ps1-tests` at `82d886a` (macOS, Bash 3.2, `pwsh` 7.6 at `/opt/homebrew/bin/pwsh`). Every workspace came from `mktemp -d` outside the repo. Each held a copy of `ravintio-zero/` from the branch or from `b52b209`, plus `git init -q`. Bash runs used `env -i HOME="$HOME" PATH="$PATH"`. PowerShell runs used `pwsh -NoProfile -File`. No source file changed.

This is the second P3 run. The first covered REQ-001 to REQ-003 before the requirement change of 2026-10-25. This run re-verifies those criteria against the new install tree and adds REQ-004 to REQ-006.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 15 |
| failed | 0 |
| not-verifiable | 0 |

Total: 15 criteria across REQ-001 to REQ-006. Three points need a reader's attention:

- **Windows PowerShell 5.1.** It is unavailable on this Mac. Every local PowerShell check ran under `pwsh` 7. CI run `40182095593` ran every suite under 5.1, and all five CI jobs passed.
- **CI total.** REQ-001 AC-1 reads the CI logs of run `40183923397`. I did not re-measure it.
- **Prune defect.** The Bash prune step splits file names on a newline. A planted name can delete a file in the caller's folder. No criterion covers it. See S-008 in `security-report.md`.

## Outcome per criterion

| REQ | AC | Outcome | Method |
|---|---|---|---|
| REQ-001 | AC-1 | verified | Read the two `[timing] setup.ps1 total` values from CI run `40183923397` and divided by the case count |
| REQ-001 | AC-2 | verified | Timed `Copy-RavintioSkills` in the old and new `setup.ps1`, 5 runs each |
| REQ-002 | AC-1 | verified | Ran `setup.ps1 claude-code` in a fresh workspace and compared the tree with the skill sources |
| REQ-002 | AC-2 | verified | Edited an installed file by hand and reran setup, with and without the manifest |
| REQ-002 | AC-3 | verified | Compared hook bytes with the source and the `+ {skill}/SKILL.md` lines with the source order |
| REQ-003 | AC-1 | verified | Ran a copy of `run-tests.ps1` over two stub suites |
| REQ-003 | AC-2 | verified | Called `Invoke-Setup` twice with the timing variable set |
| REQ-003 | AC-3 | verified | Ran the runner over a failing stub suite |
| REQ-004 | AC-1 | verified | Ran `setup.sh` and `setup.ps1` in fresh workspaces and compared each tree with the skill sources |
| REQ-004 | AC-2 | verified | Installed with the `b52b209` scripts, then reran with the branch scripts |
| REQ-005 | AC-1 | verified | Ran the REQ-006 check over the real skills and cross-checked with `grep` |
| REQ-005 | AC-2 | verified | Searched each SKILL.md for the bundle fields |
| REQ-006 | AC-1 | verified | Ran the check on a fixture with `templates/requirement.template.md` |
| REQ-006 | AC-2 | verified | Ran the check on a fixture with a missing full path |
| REQ-006 | AC-3 | verified | Ran the check on `ravintio-zero/skills/` |

## REQ-001

- **AC-1: verified.** CI run `40183923397` printed `[timing] setup.ps1 total` lines of 41086 ms on Windows PowerShell 5.1 and 64441 ms on `pwsh` 7. Each covered 57 cases. The mean is 105527 ms over 114 cases, or 926 ms per case, under the 946 ms limit. The baseline was 210.1 s over 111 cases in run `40106508296`, or 1893 ms per case. All five CI jobs passed on run `40183923397`.
- **AC-2: verified.** I copied each `setup.ps1` into a fresh workspace and wrapped the `Copy-RavintioSkills` call in a `Stopwatch` that prints to stderr. The "before" script came from `b52b209`. Each run used a fresh workspace with no `.claude` folder.

| Script | Run times (ms) | Average (ms) |
|---|---|---|
| Before (`b52b209`) | 1529, 1327, 1325, 1323, 1334 | 1367.6 |
| After (`82d886a`) | 18, 18, 17, 18, 17 | 17.6 |

The after average is 1.3 percent of the before average. The limit is 50 percent. The first P3 measured 469.6 ms before and 88.2 ms after on the same Mac. The before times differ between the two runs. The after time fell because setup now copies 24 files in place of 544 (ADR-004).

## REQ-002

Method: a fresh workspace ran `pwsh -NoProfile -File ravintio-zero/setup.ps1 claude-code` (exit 0). REQ-004 replaced the bundle rules, so each skill's install now matches its own source folder.

- **AC-1: verified.**
  - `.claude/skills/` held 25 files. 24 matched the 24 files under `ravintio-zero/skills/`, path for path and byte for byte. That includes 3 `.gitkeep` dot files in the orchestrator skill.
  - The 25th file is `.claude/skills/.ravintio-manifest`, which setup writes for reruns.
  - Each installed SKILL.md matched its source byte for byte. No path rewrite remains.
  - Windows PowerShell 5.1 ran the same check in the `test-0000171-req-002-install-tree-parity.ps1` suite on CI run `40182095593`.
- **AC-2: verified.**
  - I appended a line to the installed `ravintio-orchestrator/references/orchestrator-scope-lock.md`. A rerun (exit 0) restored it, and the tree matched the sources again.
  - With the manifest present, setup removes each skill folder and copies it again.
  - I then appended a line to the installed `ravintio-plan/SKILL.md` and deleted the manifest. A rerun (exit 0) overwrote the file in place, and the tree matched the sources again.
- **AC-3: verified.**
  - All 8 files under `.claude/hooks/` matched their source files byte for byte.
  - The output held 13 `+ {skill}/SKILL.md` lines. They named the 13 skills of `ravintio-zero/skills/` in the same order.
  - Against the `b52b209` script, stdout fell from 82 lines to 56. The 26 lines removed are the `templates:` and `standards:` bundle lines, which REQ-004 retires. Every other line matched.

## REQ-003

Method: a temp folder held a copy of `ravintio-zero/tests/run-tests.ps1` and two stub `test-*.ps1` suites. Each stub appended its value to `RAVINTIO_TIMING_FILE`. The first stub recorded that path in a side file.

- **AC-1: verified.** The stubs appended 100 and 250. The runner printed `PowerShell suites: 2 passed, 0 failed.` and `[timing] setup.ps1 total: 350 ms over 2 cases` before the summary block. A quiet-mode run (`RAVINTIO_TEST_QUIET=1`) printed the same total line. The path from the side file no longer existed after the run.
- **AC-2: verified.** I dot-sourced `ravintio-zero/tests/helpers/setup-workspace.ps1` and set `RAVINTIO_TIMING_FILE` to an empty file. `New-SetupWorkspace` and two `Invoke-Setup` calls with `@('claude-code')` both returned code 0. The file held 2 lines, and both were whole numbers. `Remove-AllWorkspaces` ran afterwards.
- **AC-3: verified.** With the second stub set to exit 1, the runner exited 1. It printed `PowerShell suites: 1 passed, 1 failed.` and `failed: test-b.ps1`. It still printed the total line (350 ms over 2 cases). The timing file named in the side file no longer existed.

## REQ-004

Method: one fresh workspace per script. Bash ran `setup.sh claude-code`. PowerShell ran `setup.ps1 claude-code`. A compare script listed each skill's files with `find` and compared each pair with `cmp`.

- **AC-1: verified.**
  - Both runs exited 0. Each `.claude/skills/{skill}/` held exactly the files of `ravintio-zero/skills/{skill}/`, byte for byte, for all 13 skills.
  - Both trees held 25 files: the 24 skill files and `.ravintio-manifest`. The two file and folder lists were identical.
  - No skill held an `assets/` folder except the orchestrator, whose source holds `assets/.gitkeep`.
  - Neither output held a `templates:` or `standards:` line.
- **AC-2: verified.** I ran each `b52b209` script, then replaced `ravintio-zero/` with the branch copy and ran the matching branch script.
  - The old install held 544 files, 362 of them under `assets/templates/` and 106 bundled `references/*-standards.md` files.
  - After the rerun (exit 0, both scripts), none of those remained. The tree matched the skill sources exactly.
  - I repeated the test with the manifest deleted, so the new prune step did the work. Both scripts removed every bundled file and kept every skill file.
- **Prune edge cases, both scripts, manifest deleted.**
  - A symlink to a folder in `references/`, a symlink to a file in `assets/`, and an `assets/` folder replaced by a symlink were each removed. Every link target stayed intact.
  - A dangling `references` symlink in a skill root was removed by both scripts.
  - A file the user added to `ravintio-plan/references/` was deleted. A file in the skill root stayed.
  - When `.claude/skills/ravintio-plan` was itself a symlink to a folder outside the project, both scripts deleted the user files in that folder's `assets/` and `references/`. See S-009.
  - A plain file named `assets` in a skill root stayed under Bash and was deleted under PowerShell. See S-011.
  - A planted file named `x`, a newline, then `victim.txt` made `setup.sh` delete `victim.txt` in the caller's folder. `setup.ps1` kept it. See S-008.

## REQ-005

- **AC-1: verified.** The REQ-006 check over `ravintio-zero/skills/` exited 0 and printed nothing. A separate `grep` for any `*.template.md`, `*-standards.md`, or `*.schema.json` name not preceded by `ravintio-zero/` found none. The skills hold 37 distinct full pack paths, and each exists.
- **AC-2: verified.** `grep -lE '^(bundle_templates|bundle_standards):'` over the 13 SKILL.md files matched none.

## REQ-006

Method: I extracted `pack_entries` and `check_pack_paths` from `ravintio-zero/tests/test-0000171-req-006-pack-path-check.sh` into a harness script. I ran it under `env -i` on fixture skill folders I wrote, then on the real skills.

- **AC-1: verified.** A fixture SKILL.md naming `templates/requirement.template.md` on line 4 gave exit 1 and `SKILL.md:4: short pack path: templates/requirement.template.md`. The line also named the full path to use. A second fixture with a bare `testing-standards.md` and a short `standards/roadmap-standards.md` failed on both.
- **AC-2: verified.** A fixture naming `ravintio-zero/templates/no-such.template.md` gave exit 1 and `SKILL.md:1: missing pack path: ravintio-zero/templates/no-such.template.md`.
- **AC-3: verified.** The check over `ravintio-zero/skills/` gave exit 0 with no output.

## Suites

- `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh` under `env -i`: 148 feature and 19 regression suites passed.
- `RAVINTIO_TEST_QUIET=1 pwsh -NoProfile -File ravintio-zero/tests/run-tests.ps1`: 16 suites passed. The run printed `[timing] setup.ps1 total: 34608 ms over 55 cases`.

## Failures

None against a criterion. One defect sits outside the criteria: S-008 in `security-report.md`.
