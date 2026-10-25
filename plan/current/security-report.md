---
title: "Security Report - release-hygiene"
summary: "Security review of the PR attribution check, the release-tag job, and the setup attribution setting."
status: "draft"
version: "0.1.0"
---
# Security Report - release-hygiene

**Skill:** validate-and-accept
**Feature:** 0000169-release-hygiene
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero (`scripts/check-attribution.mjs`, `scripts/release-tag.mjs`, `hooks/commit-msg`, `hooks/ravintio.yml`, `setup.sh`, `setup.ps1`, `skills/ravintio-ship/SKILL.md`) and `.github/workflows/ravintio.yml`
**Review scope:** code review | threat model

The review covers `git diff 38fe055..HEAD -- . ':!plan'`. No Critical or High finding exists. The one Medium finding is the floating `actions/checkout@v4` ref in the `release-tag` job of the consumer template. Four Low findings and two informational notes remain.

I read every file in scope. I ran `check-attribution.mjs` on a 64 KB line of repeated `co-authored-by:` text and it finished in 0.16 seconds. I did not run `setup.ps1`, because no Windows host was available. A scan of the diff for `ghp_`, `github_pat_`, `AKIA`, `sk-`, `xox`, and `-----BEGIN` found no credential. The only hit is prose in the ship skill that names the patterns.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-001 | medium | supply chain | `ravintio-zero/hooks/ravintio.yml:53` | The `release-tag` job in the consumer template uses `actions/checkout@v4`, a floating tag, in a job that holds `contents: write`. If the tag moves to hostile code, that code runs with a token that can push to the consumer repo. The repo copy pins a SHA (`.github/workflows/ravintio.yml:120`), so this repo is not exposed. The same floating ref sits at `:18` with a read-only token. | Pin the template checkout in `release-tag` to the commit SHA used in the repo copy. Keep the `# v4` comment. | not mitigated |
| S-002 | low | supply chain | `.github/workflows/ravintio.yml:18`, `:53` | `validate-branch` and `self-description-check` use `@v4`. Both jobs hold a read-only token. This predates the feature, and `:53` is not in the diff. | Pin both refs to the same SHA. | not mitigated |
| S-003 | low | credential exposure | `.github/workflows/ravintio.yml:120-123`, `ravintio-zero/hooks/ravintio.yml:53` | The `release-tag` checkout leaves `persist-credentials` at its default, so the write token stays in `.git/config` while `release-tag.mjs` runs. The script needs it, because `git push` reads it. The job runs only code already on `main`, so the exposure is the intended one. | None needed. Add a comment that the default is deliberate, so a later edit does not set it to `false` and break the push. | accepted |
| S-004 | low | injection | `.github/workflows/ravintio.yml:24`, `ravintio-zero/hooks/ravintio.yml:24` | `run:` interpolates `${{ github.base_ref }}`. A base ref is a branch name that someone with write access chose. A fork PR cannot invent one, because the base must already exist. The exploit path needs a maintainer to create a hostile branch name and open a PR against it. This predates the feature. | Move the value to `env:` and use `"$BASE_REF"`. | not mitigated |
| S-005 | low | availability | `release-tag.mjs:34-41`, `:79` | `release-tag` creates the tag from the pushed commit's `product.yml`, with no check that the commit is a release. Anyone who can push to `main` can mint a tag for an unreleased version. They already hold that power, so the job adds a convenience, not a new right. A tag the human deleted comes back on the next push. | Document that deleting a tag also needs a version bump. Optionally protect `v*` tags with a ruleset. | accepted |
| S-006 | low | availability | `.github/workflows/ravintio.yml:39-41` | The PR body travels in an environment variable. Linux limits one variable to 128 KB. A body of 65,536 characters can pass that limit when most characters take four bytes, and the step then fails with "Argument list too long". The failure blocks the PR and does not open a bypass. | Optional. Read the body with `gh pr view --json body` into the file. | accepted |
| S-007 | low | config | `ravintio-zero/setup.sh:545-548`, `setup.ps1:584-590` | Setup now writes `attribution` with empty `commit` and `pr` strings when the key is absent. It silently removes host attribution that a person may expect. A present key, including `null` or a custom string, stays unchanged. Setup prints one line for the change. | None needed. The output line and ADR-004 cover it. | accepted |
| S-008 | informational | integrity | `.github/workflows/ravintio.yml:41-42` | The PR check runs `check-attribution.mjs` from the PR's own checkout. A PR can edit the script to pass itself. The check is a hygiene guard and not a security boundary, so this is by design. | None needed. Branch protection with a required review is the control. | accepted |
| S-009 | informational | config | `release-tag.mjs:56-57` | `--root` takes the next argument without validation. A flag-like value is read as a path. The caller sets the argument, and git runs with `cwd` set to it. No injection results. | None needed. | accepted |

## Checks with no finding

### GitHub Actions script injection

- No untrusted event field reaches `run:` through `${{ }}` except `github.base_ref` (S-004).
- `PR_BODY` enters through `env:` only. The step writes it with `printf '%s' "$PR_BODY"`, quoted, so the shell never parses the body. `$RUNNER_TEMP` is runner-controlled.
- The PR title and head ref are not used.
- `matrix.shell` comes from the workflow file, not from the event.

### Token scope

- The top level sets `permissions: contents: read` in both files. Each other job inherits it or restates it.
- Only `release-tag` holds `contents: write`.
- `release-tag` runs when `github.event_name == 'push'` and the branch is `main` or `master`. It cannot run on PR events or on fork code, because fork PRs trigger `pull_request` and not `push` on the base repo.
- Only a person with write access can push to `main`, or a merge by such a person. A non-maintainer cannot trigger the job.
- The job runs code that is already on `main`. It checks out the pushed commit and never a PR head.
- A tag push with `GITHUB_TOKEN` does not start further workflows, so no chain follows.
- The PowerShell and Bash jobs pin the checkout and set `persist-credentials: false`, so PR code never sees a token.

### `release-tag.mjs`

- Every git call uses `spawnSync("git", [array])` with no shell, so no argument is parsed as shell text.
- `VERSION_RE` is anchored at both ends and allows digits and dots only. A `product.yml` version such as `--upload-pack=x` or one with a newline fails the check. The JavaScript `$` without the `m` flag matches only at the true end.
- The tag is always `v` plus the version, so it can never start with `-`. The ref is `refs/tags/v...`.
- The feature string becomes the value of `-m`. Git takes the next argument as the message even if it starts with `-`, so a crafted feature cannot add options. The value is one line, because the reader works line by line.
- `ls-remote` and `push` name `origin` and a full ref, with no force flag. The script cannot move or delete an existing tag.
- Error output prints git's stderr. That text can name the remote URL. GitHub Actions masks the token in logs.

### `check-attribution.mjs`

- It never echoes input. It prints the line number and rule name, and a fixed read-error line.
- The patterns are literal strings plus one `.*` in `co-authored-by:.*(...)`. Worst-case cost grows with the square of the line length. A 64 KB hostile line ran in 0.16 seconds, so ReDoS is not practical.
- It reads the whole input into memory. The input is a PR body of at most 65,536 characters, or a commit message.
- The path argument is passed to `readFileSync` as given. A caller who can set it can already read the file. Failure prints no path.
- `hooks/commit-msg` adds two patterns with the same shape as the existing ones. The `\\[?` escape works in the double-quoted bash array.

### `setup.sh` and `setup.ps1`

- The write goes through `writeSettings`. It writes a temporary file with the `wx` flag, so a planted link at the temporary path is not followed. It renames the file over the target and keeps the mode.
- A symlinked `settings.json` is written through to its real file. This predates the feature and is by design.
- JSON comes from `JSON.parse` and `JSON.stringify`, or `ConvertTo-Json -Depth 100`. No string concatenation builds the settings.
- The attribution key is added only when absent. A human value is never overwritten.

### Credentials

- The diff holds no secret. The tests and docs use placeholder text only.

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | PR body injects shell code | mitigated | Body passes through `env:` and `printf '%s'`. No `github.event.pull_request.body` sits inside `run:`. Test `test-0000169-req-003` covers it. `base_ref` is a separate Low finding (S-004). |
| R-002 | Check matches a PR that discusses attribution | mitigated | The patterns match whole attribution lines, and the check reports no text. |
| R-003 | `if:` guards skip a required check on `main` pushes | mitigated | PR jobs skip on push by design. Branch protection reads PR checks only. |
| R-004 | Host ignores empty `attribution` strings | open | Only a live Claude Code run can show it. The check and the `commit-msg` hook still catch the lines. |
| R-005 | `GITHUB_TOKEN` cannot push a tag | open | CI has not run on `main` yet. The job fails visibly if the repo setting blocks writes. A human tags by hand. |

## Top actions

1. Pin `actions/checkout` in the `release-tag` job of `ravintio-zero/hooks/ravintio.yml` to the SHA used in the repo workflow (S-001).
2. Move `github.base_ref` into `env:` in both workflow files (S-004).
3. Pin the two remaining `@v4` refs in the repo workflow (S-002).
4. After the first merge to `main`, confirm the `release-tag` job pushed a tag, to close R-005.
