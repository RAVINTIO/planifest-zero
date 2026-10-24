# Verification report - 0000160-ravintio-rebrand

All commands ran on branch `feat/0000160-ravintio-rebrand` (macOS, `bash`, `node`). Every fixture lived in a scratch directory under the session scratchpad. Each scratch project held a copy of `ravintio-zero/` and a fresh `git init`. Nothing ran in the repo's own `.claude/` or `plan/`. The real `claude` CLI never ran. A stub `claude` on `PATH` stood in for it. No file changed except this report.

`pwsh` is absent here (`which pwsh` prints `pwsh not found`). Every `.ps1`-only behaviour is therefore `not-verifiable` locally with the reason "CI runs the `.ps1` suites". The Bash side of each such criterion is verified.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 12 (001 a/b/c, 002 a, 003 a/b/c, 004 a/b, 006 a/b/c) |
| verified for Bash, `.ps1` clause not-verifiable here | 5 (002 b/c, 005 a/b/c) |
| not-verifiable | 1 (004 c, the version clause) |
| failed | 0 |

Total: 18 criteria (6 requirements x 3). Two points go to the gate:

- 004 c: the version is still `0.11.0` in `docs/about.md`, `product.yml`, and `component.yml`. The requirement records `1.0.0` at ship, and ship has not run. The history-folder clause of 004 c is verified.
- 003 a: `docs/decisions-index.md` line 104 still names `PLANIFEST_REQUIRE_PWSH`. It mirrors an archived ADR and the brand guard allowlists it. The criterion's wording does not list that file, so the gate decides whether that counts as history.

## What I started

- Baseline for diffs: merge-base `80db368` (`git merge-base HEAD main`).
- Fresh consumer: scratch repo, `cp -R ravintio-zero`, `bash ravintio-zero/setup.sh claude-code`.
- Old consumer: scratch repo with `git archive v0.11.0 planifest-zero | tar -x`, that version's `setup.sh claude-code` (run twice, with a `planifest-overrides/instructions/mine.md` file added), a commit, then the new `ravintio-zero/` copied in.
- Migration fixtures A to G (one scratch repo per case) for the helper.
- A stub `claude` on `PATH` that logs its arguments and `OTEL_RESOURCE_ATTRIBUTES`, then archives the roadmap (REQ-003).
- A `git clone` of the branch with a planted line, a planted path, and a renamed `README.md` (REQ-006).
- Full suite: `RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. Exit 0, 116 feature suites and 19 regression suites passed, 13 PowerShell suites skipped (no `pwsh`). This is context only and counts for no criterion.

## REQ-001 pack identifiers

- (a) **verified.**
  - Method: list tracked paths and filesystem names.
  - Evidence: `git ls-files | grep -i planifest` minus `plan/_archive/`, `plan/changelog/`, `ravintio-zero/migrations/_done/`, and `plan/current/` printed nothing. `find . -iname '*planifest*'` outside the same folders printed nothing.
- (b) **verified.**
  - Method: read every `name:` field and grep the four named files.
  - Evidence: 12 skill folders, and the loop `grep -m1 '^name:'` piped through `grep -v 'name: ravintio-'` printed nothing. `product.yml` has `id: "ravintio-zero"` and `path: "ravintio-zero/component.yml"`. `component.yml` has `id: "ravintio-zero"`. `.gitattributes` lists `ravintio-zero/hooks/...`. The word "planifest" appears in these files only in `component.yml:124` (the documented 1.x roadmap fallback) and in two `regression-manifest.json` `sourceFeature` values, `0000037-self-host-on-planifest-zero`. That value is the id of an existing archived feature folder, and the brand guard allowlists it.
- (c) **verified.**
  - Method: diff against the merge-base and compare blobs.
  - Evidence: `git diff --stat main-base...HEAD -- plan/_archive plan/changelog` printed nothing. The 7 files in `migrations/_done/` show as pure renames with 0 insertions and 0 deletions. For each of the 7, `git rev-parse <base>:planifest-zero/migrations/_done/<f>` equals `git rev-parse HEAD:ravintio-zero/migrations/_done/<f>`. No `DIFF` line printed.

## REQ-002 runtime names

- (a) **verified.**
  - Method: trigger each hook and script.
  - Evidence:
    - `auto-trigger-orchestrator.mjs` in a directory with `ravintio-zero/` printed "This is a RAVINTIO project (ravintio-zero/ detected) ... Load the ravintio-orchestrator skill", exit 0. In a directory with only `planifest-zero/` it printed nothing.
    - `em-dash-guard.mjs` with an em dash in `ravintio-zero/skills/x/SKILL.md` exited 2 with "[RAVINTIO] Em dash (U+2014) found". The same content plus `<!-- ravintio-em-dash-allow -->` exited 0. In `docs/x.md`, the content plus `<!-- planifest-em-dash-allow -->` exited 0. An em dash in `planifest-zero/skills/x/SKILL.md` exited 0 because the path is out of scope.
    - `gate-write.mjs` let a write to `.ravintio-session` through (exit 0) and blocked `src/c/a.js` with no design (exit 2, "[RAVINTIO] No confirmed design").
    - `node ravintio-zero/scripts/self-description-check.mjs` exited 0 ("README structure and folder coverage match the repository").
    - `.github/workflows/ravintio.yml` has no "planifest" and runs `ravintio-zero/...` paths.
  - Note: the guard's scoped prefixes list `ravintio-zero/skills/`, `templates/`, and `standards/`. They do not list `ravintio-overrides/`, and `main` did not list the old overrides folder either. An em dash in `ravintio-overrides/x.md` exits 0 as before.
- (b) **verified for Bash, `.ps1` not-verifiable here (no `pwsh`).**
  - Method: fresh install, then install over planted old markers.
  - Evidence: fresh `setup.sh claude-code` exit 0. `.claude/.ravintio-setup-flags` held `"tool": "claude-code"`, `"attemptStatus": "completed"`. `.claude/skills/.ravintio-manifest` listed 12 `ravintio-*` entries. `git config core.hooksPath` printed `ravintio-zero/hooks`. `.github/workflows/ravintio.yml` existed. With `ravintio-overrides/instructions/a.md` present, a rerun wrote `<!-- ravintio-overrides:instructions:start -->` and `:end -->` into `CLAUDE.md` with the file's text once. After I planted `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`, the next setup exited 0 and `ls -a` showed neither. `setup.sh` uses the `.ravintio-tmp` suffix (lines 53 and 314). `grep -rIil planifest` over the install outside `ravintio-zero/` printed nothing. Inside the pack, only the migration files, `setup.sh`, `setup.ps1` (leftover detection and marker cleanup), `component.yml`, `_done/`, and tests matched.
- (c) **verified for Bash, `.ps1` not-verifiable here (no `pwsh`).**
  - Method: create the old folder in the fresh install and run setup.
  - Evidence: with `planifest-zero/` present, `setup.sh claude-code` exited 1 and printed "found the old folder planifest-zero/ ... Run ravintio-zero/migrations/migrate-ravintio-rename.sh first". The same with `planifest-overrides/`, exit 1. In the old-consumer run (see REQ-005), setup before migration exited 1 with the same message.

## REQ-003 environment variables

- (a) **verified, with one note for the gate.**
  - Method: grep tracked files outside `plan/_archive/`, `plan/changelog/`, `migrations/_done/`, and `plan/current/` for `PLANIFEST_`, then drop the two roadmap names.
  - Evidence: the only remaining line is `docs/decisions-index.md:104`, which quotes `PLANIFEST_REQUIRE_PWSH=1` from an archived ADR. The live code uses `RAVINTIO_REQUIRE_PWSH` (`.github/workflows/ravintio.yml:95`, `run-tests.sh:7`). The six files that name the two fallback variables are `roadmap-run.mjs`, `component.yml`, `docs/dependency-graph.md`, `docs/decisions-index.md`, and two test files. `main` carried 27 distinct `PLANIFEST_*` names in the same scope.
- (b) **verified.**
  - Method: run `node ravintio-zero/scripts/roadmap-run.mjs --root <fixture>` with the stub `claude`, one fixture per case, and read the logged arguments.
  - Evidence:

| Environment set | Exit | Arguments the stub received |
|---|---|---|
| `RAVINTIO_*` only (haiku, 40) | 0 | `--model haiku --max-turns 40` |
| `PLANIFEST_*` only (opus, 25) | 0 | `--model opus --max-turns 25` |
| both | 0 | `--model haiku --max-turns 40` |

- (c) **verified.**
  - Method: read `OTEL_RESOURCE_ATTRIBUTES` in the stub log of all three runs.
  - Evidence: `OTEL=work.kind=roadmap,ravintio.roadmap=0000050-demo,ravintio.step=1`. `grep -c planifest` on the three logs printed 0 each, including the run that used the `PLANIFEST_*` fallback values.

## REQ-004 brand prose

- (a) **verified.**
  - Method: run `bash ravintio-zero/tests/test-0000160-req-006-brand-guard.sh` on the branch.
  - Evidence: exit 0, "Results: 5 passed, 0 failed". The REQ-006 section shows the guard bites on a planted line.
- (b) **verified.**
  - Method: extract `planifest-zero/setup.ps1` at the merge-base and compare bytes with `ravintio-zero/setup.ps1`.
  - Evidence: line 1010 holds the mojibake `Ã¢â‚¬â€` after "Retrofit". The old line with `Planifest` replaced by `RAVINTIO` (via `LC_ALL=C sed`) and the new line both hash to `f1fd0ed7ea94...`. Across every line with a non-ASCII byte, the old file (brand tokens replaced) and the new file hash to the same value (`485e2a7d48cb...`). Both files are UTF-8 with BOM and have no CR bytes.
- (c) **not-verifiable now for the version clause, history clause verified.**
  - Method: read the version fields and diff the history folders.
  - Evidence: `docs/about.md` and `product.yml` and `component.yml` say `0.11.0`. The design and execution plan set `1.0.0` to land at ship, so the clause cannot hold until ship. The committed test `test-0000160-req-004-brand-prose.sh` accepts a version of 1.0.0 or later after ship. The history diff is empty, as REQ-001 (c) shows.

## REQ-005 consumer migration

Fixtures used `bash ravintio-zero/migrations/migrate-ravintio-rename.sh`. All `.ps1` clauses are not-verifiable here (no `pwsh`). Parity of output and exit codes between the helpers is also unchecked here.

- (a) **verified for Bash, `.ps1` not-verifiable here.**
  - Method: the v0.11.0 consumer described above.
  - Evidence: before migration, new `setup.sh` exited 1. The helper exited 0 and printed "Moved planifest-overrides/ to ravintio-overrides/", "Moved .github/workflows/planifest.yml to .github/workflows/ravintio.yml", "Removed .claude/.planifest-setup-flags", "Removed .claude/skills/.planifest-manifest", "Removed planifest-zero/", "Archived ravintio-zero/migrations/0004-ravintio-rename.md to ravintio-zero/migrations/_done/", and "Next step: run ravintio-zero/setup.sh claude-code". `git status` showed `R planifest-overrides/instructions/mine.md -> ravintio-overrides/instructions/mine.md` (git mv) and `R .github/workflows/planifest.yml -> ravintio.yml`. The override file still read "My rule". `0004-ravintio-rename.md` was in `_done/` and absent from `migrations/`. Setup afterwards exited 0, `.claude/skills/` held only the 12 `ravintio-*` folders, no `planifest` marker remained, `core.hooksPath` was `ravintio-zero/hooks`, and `CLAUDE.md` held one copy of "My rule" inside the `ravintio-overrides:instructions` block with no "planifest" text. The v0.11.0 workflow had no `planifest-zero/` paths, so I planted `run: bash planifest-zero/tests/run.sh` in fixture A. After the helper, `ravintio.yml` read `run: bash ravintio-zero/tests/run.sh`. In fixture B (no old install), the helper left 0004 in `migrations/` and not in `_done/`.
- (b) **verified for Bash, `.ps1` not-verifiable here.**
  - Method: rerun on the migrated repo, then fixtures C to E, comparing a `find | sort | shasum` snapshot before and after.
  - Evidence:

| Case | Exit | First line | Snapshot |
|---|---|---|---|
| rerun after migration | 0 | "Skipped planifest-overrides/: not present." ... "Nothing to do." | `git status` clean |
| C: no `ravintio-zero/` | 1 | "ERROR: ravintio-zero/ not found. Nothing was moved." | unchanged |
| D: both override folders | 1 | "WARNING: Both planifest-overrides/ and ravintio-overrides/ exist. Nothing was moved." | unchanged |
| E: `ravintio.yml` exists | 1 | "ERROR: .github/workflows/ravintio.yml already exists. Nothing was moved." | unchanged |

- (c) **verified for Bash, `.ps1` not-verifiable here.**
  - Method: fixtures with each folder replaced by a symlink to an outside folder holding `t` = `keep`.
  - Evidence: for `planifest-overrides`, `ravintio-overrides`, and `planifest-zero` as the symlink, the helper exited 1 with "ERROR: <name> is a symlink. Refusing to continue. Nothing was moved." The snapshot was unchanged, the link was still present, and the outside file still read `keep`. In fixture G (real `planifest-zero/` plus a symlinked `planifest-overrides`), the helper refused and the real old pack stayed.

## REQ-006 brand guard

- (a) **verified.**
  - Method: run the guard on the branch.
  - Evidence: exit 0, 5 passed, 0 failed. A clone of the branch gave the same exit 0.
- (b) **verified.**
  - Method: in `git clone` of the branch, append `Planifest Zero was the old name.` to `README.md`, commit, run the guard.
  - Evidence: exit 1. Output `FAIL: req-006 (a): no tracked line outside the allowlist uses the word` with `actual: README.md:190`. The guard's own case (d), which plants the line in a scratch `README.md`, passed on the branch: "the check flags the planted line with its file and line number".
- (c) **verified.**
  - Method: in the clone, commit `docs/Planifest-notes.md`, run the guard. Then rename `README.md` to `README-planifest.md` and rerun.
  - Evidence: exit 1 with `FAIL: req-006 (b): no tracked path outside the allowlist names the word` and `actual: docs/Planifest-notes.md`. The rename case exited 1 with FAIL on (a), (b), and (c, a stale allowlist entry).

## Clean-up

Scratch directories under `.../scratchpad/p3-verify` were removed after this report was written. `git status` was clean apart from this file.

## Re-verification after P3 cycle 4

The helpers changed after the first pass, so REQ-005 ran again end to end on 2026-10-24. A scratch git repo under the scratchpad held a real v0.11.0 install, made with `git archive v0.11.0` and its own `setup.sh claude-code`. It also held a user file in the old overrides folder and a workflow with a pack variable and a consumer secret.

| Step | Observed |
|---|---|
| New `setup.sh` before the migration | Printed the old-folder error and the helper to run. Installed nothing. |
| `migrate-ravintio-rename.sh` | Exit 0. Moved the overrides and the workflow, removed both old markers, moved the old pack to `.ravintio-backup/`, and archived 0004. |
| Rerun of the helper | Exit 0, "Nothing to do". |
| New `setup.sh` after the migration | Exit 0. `.claude/skills/` held only the 12 `ravintio-*` skills. `core.hooksPath` was `ravintio-zero/hooks`. |
| Overrides | The user file kept its content. |
| Workflow | The pack variable became `RAVINTIO_REQUIRE_PWSH`. The consumer secret `PLANIFEST_DEPLOY_TOKEN` stayed unchanged. |
| Git | `.ravintio-backup/` was in `.git/info/exclude`. Git staged the workflow as a rename and the old pack as removed. |

REQ-005 criteria (a), (b), and (c) stay verified for Bash. CI runs the PowerShell helper test on Windows PowerShell 5.1, PowerShell 7 on Windows, and PowerShell 7 on Linux.
