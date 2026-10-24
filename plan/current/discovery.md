---
title: "Discovery - 0000160-ravintio-rebrand"
summary: "Raw discovery-pass findings: what the orchestrator knew before coaching began."
---
# Discovery - 0000160-ravintio-rebrand

> Raw findings only. Decisions belong in `design.md`, the Q&A audit trail in `build-log.md`.

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | `plan/_archive/` holds 15 prior runs and `src/` holds source |
| Git pre-flight | Branch `feat/0000160-ravintio-rebrand` cut from `main` at the merge of PR #24. `main` is up to date with `origin/main`. |
| Skills inbox | `planifest-zero/skills-inbox/` is empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`, `product.yml`): `0.11.0`. Last tag `v0.11.0`.
- `releaseSize` is absent from `product.yml`, so the budget is `medium` (8 points).
- Prior features (`plan/_archive/`): 0000030 to 0000043 and 0000151. The most recent are 0000043 (autonomous roadmaps) and 0000151 (hardening, token efficiency, and faster CI).
- Constraining ADRs:
  - 0000031 ADR-002: the last folder rename, from `planifest-framework/` to `planifest-zero/`, and the `product.yml` id.
  - 0000042 ADR-004: the pack wording and identifier map, enforced by the allowlist test `test-0000042-req-010-pack-wording-allowlist.sh`.
  - 0000151 ADR-007: setup prunes retired hooks by list.
  - 0000037 ADR-001: the repo self-hosts. `core.hooksPath` points at `planifest-zero/hooks`.
- Component map: one component, `planifest-zero` (`planifest-zero/component.yml`). No component owns data.
- Repo instructions (`planifest-overrides/instructions/`): `custom-001` to `custom-005`. They cover local git, subagent decomposition, the GUTD shorthand, ship push and PR, and redundant branch deletion.
- Backlog: 0000095, 0000100, 0000110, and 0000159. None concerns the brand.

## Rename survey

### Scale

- 295 tracked files outside `plan/_archive/` and `plan/changelog/` contain "planifest", on 1,743 lines.
- `planifest-zero/` holds 327 files. 158 test files carry "planifest" in their file name.

### Identifiers

- Top-level paths:
  - `planifest-zero/`
  - `planifest-overrides/`
  - `refresh-planifest-zero-dir.ps1`
  - `.github/workflows/planifest.yml` and its template `planifest-zero/hooks/planifest.yml`
- 12 skills, each named `planifest-*` in its folder and `name:` field.
- Marker files: `.planifest-setup-flags`, `.planifest-manifest`, `.planifest-session`, and the `.planifest-tmp` suffix.
- 26 `PLANIFEST_*` environment variables:
  - Two face consumers: `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS`.
  - Four belong to the test runners: `PLANIFEST_TEST_QUIET`, `PLANIFEST_REQUIRE_PWSH`, `PLANIFEST_PWSH`, and `PLANIFEST_PREFLIGHT_ONLY`.
  - The rest pass values to `node -e` inside setup and scripts.
- OTEL labels `planifest.roadmap` and `planifest.step` (`scripts/roadmap-labels.mjs:24-25`).
- `product.yml` and `component.yml` ids are `planifest-zero`.

### Runtime matches

- `auto-trigger-orchestrator.mjs:33-34` detects a project by the `planifest-zero` folder.
- `em-dash-guard.mjs` holds the `planifest-em-dash-allow` sentinel and `planifest-zero/` path prefixes.
- `gate-write.mjs:25` allowlists `.planifest-session`.
- `setup.sh` and `setup.ps1`:
  - overrides paths and the `planifest-overrides:instructions` markers
  - marker file names and the temp suffix
  - `core.hooksPath planifest-zero/hooks`
  - the workflow copy and the token-reduction marker
- `self-description-check.mjs:101-113` matches `planifest-zero/` links, and CI runs it.
- `.github/workflows/planifest.yml` names `planifest-zero/` paths.

### Consumer upgrade

- Consumers copy the pack folder in and run setup. No install command downloads it.
- `prune_retired_skills` and `Remove-RetiredSkills` delete any installed skill folder the pack no longer ships. Old `planifest-*` skills go on the next setup run.
- Setup re-sets `core.hooksPath` on every run.
- Setup does not handle these:
  - the old `planifest-zero/` folder
  - the `planifest-overrides/` user content
  - the installed `.github/workflows/planifest.yml`, which setup never overwrites
  - the old marker files
- The migration mechanism is `planifest-zero/migrations/*.md` plus helper scripts, run by `planifest-migrator`. Example: `_done/0003-archive-dirname.md` with `migrate-archive-dirname.sh`.

### External references

- `README.md:5` links `github.com/planifest/planifest-framework`.
- `README.md:172-181` links `github.com/planifest/planifest-docs` and `planifest.github.io/planifest-docs/`.
- `plan/changelog/` holds PR URLs under `github.com/planifest/planifest-zero`.
- The `planifest` org holds 10 repos. GitHub reports no org or user named `ravintio`.

### Other

- `setup.ps1` near line 1010 holds a mojibake sequence. A mechanical replace must not touch it.
- The strategy document attached to the request names the products RAVINTIO Zero, Framework, Accept, and Assess.
