---
title: "Scope - setup argument checks"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - setup argument checks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000196-setup-argument-checks
**Version:** 0.20.0

## In Scope

- Move the tool check in `setup.sh` and `setup.ps1` to straight after argument parsing, ahead of the old-folder check and the repo initialisation.
- Make each retired flag exit 1 during argument parsing, with an error that names the flag and tells the user to remove it.
- Keep a `--backend-url` value out of every output.
- Change the six existing tests that assert the retired-flag warning.
- Add per-shell tests for an unknown tool, a missing tool, and each retired flag.
- Change Step 3 of `ravintio-refresh-setup` so it names a retired flag in a record or marker.
- Update the `component.yml` responsibility line and the docs that describe the warning.

## Out of Scope

- New valid tools (backlog entry 0000175).
- A change to the usage text or the exit code of the tool check.
- A change to how unknown flags fail.

## Deferred

Nothing deferred.
