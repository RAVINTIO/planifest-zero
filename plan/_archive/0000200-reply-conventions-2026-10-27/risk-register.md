# Risk Register - reply conventions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Version:** 0.22.0
**Overall Risk Level:** low

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The hook warns on a valid reply because the transcript shape differs from the assumed one | low | low | The hook only warns and exits 0. The miss log shows an implausible rate. | open |
| R-002 | technical | `setup.sh` and `setup.ps1` drift on the Stop entry | medium | medium | The req-004 suite reads the Stop entry from both scripts, and the hook-parity suite compares the other two events. | open |
| R-003 | operational | The miss log grows without bound | low | low | Each line holds 80 characters of the reply, and a miss is rare. The hook adds the log to `.git/info/exclude`, so git does not track it. | open |
| R-004 | security | The log holds the start of a reply, which could hold a secret | low | medium | The hook logs only the first line, cut to 80 characters, and the hook excludes the file from git. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | The Stop payload carries `transcript_path` to a JSONL transcript | The warning never fires | open |
| A-002 | The boot file reloads after compaction | The rule drops after compaction | open |
