# Verification report - 0000169-release-hygiene

All checks ran on branch `feat/0000169-release-hygiene` (macOS, `node`, `ruby`). Every fixture lived in a directory from `mktemp -d`. No setup or release-tag run touched the real repo. No source file changed. This report is the only file added.

`pwsh` is not installed here. The PowerShell half of REQ-004 is `not-verifiable` locally. CI runs `test-0000169-req-004-setup-attribution-setting.ps1`.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 15 |
| verified for Bash, PowerShell half not-verifiable here | 3 (REQ-004 a, b, c) |
| failed | 0 |

Total: 18 criteria across REQ-001 to REQ-006. No criterion lacks a covering test. Two points need a reader's attention:

- **Template workflow step is not executed by a test.** `test-0000169-req-003-...sh` extracts and runs the CI step from `.github/workflows/ravintio.yml` only. For `ravintio-zero/hooks/ravintio.yml` it checks the text. I ran both steps by execution and both behave the same.
- **"Byte-identical" in REQ-004 b.** Setup also writes `hooks` and `allowedTools`, so the whole file cannot match its state before setup. The test and I read the criterion as: the `attribution` value is untouched and a rerun leaves the file byte-identical. Both hold.

## Coverage table

Tests are in `ravintio-zero/tests/`.

| Criterion | Covering test and case |
|---|---|
| REQ-001 a: three files state PR descriptions carry no AI attribution | `test-0000169-req-001-attribution-ban-text.sh`, loop case "bans attribution in PR descriptions" |
| REQ-001 b: each file names all three host lines | `test-0000169-req-001-...sh`, loop cases "names Generated with [Claude Code]", "names Co-Authored-By", "names Claude-Session:" |
| REQ-001 c: section 3 no longer limits the ban to commit messages | `test-0000169-req-001-...sh`, case "section 3 is not limited to commit messages" |
| REQ-002 a: exit 1, 0, and 2 per input class | `test-0000169-req-002-attribution-check-script.sh`, "Lines that must exit 1" (19 lines), "prose mentioning attribution exits 0", "missing file exits 2", "directory exits 2", "two arguments exit 2", stdin cases |
| REQ-002 b: stderr holds line number and rule only, no input text | `test-0000169-req-002-...sh`, "Output never echoes input" (line 3 and script-name assertions, empty stdout) |
| REQ-002 c: hook rejects both host lines | `test-0000169-req-002-...sh`, "Hook rejects host lines". Also `test-commit-msg-hook.sh`, "Generated with [Claude Code] line exits 1" and "Claude-Session line exits 1" |
| REQ-003 a: Step 9 orders temp file, check, stop message before `gh pr create` | `test-0000169-req-003-attribution-check-in-ship-and-ci.sh`, cases "Step 9 writes the body to a temporary file", "runs check-attribution.mjs", "holds the stop message", "orders the check before its stop message", "runs the check before gh pr create" |
| REQ-003 b: both workflows use `env:`, no `run:` holds the body expression | `test-0000169-req-003-...sh`, per workflow "passes the body through env" and "has no other use of the PR body expression". Also `test-0000169-req-006-...sh` for structure |
| REQ-003 c: CI step passes empty, fails on attribution | `test-0000169-req-003-...sh`, "CI step passes for an empty body", "fails for an attribution line", "passes for a clean body" (repo workflow only) |
| REQ-004 a: `{"commit":"","pr":""}` after setup | `test-0000169-req-004-setup-attribution-setting.sh`, cases (a) and (b). PowerShell: `test-0000169-req-004-setup-attribution-setting.ps1` (CI) |
| REQ-004 b: present key is untouched, any value | `test-0000169-req-004-...sh`, case (c) with five values. PowerShell: `.ps1` (CI) |
| REQ-004 c: second run is byte-identical | `test-0000169-req-004-...sh`, case (d) and the rerun in case (c). PowerShell: `.ps1` (CI) |
| REQ-005 a: annotated tag on HEAD, message is the feature, origin holds it | `test-0000169-req-005-release-tag-script.sh`, "local tag is annotated", "tag points at HEAD", "tag message is the feature", "origin holds the tag" |
| REQ-005 b: rerun and origin-only skip, exit 0, tags unchanged | `test-0000169-req-005-...sh`, "second run prints skip line", "local tag unchanged", "origin-only run prints skip line", "no local tag recreated" |
| REQ-005 c: missing, invalid, and failed push exit 1. about.md fallback works | `test-0000169-req-005-...sh`, "missing version exits 1", "invalid version exits 1", "failed push exits 1", "about.md fallback exits 0" |
| REQ-006 a: workflows parse, triggers, `release-tag` job, guards, no other write | `test-0000169-req-006-release-tag-ci-and-ship-flow.sh`, the ruby block "parses with push trigger, release-tag job, and guarded jobs" for both files |
| REQ-006 b: Step 7 holds no `git tag`. Steps 9 and 10 name CI tagging. Local case prints the command | `test-0000169-req-006-...sh`, "Step 7 holds no git tag command", "Step 9 names CI tagging on main", "Step 9 prints the local-git-only tag command", "Step 10 summary names the tag landing on main" |
| REQ-006 c: three docs agree and R-D Advance still tags the squash commit | `test-0000169-req-006-...sh`, "roadmap-standards no longer says Step 7 tags", "R-D Advance still tags the squash commit", "pipeline-reference names the release-tag job", "custom-004 says CI tags the merge commit" |

## Verification by execution

### Outcome per criterion

| Criterion | Outcome | Method |
|---|---|---|
| REQ-001 a, b, c | verified | Inspection of the three files, see the doc section below |
| REQ-002 a | verified | `check-attribution.mjs` runs, see below |
| REQ-002 b | verified | Same runs, stdout empty and stderr free of input text |
| REQ-002 c | verified | `commit-msg` hook runs, see below |
| REQ-003 a | verified | Inspection of ship Step 9 |
| REQ-003 b | verified | ruby YAML parse and grep of both workflows |
| REQ-003 c | verified | Ran the extracted step from both workflows |
| REQ-004 a | verified for Bash. PowerShell not-verifiable: `pwsh` is absent here, CI runs it | `setup.sh` in a temp project |
| REQ-004 b | verified for Bash. PowerShell not-verifiable: same reason | `setup.sh` with existing values |
| REQ-004 c | verified for Bash. PowerShell not-verifiable: same reason | `setup.sh` rerun |
| REQ-005 a, b, c | verified | `release-tag.mjs --root` against temp repos |
| REQ-006 a | verified | ruby YAML parse of both workflows |
| REQ-006 b, c | verified | Inspection of the ship skill and three docs |

### check-attribution.mjs (REQ-002 a, b)

Each case ran `node ravintio-zero/scripts/check-attribution.mjs <file>`. Fixture text held marker strings, and I grepped stdout and stderr for them.

| Input | Exit | stdout bytes | stderr |
|---|---|---|---|
| `Generated with [Claude Code](...)` line | 1 | 0 | `check-attribution: line 3: host attribution line` |
| Same line with a robot emoji | 1 | 0 | `line 1: host attribution line` |
| `Claude-Session:` line | 1 | 0 | `line 2: host attribution line` |
| claude.ai/code session link | 1 | 0 | `line 1: host attribution line` |
| `Co-Authored-By: Claude` (Rule 1) | 1 | 0 | `line 1: AI attribution line` |
| `generated by Claude` (Rule 1) | 1 | 0 | `line 1: AI attribution line` |
| `AI-assisted change` (Rule 1) | 1 | 0 | `line 1: AI attribution line` |
| Clean prose mentioning "attribution" | 0 | 0 | empty |
| Empty file | 0 | 0 | empty |
| Missing file | 2 | 0 | `cannot read input` |
| Directory, and two arguments | 2 | 0 | usage line or read error |
| Stdin with a host line | 1 | 0 | `line 2: host attribution line` |
| Stdin, clean | 0 | 0 | empty |
| Stdin, empty | 0 | 0 | empty |

The marker strings (a session token, a link id, an email address, the phrase `Generated with`) appeared in neither stdout nor stderr in any case.

### commit-msg hook (REQ-002 c)

`bash ravintio-zero/hooks/commit-msg <file>` on temp message files:

| Message | Exit |
|---|---|
| `Generated with [Claude Code](...)` body line | 1 |
| Same with a robot emoji | 1 |
| `Claude-Session:` body line | 1 |
| `Co-Authored-By: Claude` body line | 1 |
| Clean subject, body mentions "attribution" | 0 |

### validate-branch attribution step (REQ-003 c)

I parsed each workflow with ruby, took the `run:` of the step named "Check PR description for attribution", and ran it with `bash` from the repo root. `PR_BODY` was set and `RUNNER_TEMP` pointed at a temp dir. The step's `env:` holds only `PR_BODY` in both files.

| Body | `.github/workflows/ravintio.yml` | `ravintio-zero/hooks/ravintio.yml` |
|---|---|---|
| Empty | exit 0 | exit 0 |
| Clean prose | exit 0 | exit 0 |
| Robot emoji `Generated with` line | exit 1, `line 3: host attribution line` | exit 1, same |
| `$(touch /tmp/pwned-0000169)`, backticks, and `; touch` | exit 0 | exit 0 |
| `$(touch ...)` plus a `Co-Authored-By: Claude` line | exit 1 | not run |

After all runs, `/tmp/pwned-0000169` did not exist. The body reaches the script as data only.

### Workflow structure (REQ-003 b, REQ-006 a)

`ruby -ryaml` on both files gave the same result:

- `on` holds `pull_request` (branches `main`, `master`, `roadmap/**`) and `push` (branches `main`, `master`).
- Top-level `permissions` is `contents: read`.
- Every job except `release-tag` has `if: github.event_name == 'pull_request'`. The repo file has four such jobs and the template has one.
- `release-tag` has `if: github.event_name == 'push'` and `permissions: contents: write`. It is the only job with `contents: write`.
- `release-tag` has `fetch-depth: 0`, the bot identity `github-actions[bot]`, and the run `node ravintio-zero/scripts/release-tag.mjs`.
- `pull_request.body` appears once per file, on the `PR_BODY:` env line. No `run:` contains it.

### setup.sh (REQ-004)

I copied `ravintio-zero/` into a temp dir, ran `git init`, then ran `bash ravintio-zero/setup.sh claude-code`. I read `.claude/settings.json` through `node`, and never printed it whole.

| Case | Exit | Observed state |
|---|---|---|
| No settings file | 0 | `attribution` is `{"commit":"","pr":""}` |
| Rerun on that project | 0 | File byte-identical to before the rerun |
| Existing object value, plus `permissions` | 0 | `attribution` unchanged, `permissions` kept, rerun byte-identical |
| Existing string value | 0 | `attribution` unchanged |
| Existing `null` value | 0 | `attribution` unchanged |

PowerShell: not-verifiable locally because `pwsh` is absent. CI runs `setup.ps1` and its test.

### release-tag.mjs (REQ-005)

Each case ran `node ravintio-zero/scripts/release-tag.mjs --root <tmp>` in a temp repo with a local bare `origin`.

| Case | Exit | Observed state |
|---|---|---|
| Create, `product.yml` has `version: 1.2.3` | 0 | `release-tag: v1.2.3 created and pushed`. Tag type is `tag`, points at HEAD, message is the feature id, bare origin holds `refs/tags/v1.2.3` |
| Rerun | 0 | `v1.2.3 exists, skipped`. Tag object id unchanged |
| Origin-only (local tag deleted) | 0 | `v1.2.3 exists, skipped`. No local tag recreated |
| No version anywhere | 1 | `no version found in product.yml or docs/about.md` |
| Version `1.2.beta` | 1 | `invalid version "1.2.beta" ...`. No tag created |
| Version only in `docs/about.md` frontmatter | 0 | Tag `v0.9.1` created and pushed, message is the feature id |
| Origin URL points at a missing path | 1 | `push of v2.0.0 to origin failed: ...` |

### Documentation criteria (REQ-001, REQ-003 a, REQ-006 b and c)

Method: inspection of each file.

- `ravintio-zero/templates/standard-boot.md` line 18 bans attribution in commit messages and PR descriptions and names all three host lines.
- `ravintio-zero/standards/commit-standards.md` section 3 opens with "Commit messages and PR descriptions MUST NOT attribute authorship" and lists all three host lines.
- Ship `SKILL.md` Step 9 states that PR bodies carry no AI attribution and lists the host lines. It orders the temp file, the `check-attribution.mjs` run, and the stop line `P4 Ship: Blocked: attribution line in the PR body.` before `gh pr create`.
- Ship Step 7 reads "Create no tag" and holds no `git tag` command. It says the CI `release-tag` job tags the merge commit on `main`.
- Step 9 option [1] pushes the branch only. The local-git-only case prints `git tag v{version} -m "{feature-id}" {merge-commit}`. Step 10 shows `Tag: v{version} (CI tags the merge commit on main)`.
- `roadmap-standards.md` says "Step 7 creates no tag" in the Ship stages paragraph. R-D Advance still runs `git tag v{version} -m "{feature-id}" "$sha"` on the squash commit.
- `pipeline-reference.md` says the agent creates no tag and the `release-tag` job tags the merge commit. Its CI table lists the `release-tag` job. The roadmap step text still tags the squash commit.
- `custom-004-ship-push-and-raise-pr.md` pushes the branch and says CI tags the merge commit on `main`.

## Full test suite

Command: `RAVINTIO_TEST_QUIET=1 env -i HOME=$HOME PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin RAVINTIO_TEST_QUIET=1 bash ravintio-zero/tests/run-tests.sh`. Exit code 0.

- Feature suites: 125 passed, 0 failed.
- Regression suite: 19 passed, 0 failed.
- Skipped: 13 PowerShell suites, because `pwsh` is not found.
