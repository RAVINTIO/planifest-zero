---
title: "Retrospective: 2026-10-27 - verify codex setup"
summary: "A blameless review of the step 14 chore run."
status: "open"
---
# Retrospective: 2026-10-27 - verify codex setup

**Mode:** run
**Subject:** 0000217-verify-codex-setup
**Date:** 2026-10-27

## Summary

Codex loaded all 16 skills. It also ran a merge command, because it skips untrusted project hooks. The step fixed the wording and shipped as 0.30.0. The block after trust is unverified.

## What helped

- The real run exposed a false claim that earlier text made: setup and `AGENTS.md` called `merge-guard` active (`plan/current/verification-report.md` in the archive).
- A control command proved the stub `gh` ran before the merge check counted its empty log.

## What slowed the work

- The chart's step 3 put a stub `gh` first on `PATH`. Codex's login shell reset it, so the first control run used the real `gh` (`build-log.md`, harness defect line).
- `setup.sh` installed into this repo on the first attempt, because it takes its project root from its own location. The run removed the stray files by hand.
- No non-interactive trust path exists, so check 2 could not run after trust (`acceptance-evidence.md`, item 4).

## Keep

- A control command beside each negative check.

## Change

- Record the post-trust check as a human step and add the two harness facts to the docs.

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Verify `merge-guard` after trust and document the harness facts | pack maintainers | `ravintio-zero/getting-started.md` | a recorded Codex run with exit 2 and an empty stub log | `plan/backlog/0000220-verify-codex-merge-guard-after-trust/` |
