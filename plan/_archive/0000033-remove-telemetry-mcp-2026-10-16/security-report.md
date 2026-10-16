---
title: "Security Report - 0000033-remove-telemetry-mcp"
summary: "Security review of the telemetry removal and the legacy-cleanup function that rewrites a project's settings.json."
status: "draft"
version: "0.4.0"
---
# Security Report - 0000033-remove-telemetry-mcp

**Skill:** [security-agent](../../.claude/skills/planifest-security-agent/SKILL.md)
**Feature:** 0000033-remove-telemetry-mcp
**Reviewed:** 2026-10-16, by a fresh-context reviewer over `git diff main...HEAD`

## Threat Model (STRIDE)

| Threat | Category | Severity | Mitigation |
|---|---|---|---|
| The cleanup filter deletes a user's own hook if its command contains a telemetry module name as a bare substring, for example `./my-tools/emit-event-logger.sh` | Tampering | Medium | Fixed in P5. Both scripts now match only `<module>.mjs` at a path boundary. A test proves a user's look-alike hook survives. |
| PowerShell matching is case-insensitive (`-like`), and bash matching is case-sensitive | Tampering | Low | Fixed in P5. PowerShell now uses `-cmatch`. |
| On Windows PowerShell 5.1, `Remove-Item -Recurse` on a symlinked `plan/.telemetry-*` directory recurses into the link target | Tampering | Medium | Fixed in P5. PowerShell now deletes only the link when the marker is a reparse point. Bash `rm -rf` on a link with no trailing slash already removes only the link. |
| A user entry whose `matcher` contains `mcp__structured-telemetry-mcp__emit_event` is dropped with all its hooks | Tampering | Low | Accepted. The string is specific to the retired MCP server. |
| Crafted `settings.json` content injects a command | Elevation of privilege | None found | Bash passes values by environment variable into a single-quoted `node -e` literal. PowerShell uses `ConvertFrom-Json` with no `Invoke-Expression`. Match patterns come from constants, never from file content. |
| Writing or deleting outside the project through `PROJECT_ROOT` | Tampering | None found | `PROJECT_ROOT` comes from the script location, and every target path is a fixed constant. |
| A symlinked `plan/` directory sends deletion outside the project | Tampering | Low | Accepted. The user chose that layout, and only the two named directories are deleted. |
| A parse error truncates or corrupts `settings.json` | Denial of service | Low | Both scripts parse before writing and write only when something was removed. Invalid JSON leaves the file byte-identical. The write is not atomic, which matches the existing installers. Backlog 0000091. |
| Settings nested deeper than 10 levels flatten on the PowerShell write | Tampering | Low | Accepted. The existing installers share the `-Depth 10` limit, and real settings files are shallow. |
| Telemetry hooks post session data to a backend | Information disclosure | Resolved | The feature deletes them. No outbound calls survive. |
| The cleanup drops one of the six enforcement hooks | Tampering | None found | No enforcement command contains a telemetry module name, and cleanup runs before the enforcement installer. |

## Dependency Audit

The diff adds no dependencies. All seven surviving modules in `planifest-zero/hooks/enforcement/` pass `node --check`. They import only `node:path`, `node:fs`, `node:child_process`, and `./read-stdin.mjs`. None imports a deleted module.

## Secrets Management

The diff adds no keys, tokens, passwords, or auth headers. The cleanup removes old hook commands that carried `PLANIFEST_TELEMETRY_URL=<backend>` inline. Bash suppresses stderr from the settings rewrite and never logs file contents.

## Authentication & Authorisation Review

Not applicable. The feature has no API.

## Input Validation Review

The only untrusted input is the project's `.claude/settings.json`. Both scripts parse it with `JSON.parse` or `ConvertFrom-Json` inside a try block. A parse failure prints a warning, setup continues, and the file stays as it was. The filter touches only `hooks.*[].hooks[].command` and `hooks.*[].matcher`. Keys such as `permissions`, `env`, and `__proto__` survive unchanged.

## Network Policy

No egress remains. Outside `tests/`, `planifest-zero/` has no `curl`, `wget`, `fetch(`, `http(s).request`, `Invoke-WebRequest`, or `Invoke-RestMethod`. The only URLs are two doc-comment links in `setup/claude-code.sh` and `setup/claude-code.ps1`.

## Infrastructure as Code Review

Not applicable. The feature has no IaC.

## Risk Register Cross-Reference

| Item | Status | Reason |
|---|---|---|
| R-001 | Mitigated | The enforcement installer writes exactly the six surviving commands. None of them matches the cleanup filter, and the req-004 suite passes. |
| A-003 | Holds | Every entry an old setup wrote ends in a telemetry `<module>.mjs` or carries the MCP matcher, so the tightened filter still finds all of them. |

## Bash and PowerShell Parity

After the P5 fixes, the two scripts use the same module list, the same path-boundary match, the same case sensitivity, and the same messages. Two differences remain:

- If `node` is missing, bash skips the settings cleanup without a warning. PowerShell needs no `node`. Backlog 0000091.
- PowerShell wraps a non-array event value in an array when it rewrites the file. Bash leaves it alone.

## Out-of-scope finding

`setup.sh` now rejects `--structured-telemetry-mcp` as an unknown flag. If an old flags marker still lists that flag, `planifest-refresh-setup` replays it and setup exits 1. Framework 0000030 ADR-003 accepts retired flags as no-ops instead. Backlog 0000092.

## Summary

Overall risk rating: Low, after the P5 fixes. Before the fixes, the rating was Medium.

Top actions before production:

1. Done in P5: limit the cleanup match to `<module>.mjs` at a path boundary in both scripts, and test that a look-alike user hook survives.
2. Done in P5: make PowerShell marker deletion safe on symlinks, and make its match case-sensitive.
3. Backlog 0000092: let `planifest-refresh-setup` drop retired flags, so an upgraded project can still refresh.
