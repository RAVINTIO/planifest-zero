# Security Report - ravintio-rebrand

**Skill:** [validate-and-accept](../../ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md)
**Feature:** 0000160-ravintio-rebrand
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** low (high at the first review)
**Components Reviewed:** ravintio-zero (`migrations/migrate-ravintio-rename.sh`, `migrations/migrate-ravintio-rename.ps1`, `migrations/0004-ravintio-rename.md`, `setup.sh`, `setup.ps1`, `hooks/enforcement/em-dash-guard.mjs`, `scripts/roadmap-run.mjs`, `skills/ravintio-orchestrator/SKILL.md`, `skills/ravintio-migrator/SKILL.md`)
**Review Scope:** code review | threat model

The review covers `git diff main...HEAD`. Most of the diff is a mechanical rename, so the review focuses on the new executable logic. Three review rounds ran:

1. The first review found one High, two Medium, and six Low findings.
2. The second round re-reviewed the cycle 3 fixes. It found six more Low findings, four of them stops that wrongly blocked a normal upgrade.
3. The third round re-reviewed cycle 4 at `a9a7084`. Cycle 4 replaced deletion of the old pack with a move to `.ravintio-backup/planifest-zero/`.

The redesign closes S-001 to S-015, except S-008, which stays accepted. It adds three new Low findings. No Critical, High, or Medium finding remains, so the stop rule does not fire.

The PowerShell helper is reviewed by reading only. No Windows host or `pwsh` was available. Two CI runs on the branch were still in progress at review time, and the two before them failed. The rating assumes the PowerShell helper test passes in CI.

## Re-review

I re-reviewed every finding independently against `a9a7084`. I did not rely on the status notes in earlier versions of this report. I ran the Bash helper in fresh scratch repos under `mktemp -d`. Each repo held a tracked old pack, overrides, a workflow, and both old markers.

| Case | Result |
|------|--------|
| Clean upgrade with an untracked file and an excluded file in the pack | Exit 0. Both files landed in `.ravintio-backup/planifest-zero/`. Git no longer tracks any pack file. `.ravintio-backup/` was added to `.git/info/exclude` once. |
| Rerun | Exit 0, no change. |
| Workflow with `PLANIFEST_REQUIRE_PWSH`, `PLANIFEST_ROADMAP_*`, `secrets.PLANIFEST_DEPLOY_TOKEN`, and `secrets.PLANIFEST_REQUIRE_PWSH_X` | Only the three pack variables changed. Both secrets stayed as they were. |
| `.ravintio-backup` is a file | Exit 1, nothing moved. The message names `.ravintio-backup/planifest-zero`, not the file. |
| `.ravintio-backup` is a symlink | Exit 1, nothing moved. The link target stayed empty. |
| `.ravintio-backup/planifest-zero` is a symlink | Exit 1, nothing moved. |
| `.github` is a symlink | Exit 0. The helper skipped the workflow step with a warning and left `planifest.yml` in the link target untouched. |
| Project nested below its git root | Exit 0. The exclude entry went to the repo's `.git/info/exclude` and matches at any depth. |
| Linked worktree | Exit 0. The exclude entry went to the main repo's `.git/info/exclude`, which git shares across worktrees. |
| Staged pack edit that differs from both `HEAD` and the working file | Exit 1 after the overrides, workflow, and markers had moved. `git rm --cached` refused. A rerun fails the same way (S-016). |
| `.git/info/exclude` is a symlink to an outside file | Exit 0. The helper appended `.ravintio-backup/` to the outside file (S-017). |

I reviewed the PowerShell helper by reading it. It mirrors the Bash steps. `[System.IO.Directory]::Move` at `migrate-ravintio-rename.ps1:229` renames the folder and never enters a nested junction. The tree walk and the recursive delete are gone. `Test-Link` at `:40-60` also checks `LinkTarget` and `LinkType`.

## Findings

Locations for S-001 to S-015 name the lines as they stood when each finding was raised. The status column names the current lines.

| ID | Severity | Category | Location | Description | Recommendation | Status |
|----|----------|----------|----------|-------------|----------------|--------|
| S-001 | high | path traversal | `migrate-ravintio-rename.ps1:124-125` (first review) | `Remove-Item -Recurse -Force` deleted `planifest-zero/`. Windows PowerShell 5.1 walks into a nested junction or directory symlink and deletes the files in its target. | Delete nested links as links only. | mitigated in cycle 4. The helper no longer deletes the pack. `Directory.Move` at `.ps1:229` renames it and never follows a nested link. Code-reviewed only. |
| S-002 | medium | path traversal | `migrate-ravintio-rename.sh:72-76`, `.ps1:97-103` (first review) | A symlink at a workflow path let the rewrite write to a file outside the repo. Reproduced. | Refuse links at both workflow paths. Rewrite through a temporary file and a rename. | mitigated. Link refusal at `.sh:57-67` and `.ps1:125-133`. Temporary file and rename at `.sh:122-126` and `.ps1:194-197`. |
| S-003 | medium | config | `migrate-ravintio-rename.sh:96-97`, `.ps1:124-125` (first review) | The helpers deleted `planifest-zero/` with no check of the working directory or its contents. | Stop the deletion of files the user may need. | mitigated in cycle 4. The pack moves to `.ravintio-backup/` at `.sh:147-169` and `.ps1:221-248`. Nothing is deleted. A run from the wrong folder moves that folder's `planifest-zero` into a backup, which the user can move back. |
| S-004 | low | path traversal | `migrate-ravintio-rename.sh:85-87`, `:106-110`, `setup.sh:1110-1121`, `setup.ps1:1119-1146` (first review) | A symlinked parent folder sent writes or removals into the link target. | Refuse or skip a symlinked parent folder. | mitigated. A parent link skips only its own step with a warning, at `.sh:52`, `:114-116`, `:135-137`, and `:175-177`, and `.ps1:120`, `:180-182`, `:207-209`, and `:254-256`. Setup skips at `setup.sh:1114-1116` and `setup.ps1:1127-1135`. Reproduced for `.github`. |
| S-005 | low | path traversal | `migrate-ravintio-rename.ps1:54-60`, `:124-125` (first review) | A local process could swap `planifest-zero` for a junction between the check and the delete. | Re-check before removal. | mitigated in cycle 4. A rename of a swapped link moves the link, not its target. A local process could still swap `.ravintio-backup` for a link after the check, which would move the pack into the link target. Only a concurrent local process can do that, and nothing is deleted. |
| S-006 | low | config | `migrate-ravintio-rename.ps1:97-101`, `.sh:56`, `:72-73` (first review) | A dangling workflow link moved the overrides, then aborted. | Make the conflict checks link-aware. | mitigated. `-L` in the conflict check at `.sh:87-89`. Link-aware `Test-Present` at `.ps1:62-66`. |
| S-007 | low | config | `setup.sh:1212-1213`, `setup.ps1:1380-1381` (first review) | A dangling old-folder link passed the setup stop. | Make the stop link-aware. | mitigated. `-L` at `setup.sh:1216`, `Get-Item -Force` at `setup.ps1:1392`. Reproduced in round 2. |
| S-008 | low | injection | `ravintio-zero/skills/ravintio-orchestrator/SKILL.md:74`, `ravintio-zero/skills/ravintio-migrator/SKILL.md:24` | `Applies when:` is free text that the agent judges. The orchestrator skips a false condition without telling the human. A migration body is already agent instruction, so the field grants no new privilege. | Report each skip. | accepted. The migrator reports `Skipped:`. The orchestrator skip still reports nothing. |
| S-009 | low | config | `migrate-ravintio-rename.sh:75`, `.ps1:102` (first review) | The rewrite left `PLANIFEST_REQUIRE_PWSH` in a workflow, so CI could skip PowerShell suites. | Rewrite the pack's variables. | mitigated. Seven named variables at `.sh:18` and `:124-125`, and `.ps1:190-191`. Reproduced. |
| S-010 | low | config | `migrate-ravintio-rename.sh:112`, `.ps1:200` (round 2) | The rewrite renamed every `PLANIFEST_` token, including consumer secrets. | Rewrite only the pack's variables. | mitigated in cycle 4. The rule matches whole names from the list only. Reproduced: `secrets.PLANIFEST_DEPLOY_TOKEN` and `secrets.PLANIFEST_REQUIRE_PWSH_X` stayed. |
| S-011 | low | data-exposure | `migrate-ravintio-rename.sh:85-93`, `.ps1:171-181` (round 2) | Ignored files, and any file outside git, were deleted without notice. | Keep files the user may need. | mitigated in cycle 4. Untracked and excluded files move into the backup. Reproduced. |
| S-012 | low | config | `migrate-ravintio-rename.sh:42-51`, `.ps1:125-137` (round 2) | The git top-level check blocked a project nested below its git root. | Accept a nested project. | mitigated in cycle 4. The check is gone. Reproduced with a nested project. |
| S-013 | low | config | `migrate-ravintio-rename.sh:32-34`, `.ps1:114-116` (round 2) | The helpers refused a symlinked `ravintio-zero`, `.claude`, or `.github` even when no step wrote there. | Skip only the affected step. | mitigated in cycle 4. See S-004. |
| S-014 | low | config | `migrate-ravintio-rename.sh:86-91`, `.ps1:172-180` (round 2) | The dirty check blocked a never-committed pack and stray OS files. | Drop the stop or narrow it. | mitigated in cycle 4. The dirty check is gone, because nothing is deleted. |
| S-015 | low | config | `migrate-ravintio-rename.ps1:64-70` (round 2) | `Remove-TreeNoFollow` threw on a non-link reparse folder and left a partial delete. | Give a clear failure. | mitigated in cycle 4. The tree walk is gone. |
| S-016 | low | config | `migrate-ravintio-rename.sh:149-152`, `migrate-ravintio-rename.ps1:223-229` | The pack checks run after the overrides, workflow, and markers have moved. `git rm -r --cached` refuses a pack file whose staged content differs from both `HEAD` and the working file. The helper then exits 1 with git's raw error, and the pack stays in place. A rerun fails the same way. In PowerShell, `Directory.Move` also throws if `.ravintio-backup` sits on another volume, after `git rm --cached` has run. Nothing is lost, but the helper breaks its promise to stop before it moves anything. The Bash case is reproduced. | Before step 3, check `git diff --cached --quiet -- planifest-zero` and stop with a clear message. Do the move before `git rm --cached`, or restore the index if the move fails. | not mitigated |
| S-017 | low | path traversal | `migrate-ravintio-rename.sh:155-163`, `migrate-ravintio-rename.ps1:230-241` | The exclude write follows a symlink at `info/exclude`. The helper appends `.ravintio-backup/` to the link target, which can sit outside the repo. Checkout never writes into `.git/`, so only a local actor can plant the link. The appended text is one fixed line. Reproduced. | Skip the exclude write with a warning when `info/exclude` or `info` is a link. | not mitigated |
| S-018 | low | config | `migrate-ravintio-rename.sh:153-154`, `:156-162`, `migrate-ravintio-rename.ps1:228-229` | The backup keeps a full copy of the old pack inside the project. Only the local `.git/info/exclude` hides it, so a tool that walks the tree can still find it. Examples are test globs, linters, and search indexes. Its old hooks and scripts stay executable. `core.hooksPath` still points at `planifest-zero/hooks` until setup runs, so git runs no pack hook between the helper and setup (R-008). | Name the backup in the setup next-step line. Tell the human to run setup before the next commit. Optionally drop the execute bit on backup files. | not mitigated |

Checked and clean:

- `roadmap-run.mjs:121-134` validates the resolved value, whichever name supplied it. Both values reach `claude` as separate argv entries through `spawn` at `:231` with no shell.
- `em-dash-guard.mjs:45` and `:109` add the legacy sentinel as a second bypass string. The guard enforces a style rule, not a security control.
- The backup conflict check at `.sh:95-102` and `.ps1:159-167` refuses a `.ravintio-backup` that is a file. It also refuses an existing or linked `.ravintio-backup/planifest-zero`. An earlier backup is never overwritten.
- `git rev-parse --git-path info/exclude` resolves to the shared exclude file in a linked worktree, and to the repo's own file for a nested project. The pattern `.ravintio-backup/` has no leading slash, so it matches at any depth.
- A cross-volume move in Bash falls back to copy and delete, which copies links as links.
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
| Deletion outside the repo | A nested junction or link in `planifest-zero/` (S-001, S-005) | both helpers | low | low | The helpers rename the pack and delete nothing. | A local race at `.ravintio-backup` can move the pack, not delete it. |
| Write outside the repo | A symlink at a workflow path or parent folder (S-002, S-004) | both helpers | low | medium | Link refusal, step skips, and a rename-based rewrite. | None found. |
| Write outside the repo through git metadata | A symlinked `.git/info/exclude` (S-017) | both helpers | low | low | Checkout never writes into `.git/`. | No link check on the exclude file. |
| Loss of user files | Custom, ignored, or untracked files in the old pack (S-003, S-011) | both helpers | low | low | Every file moves into the backup. | None found. |
| A half-finished upgrade | Staged pack edits, or a cross-volume backup on Windows (S-016) | both helpers | low | low | Git keeps the staged content. Nothing is deleted. | The check runs after the first moves. |
| Old pack code found in the tree | Tools that walk the project (S-018) | consumer tooling | medium | low | Local exclude keeps it out of commits. | No reminder to delete the backup at setup. |
| A migration hides from review | A crafted `Applies when:` condition (S-008) | orchestrator | low | low | Pack-update provenance check. Migrator reports `Skipped:`. | Orchestrator skips are not reported. |

## Risk register cross-reference

| Risk | Category | Status in this review |
|------|----------|------------------------|
| R-002 | operational | Mitigated. Setup stops while `planifest-zero/` or `planifest-overrides/` exists, including as a dangling link. The helper moves the old pack out of the root, so setup can run after it. |
| R-004 | technical | Mitigated. The helpers move the workflow and rewrite its paths and the seven pack variables without following links. A symlinked `.github` skips the step with a warning, and the human renames the file. |
| R-006 | compliance | Mitigated. The roadmap fallback works and validates legacy values the same way. |
| R-008 | technical | Open until setup runs. Git runs no pack hook between the helper and setup (S-018). Setup re-sets `core.hooksPath` to `ravintio-zero/hooks`. |
| R-009 | operational | Mitigated. Setup and the helpers remove the old markers. A marker under a symlinked folder stays, with a warning. |

The register holds no row for the backup folder or for a half-finished upgrade. S-016 and S-018 are new risks for the register.

## Recommendations

Ordered by priority:

1. Confirm that the PowerShell helper test passes in CI before merge. The PowerShell helper is code-reviewed only.
2. Check for staged pack edits before the first move, and give a clear message (S-016).
3. Name the backup and the setup step in the helper's final output, so the human runs setup before the next commit (S-018).
4. Skip the exclude write when `info/exclude` is a link (S-017).
5. Report orchestrator migration skips (S-008).
