---
title: "Security Report - workflow-governance-gates"
summary: "Security review of the workflow metrics script, the governance standard, the marker rules, and the ship PR body change."
status: "draft"
version: "0.18.0"
---
# Security Report - workflow-governance-gates

**Skill:** validate-and-accept
**Feature:** 0000173-workflow-governance-gates
**Version:** 0.18.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero (`scripts/workflow-metrics.mjs`, `standards/workflow-governance-standards.md`, ship, implement, orchestrator, and validate-and-accept skills, four `test-0000173-*` suites, `component.yml`), `docs/`
**Review scope:** code review | dependency audit | threat model | data exposure

The review covers `git diff 2259559..HEAD -- ravintio-zero docs`. It excludes `plan/`.

No Critical or High finding exists. No Medium finding exists. Four Low findings and four informational notes remain.

The script prints only static labels, integer counts, threshold numbers, and one requirement id. The id must match `REQ-\d+`. Marker text and log content cannot reach the output, so the PR body copy does not leak log content. The one leak path is the free-text failure reason in the ship skill (S-001).

The script uses Node built-ins only, runs no child process, uses no `eval`, makes no network call, and writes no file. A scan of the diff for credential patterns found only the test sentinel `SECRET-REASON-TEXT`, which proves the output never echoes marker text.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-001 | low | data-exposure | `ravintio-zero/skills/ravintio-ship/SKILL.md:67`, `:100`; `ravintio-zero/scripts/workflow-metrics.mjs:63` | On failure the ship skill writes `Workflow governance: not measured ({reason})` into the build report and the public PR body. The reason is free text. The script's stderr is `cannot read {path}`, so an agent that copies it publishes an absolute local path, such as a home folder with a user name. The skill does not limit the reason. | Not mitigated. Say the reason is one fixed phrase, such as `build log unreadable` or `thresholds invalid`, and never a path or stderr text. | open |
| S-002 | low | injection | `ravintio-zero/skills/ravintio-ship/SKILL.md:67` | `{archive-folder}` sits unquoted in a shell command. The folder name comes from the feature id and slug, which the human approves at discovery. A slug with a space or shell metacharacter would split or run extra commands. The script itself builds no command. | Not mitigated. Write the command with the folder in double quotes. The ship skill already restricts slugs in practice, so the likelihood is low. | open |
| S-003 | low | path traversal | `ravintio-zero/scripts/workflow-metrics.mjs:61`, `:134-138` | `readFileSync` follows symlinks. A `loop-state-*.md` symlink to another file adds only marker counts, so no content leaves the file. A symlink to a FIFO or a device file makes the read wait without end. A directory named `loop-state-x.md` makes `readText` call `fail`, which aborts the whole run with exit 1. Ship then writes `not measured`. The folder holds files that agents wrote during the run, so an attacker needs write access to the repository. | Not mitigated. Optionally use `readdirSync(folder, { withFileTypes: true })` and keep only entries where `isFile()` is true. | open |
| S-004 | low | injection | `ravintio-zero/scripts/workflow-metrics.mjs:73-91`; `ravintio-zero/standards/workflow-governance-standards.md:31` | Any line that starts with a marker counts, so a build log line copied from tool output or a failing test can inflate a count. An unclosed code fence (`:74-80`) hides every later marker, which deflates counts. The effect is a wrong breach flag or a missed one. The gate never blocks, and the report says counts come from markers only. | Partly mitigated. The line-start and fence rules cut prose false positives. This matches R-001 and A-001 in the risk register. Optionally require the full marker shape, including the timestamp. | accepted |
| S-005 | informational | injection | `ravintio-zero/scripts/workflow-metrics.mjs:68-69`, `:82`, `:102-114`, `:121` | No ReDoS risk. Every regex is anchored and has no nested quantifier. `LIST_PREFIX` starts at `^`, and the `\s*` run cannot retry from another offset. `\d+` in `REQ-(\d+)` and `^\d+$` runs once per line. Runtime stays linear in file size. | None needed. | accepted |
| S-006 | informational | path traversal | `ravintio-zero/scripts/workflow-metrics.mjs:42-52`, `:130` | The `--standard` and folder arguments take any path, with no root check. A caller who can run the script can already read the file. The `--standard` path only yields numbers from a `Key` and `Threshold` table, and the error text names a static key. No file content other than whole numbers reaches the output. Arguments are never passed to a shell by the script. | None needed. The script runs with the caller's own rights. | accepted |
| S-007 | informational | config | `ravintio-zero/scripts/workflow-metrics.mjs:121-122` | A threshold of 400 or more digits gives `Infinity` through `Number(v)`, so that metric never breaches. The standard is a tracked file, and a change to it goes through review. | None needed. Optionally cap the digit count. | accepted |
| S-008 | informational | availability | `ravintio-zero/scripts/workflow-metrics.mjs:61`, `:73` | The script reads each file whole and splits it in memory. A very large build log uses memory in proportion to its size. Build logs are small text files, and the script is a local tool. | None needed. | accepted |

## Checks with no finding

### Injection points

- Argument handling at `workflow-metrics.mjs:38-53` rejects unknown `--` flags, a second positional, and a `--standard` with no value. All three exit 2.
- The script contains no `child_process`, `eval`, `Function`, dynamic `import`, or template that builds a command.
- The `Map` for rework counts uses requirement ids that match `REQ-\d+`. Prototype keys cannot occur.

### Credential handling

- Output has fixed text at `:162-172`. The `shown` values at `:152` are digits and a `REQ-\d+` id.
- Marker reasons, timestamps, and exception text are matched only for line start and never captured, except the requirement id at `:82`. Test `test-0000173-req-001-workflow-metrics-script.sh:79-83` checks this with a sentinel.
- The attribution check in the ship skill (`:79` onwards) still runs on the PR body, which now holds the governance section.
- The marker rules in the implement, orchestrator, and validate-and-accept skills ask agents to write a reason string into the build log. A reason can quote a credential only if an agent writes one. The log never reaches the PR body.

### Dependencies

- Node built-ins only: `node:fs`, `node:path`, `node:url`. No package file changes and no new lock file entry. No CVE applies.
- Node version is not pinned. `import.meta` and ES modules need Node 12 or later, and the pack already requires Node for `check-attribution.mjs`.

### Tests

- The suites create a folder with `mktemp -d` and remove it with `trap` on exit. They use no `eval`, and they build no command from file content.

## Dependency audit

| Package | Current version | Known CVEs | Severity | Action required |
|---------|----------------|------------|----------|-----------------|
| Node built-ins (`fs`, `path`, `url`) | runtime | none | low | none |

## Threat model

| Threat | Attack vector | Affected component | Likelihood | Impact | Existing mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|-----|
| Local path or log text in the public PR body | Failure reason copied from stderr | ship skill `:67`, `:100` | medium | low | Script prints no log content | Free-text reason (S-001) |
| Command injection through the folder name | Slug with a shell metacharacter | ship skill `:67` | low | medium | Slug approved at discovery | Unquoted placeholder (S-002) |
| Forged or hidden markers | Log line copied from untrusted output, or an open fence | `workflow-metrics.mjs:73-91` | medium | low | Line-start and fence rules, report-only gate | Counts can drift (S-004) |
| Read of an unexpected file | Symlink in the run folder | `workflow-metrics.mjs:61`, `:138` | low | low | Output holds counts only | No regular-file check (S-003) |

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | A prose mention of `Blocked:` counts as a stop | mitigated in part | Line-start and fence rules at `workflow-metrics.mjs:71-92`. A copied tool-output line still counts (S-004). |
| R-002 | Skill size budgets fail when marker rules land | not a security risk | The additions are one or two lines each. Outside this review. |
| A-001 | Agents write marker lines when told to | open | Counts read low if agents skip them. The report says counts come from markers only (`workflow-metrics.mjs:170`). |

New risks this review adds to the register: S-001 and S-002 as low risks. Both have a concrete wording fix in the ship skill.

## Top actions

1. Limit the `not measured` reason to a fixed phrase, with no path or stderr text (S-001).
2. Put `{archive-folder}` in double quotes in the ship command (S-002).
3. Keep only regular files when the script lists loop-state files (S-003).

## Counts

- Critical: 0
- High: 0
- Medium: 0
- Low: 4
- Informational: 4
- Unmitigated Critical or High: 0
