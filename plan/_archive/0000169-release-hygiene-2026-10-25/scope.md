---
title: "Scope - release-hygiene"
summary: "Boundaries for the PR attribution ban, the attribution check, the setup setting, and the release-tag job."
status: "draft"
version: "0.1.0"
---
# Scope - release-hygiene

**Skill:** plan
**Feature:** 0000169-release-hygiene
**Version:** 0.14.0

## In Scope

- The boot template, `commit-standards.md`, and the ship skill ban attribution lines in PR descriptions. The ban names `Generated with [Claude Code]`, `Co-Authored-By:`, and `Claude-Session:` lines.
- `ravintio-zero/scripts/check-attribution.mjs` reads a file or stdin. It exits 1 on an attribution line and 0 otherwise. The `commit-msg` hook gains the same host-line patterns.
- Ship Step 9 runs the check on the PR body before `gh pr create`. The `validate-branch` job runs it on the PR description in both workflow files.
- `setup.sh` and `setup.ps1` set `attribution` to `{"commit": "", "pr": ""}` in `.claude/settings.json` when the key is absent.
- `ravintio-zero/scripts/release-tag.mjs` tags `HEAD` with `v{version}` from `product.yml`, falling back to `docs/about.md`. It skips when the tag exists. It pushes a new tag otherwise.
- A `release-tag` job runs on a push to `main` in both workflow files. The PR jobs run only on `pull_request`.
- Ship Step 7 no longer creates a tag. Steps 9 and 10, `roadmap-standards.md`, `pipeline-reference.md`, and `custom-004` describe the new flow.
- Version 0.14.0.

## Out of Scope

- Moving existing tags.
- Updating a consumer's existing workflow file.
- Other backlog entries.

## Deferred

Nothing deferred.
