# Migration 0004 - RAVINTIO rename

**Target standard:** `ravintio-zero/`, `ravintio-overrides/`, `.github/workflows/ravintio.yml`, and `.ravintio-*` markers
**Scope:** consumer repo root
**Safe to skip:** No. Setup stops while `planifest-zero/` or `planifest-overrides/` remains. Re-running is safe.

---

## What this migration does

The pack changed its name from Planifest to RAVINTIO. A consumer repo that installed the old pack holds four things that setup does not move:

- the old `planifest-zero/` folder
- your content in `planifest-overrides/`
- the installed `.github/workflows/planifest.yml`
- the old marker files `.claude/.planifest-setup-flags` and `.claude/skills/.planifest-manifest`

The helper moves or removes each one. The helper stops before it moves anything if it finds a conflict.

---

## Migrator instructions

1. Check that `ravintio-zero/` exists in the repo root. If it doesn't, ask the human to copy the new `ravintio-zero/` folder into the repo, then continue.

2. Check `planifest-zero/` for files you added yourself. The helper deletes the whole folder. Show the human any custom file and ask them to move it first.

3. Show: `Will run the helper from the repo root. It moves planifest-overrides/ and planifest.yml, then removes the old markers and planifest-zero/.`
   Ask: `Proceed? (y/n)`

4. If yes, run the helper that matches the shell:
   - Bash: `bash ravintio-zero/migrations/migrate-ravintio-rename.sh`
   - PowerShell: `ravintio-zero/migrations/migrate-ravintio-rename.ps1`

5. If the helper exits non-zero, show its output and stop. It moved nothing. Do not retry until the human fixes the cause:
   - `ravintio-zero/` is missing.
   - Both `planifest-overrides/` and `ravintio-overrides/` exist. The human picks the authoritative folder.
   - `.github/workflows/ravintio.yml` already exists. The human merges or deletes one workflow.
   - A source or target folder is a symlink. The human replaces the link with a real folder.

6. If the helper exits 0, run setup for the installed tool:
   - Bash: `ravintio-zero/setup.sh claude-code`
   - PowerShell: `ravintio-zero/setup.ps1 claude-code`

   Setup prunes the old `planifest-*` skill folders because the pack no longer ships them.

7. Ask the human to check that `ravintio-overrides/` holds their content and that `git status` shows the moves. Ask: `Confirmed? (y/n)`

Move this file to `ravintio-zero/migrations/_done/0004-ravintio-rename.md` when the migration is complete or explicitly skipped by the human.
