---
title: "Security Report - 0000036-test-runner-coverage"
summary: "P5 security review of the test runner, the PowerShell suites, the Windows CI job, and the setup.ps1 --backend-url= split fix."
status: "active"
version: "0.1.0"
---
# Security Report - 0000036-test-runner-coverage

**Skill:** planifest-security-agent
**Scope:** `git diff 5c7b3ee..HEAD -- planifest-zero/ .github/`
**Overall risk rating:** Low

The change adds no network service, no secret, and no new privilege. The findings below are hardening items. None needs action before merge, but S-001 and S-004 are worth fixing in this feature because they are small.

## Findings

| ID | Severity | File and line | Finding | Suggested fix |
|---|---|---|---|---|
| S-001 | Low | `planifest-zero/tests/helpers/setup-workspace.ps1:33`, `planifest-zero/setup.ps1:535` | `New-SetupWorkspace` discards the result of `git init`. If `git init` fails, `setup.ps1` still runs `git config core.hooksPath`. Git then walks up from the temporary folder. If that folder sits inside another repo, git rewrites that repo's `core.hooksPath`. | Check `$LASTEXITCODE` after `git init` and throw on failure. Set `GIT_CEILING_DIRECTORIES` to the temporary parent in `Invoke-Setup`. |
| S-002 | Low | `planifest-zero/tests/test-0000036-req-004-setup-ps1-install.ps1`, `planifest-zero/tests/test-0000036-req-004-setup-ps1-flags.ps1` | Neither suite calls `Remove-SetupWorkspace` in a `finally` block. A stopped run leaves copies of `planifest-zero/` under the temp folder. The copies hold only repo files, so the exposure is small. | Wrap each workspace's use in `try` and `finally`. |
| S-003 | Low | `planifest-zero/setup.ps1:35-37`, `planifest-zero/setup.ps1:1125` | The skip rule relies on PowerShell 7 dropping the colon. If a host keeps it, as in `--backend-url=https:`, the rule does not fire. The rest of the value, such as `//host/token`, then becomes `$Tool`. `setup.ps1` prints it in `Unknown tool:`. The suite tests only the split that CI observed. | Also skip a next argument that starts with `//`. Print `$Tool` only when it matches `^[a-z0-9-]+$`, and print a fixed message otherwise. |
| S-004 | Low | `planifest-zero/tests/run-tests.sh:41` | The pre-flight exempts every path under `helpers/` at any depth. A misplaced suite, such as `helpers/test-x.sh` or `helpers/regression/test-y.sh`, passes the check and never runs. This is the silent-skip failure that ADR-001 sets out to stop. | Name the three helper files in `KNOWN_NON_SUITES`, or exempt only depth-one helper files whose name does not start with `test-`. |
| S-005 | Low | `.github/workflows/planifest.yml:52` | `actions/checkout@v4` uses a mutable tag. Checkout also keeps `GITHUB_TOKEN` in `.git/config` while PR code runs. The token is read-only under `contents: read`, so the impact is small. The other jobs share the tag pattern. | Pin the action to a full commit SHA with a version comment. Add `persist-credentials: false`. |
| S-006 | Info | `.github/workflows/planifest.yml` (workflow level) | The workflow has no top-level `permissions` block. The three older jobs take the repository's default token scope. This predates the change. The new job sets its own scope correctly. | Add `permissions: contents: read` at the workflow level. File it as a backlog item if it is out of scope. |
| S-007 | Info | `planifest-zero/tests/run-tests.sh:59` | The pre-flight lists regular files and symlinks only. A symlink named `test-x.sh` counts as a suite and runs a target outside `tests/`. A FIFO named `test-x.sh` escapes the check, and `bash` waits on it without end. Both need write access to the checkout, which already allows running code. | Accept, or reject symlinks and non-regular files in the pre-flight. |
| S-008 | Info | `planifest-zero/setup.ps1:37` | The split rule never swallows a flag or `claude-code`. It can swallow a mis-cased tool name such as `Claude-Code`. Setup then prints usage and exits 0 instead of exit 1. The spaced `--backend-url` form already behaves this way. | Accept. Record the behaviour in the 0000034 retired-flag notes if it matters. |

## Threat Model (STRIDE)

| Threat | Category | Severity | Mitigation |
|---|---|---|---|
| A setup run in a test rewrites `core.hooksPath` of a repo outside the workspace (S-001) | Tampering | Low | Partly mitigated. Each workspace gets its own `git init`, but the result goes unchecked. |
| A misplaced suite under `helpers/` hides from the stray-file check (S-004) | Tampering | Low | Not mitigated. |
| A split `--backend-url=` value reaches the console in `Unknown tool:` (S-003) | Info Disclosure | Low | Mitigated for the observed PowerShell 7 split. Not mitigated for other split shapes. |
| A moved action tag runs changed code in CI (S-005) | Tampering | Low | Not mitigated. The token is read-only and the job has no secrets. |
| `PLANIFEST_PWSH` points at a hostile program | Elevation | Info | Accepted. Anyone who can set it can also set `PATH`, so it grants nothing new. |
| A FIFO named as a suite stalls the run (S-007) | DoS | Info | Not mitigated. Needs write access to the checkout. |

## Dependency Audit

The change adds no package dependency. CI uses `actions/checkout@v4` by tag (S-005). The Windows job uses the runner's own `powershell` and `pwsh`. Nothing needs immediate action.

## Secrets Management

No credential appears in the diff. The Windows job references no `secrets.` value, and `test-0000036-req-005-windows-ci-job.sh` asserts this. The flags suite uses the placeholder `https://example.invalid/token-abc`. The suite masks that value when it prints output on failure. `GITHUB_TOKEN` persists in `.git/config` during the job (S-005).

## Authentication & Authorisation Review

Not applicable. The feature exposes no API. The new CI job declares `permissions: contents: read` and runs on `pull_request`, not `pull_request_target`. A fork PR therefore receives a read-only token. The workflow as a whole lacks a default scope (S-006).

## Input Validation Review

`run-tests.sh` quotes every path. A file name with spaces or glob characters runs as one argument and never re-expands. A name with a newline splits into fragments in the pre-flight. Each fragment fails the known-file test, so the run fails closed. `run-tests.ps1` uses `-LiteralPath` and passes `FullName` as one argument. The `setup.ps1` split rule skips only an argument that is neither a flag nor `claude-code`. It never prints the skipped value. The residual gaps are S-003 and S-008.

## Network Policy

Not applicable. The suites make no network call. The `example.invalid` URL is only a flag value, and setup ignores it.

## Infrastructure as Code Review

The only infrastructure file is `.github/workflows/planifest.yml`. The new `windows-powershell` job has read-only contents and no secrets. It has no write step. The gaps are the mutable action tag and the persisted token (S-005), and the missing workflow default (S-006).

## Risk Register cross-reference

| Risk | Status after review |
|---|---|
| R-004: the CI job gains write access or secrets | Mitigated. The job sets `contents: read` and uses no secrets. A suite asserts both. |
| R-005: `setup.ps1` writes outside the temporary project | Partly mitigated. The local `git init` keeps `git config` inside the workspace while `git init` succeeds. S-001 covers the failure path. No global git config write exists in `setup.ps1`. |
| R-002: the stray-file check flags a needed file | Open as designed. S-004 is the reverse case, where the check misses a file. |

## Summary

Overall risk rating: Low

Top actions before production:
1. Check the `git init` result and set `GIT_CEILING_DIRECTORIES` in the workspace helper (S-001).
2. Narrow the `helpers/*` exemption in the pre-flight (S-004).
3. Harden the `--backend-url=` split rule and stop echoing an unknown tool value (S-003).

## Resolution (after P5 fixes)

| ID | Outcome |
|----|---------|
| S-001 | Fixed. `New-SetupWorkspace` throws if `git init` fails, and `Invoke-Setup` sets `GIT_CEILING_DIRECTORIES` to the workspace's parent folder. |
| S-002 | Fixed. Both suites wrap their body in `try` and remove every workspace in `finally`. |
| S-003 | Fixed. A rest that starts with `//` is skipped too. `setup.ps1` prints a tool name only when it matches `^[a-z0-9-]+$`. A runtime case checks it. |
| S-004 | Fixed. `KNOWN_NON_SUITES` names the three helper files. A suite under `helpers/` is now stray, and a runner case checks it. |
| S-005 | Fixed. The new job pins `actions/checkout` to the `v4` commit and sets `persist-credentials: false`. |
| S-006 | Fixed. The workflow grants `contents: read` at the top level. |
| S-007 | Accepted. Both cases need write access to the checkout. |
| S-008 | Accepted. It matches the spaced form, which already behaves this way. |

Overall risk rating after the fixes: **Low**. CI run on PR #10: `windows-powershell` green on both hosts, 34 of 34 assertions each.
