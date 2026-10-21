# Security Report - setup-json-checks-and-park

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000040-setup-json-checks-and-park
**Version:** 0.7.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low. It was medium at review. Commit 108d1ce fixed F-001 to F-005 with tests: one branch check, exact refspecs, and fixed slug and id patterns.
**Components Reviewed:** planifest-zero (`setup.sh`, `setup.ps1`, `skills/planifest-orchestrator/scripts/park.mjs`, the orchestrator `SKILL.md` Park Command and pickup text, `park.template.md`, and the 0000040 tests)
**Review Scope:** code review | dependency audit | threat model

The setup changes are sound. They add one fixed error line and print no file content. The new `park.mjs` uses `spawnSync` with argument arrays, so no shell parses any value. Its weak point is argument validation. `resume` and `discard` pass the branch argument to git unchecked. I confirmed three ways to defeat a stated guarantee or guard. Each needs the agent to pass an unusual branch argument, and none is reachable from a branch git would create through `park`.

No finding is Critical or High. F-001 and F-002 are Medium.

I ran `park.mjs` against a local bare remote with a stub `gh` in a scratch directory outside the repo. I ran both bash suites. `test-0000040-req-001-sh-shape-check.sh` passed 63 of 63, and `test-0000040-req-004-005-park.sh` passed 81 of 81. `pwsh` is not installed here, so I reviewed `setup.ps1` by reading it.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | medium | injection | planifest-zero | `discard` guards only the literal string `main` (`park.mjs:186`). It then passes the argument to `git ls-remote --heads` and `git push origin --delete` (`park.mjs:189`). `ls-remote` matches a full ref name, and `push --delete` accepts one. I ran `discard refs/heads/extra --confirmed` and it deleted `extra` on origin with exit 0. The same call with `refs/heads/main` passes the guard and deletes origin `main`. GitHub refuses to delete the default branch, and branch protection may also block it. A bare or self-hosted remote may not. | Validate the argument with `git check-ref-format --branch` and reject a `refs/` or `heads/` prefix. Push `refs/heads/{branch}` as an exact refspec. Compare the resolved ref against `refs/heads/main`. | mitigated in 108d1ce |
| F-002 | medium | injection | planifest-zero | `resume` passes its positional argument straight to `git checkout` (`park.mjs:174-177`). `parseArgs` treats only a `--` prefix as an option (`park.mjs:65`), so `-f` reaches git as a flag. I ran `resume -f` with an uncommitted edit. Git ran `git checkout -f`, threw the edit away, and the script printed `Resumed -f` with exit 0. Git refuses to create a branch whose name starts with `-`, so a real parked entry can't name one. The risk is a malformed or crafted entry, or an agent slip. | Reject an argument that starts with `-`. Check that `refs/heads/{branch}` or `refs/remotes/origin/{branch}` exists before checkout. Pass `--end-of-options` before the branch. | mitigated in 108d1ce |
| F-003 | low | config | planifest-zero | `resume` has no `main` guard, unlike `discard` (`park.mjs:186`). I ran `resume main` with a local commit on `main`. It ran `git merge --no-edit origin/main` (`park.mjs:178`) and made a merge commit on local `main`. Nothing was pushed. This breaks the "never commits to `main`" rule in `park.mjs:34` and `SKILL.md` for the local branch. | Refuse `resume main`, as `discard` does. | mitigated in 108d1ce |
| F-004 | low | path traversal | planifest-zero | `--slug` and `--backlog-id` build `entryPath` with no check (`park.mjs:91`). `mkdirSync` and `writeFileSync` then write it (`park.mjs:119-120`). With `--slug ../../../../escaped`, the script committed `escaped/entry.md` at the repo root on the chore branch, pushed it, and exited 0. With one more `..`, it wrote `entry.md` outside the repo. `git add` then failed (`park.mjs:121`) and left the file there. A slug taken from the branch can't escape, because git refuses `..` in a ref name. | Require `--backlog-id` to match `^[0-9]{7}$` and `--slug` to match `^[a-z0-9][a-z0-9-]*$`. Resolve the path and check it stays under `plan/backlog/`. | mitigated in 108d1ce |
| F-005 | low | injection | planifest-zero | Every push uses the bare branch name as the refspec (`park.mjs:125`, `park.mjs:161`, `park.mjs:189`). Git accepts a branch named `+x`, and `git push origin +x` reads it as a forced push of `x`. I confirmed git parses it that way. `park` only pushes the current branch (`park.mjs:152`), so this needs both `+x` and `x` to exist locally. The chore branch always starts `chore/`, so it is safe. | Push `refs/heads/{branch}:refs/heads/{branch}`. This also closes F-001. | mitigated in 108d1ce |
| F-006 | informational | data-exposure | planifest-zero | `--entry` reads any readable file (`park.mjs:81-82`). The script commits it to the chore branch and pushes it to origin (`park.mjs:120-125`). The only check is the `**Parked branch:**` line (`park.mjs:83`). An agent that passes the wrong path could publish a local file. The skill tells the agent to write the entry outside the working tree, so the path is agent-chosen by design. | Accept, or check the frontmatter `status: "parked"` and the template heading before the write. | open |
| F-007 | informational | data-exposure | planifest-zero | `run` prints git or `gh` stderr and stdout verbatim on failure (`park.mjs:51-52`). I set the remote to `https://user:ghp_PLANTEDTOKEN@127.0.0.1:9/x.git` and ran `park`. Git 2.50.1 printed the URL without the user and token. An older git, a credential helper, or a server message could print more. `gh` does not print its token on error. The user's goal (report the exact error) needs this output. | Accept. Optionally strip `//user:pass@` from the detail text before printing. | accepted |
| F-008 | informational | config | planifest-zero | `git checkout -B` (`park.mjs:118`) resets an existing local chore branch to the remote chore branch or `origin/main`. Local-only commits on that branch drop out of the branch, though the reflog keeps them. It does not force-push, because the reset base is the remote tip. | Accept. | accepted |
| F-009 | low | data-exposure | planifest-zero | Pre-existing, not changed by this feature. The non-array warning still prints the old `hooks.{event}` value (`setup.sh:495`, `setup.ps1:464`). This is 0000039 F-001 and 0000038 F-006. It had no backlog entry. | Print the event name and the file only. | open, backlog 0000130 |

## Review notes by area

### Injection in park.mjs

- **No shell:** `run` calls `spawnSync(cmd, args)` with no `shell` option (`park.mjs:48`). Branch names, feature ids, slugs, backlog ids, and the entry path are separate argv items. No value reaches a shell parser, so `;`, `$()`, quotes, and spaces are inert.
- **Leading `-`:** `park` and `finish-pr` require `--branch` to equal the current branch (`park.mjs:152`, `park.mjs:168`). Git refuses a branch named `-f` (`fatal: '-f' is not a valid branch name`). Those two paths therefore can't carry an option. `resume` and `discard` have no such check (F-002, F-001).
- **Separators:** `git add --` (`park.mjs:121`), `git ls-files ... --` (`park.mjs:154`), and `git status ... --` (`park.mjs:157`) end option parsing before the path.
- **Feature id:** a `--feature-id` with `:` or spaces makes `chore/park-{id}` an invalid ref. `git checkout -B` then fails at `park.mjs:118`, before any commit or push. `onFeatureBranch` returns the tree to the feature branch.
- **Entry content:** the entry text goes to a file and a commit, never to argv. `gh pr create` gets only the feature id and branch name in `--title` and `--body` (`park.mjs:128-129`).
- **Interpolation in errors:** `${cmd} ${args.join(' ')}` (`park.mjs:49`, `park.mjs:52`) prints the argv. It holds no secret.

### Never merge, never commit to main, never force-push

| Guarantee | Evidence | Verdict |
|-----------|----------|---------|
| Never merges a PR | No `gh pr merge` call in `park.mjs`. The suite asserts the `gh` log has no `pr merge` after park, failure, and pickup. | holds |
| Never commits to `main` | `commitOffMain` checks the current branch before `git commit` (`park.mjs:104-107`). The chore branch base is `origin/main`, but the commit lands on `chore/park-*`. The suite checks origin `main` is unchanged. | holds for `park` and `finish-pr`. Fails locally for `resume main` (F-003). |
| Never force-pushes | No `--force`, `-f`, or `--force-with-lease` in any push (`park.mjs:125`, `park.mjs:161`, `park.mjs:189`). | holds, except a branch named `+x` (F-005). |
| Never deletes `main` | `discard` refuses the literal `main` (`park.mjs:186`). | bypassable with `refs/heads/main` (F-001). |

### Path traversal

- `entryPath` is `plan/backlog/{backlog-id}-park-{slug}/entry.md` (`park.mjs:91`). The `{backlog-id}-park-` prefix makes the first segment a plain name. Each later `..` climbs one level. Four climb to the repo root, and five leave it (F-004).
- A slug derived from the branch can hold `/`, for example `feat/0000040-a/b`. That nests a folder but stays inside `plan/backlog/`.
- `PARK_RECORD` is a fixed constant (`park.mjs:43`).

### Data exposure in setup

I ran the req-001 suite, which plants `PLANTED-0000040-secret` in `settings.json`. The planted value never appeared on stdout or stderr for any shape case, and each file stayed byte-identical.

- **setup.sh:** the shape check (`setup.sh:480-485`) prints `PLANIFEST_SETTINGS_REL` and a fixed string. The file path comes from tool config, not file content. It runs before `s.hooks = s.hooks || {}`. This closes 0000039 F-002: a JSON array, `null`, a string, or `{"hooks":"text"}` now stops setup with exit 1 and no stack trace.
- **setup.ps1:** a syntax failure prints the fixed invalid-JSON line (`setup.ps1:419-422`). `ConvertFrom-Json` runs inside `try` with `-ErrorAction Stop`, and the `catch` discards the exception (`setup.ps1:436`). Every unreadable shape prints one fixed line through `[Console]::Error.WriteLine` (`setup.ps1:445`). Both exits come before any write. I reasoned this and did not run it.
- **Depth cap:** `Test-JsonText` fails at depth 1025 (`setup.ps1:339-341`) and tells the caller through `[ref]`. The caller then prints the shape line. The message names no content. The `Stack[char]` push and pop make the scan linear, which closes 0000039 F-003 (backlog 0000122). No recursion remains.
- **Empty file:** `"$(Get-Content ...)"` turns `$null` into `""` (`setup.ps1:417`). `Test-JsonText ""` fails, so the invalid-JSON line prints. `JSON.parse("")` also throws in `setup.sh`, so both scripts agree.

### Credential handling

The feature adds no credential, token, or secret. `park.mjs` relies on the user's existing git credential setup and `gh` login. It never reads, prints, or stores either. F-007 covers the only path where a remote URL could reach the output.

### Dependency risk

No new dependency. `park.mjs` imports only `node:child_process`, `node:fs`, and `node:path`. No lock file changed. The script needs `git` and `gh` on `PATH`. A planted `gh` earlier on `PATH` would run, but that is true of every `gh` call the skills already make.

## Prior findings

| Prior ID | Backlog | Status now | Evidence |
|----------|---------|------------|----------|
| 0000039 F-001 (old value printed) | 0000130 (filed now) | open (pre-existing) | Now F-009. |
| 0000039 F-002 (non-object JSON) | 0000121 | mitigated | `setup.sh:480-485` and `setup.ps1:434-447`. The req-001 suite covers array, `null`, string, number, and non-object `hooks`. |
| 0000039 F-003 (quadratic stack) | 0000122 | mitigated | `Stack[char]` and the 1024 cap at `setup.ps1:320-341`. CI proof pending. |
| 0000039 F-004 (`Merge-AllowedTools` parity) | none | open | Unchanged (`setup.ps1:517-520`). |
| 0000039 F-006 (regex divergence) | 0000120 | open | Unchanged. Case-duplicate keys now print the shape line in `setup.ps1` (ADR-003). |

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Remote `main` deleted | `discard refs/heads/main --confirmed` | park.mjs | low | high | Human confirmation, literal `main` guard, GitHub default-branch rule | F-001 |
| Uncommitted work lost | `resume -f` from a crafted entry | park.mjs | low | medium | Git refuses `-` branch names | F-002 |
| Local commit on `main` | `resume main` | park.mjs | low | low | None | F-003 |
| File written or pushed outside `plan/backlog/` | `--slug` or `--backlog-id` with `..` | park.mjs | low | medium | Agent supplies the values | F-004 |
| Forced push | Branch named `+x` | park.mjs | low | medium | `park` pushes only the current branch | F-005 |
| Local file published | Wrong `--entry` path | park.mjs | low | medium | `**Parked branch:**` line check | F-006 |
| Token in error output | Credentials embedded in remote URL | park.mjs | low | medium | Git strips userinfo from URLs | F-007 |
| Secret from `settings.json` reaches a log | Shape or depth failure | setup.sh, setup.ps1 | low | high | Fixed lines, planted-value tests | F-009 (pre-existing path) |
| Shell injection | Metacharacters in branch or slug | park.mjs | low | high | `spawnSync` with argv arrays | None |

## Risk register cross-reference

| ID | Status | Evidence |
|----|--------|----------|
| R-001 | Mitigated in code. CI proof pending. | Both suites assert the exact shape line. The bash suite passed here. The PowerShell suite runs only in CI. |
| R-002 | Mitigated. | `SKILL.md` resume step 8 runs `gh pr list --head chore/park-{feature-id}` and then `park.mjs finish-pr`. `finish-pr` skips the chore step when a PR exists (`park.mjs:110-112`). |
| R-003 | Open. | `pwsh` is not installed here. Only CI proves `setup.ps1`. |
| R-004 | Mitigated for the new paths. | No planted value reached output in the bash suite. `setup.ps1:436` discards the exception. F-009 is a separate pre-existing path. |
| R-005 | Open until CI. | Reasoned from `setup.ps1:320-341`. The PowerShell suite holds the 1024 and 1025 cases and the 100,000-level timing case. |
| R-006 | Partly mitigated. | Holds for `park` and `finish-pr` (`park.mjs:104-107`, no `--force`, no `gh pr merge`). Open for `resume main` (F-003) and `+x` branches (F-005). |
| R-007 | Open. | `--confirmed` is a flag the agent passes, so the script can't prove a human confirmed. The `main` guard is bypassable (F-001). |
| R-008 | Mitigated. | A conflicting `git merge` exits non-zero. `run` throws, and the script prints the error and exits 1 (`park.mjs:178`, `park.mjs:200-202`). It never resolves the conflict. |
| A-001 | Open. | If `gh` is missing, `spawnSync` sets `r.error`, and the script prints `could not start` and returns to the feature branch (`park.mjs:49`, `park.mjs:138-147`). |
| A-002 | Open. | Not a security risk. CI proves it. |

## Recommendations

Ordered by priority:

1. Validate the branch argument in `resume` and `discard` before any git call (F-001, F-002, F-003). Reject a leading `-` or `+`, a `refs/` or `heads/` prefix, and `main`. Run `git check-ref-format --branch` on it.
2. Push and delete with exact refspecs, `refs/heads/{branch}:refs/heads/{branch}` (F-001, F-005).
3. Validate `--backlog-id` and `--slug` against fixed patterns, and check the resolved path stays under `plan/backlog/` (F-004).
4. Confirm the PowerShell 7 and Windows PowerShell 5.1 CI jobs are green (R-001, R-003, R-005).
5. Stop printing old hook values in the non-array warning (F-009, backlog 0000130).
