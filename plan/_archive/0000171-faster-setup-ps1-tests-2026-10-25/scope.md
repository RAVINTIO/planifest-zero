---
title: "Scope - faster-setup-ps1-tests"
summary: "Boundaries for the faster setup.ps1 skill and hook copy, the tree parity test, and the CI timing total."
status: "draft"
version: "0.1.0"
---
# Scope - faster-setup-ps1-tests

**Skill:** plan
**Feature:** 0000171-faster-setup-ps1-tests
**Version:** 0.16.0

## In Scope

- `Copy-RavintioSkills` copies files and folders with `System.IO` calls in place of `Copy-Item`, `Test-Path`, and `New-Item`. It keeps `Get-Content` and `Set-Content` for the SKILL.md rewrite.
- `Install-EnforcementHooks` copies hook modules the same way.
- The installed tree keeps the same paths, bytes, and dot files. The SKILL.md BOM follows each host. Console output of `setup.ps1` stays the same.
- A test checks the installed skill tree against the bundle rules, file by file and byte for byte, under both hosts.
- `Invoke-Setup` appends each `setup.ps1` time in milliseconds to the file named by `RAVINTIO_TIMING_FILE`.
- `run-tests.ps1` sets that variable and prints a `[timing] setup.ps1 total` line with the milliseconds and the case count.
- Total `setup.ps1` time across both Windows CI jobs falls under 105 s, from 210 s.
- Requirement change 2026-10-25 (REQ-004 to REQ-006, ADR-004): `setup.sh` and `setup.ps1` stop bundling templates, standards, and schemas into each skill. Setup installs only each skill's own files.
- The `bundle_templates` and `bundle_standards` frontmatter fields leave every SKILL.md.
- Every skill names a pack template, standard, or schema by its full `ravintio-zero/...` path.
- A test fails when a skill names one by a short path or a bare name, or when the full path does not exist.
- Version 0.16.0. This roadmap 0000168 step 3 closes backlog 0000159.

## Out of Scope

- `setup.sh` changes other than the bundling removal in REQ-004.
- Sharing one setup run across test cases. Few cases share a starting state.
- The workspace copy in the test helper.
- Other backlog entries.

## Deferred

Nothing deferred.
