---
title: "Scope - ravintio-rebrand"
summary: "Boundaries for the rebrand of Planifest Zero to RAVINTIO Zero."
status: "active"
version: "1.0.0"
---
# Scope - ravintio-rebrand

**Skill:** plan
**Feature:** 0000160-ravintio-rebrand
**Version:** 1.0.0

## In Scope

- Apply the design's rename map across code, tests, CI, docs, skills, templates, and standards. This covers the pack folder, overrides folder, skills, workflow file, refresh script, marker files, sentinel, environment variables, OTEL labels, component ids, test file names, and GitHub links.
- Write the brand in prose as "RAVINTIO Zero". Sibling products become "RAVINTIO Framework".
- Add setup cleanup that removes the old marker files.
- Add migration `0004-ravintio-rename.md` with `migrate-ravintio-rename.sh` and `migrate-ravintio-rename.ps1`. The scripts refuse symlinked targets.
- Add a guard test that fails when "planifest" appears outside history and the allowlist. It supersedes the 0000042 ADR-004 allowlist approach for the brand word.
- Keep `PLANIFEST_ROADMAP_MODEL`, `PLANIFEST_ROADMAP_MAX_TURNS`, and the `planifest-em-dash-allow` sentinel working as fallbacks in 1.x.
- Release version 1.0.0.

## Out of Scope

- History records: `plan/_archive/`, `plan/changelog/`, and `migrations/_done/`. They stay as written.
- The sibling repos and their names. Their own renames are separate work.
- The local clone folder `~/d/planifest/zero`.
- Backlog items 0000095, 0000100, 0000110, and 0000159.

## Deferred

- The org rename. The human renames the GitHub org in Settings after the PR merges. Blocked: links to `github.com/ravintio/...` and `ravintio.github.io/...` fail until the org rename lands.
- The repo rename. The agent runs `gh repo rename ravintio-zero` and updates `origin` after the human merges the PR and renames the org. Blocked: the repo keeps its old name, and clones keep the old `origin`, until then.
