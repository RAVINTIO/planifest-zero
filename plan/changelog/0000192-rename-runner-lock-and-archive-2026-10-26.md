# Changelog (0000192-rename-runner-lock-and-archive, 26 Oct 2026)

**Feature:** rename-runner-lock-and-archive
**Version:** 0.19.0
**PR:** [#37](https://github.com/RAVINTIO/ravintio-zero/pull/37)

## What changed

The last two names for the charted unit now use the `initiative` form.

- req-001: the driver locks `plan/.initiative-runner.lock` and adds it to `.git/info/exclude`. The old lock was `plan/.roadmap-runner.lock`.
- req-002: I-E Delivery archives to `plan/_archive/{id}-{slug}-initiative-{date}/`. The driver's delivery check also accepts the older `{id}-{slug}-roadmap-{date}` folder form.
- req-003: the old-name guard flags both old names.

## Why

Backlog entry 0000191: feature 0000189 renamed every name in its design Names table, and these two were not on it.

## Deviations

- The version stays 0.19.0. This run joins the unreleased 0.19.0 on PR #37, at the human's request.
- Plan files avoid the literal old names, because the guard no longer allowlists `plan/current/`.

## Validation results

- 165 feature and 19 regression Bash suites pass on macOS. 16 PowerShell suites pass under pwsh 7.
- All 8 acceptance criteria pass by execution. The driver ran in stub repos for both archive folder forms and for a held lock.
- The old-name guard finds 0 old names outside its allowlist.
- Security review: overall low, two low findings.

## Skipped phases

None
