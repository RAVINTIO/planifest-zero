# Verification report - 0000200-reply-conventions

**Method:** each hook check ran `node ravintio-zero/hooks/enforcement/check-reply-prefix.mjs` in a temporary folder with a sentinel and a JSONL transcript. Setup checks ran `setup.sh` in a scratch project. The folders were removed afterwards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 boot file carries the table | Read the Reply Conventions section | verified | It lists all ten prefixes, `Supervise:`, and the status form. |
| REQ-001 AC-2 reporting rule stated twice | Searched the boot template and the orchestrator skill | verified | Both name results, deviations, failures, and decisions, and both bar reporting compliance. |
| REQ-001 AC-3 orchestrator lists the new prefix | Read the prefix lists | verified | `Supervise:` appears with the status form. |
| REQ-002 AC-1 phase skills state their prefix | Read the first 15 lines of four skills | verified | Each holds its own prefix and the status form. |
| REQ-003 AC-1 a miss warns and logs | Transcript whose last reply starts with plain text | verified | Exit 0, a `systemMessage` that lists the valid prefixes, and one log line with a timestamp and the reply start. |
| REQ-003 AC-2 a valid prefix passes silently | Transcript whose last reply starts with `P4 Ship:` | verified | Exit 0, no output, no new log line. |
| REQ-003 AC-3 the hook never blocks | No sentinel, malformed JSON, missing transcript, no assistant text | verified | Each exited 0 with no output. |
| REQ-003 log stays out of git | Two misses in a project with `.git/info` | verified | `.git/info/exclude` holds the log path once. |
| REQ-004 AC-1 setup installs the hook | `setup.sh claude-code` in a scratch project | verified | The hook file exists and `settings.json` holds one `Stop` entry for it. |
| REQ-004 AC-2 setup is idempotent | Two runs over a settings file with a user `Stop` entry | verified | One hook entry and the user entry stay. |
| REQ-004 AC-3 both scripts agree | Read `setup.ps1` source and the docs | verified | `setup.ps1` declares the same `Stop` entry. The docs and `component.yml` name the hook. `setup.ps1` itself did not run, as no PowerShell runner exists for the setup suites. |

**Full suite:** 176 feature suites and 19 regression suites pass. The consistency check is clean over `plan/current`, and the self-description check passes.
