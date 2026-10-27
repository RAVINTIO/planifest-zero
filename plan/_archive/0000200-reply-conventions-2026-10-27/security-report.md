# Security report - 0000200-reply-conventions

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|-----------|
| The hook reads a file at the payload's `transcript_path` | `ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` | Low | Accepted. Claude Code supplies the path. The hook only reads it, prints no file content, and exits 0 on any error. |
| The log holds the start of a reply | `plan/.prefix-misses.log` | Low | Mitigated. The hook logs 80 characters of the first reply text and excludes the file through `.git/info/exclude`. A secret in the first 80 characters of a reply would stay in the local file. |
| The hook appends to `.git/info/exclude` | `check-reply-prefix.mjs` | Informational | Mitigated. It adds one fixed line, once, and only when `.git/info` exists. |
| Setup edits `settings.json` | `ravintio-zero/setup.sh`, `ravintio-zero/setup.ps1` | Informational | Mitigated. It uses the existing atomic write and the existing path-boundary filter. A user `Stop` entry stays. |
| Injection, credentials, dependencies | none found | none | The hook uses Node built-ins, runs no shell, and reads no secret. No dependency joins the pack. |

## Risk register cross-check

- R-001 (false warning): accepted. The hook only warns.
- R-002 (setup drift): mitigated. The req-004 suite reads both scripts.
- R-003 (log growth): accepted. A miss is rare and each line is short.
- R-004 (secret in the log): mitigated as far as the 80-character cut allows.

**Overall risk rating:** low. No critical or high finding.
