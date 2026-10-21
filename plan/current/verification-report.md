# Verification Report - 0000040-setup-json-checks-and-park

## What ran

- **`setup.sh`, local (macOS):** each case used a fresh workspace under `mktemp -d`. The workspace held a copy of `planifest-zero/` and its own git repo. Each ran `bash planifest-zero/setup.sh claude-code` with `GIT_CEILING_DIRECTORIES` set, as `planifest-zero/tests/test-0000040-req-001-sh-shape-check.sh` does. Each input was written to `.claude/settings.json`. The run then read the exit code, stdout, stderr, and a `cmp` of the file against a copy taken before setup.
- **`park.mjs`, local (macOS):** a scratch bare origin, a seed clone, and a working clone, all under a fresh `mktemp -d`. `main` held one commit. The feature branch `feat/0000777-demo` held a committed `plan/current/park.md`. A stub `gh` came first on `PATH` and logged each call. Git used a scratch global config. The run called `node planifest-zero/skills/planifest-orchestrator/scripts/park.mjs` with `park`, `finish-pr`, `resume`, and `discard` (with and without `--confirmed`). It read the branch, the refs on origin, the entry file on the chore branch, the `gh` log, and `main` on both sides.
- **`setup.ps1`, not run locally:** `pwsh` is not installed. CI's `windows-powershell` job on PR #17 is the execution evidence for req-002 and req-003. The orchestrator adds that result.
- **Skill and template text:** read `planifest-zero/skills/planifest-orchestrator/SKILL.md`, `park.template.md`, and `backlog-entry.template.md`.

All scratch directories were deleted. Nothing was left running.

## Per criterion

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| req-001 (a) eight rejected inputs print the shape line, exit 1, file unchanged | CLI, `setup.sh` on `["x"]`, `null`, `"text"`, `42`, `true`, `{"hooks":"text"}`, `{"hooks":[]}`, `{"hooks":5}` | verified | Every input exited 1. Stderr held `! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.` `cmp` found each file identical. No `gate-write` entry appeared. No stack trace appeared. |
| req-001 (b) planted value in neither stream | CLI, `setup.sh` on `["PLANTED-VALUE"]` | verified | Exit 1. `PLANTED` matched 0 lines in stdout and stderr combined. The file was byte-identical. |
| req-001 (c) `{"hooks":null}` | CLI, `setup.sh` | verified | Exit 0. Stderr was empty. The file held 2 `gate-write` entries. |
| req-001 (c) `{"a":1,"A":2}` | CLI, `setup.sh` | verified | Exit 0. Stderr was empty. The file held 2 `gate-write` entries. |
| req-001 (c) `{"a":1,` | CLI, `setup.sh` | verified | Exit 1. Stderr ended with `! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.` The shape line was absent. The file was byte-identical. |
| req-002 (a), (b), (c) | None | not-verifiable | `pwsh` is not installed locally. CI's `windows-powershell` job on PR #17 is the execution evidence. |
| req-003 (a), (b), (c) | None | not-verifiable | `pwsh` is not installed locally. CI's `windows-powershell` job on PR #17 is the execution evidence. |
| req-004 (a) Park Command section | File inspection of `SKILL.md` | verified | `## Park Command` has five numbered steps in order. It holds the P1 rule for a park before `design.md`, the stop-on-failure rule, and `Park never merges a pull request, never commits to \`main\`, and never force-pushes.` |
| req-004 (b) templates and index | File inspection | verified | `park.template.md` has `phase`, `last_artifact`, `head_commit`, and `reason`. The Framework Index row `A park record` and the `bundle_templates` line name it. `backlog-entry.template.md` has `status: "open"  # open \| parked` and a `**Parked branch:**` field. |
| req-004 (c) successful park | CLI, `park.mjs park --entry entry.md --backlog-id 0000900` | verified | Exit 0. Output: `Parked feat/0000777-demo. The working tree is on main.` Origin's feature branch held `plan/current/park.md`. The chore branch held only `README.md` and `plan/backlog/0000900-park-demo/entry.md`, with `status: "parked"` and `**Parked branch:** feat/0000777-demo`. The working tree was on `main`. Origin and local `main` stayed at `65e2a8fb`. The `gh` log held `pr list --head chore/park-0000777-demo --state all` and `pr create --base main --head chore/park-0000777-demo`. No `pr merge` call appeared. |
| req-004 (c) forced push failure | CLI, `park.mjs park` with origin set to a missing path | verified | Exit 1. Output held the exact git error `fatal: '.../missing.git' does not appear to be a git repository`. The working tree stayed on `feat/0000777-demo`. Origin and local `main` were unchanged. The `gh` log was empty. |
| req-004 extra: uncommitted `park.md` | CLI, `park.mjs park` after editing `park.md` | verified | Exit 1 with `park: plan/current/park.md has uncommitted changes. Commit it first.` Nothing reached origin. |
| req-005 (a) pickup offers resume or discard | File inspection of backlog pickup (step 10) | verified | A `parked` entry offers resume or discard, not pull-in, leave, or discard. The four resume steps appear in order: check out the branch, merge `origin/main`, restore from `park.md`, and delete the entry and `park.md` in one commit. Discard `runs only after the human confirms`. |
| req-005 (b) Resume Detection step | File inspection | verified | Step 8, `Park restore`, runs `gh pr list --head chore/park-{feature-id} --state all`. If it returns nothing, it runs `node scripts/park.mjs finish-pr`. |
| req-005 (c) resume | CLI, `park.mjs resume feat/0000777-demo` after a new commit landed on origin `main` | verified | Exit 0. Output: `Resumed feat/0000777-demo with origin/main merged. Restore state from plan/current/park.md.` The working tree was on the feature branch. `git merge-base --is-ancestor origin/main HEAD` returned yes. `later.txt` from the new `main` commit was present. `park.md` was present with `phase: "P3"`. |
| req-005 (c) declined discard | CLI, `park.mjs discard feat/0000777-demo` | verified | Exit 1 with `Pass --confirmed only after the human confirms.` The local branch and the origin branch both stayed. |
| req-005 (c) confirmed discard | CLI, `park.mjs discard feat/0000777-demo --confirmed` | verified | Exit 0. Output: `Discarded feat/0000777-demo locally and on origin.` The local branch and the origin branch were both gone. The chore branch stayed. No `gh` call ran. |
| req-005 extra: interrupted park | CLI, `park` with a stub `gh pr create` that fails, then `finish-pr` | verified | The park exited 1 with the exact stub error and the working tree returned to the feature branch. `finish-pr` then exited 0, ran `pr list` then `pr create`, and ended on `main`. |

## Observations

- `finish-pr` run from `main` exits 1 with `Park runs from a feature branch, not "main".` This matches Resume Detection step 8, which runs it from the feature branch.
- With `null` input, `setup.sh` prints `! Warning: could not remove telemetry hook entries from .claude/settings.json` before the shape error. This is the existing behaviour tracked in backlog 0000127. The shape line still prints and the file stays unchanged.
- With `{"a":1,` input, the same telemetry warning precedes the invalid-JSON line. This matches the 0000039 report.

## Not verifiable

- req-002 (a), (b), (c) and req-003 (a), (b), (c): `pwsh` is not installed locally. CI's `windows-powershell` job on PR #17 is the execution evidence.

## Totals

- Verified: 9 criteria (req-001 a to c, req-004 a to c, req-005 a to c).
- Failed: 0.
- Not-verifiable: 6 criteria (req-002 a to c, req-003 a to c).
