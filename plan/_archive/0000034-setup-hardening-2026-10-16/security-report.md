# Security Report - 0000034-setup-hardening

> A fresh-context reviewer checked the feature diff and reproduced findings in a sandbox copy. The P5 fix commit `b6e13ef` closed findings S-001 to S-007. This report states the result after that fix.

## Threat Model (STRIDE)

| Threat | Category | Severity | Mitigation |
|---|---|---|---|
| S-001: a symlink planted at `.claude/settings.json.planifest-tmp` makes the temporary write overwrite another file (`setup.sh:28-55`, `setup.ps1:217-243`) | Tampering | Medium | Mitigated. Setup removes any leftover first, then creates the file with `wx` (bash) or after `Remove-Item` (PowerShell). Test req-003 (d) plants a link |
| S-002: the rename resets the file mode, so a `0600` `settings.json` becomes `0644` (`setup.sh:47-49`) | Info Disclosure | Medium | Mitigated. The temporary file takes the original's mode. PowerShell uses `File.Replace`, which keeps the original's ACL. Test req-003 (d) checks `600` |
| S-003: on Windows, `Move-Item -Force` deletes the target before the move, so a failed move loses both copies (`setup.ps1:229`) | Tampering / DoS | Medium | Mitigated by reading only, no `pwsh` to run it. An existing file is swapped with `[System.IO.File]::Replace`, and the `catch` removes the temporary file only while the original exists |
| S-004: a read-only `settings.json` is replaced without error (`setup.sh:36-41`, `setup.ps1:222`) | Tampering | Low | Mitigated. Both scripts refuse, as 0.4.0 did. Test req-003 (d) |
| S-005: a symlinked `settings.json` becomes a regular file (`setup.sh:32`) | Tampering | Low | Mitigated in bash: setup writes next to the resolved path. Test req-003 (d). PowerShell doesn't resolve links |
| S-006: `--backend-url` swallows the tool name, so `setup.sh --backend-url claude-code` installs nothing and exits 0 (`setup.sh:1031`, `setup.ps1:37`) | DoS | Low | Mitigated. Setup never skips a valid tool name. Test req-001 (b) |
| S-007: `--backend-url=<value>` and any unknown `--flag=<value>` print the value (`setup.sh:1033-1036`, `setup.ps1:28-32,43`) | Info Disclosure | Low | Mitigated. The `=` form warns with the flag name only, and the unknown-flag error cuts at `=`. Test req-001 (b) |
| S-008: PowerShell matched retired flags without regard to case, unlike `setup.sh` (`setup.ps1:34`) | Tampering | Low | Mitigated for retired flags with `-ccontains`. The `--strict-orchestrator` switch still ignores case, which predates this feature |
| S-009: a leftover `settings.json.planifest-tmp` after a hard stop could be committed in a project that doesn't ignore `.claude/` | Info Disclosure | Low | Not mitigated. The next run replaces it. Recorded as a recommendation |
| S-010: `--backend-url -x` skips `-x` instead of rejecting it | Tampering | Low | Accepted. No single-dash flag exists |
| S-011: tool-name check matches partial words or patterns (`setup.sh:1066-1069`) | Elevation | Low | Mitigated. Exact quoted comparison over `VALID_TOOLS` |
| S-012: the missing-node warning leaks information (`setup.sh:338-341`) | Info Disclosure | Low | Mitigated. It prints the relative settings path only |

## Dependency Audit

No dependency added. `fs.rmSync` needs Node 14.14 or later, inside the declared Node 18+. `[NullString]::Value` and `File.Replace` exist in Windows PowerShell 5.1 and PowerShell 7.

## Secrets Management

No secret handled. The `--backend-url` value can hold a token. After the fix, setup never prints, stores, or passes it on in either form. `settings.json` can hold `env` tokens, which is why S-002 mattered.

## Authentication & Authorisation Review

Not applicable. Setup is a local CLI with no API.

## Input Validation Review

Command-line arguments only. Retired flags match exactly and case-sensitively. The `--backend-url` value is discarded unvalidated, because nothing uses it. The tool name matches exactly.

## Network Policy

Not applicable. Setup makes no network call.

## Infrastructure as Code Review

Not applicable. No IaC in this feature.

## Out-of-scope observations

- `setup.ps1:331` uses `ConvertFrom-Json -AsHashtable`, which Windows PowerShell 5.1 lacks, so 5.1 support is doubtful. This predates the feature and belongs with the PowerShell parity work (backlog 0000090 and 0000094).
- The `planifest-framework/` copy of `planifest-refresh-setup` still replays `backendUrl`. `planifest-framework/` is out of scope, and backlog 0000097 removes it.

## Risk register cross-check

| ID | Status |
|----|--------|
| R-001 | Open. S-003 shows the kind of defect static checks miss |
| R-002 | Mitigated. The req-003 suite matches the `v0.4.0` output byte for byte |
| R-003 | Mitigated for both value forms (S-007) |
| R-004 | Mitigated, with S-006 closing the related tool-name gap |
| R-005 | Superseded by S-003. `File.Replace` replaces `Move-Item -Force` |
| R-006 | Mitigated. The `=` form is now a retired flag too |

## Summary

Overall risk rating: Low after the fix. It was Medium before it.

Top actions before production:
1. Add a `pwsh` runner so `Write-SettingsAtomic` and the argument loop run under test (R-001, backlog 0000084).
2. Have setup add `settings.json.planifest-tmp` to the ignore list it writes (S-009).
3. Settle whether Windows PowerShell 5.1 is supported, given `-AsHashtable`.
