# Security Report - ravintio-rebrand

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low (high before the re-review)
**Components Reviewed:** ravintio-zero (`migrations/migrate-ravintio-rename.sh`, `migrations/migrate-ravintio-rename.ps1`, `migrations/0004-ravintio-rename.md`, `setup.sh`, `setup.ps1`, `hooks/enforcement/em-dash-guard.mjs`, `scripts/roadmap-run.mjs`, `skills/ravintio-orchestrator/SKILL.md`, `skills/ravintio-migrator/SKILL.md`)
**Review Scope:** code review | threat model

The review covers `git diff main...HEAD`. Most of the diff is a mechanical rename. The review focuses on the new executable logic. It found one High, two Medium, and six Low findings. The High finding is not mitigated, so the stop rule fires.

The High finding is in the PowerShell migration helper. `migrate-ravintio-rename.ps1` removes `planifest-zero/` with `Remove-Item -Recurse -Force`. It refuses a link only at the top level. Windows PowerShell 5.1 follows a junction or directory symlink nested inside the folder and deletes the target's contents. The pack already records this behaviour in `setup.ps1:688-690` and works around it there. The helper has no such guard. I could not reproduce it, because no Windows host or `pwsh` was available.

I reproduced the first Medium finding in a scratch repo under `mktemp -d`. A symlink at `.github/workflows/planifest.yml` pointed at a file outside the repo. The Bash helper moved the link, then wrote the rewritten text through it. The outside file changed from `keep planifest-zero/ x` to `keep ravintio-zero/ x`.

The same run confirmed that `rm -rf` in the Bash helper does not follow links. A directory symlink nested in `planifest-zero/` pointed at an outside folder. The helper removed the link and left the outside folder and its files intact.

## Re-review

The fixes landed on 2026-10-24, and the re-review then checked each finding against the new code. Eight findings are mitigated. S-008 stays low and is accepted. No High or Medium finding remains, so the overall risk is now low and the stop rule no longer fires.

The Bash helper test reproduces each fixed case on macOS and passes. No Windows host or `pwsh` was available locally, so CI runs the PowerShell test. The nested-junction case (h) and the parent-folder cases (j) run only where `New-Item -ItemType Junction` works. The workflow-link cases (i) skip on a host that cannot create a symlink.

The re-review also found why the PowerShell helper test failed in CI on every host. `"Skipped $OldWorkflow: not present."` and `"Skipped $m: not present."` parse as drive-qualified variables, so the helper did not parse and exited 1. Both strings now use `${name}:`.

## Findings

| ID | Severity | Category | Location | Description | Recommendation | Status |
|----|----------|----------|----------|-------------|----------------|--------|
| S-001 | high | path traversal | `ravintio-zero/migrations/migrate-ravintio-rename.ps1:124-125`, `:54-60` | `Remove-Item -LiteralPath $OldPack -Recurse -Force` deletes `planifest-zero/`. The link check at `:54-60` covers the top-level folder only. Windows PowerShell 5.1 walks into a nested junction or directory symlink and deletes the files in its target. The target can sit anywhere the user can write. PowerShell 7 does not follow these links. `setup.ps1:688-690` names the same 5.1 behaviour and deletes links with `[System.IO.Directory]::Delete`. A tracked symlink inside a consumer's `planifest-zero/` can arrive through git when `core.symlinks` is on. A junction a user made inside the folder has the same effect. Not reproduced, because no Windows host was available. | Walk the tree before removal. Delete each reparse point as a link only with `[System.IO.Directory]::Delete` or `[System.IO.File]::Delete`, then remove the rest. Check that every path stays under the resolved repo root, as `Test-UnderRealRoot` does at `setup.ps1:702`. Add a nested-junction case to the helper test. | mitigated: `Remove-TreeNoFollow` at `migrate-ravintio-rename.ps1:60-85` deletes each reparse point as a link only, called at `:234`. Test case (h) in both helper tests. |
| S-002 | medium | path traversal | `ravintio-zero/migrations/migrate-ravintio-rename.sh:72-76`, `ravintio-zero/migrations/migrate-ravintio-rename.ps1:97-103` | The helpers refuse links only at the two override folders and `planifest-zero`. A symlink at `.github/workflows/planifest.yml` passes. The helper moves the link to `ravintio.yml`. `sed` then reads the target, and `cat "$tmp" > "$NEW_WORKFLOW"` writes through the link to the target. The `.ps1` helper does the same with `Resolve-Path` and `WriteAllText`. The write replaces every `planifest-zero/` in a file outside the repo. Reproduced with the Bash helper in a scratch repo. | Refuse a symlink at `.github/workflows/planifest.yml` and `ravintio.yml` in the first check loop. Write the rewrite to a temporary file in the same folder and rename it over the target, so a link is replaced, never followed. | mitigated: link refusal at `migrate-ravintio-rename.sh:32-40` and `.ps1:114-123` covers both workflow files. The rewrite goes through a temp file and a rename at `.sh:108-113` and `.ps1:200-206`. Test case (i). |
| S-003 | medium | config | `ravintio-zero/migrations/migrate-ravintio-rename.sh:96-97`, `ravintio-zero/migrations/migrate-ravintio-rename.ps1:124-125` | The helpers delete `planifest-zero/` without a prompt. They check neither that the working directory is a git repo root nor that the folder holds a pack, such as a `setup.sh`. Run from the wrong directory, they delete any `planifest-zero` folder that sits next to a `ravintio-zero` folder, such as a sibling clone. Untracked files in the folder are lost for good. Only the agent step in `0004-ravintio-rename.md:27-30` asks the human first. A human who runs the helper directly gets no prompt. | Check `git rev-parse --show-toplevel` against the working directory. Check that `planifest-zero/setup.sh` exists before removal. List untracked files in the folder and stop if any exist. | mitigated: root check at `.sh:42-51` and `.ps1:125-137`. Pack and dirty checks at `.sh:77-94` and `.ps1:163-181`. Test cases (k), (l), (m), and (n). |
| S-004 | low | path traversal | `ravintio-zero/migrations/migrate-ravintio-rename.sh:85-87`, `:106-110`, `ravintio-zero/migrations/migrate-ravintio-rename.ps1:112-114`, `:135-140`, `ravintio-zero/setup.sh:1110-1121`, `ravintio-zero/setup.ps1:1119-1146` | Each check covers the last path part only. A symlinked `.claude`, `.claude/skills`, `.github`, `.github/workflows`, `ravintio-zero`, or `ravintio-zero/migrations` sends the marker removal, the workflow move, or the archive `mkdir` and `mv` into the link target. Every file name is fixed, so the reach is narrow. | Refuse a symlink at each parent folder, or check that the real path sits under the real repo root. | mitigated: parent-folder link refusal at `.sh:32-40` and `.ps1:114-123`. Setup skips linked marker folders at `setup.sh:1110-1127` and `setup.ps1:1119-1152`. Test case (j) and a REQ-002 case. |
| S-005 | low | path traversal | `ravintio-zero/migrations/migrate-ravintio-rename.ps1:54-60`, `:124-125` | The link check runs once at the start. A local process that swaps `planifest-zero` for a junction before `:125` makes Windows PowerShell 5.1 delete the junction target. The Bash helper is safe here. `rm -rf` on a link path removes the link only. Only a concurrent local process can win this race. | Repeat the reparse-point check right before removal. S-001's link-aware delete also closes this race. | mitigated by the S-001 fix. Both helpers also re-check the link right before removal at `.sh:133-138` and `.ps1:228-233`. |
| S-006 | low | config | `ravintio-zero/migrations/migrate-ravintio-rename.ps1:97-101`, `ravintio-zero/migrations/migrate-ravintio-rename.sh:56`, `:72-73` | A dangling link breaks the "nothing was moved" promise. In `.ps1`, `Test-Present` accepts a dangling `planifest.yml`, then `Resolve-Path` throws after the overrides have moved. The `.sh` helper skips the same link, so the two helpers diverge. In `.sh`, a dangling `ravintio.yml` passes the `-e` conflict check. `git mv` then refuses the existing destination, and `set -e` exits after the overrides have moved. | Test with `-L` as well as `-e` in the conflict checks. Refuse links at both workflow paths (S-002). | mitigated: conflict checks use `-L` as well as `-e` at `.sh:71`. `Test-Present` and `Test-Link` read link attributes without following at `.ps1:24-40`. Both workflow links are refused (S-002). Test case (i) covers dangling links. |
| S-007 | low | config | `ravintio-zero/setup.sh:1212-1213`, `ravintio-zero/setup.ps1:1380-1381` | The leftover-folder stop uses `-e` and `Test-Path`. Both follow links, so a dangling `planifest-zero` or `planifest-overrides` link passes the stop. Setup then installs beside the stale link. No write or delete follows the link, so the impact is confusion only. | Test with `-e` or `-L` in Bash, and `Get-Item -Force` in PowerShell. | mitigated: `setup.sh:1216` adds `-L`, and `setup.ps1:1391-1392` uses `Get-Item -Force`. REQ-002 test covers a dangling link. |
| S-008 | low | injection | `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:74`, `ravintio-zero/skills/ravintio-migrator/SKILL.md:24`, `ravintio-zero/migrations/0004-ravintio-rename.md:5` | `Applies when:` is free text that the agent judges. The orchestrator skips a migration whose condition is false without showing it to the human. A crafted migration could word its condition to stay pending and out of view. It could also carry instructions in the condition text. A migration body is already agent instruction, so the field grants no new privilege. `pack-update-policy.md` stays the gate for files that arrive with a pack update. | Name each skipped migration in the build log or the session output. Prefer a condition the agent checks as a path test, such as a list of paths that must exist. | accepted (low): `ravintio-migrator/SKILL.md:24` reports each skip as `Skipped:`. The orchestrator skill keeps its byte budget and line test. A migration body is already agent instruction, so the field grants no new privilege. |
| S-009 | low | config | `ravintio-zero/migrations/migrate-ravintio-rename.sh:75`, `ravintio-zero/migrations/migrate-ravintio-rename.ps1:102`, `ravintio-zero/tests/run-tests.sh:180` | The workflow rewrite replaces `planifest-zero/` only. A consumer workflow that sets `PLANIFEST_REQUIRE_PWSH` keeps the old name. `run-tests.sh` reads `RAVINTIO_REQUIRE_PWSH` with no fallback. CI then skips missing PowerShell suites without failing. The shipped consumer workflow holds no `PLANIFEST_*` variable, so only a customised workflow is affected. | Rewrite `PLANIFEST_` to `RAVINTIO_` in the workflow too, or warn when the moved workflow still holds `PLANIFEST_`. | mitigated: the rewrite replaces `PLANIFEST_` with `RAVINTIO_` at `.sh:112` and `.ps1:200`. Test case (a). |

Checked and clean:

- `roadmap-run.mjs:121-134` validates the resolved value, whichever name supplied it. A legacy `PLANIFEST_ROADMAP_MODEL` must still match the model pattern, so it cannot pass as an option. A legacy `PLANIFEST_ROADMAP_MAX_TURNS` still takes digits only. Both reach `claude` as separate argv entries through `spawn` at `:231` with no shell. The stop line names `RAVINTIO_*` even when the bad value came from the legacy name. That affects diagnosis only.
- `em-dash-guard.mjs:45` and `:109` add the legacy sentinel as a second bypass string. The guard enforces a style rule, not a security control, so the wider bypass adds no risk.
- The Bash helper's top-level link refusal at `migrate-ravintio-rename.sh:30-36` holds. A swap after the check is harmless in Bash, because `mv` and `rm -rf` act on the link itself.
- `remove_old_markers` in `setup.sh:1110-1121` and `Remove-OldMarkers` in `setup.ps1:1119-1146` skip a symlinked marker and remove plain files only. S-004 covers parent folders.
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
| Deletion outside the repo on Windows | A junction or directory symlink nested in `planifest-zero/` (S-001, S-005) | migrate-ravintio-rename.ps1 | low | high | Top-level reparse-point check. | No nested link handling on Windows PowerShell 5.1. |
| Write outside the repo through the workflow | A symlink at `.github/workflows/planifest.yml` (S-002) | both helpers | low | medium | None. | No link check at the workflow paths. |
| Loss of a folder the user did not mean to remove | The helper runs from the wrong directory, or the old pack holds untracked files (S-003) | both helpers | medium | medium | Agent step 2 in migration 0004 asks the human. | No root or pack check, no prompt in the helper. |
| A migration hides from review | A crafted `Applies when:` condition (S-008) | orchestrator, migrator | low | low | Pack-update provenance check. | Skips are not reported. |
| CI gate weakened after upgrade | A customised workflow keeps `PLANIFEST_REQUIRE_PWSH` (S-009) | consumer CI | low | medium | Shipped workflow has no such variable. | No rewrite or warning. |

## Risk register cross-reference

| Risk | Category | Status in this review |
|------|----------|------------------------|
| R-002 | operational | Mitigated. Setup stops while `planifest-zero/` or `planifest-overrides/` exists. S-007 records that a dangling link passes the stop. |
| R-004 | technical | Mitigated for the shipped workflow. The helpers move it and rewrite `planifest-zero/` paths. S-002 and S-006 record link gaps. S-009 records that `PLANIFEST_*` variables in a customised workflow stay. |
| R-006 | compliance | Mitigated. The roadmap fallback works and validates legacy values the same way. |
| R-008 | technical | Not reviewed as a security risk. Setup re-sets `core.hooksPath` to `ravintio-zero/hooks`. |
| R-009 | operational | Mitigated. Setup and the helpers remove the old markers and skip a symlinked marker. S-004 records the parent-folder gap. |

The register holds no row for destructive file operations in the migration helpers. S-001, S-002, and S-003 are new risks for the register.

## Recommendations

Ordered by priority:

1. Fix S-001 before merge. Delete nested reparse points as links only in `migrate-ravintio-rename.ps1`, and add a nested-junction test. Or accept the risk with a human decision.
2. Refuse links at both workflow paths and rewrite through a temporary file and rename (S-002, S-006).
3. Check the repo root and the pack identity before deleting `planifest-zero/`, and stop on untracked files (S-003).
4. Refuse symlinked parent folders (S-004) and use link-aware tests in the setup stop (S-007).
5. Report skipped migrations (S-008) and warn on `PLANIFEST_*` left in the workflow (S-009).
