# Security Report - hardening-efficiency-and-ci

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Version:** 0.1.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** high
**Components Reviewed:** planifest-zero (`skills/planifest-orchestrator/scripts/park.mjs`, `scripts/roadmap-run.mjs`, `scripts/roadmap-labels.mjs`, `setup.sh`, `setup.ps1`, `hooks/enforcement/gate-write.mjs`, `hooks/enforcement/em-dash-guard.mjs`, `hooks/enforcement/ratchet-check.mjs`, `tests/run-tests.sh`, `tests/run-tests.ps1`, `tests/helpers/assert.sh`, `tests/helpers/assert.ps1`), `.github/workflows/planifest.yml`
**Review Scope:** code review | threat model

The review covers `git diff main...HEAD -- planifest-zero .github`. It found one High, one Medium, and four Low findings. The stop rule for unmitigated critical or high findings fires.

The High finding is in the new step logs. `roadmap-run.mjs` opens `plan/.roadmap-logs/step-{position}.log` with a plain `openSync(..., 'w')`. That call follows a symlink at the log path. A step session can plant the link for the next step, or a tracked symlink can arrive from the roadmap branch. The driver then truncates a file outside the repo and writes the child's stdout into it. The child controls that text. I reproduced this in a scratch repo under `mktemp -d`. The driver runs outside Claude Code's permission checks, so the write bypasses them.

Park containment (REQ-001) holds. I ran eleven symlink cases against `park.mjs` in scratch repos. Every case refused with exit 1, wrote nothing outside the repo, and pushed nothing. The cases covered:

- a symlinked `plan`, `plan/backlog`, entry folder, or `entry.md` on `origin/main` only
- a dangling link at each of those parts
- a run from a subdirectory with a link under it, and a subdirectory that is itself a link
- a local pre-commit hook that swaps `plan` or `plan/backlog` for a link before cleanup

No git command runs between `checkEntryPath` and the write, mkdir, or delete it guards. Only a concurrent local process could race the check (S-005).

The env and argument handling in `roadmap-run.mjs` is sound. `PLANIFEST_ROADMAP_MODEL` must start with a letter or digit, so it cannot pass as an option. `PLANIFEST_ROADMAP_MAX_TURNS` takes digits only. Both reach `claude` as separate argv entries through `spawn` with no shell. Every label value comes from fields that `BRANCH` and `POSITION` already restrict to digits, lower-case letters, and hyphens.

## Findings

| ID | Severity | Category | Location | Description | Recommendation | Status |
|----|----------|----------|----------|-------------|----------------|--------|
| S-001 | high | path traversal | `planifest-zero/scripts/roadmap-run.mjs:160-165`, `:203-206` | `openLog` runs `mkdirSync` then `openSync(join(root, rel), 'w')`. Neither checks for a symlink. A link at `plan/.roadmap-logs` or at `step-{n}.log` sends the truncate and the child's output outside the repo. Reproduced: a stub step 1 ran `ln -s $VICTIM plan/.roadmap-logs/step-2.log`. Step 2 printed one line. `$VICTIM` (outside the repo, holding `precious-bytes`) then held only that line. A symlinked `plan/.roadmap-logs` folder also took the new `step-3.log`. `.git/info/exclude` does not stop a tracked symlink from checkout. | `lstat` `plan`, `plan/.roadmap-logs`, and the log file, and refuse a symlink, as `park.mjs` `checkEntryPath` does. Open with `O_WRONLY \| O_CREAT \| O_TRUNC \| O_NOFOLLOW`. Check that the real path of the folder sits under the real repo root. Add a test with a planted link. | not mitigated |
| S-002 | medium | config | `planifest-zero/tests/helpers/assert.ps1:13-16`, `:18-30` | `Write-AssertPass` calls `Write-AssertPass`, and `Write-AssertFail` calls `Write-AssertFail`. The rename replaced the `Write-Host` line inside each helper with a call to the helper itself. Each call recurses until PowerShell raises a call-depth error. The `FAIL:` text is never printed in either mode. In default mode, the first passing assert also recurses. The suite exit code stays non-zero on a failure, so CI does not pass a broken build. It does lose the failure detail and fail passing suites. Found by code reading. No `pwsh` was available to run it. The Windows CI job for this PR was still running at review time. | Restore `Write-Host "  PASS: $Message"` and `Write-Host "  FAIL: $Message"` inside the two helpers. Run the PowerShell suites under both hosts before merge. | not mitigated |
| S-003 | low | data-exposure | `planifest-zero/scripts/roadmap-run.mjs:160-165`, `:203-206` | Step logs keep the child's full stdout and stderr with no redaction. Before this change the driver dropped stdout. A token that a tool prints now lands on disk. The file gets mode `0644` in a `0755` folder, so other local users can read it. It stays until the same step reruns. Only the local `.git/info/exclude` keeps it out of commits. | Create the folder `0700` and each log `0600`. Name the logs in the credential scan before ship. Add `plan/.roadmap-logs/` to the shipped `.gitignore` as a second layer. | not mitigated |
| S-004 | low | path traversal | `planifest-zero/setup.ps1:710-711` | `Remove-RetiredHooks` uses `Get-ChildItem -Recurse`. Windows PowerShell 5.1 follows directory links and junctions on `-Recurse`. PowerShell 7 does not. A junction inside `.claude/hooks` would let 5.1 delete files with a retired hook name, such as `emit-event.mjs`, outside the hooks tree. The names are fixed, so the reach is narrow. Not reproduced, because no Windows host was available. The bash mirror (`setup.sh:445`) uses `find -type f` with no `-L`. I confirmed it follows neither a symlinked `.claude/hooks` nor a link inside it. | Skip any item with the `ReparsePoint` attribute while walking the tree. Check that each match's full path starts with the resolved hooks root before `Remove-Item`. | not mitigated |
| S-005 | low | path traversal | `planifest-zero/skills/planifest-orchestrator/scripts/park.mjs:180-190`, `:198`, `:215-217` | `checkEntryPath` runs right before each write, mkdir, and delete. The write itself still follows links, because `writeFileSync` takes no `O_NOFOLLOW`. A concurrent local process that swaps a path part between the check and the write could still redirect it. No git command runs in that window, so the untrusted tree from `origin/main` cannot cause the swap. Paths resolve against the working directory, not the repo root. A run from a subdirectory stays contained relative to that directory. | Accept the local race. Optionally open the entry with `O_NOFOLLOW` and resolve paths against `git rev-parse --show-toplevel`. | accepted |
| S-006 | low | injection | `planifest-zero/scripts/roadmap-labels.mjs:12-29`, `roadmap-run.mjs:199` | `encodeLabelValue` encodes percent, comma, equals, and space only. W3C baggage values also exclude other characters, such as `"`, `;`, `\`, and non-ASCII text. Today no such character can reach it, because `BRANCH` and `POSITION` restrict every input. The old `OTEL_RESOURCE_ATTRIBUTES` value passes through as given. A caller-set `work.kind` or `planifest.step` key would sit beside the driver's own. That value is the caller's own environment, so it adds no privilege. | Use `encodeURIComponent` so a future caller with wider input stays safe. Optionally drop old keys that the driver sets. | accepted |
| S-007 | low | data-exposure | `planifest-zero/tests/helpers/assert.sh:126-132` | `orch_combined` writes a copy of the orchestrator skill text to `mktemp` under `$TMPDIR` and nothing removes it. Each run leaves files behind. The content is public skill text, so the exposure is clutter, not secrets. | Remove the file in each caller's `trap`, or return the text on stdout. | not mitigated |

Checked and clean:

- `setup.sh:28-38` and `setup.ps1:269-286` print one fixed write-error line. It holds `.claude/settings.json` as a relative path, with no absolute path, error code, or stack trace.
- The hook stderr reasons (`gate-write.mjs:74-78`, `em-dash-guard.mjs:116-123`, `ratchet-check.mjs:243-244`) echo the repo-relative target path and the plan lines the agent itself tried to remove. They echo no environment value, no absolute path outside the project, and no file content beyond those lines.
- `.github/workflows/planifest.yml:50-77` keeps `contents: read` and the checkout pinned to a commit with `persist-credentials: false`. The matrix values are fixed literals, so `${{ matrix.shell }}` carries no PR-controlled text. The two older jobs still use `actions/checkout@v4` by tag (`:15`, `:42`). That predates this feature.
- Quiet mode in `run-tests.sh:84-101` and `run-tests.ps1:28-37` keys on the suite exit code, not on the printed text. A failing suite prints its whole captured output and still counts as failed. A skipped PowerShell suite still counts towards `PLANIFEST_REQUIRE_PWSH`. S-002 covers the PowerShell helper defect.
- The `.git/info/exclude` write (`roadmap-run.mjs:142-158`) finds the file through `git rev-parse --git-path`. It appends two fixed lines and skips outside a work tree. A work tree cannot track anything under `.git`.

## Dependency audit

The feature adds no package. `roadmap-run.mjs`, `roadmap-labels.mjs`, and `park.mjs` use only Node built-ins.

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Overwrite a file outside the repo through the step log | A step session or a tracked commit plants a symlink at the log path (S-001) | roadmap-run | low | high | None. | No symlink check and no `O_NOFOLLOW`. |
| Secrets persist in step logs | A tool prints a token, and the log keeps it (S-003) | roadmap-run | medium | medium | Local exclude keeps logs out of commits. | No redaction, world-readable mode. |
| Park writes outside the repo | A symlink in the untrusted `origin/main` tree (REQ-001) | park | low | high | `checkEntryPath` before each write, mkdir, and delete. Reproduced as refused. | Local concurrent race only (S-005). |
| Setup deletes outside the hooks tree | A junction inside `.claude/hooks` on Windows PowerShell 5.1 (S-004) | setup.ps1 | low | low | Fixed retired names, `-File` only. | No reparse-point check. |
| CI evidence lost for PowerShell suites | Helper self-recursion (S-002) | tests | high | medium | Exit code still fails the suite. | No `FAIL:` detail, passing suites fail. |

## Risk register cross-reference

| Risk | Category | Status in this review |
|------|----------|------------------------|
| R-007 | security | Behaves as designed. A symlinked `plan` on `origin/main` gives `Refusing plan: it is a symlink.` with exit 1. The message names the repo-relative part only. Park fails closed. Stays open until the park docs state the limit. |
| R-010 | security | Mitigated. The labels hold the roadmap id, slug, and position only. Each value is percent-encoded and appended to the old value, which stays byte for byte. S-006 records the narrow encoding as a future-proofing gap. |
| R-006 | operational | Related to S-002. Bash quiet mode keeps every failure and its detail. PowerShell quiet mode cannot print a `FAIL:` line until S-002 is fixed. Stays open. |

No other register row is a security risk.

## Recommendations

Ordered by priority:

1. Fix S-001 before merge. Refuse a symlink at `plan/.roadmap-logs` and at each log file, open with `O_NOFOLLOW`, and add a planted-link test.
2. Fix S-002 before merge. Restore the `Write-Host` lines in `assert.ps1` and run the PowerShell suites under both hosts.
3. Tighten log permissions to `0700` and `0600`, and cover the logs in the pre-ship credential scan (S-003).
4. Skip reparse points in `Remove-RetiredHooks` (S-004).
5. Clean up the `orch_combined` temporary files (S-007), and move label encoding to `encodeURIComponent` (S-006).
