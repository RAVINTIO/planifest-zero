# Changelog (0000189-name-the-roadmap-initiative, 26 Oct 2026)

**Feature:** name-the-roadmap-initiative
**Version:** 0.19.0
**PR:** [#37](https://github.com/RAVINTIO/ravintio-zero/pull/37)

## What changed

The pack now uses "roadmap" for the long-term plan and "roadmap initiative" for the charted set of steps that ships in one PR. Every name for the charted unit uses its `initiative` form.

- req-001: `project-operations.md` has a `## Roadmap and initiative glossary` section. It defines both terms and the five initiative states. `roadmap-standards.md` links to it.
- req-002: the branch pattern is `initiative/{id}-{slug}`. The active file is `plan/current-initiative/initiative.md`, and drafts are `plan/roadmap/{id}-{slug}/initiative.md`. The scripts are `initiative-run.mjs` and `initiative-labels.mjs`, and the template is `initiative.template.md`. Step logs go to `plan/.initiative-logs/`. Telemetry uses `work.kind=initiative` and `ravintio.initiative`. `merge-guard` and the CI workflow use `initiative/*` and `initiative/**`.
- req-003: stage prefixes are `I-A Chart:`, `I-B Activate:`, `I-C Run:`, `I-D Advance:`, and `I-E Delivery:`.
- req-004: the initiative template status takes `proposed | charted | active | delivered | blocked`. `roadmap-standards.md` names the stage that sets each state.
- req-005: migration 0005 renames a consumer's drafts, CI pattern, and step log folder. It stops while `plan/current-roadmap/` exists, and a rerun changes nothing.
- req-006: the driver reads only `RAVINTIO_INITIATIVE_MODEL` and `RAVINTIO_INITIATIVE_MAX_TURNS`. An old `RAVINTIO_ROADMAP_*` or `PLANIFEST_ROADMAP_*` variable stops it with the new name.
- req-007: `test-0000189-req-007-old-name-guard.sh` fails on any old name outside its allowlist.
- req-008: open backlog entries 0000174 to 0000186 use the new terms.
- req-009: setup refreshed `.claude/skills/` from `ravintio-zero/skills/`.

## Why

Backlog entry 0000188: "roadmap" meant two things, so names and prose did not say which one they meant. The next initiative, charted on 25 Oct 2026, activates under the new names.

## Deviations

- During the run, the guard also allowlisted `plan/current/`, because this run's plan files name every old name. That entry came out after ship archived them, so the allowlist holds the two history folders only. ADR-005 records it.
- The driver also drops the `PLANIFEST_ROADMAP_*` fallback (ADR-002).
- The driver status check still accepts `draft` and `done`, so older initiative files still parse.
- Two names stay, because the design Names table does not list them: the lock file `plan/.roadmap-runner.lock` and the delivery archive folder `plan/_archive/{id}-{slug}-roadmap-{date}/`.
- `test-0000151-req-011` raises its size cap from 35,484 to 35,600 bytes. Its fixture now uses the new names.

## Validation results

- 165 feature and 19 regression Bash suites pass on macOS. 16 PowerShell suites pass under pwsh 7.
- All 21 acceptance criteria pass by execution. The driver, `merge-guard`, and both migration helpers ran in stub repos.
- The old-name guard finds 0 old names outside its allowlist.
- Security review: overall low, four low findings and one informational note.

## Skipped phases

None
