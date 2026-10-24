# Security Report - ravintio-rebrand

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low (high at the first review). The rating holds if the Windows CI job passes helper test case (h).
**Components Reviewed:** ravintio-zero (`migrations/migrate-ravintio-rename.sh`, `migrations/migrate-ravintio-rename.ps1`, `migrations/0004-ravintio-rename.md`, `setup.sh`, `setup.ps1`, `hooks/enforcement/em-dash-guard.mjs`, `scripts/roadmap-run.mjs`, `skills/ravintio-orchestrator/SKILL.md`, `skills/ravintio-migrator/SKILL.md`)
**Review Scope:** code review | threat model

The review covers `git diff main...HEAD`. Most of the diff is a mechanical rename, so the review focuses on the new executable logic. The first review found one High, two Medium, and six Low findings. Fixes landed in `7aa7fe3`, `4013be6`, and `ec7b72f`.

An independent re-review checked each fix in the code and reproduced the Bash cases. Eight of the nine first-round findings are mitigated. S-008 stays Low and accepted. The re-review found six new Low findings. Four of them are regressions from the fixes, where a new stop blocks a normal upgrade. No Critical, High, or Medium finding remains unmitigated, so the stop rule does not fire.

S-001 is the only finding still unconfirmed on a real host. The fix reads as correct, but no Windows host or `pwsh` was available locally. The CI run on the current head was still in progress at review time. The two runs before it failed.

## Re-review

I re-reviewed every finding independently against `dd09b36`. I did not rely on the status notes the fixing agent had added. I ran the Bash helper in fresh scratch repos under `mktemp -d`. Each case used a consumer fixture with a tracked old pack, overrides, a workflow, and both old markers.

| Case | Result |
|------|--------|
| Clean upgrade, then a rerun | Exit 0 both times. The second run changed nothing. The workflow lost every `planifest-zero/` and `PLANIFEST_` token. |
| Symlink at `planifest.yml` to an outside file | Exit 1, nothing moved. The outside file kept `planifest-zero/`. S-002 is fixed. |
| Directory link nested in `planifest-zero/` | Exit 0. The outside folder and its file stayed intact. |
| Run from a subdirectory | Exit 1 with the repo root named. Nothing was deleted. |
| Untracked file in `planifest-zero/` | Exit 1 with the file listed. The file stayed. |
| Git-ignored file in `planifest-zero/` | Exit 0. The ignored file was deleted without notice (S-011). |
| Pack never committed | Exit 1, listing every pack file as untracked (S-014). |
| `ravintio-zero` or `.claude` is a symlink | Exit 1 (S-013). |
| No git repo, untracked file in the pack | Exit 0. The file was deleted, because the dirty check skips outside git (S-011). |
| Workflow uses `secrets.PLANIFEST_DEPLOY_TOKEN` | Rewritten to `secrets.RAVINTIO_DEPLOY_TOKEN` (S-010). |

I also ran `setup.sh claude-code` in a scratch repo. A dangling `planifest-zero` link now stops setup with exit 1. With `.claude` as a symlink, setup skipped both old markers with a warning and left the outside marker in place.

I reviewed the PowerShell fixes by reading the code. `Remove-TreeNoFollow` (`migrate-ravintio-rename.ps1:60-85`) checks each entry's attributes before it recurses. It deletes a reparse point as a link only and never enumerates it. `Get-EntryAttributes` (`:24-28`) reads the entry itself, so a dangling link counts as present. The fixing agent also fixed a parse error. `"Skipped $OldWorkflow: not present."` read as a drive-qualified variable, so the helper did not run in CI on any host.

## Findings

Locations for S-001 to S-009 name the lines as they stood at the first review. The status column names the lines of each fix.

| ID | Severity | Category | Location | Description | Recommendation | Status |
|----|----------|----------|----------|-------------|----------------|--------|
| S-001 | high | path traversal | `ravintio-zero/migrations/migrate-ravintio-rename.ps1:124-125`, `:54-60` (first review) | `Remove-Item -Recurse -Force` deleted `planifest-zero/` after a top-level link check only. Windows PowerShell 5.1 walks into a nested junction or directory symlink and deletes the files in its target. `setup.ps1:688-690` names the same behaviour. | Delete each nested reparse point as a link only. Add a nested-junction test. | mitigated in `7aa7fe3`. `Remove-TreeNoFollow` at `.ps1:60-85`, called at `:234`. Code-reviewed only. Test case (h) runs only on a host that can create a junction, so it needs the Windows CI job to pass. |
| S-002 | medium | path traversal | `migrate-ravintio-rename.sh:72-76`, `.ps1:97-103` (first review) | A symlink at `.github/workflows/planifest.yml` passed the checks. The rewrite then wrote through the link to a file outside the repo. Reproduced. | Refuse links at both workflow paths. Rewrite through a temporary file and a rename. | mitigated in `7aa7fe3`. Link refusal at `.sh:32-40` and `.ps1:114-123`. Temporary file and rename at `.sh:108-113` and `.ps1:201-206`. Reproduced as refused. |
| S-003 | medium | config | `migrate-ravintio-rename.sh:96-97`, `.ps1:124-125` (first review) | The helpers deleted `planifest-zero/` with no check of the working directory or the folder's contents. Untracked files were lost for good. | Check the repo root and the pack identity. Stop on untracked files. | mitigated in `7aa7fe3`. Root check at `.sh:42-51` and `.ps1:125-137`. Pack and dirty checks at `.sh:77-94` and `.ps1:163-182`. Reproduced as refused. S-011 records the gaps that remain. |
| S-004 | low | path traversal | `migrate-ravintio-rename.sh:85-87`, `:106-110`, `.ps1:112-114`, `:135-140`, `setup.sh:1110-1121`, `setup.ps1:1119-1146` (first review) | Each check covered the last path part only. A symlinked parent folder sent writes or removals into the link target. | Refuse a symlinked parent folder. | mitigated in `7aa7fe3` and `4013be6`. The helpers refuse at `.sh:32-40` and `.ps1:114-123`. Setup skips with a warning at `setup.sh:1114-1116` and `setup.ps1:1127-1135`. Reproduced. S-013 records the cost. |
| S-005 | low | path traversal | `migrate-ravintio-rename.ps1:54-60`, `:124-125` (first review) | A local process could swap `planifest-zero` for a junction between the check and the delete. | Re-check before removal and delete without following links. | mitigated in `7aa7fe3`. Re-check at `.sh:135-138` and `.ps1:230-233`, and the S-001 walk. A race against a concurrent local process is still possible, but the walk never follows a link. |
| S-006 | low | config | `migrate-ravintio-rename.ps1:97-101`, `.sh:56`, `:72-73` (first review) | A dangling workflow link moved the overrides, then aborted. The two helpers behaved differently. | Make the conflict checks link-aware. | mitigated in `7aa7fe3`. `-L` in the conflict check at `.sh:71`. Link-aware `Test-Present` at `.ps1:36-39`. The first check loop refuses both workflow links. |
| S-007 | low | config | `setup.sh:1212-1213`, `setup.ps1:1380-1381` (first review) | A dangling `planifest-zero` or `planifest-overrides` link passed the leftover-folder stop. | Make the stop link-aware. | mitigated in `4013be6`. `-L` at `setup.sh:1216`, `Get-Item -Force` at `setup.ps1:1392`. Reproduced as stopped. |
| S-008 | low | injection | `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:74`, `ravintio-zero/skills/ravintio-migrator/SKILL.md:24`, `ravintio-zero/migrations/0004-ravintio-rename.md:5` | `Applies when:` is free text that the agent judges. The orchestrator skips a false condition without telling the human. A crafted migration could keep itself pending and out of view. A migration body is already agent instruction, so the field grants no new privilege. | Report each skip. Prefer a path test over free text. | accepted. No code changed. The migrator reports `Skipped:` at `SKILL.md:24`, but the orchestrator skip at `SKILL.md:74` still reports nothing. |
| S-009 | low | config | `migrate-ravintio-rename.sh:75`, `.ps1:102`, `ravintio-zero/tests/run-tests.sh:180` (first review) | The rewrite left `PLANIFEST_REQUIRE_PWSH` in a customised workflow, so CI could skip PowerShell suites without failing. | Rewrite `PLANIFEST_` too. | mitigated in `7aa7fe3`. Rewrite at `.sh:112` and `.ps1:200`. Reproduced. S-010 records a side effect. |
| S-010 | low | config | `migrate-ravintio-rename.sh:112`, `migrate-ravintio-rename.ps1:200` | The `PLANIFEST_` rewrite matches any token. It also renames the consumer's own secret and variable references, such as `secrets.PLANIFEST_DEPLOY_TOKEN`. The repo has no secret under the new name, so the step gets an empty value. A deploy or signing step can then fail, or run without its credential. Reproduced. | Rewrite only the known pack variables, such as `PLANIFEST_REQUIRE_PWSH` and `PLANIFEST_ROADMAP_*`. Print each other `PLANIFEST_` line for the human to check. | not mitigated |
| S-011 | low | data-exposure | `migrate-ravintio-rename.sh:85-93`, `migrate-ravintio-rename.ps1:171-181` | The dirty check uses `git status --porcelain`, which hides ignored files. A git-ignored file inside `planifest-zero/`, such as local config, is deleted without notice. Outside a git repo the dirty check is skipped, so any extra file is deleted. Both reproduced. | Add `--ignored` to the status call, or list every file that `git ls-files` does not hold. Outside git, list files that the pack does not ship and stop. | not mitigated |
| S-012 | low | config | `migrate-ravintio-rename.sh:42-51`, `migrate-ravintio-rename.ps1:125-137` | Regression. The root check stops a project that sits below its git top level, as in a monorepo. Setup supports that layout, because it takes the pack's parent as the project root (`setup.sh:14`). From the git root, the helper then stops with `ravintio-zero/ not found`. Such a consumer cannot use the helper at all. Reproduced. | Accept a working directory that holds `ravintio-zero/`, even below the git top level. Or compare against the pack's parent folder, as setup does. | not mitigated |
| S-013 | low | config | `migrate-ravintio-rename.sh:32-34`, `migrate-ravintio-rename.ps1:114-116` | Regression. The helpers refuse a symlinked `ravintio-zero`, `.claude`, or `.github` even when nothing needs writing there. A developer who links the pack in from a shared checkout, or links `.claude` from a dotfiles repo, is blocked. Setup accepts these links. Reproduced for `ravintio-zero` and `.claude`. | Check a parent folder only when a step will write into it. Or skip that step with a warning, as setup does for the markers. | not mitigated |
| S-014 | low | config | `migrate-ravintio-rename.sh:86-91`, `migrate-ravintio-rename.ps1:172-180` | Regression. A consumer who never committed `planifest-zero/` sees every pack file listed as untracked, so the helper always stops. A stray untracked file such as `.DS_Store` also stops it. The message is clear and nothing moves, but the consumer must finish the upgrade by hand. Reproduced. | If no file under `planifest-zero/` is tracked, compare the folder against the shipped pack file list instead. Ignore known OS clutter files. | not mitigated |
| S-015 | low | config | `migrate-ravintio-rename.ps1:64-70`, `:234` | `Remove-TreeNoFollow` treats every directory reparse point as a link. A non-empty reparse folder that is not a link, such as a cloud-sync placeholder, makes `Directory.Delete` fail. The fallback `File.Delete` then throws. The helper stops after the overrides and workflow have moved and part of the pack is gone. Git can restore the tracked part. Found by code reading only. | Catch the failure, print which folder could not go, and exit non-zero with a clear message. | not mitigated |

Checked and clean:

- `roadmap-run.mjs:121-134` validates the resolved value, whichever name supplied it. A legacy `PLANIFEST_ROADMAP_MODEL` must still match the model pattern, so it cannot pass as an option. A legacy `PLANIFEST_ROADMAP_MAX_TURNS` still takes digits only. Both reach `claude` as separate argv entries through `spawn` at `:231` with no shell. The stop line names `RAVINTIO_*` even when the bad value came from the legacy name. That affects diagnosis only.
- `em-dash-guard.mjs:45` and `:109` add the legacy sentinel as a second bypass string. The guard enforces a style rule, not a security control.
- `rm -rf` in the Bash helper removes a nested link as a link. Reproduced with an outside folder that stayed intact.
- The workflow rewrite writes to a temporary file in the same folder, then renames it over the target. A link at the target is replaced, never followed.
- The helpers take no arguments and use fixed relative paths, so no `..` path can reach them from input.
- The credential scan of added lines found no secret. `SECRET_URL` in `ravintio-zero/tests/test-0000034-req-001-retired-flags.sh:18` is a fixture on the reserved `.invalid` domain.

## Dependency audit

The feature adds no package. The helpers use shell built-ins, `git`, and `sed`. `roadmap-run.mjs` and `em-dash-guard.mjs` use only Node built-ins.

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Deletion outside the repo on Windows | A junction or directory symlink nested in `planifest-zero/` (S-001, S-005) | migrate-ravintio-rename.ps1 | low | high | `Remove-TreeNoFollow` deletes links as links. Re-check before removal. | Not yet observed on a Windows host. |
| Write outside the repo through the workflow | A symlink at a workflow path (S-002, S-006) | both helpers | low | medium | Link refusal and a rename-based rewrite. | None found. |
| Loss of files the user meant to keep | Wrong directory, untracked files, ignored files, or no git (S-003, S-011) | both helpers | low | medium | Root, pack, and dirty checks. | Ignored files, and any file outside git (S-011). |
| A broken CI credential after the upgrade | A consumer secret named `PLANIFEST_*` (S-010) | consumer CI | low | medium | None. | The rewrite renames every `PLANIFEST_` token. |
| A normal upgrade blocked | A nested project, a linked folder, or an uncommitted pack (S-012, S-013, S-014) | both helpers | medium | low | Each stop prints a clear message and moves nothing. | Manual upgrade is the only path. |
| A migration hides from review | A crafted `Applies when:` condition (S-008) | orchestrator | low | low | Pack-update provenance check. Migrator reports `Skipped:`. | Orchestrator skips are not reported. |

## Risk register cross-reference

| Risk | Category | Status in this review |
|------|----------|------------------------|
| R-002 | operational | Mitigated. Setup stops while `planifest-zero/` or `planifest-overrides/` exists, including as a dangling link. |
| R-004 | technical | Mitigated. The helpers move the workflow and rewrite its paths and variables without following links. S-010 records that the rewrite also renames consumer secrets. |
| R-006 | compliance | Mitigated. The roadmap fallback works and validates legacy values the same way. |
| R-008 | technical | Not assessed as a security risk. Setup re-sets `core.hooksPath` to `ravintio-zero/hooks`. |
| R-009 | operational | Mitigated. Setup and the helpers remove the old markers. Setup skips a marker under a symlinked folder and leaves it in place. |

The register holds no row for destructive file operations in the migration helpers, or for an upgrade that the helper wrongly blocks. S-001, S-003, and S-011 to S-014 are new risks for the register.

## Recommendations

Ordered by priority:

1. Confirm that the Windows CI job passes helper test case (h) before merge. Until then, S-001 rests on code review only.
2. Narrow the `PLANIFEST_` rewrite to the pack's own variables (S-010).
3. Include ignored files in the dirty check, and add a check outside git (S-011).
4. Relax the stops that block a normal upgrade (S-012, S-013, S-014). Each one should check only what the next step touches.
5. Give `Remove-TreeNoFollow` a clear failure message (S-015), and report orchestrator migration skips (S-008).
