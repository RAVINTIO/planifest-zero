# Security Report - name-the-roadmap-initiative

**Skill:** [validate-and-accept](../skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000189-name-the-roadmap-initiative
**Wave:** not waved
**Version:** 0.19.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low
**Components Reviewed:** ravintio-zero
**Review Scope:** code review, threat model

The review found no critical, high, or medium findings. The `merge-guard` change is a string swap from `roadmap/` to `initiative/` and keeps every earlier check. The workflow diff touches only the branch trigger and changes no permissions. The diff holds no credentials.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| S-001 | low | config | ravintio-zero | `ravintio-zero/scripts/initiative-run.mjs:195` passes mode `0o700` to `mkdirSync`, which applies only when the folder is new. A `plan/.initiative-logs/` folder that already exists, for example one renamed by the migration from `plan/.roadmap-logs/`, keeps its old mode. The umask can also narrow the mode but never widens it. Step logs inside it get `0o600` at line 202, so file content stays private. | Call `chmodSync(dir, 0o700)` after `mkdirSync`. | open |
| S-002 | low | injection | ravintio-zero | `ravintio-zero/scripts/initiative-run.mjs:194-202` checks for symlinks and then opens the file. `O_NOFOLLOW` at line 202 covers only the last path part. A local user who can write to `plan/` could swap the folder for a link between lines 197 and 202. The `realpathSync` check at lines 196-198 is not atomic. Exploiting it needs local write access to the working tree. | Accept the risk, or open the folder first and use `openat`-style access. | accepted |
| S-003 | low | auth | ravintio-zero | `ravintio-zero/hooks/enforcement/merge-guard.mjs:177` accepts any base that starts with `initiative/`. Anyone who can push a branch named `initiative/x` and open a PR against it gets an agent squash merge. The old `roadmap/` check had the same shape. I found no input that reaches `main`. The code removes unsafe characters at line 148 before the check. A real base such as `initiative!/x` then reads as `initiative/x`. That base is still not `main`. Git refuses `initiative/../main`, and `gh pr view` returns the real base name. | Keep branch protection on `initiative/**` as the second control. | accepted |
| S-004 | low | config | ravintio-zero | `ravintio-zero/migrations/migrate-initiative-rename.sh:100-101` and `.ps1:154` rewrite the workflow in place, and steps 1 to 3 are not atomic. An interrupted run can leave a half-migrated repo or a truncated workflow. Git tracks the workflow, so `git checkout` recovers it. The run is idempotent, so a second run finishes the job. | Write the temp file in the same folder and `mv` it over the workflow. | open |
| S-005 | informational | config | ravintio-zero | `ravintio-zero/scripts/initiative-run.mjs:76` still names the lock `plan/.roadmap-runner.lock`, and line 226 matches archives named `-roadmap-`. This is a leftover old name, not a vulnerability. The lock is created with `wx` at line 288, which refuses an existing symlink. | Track the leftover name in the old-name guard allowlist or rename it. | open |

### Checks that found no issue

- `merge-guard.mjs:158-177`: Quoting, `$`, backticks, and `=` outside `--flag=value` are rejected by `parsePlain` (lines 73-81). Chained commands give more than one call and block at line 169. `--base main` is not a value flag, so it reaches `gh` as an unknown flag and does not change the base that `gh pr view` reads. Commands over 4096 characters block at line 155.
- `initiative-run.mjs:80-82`: The status regex now also accepts `proposed`, `charted`, and `delivered`. Line 282 and line 326 still stop unless status is `active`, so the wider set starts nothing new. The branch regex is anchored and allows only seven digits and a lower-case slug. The position regex allows one to three digits.
- `initiative-run.mjs:130`: The stop message names the old variable and never prints its value.
- `initiative-labels.mjs:11-17`: Encoding covers `%`, `,`, `=`, and space, and encodes `%` first. The id and slug are already limited by the branch regex.
- `migrate-initiative-rename.sh:48-74`: The script refuses a symlink at `plan`, at the drafts and log folders, at the workflow path, and at each draft file. Line 65 quotes the glob, so names with spaces are safe. A name that starts with `-` is safe because every path carries the `plan/roadmap/` prefix. Outside the project root, no path exists and the script prints "Nothing to do".
- `migrate-initiative-rename.sh:117-124`: The move to `_done/` is skipped when `ravintio-zero` or its `migrations` folder is a link.
- `.github/workflows/ravintio.yml:5` and `ravintio-zero/hooks/ravintio.yml:5`: The trigger changes to `initiative/**`. No `permissions` block changed.
- Credential scan of the full diff: no tokens, keys, passwords, or private key headers.

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Agent merges into `main` | Crafted `gh` command or PR base name | merge-guard | low | high | Plain-word parser, single call, `--squash` only, base read by `gh pr view` | Branch protection is the only control against a hostile `initiative/*` base (S-003) |
| Log redirect through a symlink | Link swapped in `plan/.initiative-logs/` | initiative-run | low | medium | `lstat` checks, `realpath` check, `O_NOFOLLOW` | Race window (S-002) |
| Log content read by other users | Loose folder mode | initiative-run | low | low | Mode `600` on each log | Existing folder keeps its mode (S-001) |
| Old variable silently ignored | Consumer sets `*_ROADMAP_MODEL` | initiative-run | medium | low | The driver stops and names the new variable | none |
| Interrupted migration | Ctrl+C during the run | migration helpers | low | low | Idempotent, conflict checks run first | Non-atomic rewrite (S-004) |

## Risk register cross-reference

| Risk | Security view | Status |
|------|---------------|--------|
| R-001 A missed old name breaks the driver or `merge-guard` | Code review found one leftover old name, the lock file (S-005). It does not break the driver. `merge-guard` has no missed name. | open until CI runs the old-name test |
| R-002 `.claude/skills/` drifts from `ravintio-zero/skills/` | Out of the code scope. Not checked here. | open |
| R-003 A rename breaks a Windows-only test path | The `.ps1` helper mirrors the `.sh` checks. Not run here. | open |
| R-004 Old-name allowlist grows too broad | Not a code risk. Not reviewed beyond the diff. | open |
| A-004 Removing the `PLANIFEST_ROADMAP_*` fallback breaks no one | Mitigated. `initiative-run.mjs:129-131` stops with a clear message. | mitigated |

## Recommendations

1. Add `chmodSync(dir, 0o700)` after `mkdirSync` at `ravintio-zero/scripts/initiative-run.mjs:195` (S-001).
2. Confirm branch protection covers `initiative/**` bases (S-003).
3. Rewrite the workflow through a same-folder temp file and `mv` in both migration helpers (S-004).
4. Rename or allowlist the leftover lock name at `initiative-run.mjs:76` (S-005).
