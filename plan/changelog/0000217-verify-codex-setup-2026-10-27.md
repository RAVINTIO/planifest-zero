# Changelog (0000217-verify-codex-setup, 27 Oct 2026)

**Feature:** Verify the codex setup target against real Codex
**Version:** 0.30.0
**PR:** pending

## What changed

- Ran `setup.sh codex` in a fresh temp repo and two `codex exec` checks with `codex-cli 0.163.0`.
- Setup output now says Codex skips `merge-guard` until you trust it, including in `codex exec`. `setup.sh` and `setup.ps1` both print the line.
- `AGENTS.md` (from `codex-boot.md`), `getting-started.md`, and `README.md` carry the same statement.
- Two assertions in the Bash and PowerShell codex setup suites cover the new wording.

## Why

Step 12 added the `codex` target without running Codex. Codex names all 16 skills, but it skips an untrusted project hook, so the merge command ran. The old text called `merge-guard` active.

## Deviations

- Check 2 failed as specified, so the bump rose from patch to minor, per the chart bump rule.
- The fix changes wording only. It does not make Codex run the hook. A person must trust it with `/hooks`, and the block after trust is unverified.
- The harness needed a `ZDOTDIR` `.zprofile` so the stub `gh` came first, because Codex runs commands in a login shell.

## Validation results

Bash runner: 198 feature suites and 19 regression checks passed with `RAVINTIO_INITIATIVE_STEP` unset. PowerShell runner: 19 suites passed. See `acceptance-evidence.md` in the archive.

## Skipped phases

P1 Plan: skipped. The chart fixes the spec for this chore.
