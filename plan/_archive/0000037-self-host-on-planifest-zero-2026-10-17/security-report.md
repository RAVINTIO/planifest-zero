---
title: "Security Report - 0000037-self-host-on-planifest-zero"
summary: "P5 security review of the bash-suites CI job, the setup.sh and setup.ps1 hook-entry repairs, the core.hooksPath switch, and the removal of planifest-framework/."
status: "active"
version: "0.1.0"
---
# Security Report - 0000037-self-host-on-planifest-zero

**Skill:** planifest-security-agent
**Scope:** `git diff main...HEAD -- . ':!planifest-framework'`, focused on the 0000037 commits (`17dc8d0` to `e790cb9`). The `planifest-framework/` deletion had a dependency check only.
**Overall risk rating:** Low

The change adds no network service, no secret, and no new privilege. It removes the one CI job that read a secret. No finding needs action before merge. S-001 and S-004 are small hardening items worth filing.

## Findings

| ID | Severity | File and line | Finding | Suggested fix |
|---|---|---|---|---|
| S-001 | Low | `planifest-zero/setup.sh:484-486`, `planifest-zero/setup.ps1:332-336` | The `PreToolUse` filter drops a whole entry when any one of its commands names a Planifest module. Since req-007 this applies on any matcher in `setup.sh`. An entry such as `{matcher:"Bash", hooks:[./my-audit.sh, node .../gate-write.mjs]}` loses `./my-audit.sh` with no warning. A user script at another path with the same basename, such as `/home/u/tools/gate-write.mjs`, also goes. A replay with node confirmed both cases. Planifest never writes multi-command entries, so this needs a hand edit first. | Filter at the command level. Remove only the matching commands, and drop an entry only when no command is left. Or warn when a removed entry held a command that does not match. |
| S-002 | Low | `planifest-zero/setup.sh:470-476`, `planifest-zero/setup.ps1:321-322` | The non-array warning prints the old `hooks.PreToolUse` or `hooks.UserPromptSubmit` value to stderr. A hand-written command can embed a token, for example a `curl` header. If setup runs in CI or a shared terminal, the log keeps that value. Both serialisers escape control characters, so the value can't inject terminal escape codes. The value reaches node through the parsed file only, never through `node -e` source or an env var, so no code injection path exists. | Accept, as ADR-003 does. The print is the only recovery copy. Optionally write the old value to a `settings.json.planifest-bak` file with mode `0600` and print its path instead. |
| S-003 | Low | `planifest-zero/setup.ps1:321` | `ConvertTo-Json -Depth 10` truncates a deeper value. Windows PowerShell 5.1 truncates in silence. The printed recovery copy can then be incomplete while setup still discards the original. | Raise `-Depth` to 100 for the warning, or write the raw text of the old value. |
| S-004 | Low | `planifest-zero/hooks/commit-msg`, req-004 | `core.hooksPath` is local git config. This clone now reads `planifest-zero/hooks`, and the three hooks match the deleted copies byte for byte. Any other clone still points at `planifest-framework/hooks`. After it pulls the deletion, git finds no hook and skips `commit-msg` with no error. R-005 covers this clone only. | Add a line to the PR description and release notes. Tell each clone to run `planifest-zero/setup.sh claude-code` or `git config core.hooksPath planifest-zero/hooks` after merge. |
| S-005 | Informational | `.claude/hooks/enforcement/auto-trigger-orchestrator.mjs:33`, `.claude/hooks/enforcement/em-dash-guard.mjs:49-51` | The installed hooks still look for `planifest-framework/`. Until the reinstall, `auto-trigger-orchestrator` stops firing and `em-dash-guard` no longer checks `planifest-zero/` skills, templates, or standards. `gate-write` has no such path and keeps working. ADR-001 and R-004 accept this until the post-merge reinstall. | Run the reinstall right after merge, as ADR-001 states. |
| S-006 | Informational | `.github/workflows/planifest.yml:15`, `.github/workflows/planifest.yml:42` | `validate-branch` and `self-description-check` use `actions/checkout@v4` by tag, with the default `persist-credentials`. The workflow-level `contents: read` limits the token. This predates 0000037. | Pin both to the same SHA and set `persist-credentials: false`, to match the newer jobs. |

## Threat model (STRIDE)

| Threat | Category | Severity | Mitigation |
|---|---|---|---|
| A fork PR's code in `bash-suites` steals a write token | Elevation | Low | Mitigated. `pull_request` gives forks a read-only token. The job sets `contents: read` and `persist-credentials: false` at lines 78-85. It references no `secrets`. |
| A compromised `actions/checkout` tag runs code in `bash-suites` | Tampering | Low | Mitigated. Line 83 pins the action to commit `11d5960`. |
| A PR edits `run-tests.sh` to use runner minutes without limit | Denial of service | Low | Not mitigated. The job has no `timeout-minutes`, so GitHub's 6-hour default applies. The token can't write, so the cost is minutes only. |
| A crafted `settings.json` value injects code into `node -e` | Tampering | Low | Mitigated. `PLANIFEST_WRITE_SETTINGS_JS` is a fixed string. Paths and commands reach node through env vars and the parsed file, never through the script source. |
| Setup drops a user's own guard hook | Tampering | Low | Partly mitigated. See S-001. |
| The old hook value leaks through the warning | Information disclosure | Low | Accepted. See S-002. |
| `commit-msg` stops running after the deletion | Repudiation | Low | Mitigated for this clone (S-004). |

## Dependency audit

The change adds no package. `bash-suites` uses `pwsh` and `node` from the `ubuntu-latest` image, not from a lock file. No action is needed.

## Secrets management

- `plan/state/claude-code.md` holds the tool name, an empty `flags` list, and a timestamp. It has no secret, URL, or token.
- Commit `94482e7` removes `validate-telemetry-schema` and its `secrets.PLANIFEST_TELEMETRY_URL` reference. No workflow job now reads a secret.
- The retired `--backend-url` value is still never printed or stored (0000034 ADR-001).
- A grep of the diff found no hardcoded credential.

## Authentication and authorisation review

No API exists in scope, and no OpenAPI spec applies. The only authority in scope is the GitHub token, and `permissions: contents: read` caps it at workflow and job level.

## Input validation review

`setup.sh` and `setup.ps1` read `settings.json`. A non-array event value now warns and gets replaced instead of failing or being wrapped. Both scripts treat absent, null, and array values the same way. A malformed entry, such as a `null` element or a non-array `hooks` field, makes `setup.sh` throw before `writeSettings` runs. The atomic write then leaves the original file untouched. The `UserPromptSubmit` filter in `setup.sh:497-500` still uses a plain substring match. Backlog `0000111-userpromptsubmit-filter-parity` tracks that.

## Network policy

The change opens no port and adds no egress. Removing the telemetry job also removes the only outbound `curl` from CI.

## Infrastructure as Code review

No IaC files exist in scope. The CI workflow is the only infrastructure config, and the findings above cover it.

## Risk register cross-reference

| Risk | Status in the code |
|---|---|
| R-005 | Mitigated for this clone. `git config core.hooksPath` prints `planifest-zero/hooks`. Other clones need S-004's note. |
| R-009 | Mitigated. Pinned checkout, `persist-credentials: false`, `contents: read`, and no `secrets` all hold at `.github/workflows/planifest.yml:76-90`. |
| R-010 | Out of scope for security. P4 owns it. |

## Dependency check on the deleted folder

No tracked file under `.github/`, `planifest-zero/hooks/`, or the setup scripts reads `planifest-framework/`. The remaining references sit in prose, archived plans, and the gitignored `.claude/` install (S-005).

## Summary

Overall risk rating: Low

Top actions before production:

1. Add the S-004 note to the PR description, so other clones repoint `core.hooksPath`.
2. Run the reinstall right after merge to restore `auto-trigger-orchestrator` and `em-dash-guard` scope (S-005).
3. File S-001 as backlog: filter hook commands one at a time rather than whole entries.
