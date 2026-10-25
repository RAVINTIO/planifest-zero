---
title: "Security Report - story-mapping-and-gherkin"
summary: "Security review of the Gherkin and story map checks in the consistency check and the ratchet hook."
status: "draft"
version: "0.1.0"
---
# Security Report - story-mapping-and-gherkin

**Skill:** validate-and-accept
**Feature:** 0000170-story-mapping-and-gherkin
**Version:** 0.1.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero (`scripts/consistency-check.mjs`, `hooks/enforcement/ratchet-check.mjs`, templates, plan skill, `component.yml`)
**Review scope:** code review | dependency audit | threat model

The review covers `git diff roadmap/0000168-backlog-clearance...HEAD -- ravintio-zero/`. No Critical or High finding exists. Three Low findings and three informational notes remain.

I timed the new regexes on hostile input in a temporary directory. A line of 80,000 spaces ending in ` ` ran in under 0.1 ms against the new Acceptance Criteria pattern. A 2 MB hostile requirement file and a 2 MB story map ran through `consistency-check.mjs` in 0.055 seconds. A 40,000-space hostile line ran through `ratchet-check.mjs` end to end with exit 2 in 0.043 seconds. ReDoS is not practical. The diff adds no dependency and no shell call. A scan of the diff for credential patterns found none.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-001 | low | data exposure | `ravintio-zero/hooks/enforcement/ratchet-check.mjs:239`, `:247-253` | The block message prints each removed line in full, with no length cap. The new step-line guard widens this to `Given/When/Then` lines. If someone writes a secret into a criterion, the hook copies it to stderr and to the JSON deny reason. The agent could already read the file, so no new reader gains access. The message also lands in transcripts and logs. | Cap each printed line at about 200 characters. Keep the "no credentials in context" rule in the plan skill. | open |
| S-002 | low | data exposure | `ravintio-zero/scripts/consistency-check.mjs:135`, `:141` | A finding echoes the story map row label, which is a whole table cell with no length cap. A 2 MB cell prints 2 MB to stdout, and CI logs keep it. The source is a plan file the repo owner controls. | Truncate the label at 80 characters. | open |
| S-003 | low | availability | `ravintio-zero/scripts/consistency-check.mjs:105`, `:59`, `:112`, and `ravintio-zero/hooks/enforcement/ratchet-check.mjs:214` | Both programs read whole files into memory with no size limit. A multi-gigabyte plan file would exhaust memory. The ratchet hook exits 0 on unexpected errors, so it fails open. The plan files belong to the repo owner, so no outside party reaches this path. | None needed. Optionally skip files above 1 MB. | accepted |
| S-004 | informational | injection | `ravintio-zero/hooks/enforcement/ratchet-check.mjs:85`, `:96` | The Gherkin alternative `((?:Given\|When\|Then\|And\|But)\b.*)$` is anchored at both ends. No nested quantifier or overlapping alternation exists. I timed `\s*(.+)$` against a line with a trailing ` `, which is the only way to defeat `.`. Cost stayed flat at 80,000 characters. The `im[1] ?? im[2]` read is safe because the scope pattern has one group only. | None needed. | accepted |
| S-005 | informational | injection | `ravintio-zero/scripts/consistency-check.mjs:118` | `new RegExp(\`\\b${us}\\b\`)` interpolates a value from file text. The capture `US-\d+` allows only `US-` and digits, so no metacharacter reaches the pattern. The heading builder at `:44` takes constant headings only. | None needed. Keep the capture group strict if it changes. | accepted |
| S-006 | informational | path traversal | `ravintio-zero/hooks/enforcement/ratchet-check.mjs:198-206`, `:214` | The path comes from untrusted tool input. The hook resolves it with `realpathSafe` and `relative`, then guards only paths under `plan/current/` that end in `.md`. A `..` segment or symlink resolves before the prefix test. The diff leaves this logic unchanged. The hook only reads the file, and the approval consumption writes to fixed paths under the project root. `consistency-check.mjs:35` takes its directory from `argv[2]`, which the caller sets. It opens only `story-map.md` and `requirements/` inside it. | None needed. | accepted |

## Checks with no finding

### Regex and input handling

- The hook runs `JSON.parse` in a `try` block and exits 0 on malformed input (`ratchet-check.mjs:194-195`). The top-level catch also exits 0.
- Neither program uses `eval`, `Function`, `exec`, or `spawn` in the diff. The only process call is the existing `execFileSync("git", [array])` at `ratchet-check.mjs:146`, which uses no shell. The diff adds no shell call, as NFR-001 requires.
- Every new pattern runs on one line at a time or on a bounded table cell. Lines come from `split(/\r?\n/)`.
- `consistency-check.mjs:62-72` and `:120-127` use anchored or linear patterns only. The separator test `/^-+:?$|^:-+:?$/` is linear.

### Output

- Check 6 and check 7 print file names, AC-n ids, `REQ-nnn` and `US-nnn` ids, line numbers, and the row label (S-002). They print no other file content.
- The hook prints the removed lines (S-001) and the relative path of the file. It prints no unchanged content and no environment values.
- Stdout carries a JSON deny. Stderr carries the same text. Neither stream holds a path outside the project root.

### Credentials and dependencies

- The diff holds no secret. Tests and templates use placeholder text.
- The pack has no `package.json`. Both programs import only `node:` built-ins and the existing local `read-stdin.mjs`. No new dependency exists.
- `component.yml` gains two text lines. They add no executable surface.

### Bypass of the guard

- The ratchet stays advisory for a malicious author. A step line that is not an indented bullet, or an uppercase `[X]` box, escapes the guard. That limit predates the feature and the `component.yml` note records the bullet-only form. The ratchet defends against agent drift, not an adversary with write access.

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | Consumer runs in flight fail the new checks on old-format criteria | open | A functional risk, not a security one. The finding text names the expected format, and the fix is a text edit. |
| R-002 | The ratchet parser misreads a Gherkin step line and blocks a valid write | mitigated | `test-0000170-req-005-ratchet-gherkin-guard.sh` covers the guard. Review of `ratchet-check.mjs:85-96` found no misread. A removed step blocks, and an added step passes. |
| R-003 | Plan skill text grows and shell suites that grep it break | open | Outside the security scope. The shell suite results sit in the P3 test evidence. |
| R-004 | The story map adds work to small plans | open | An operational risk with no security effect. |
| A-001 | Plain Markdown lines are enough for Gherkin | open | The regex approach is safe against hostile input (S-004). A later `.feature` export would need a fresh review. |

## NFR-001 check

NFR-001 asks for no shell calls added and no file content printed beyond the removed line. The first half holds, as the Checks section shows. The second half holds for the hook, which prints removed lines only. It does not hold for `consistency-check.mjs`, which prints the story map row label (S-002). The NFR names the ratchet, so the scope is met, but the check script also echoes cell text.

## Top actions

1. Cap each removed line the ratchet hook prints (S-001).
2. Truncate the row label in the story map findings (S-002).
3. Keep `US-\d+` strict if anyone changes the capture at `consistency-check.mjs:117` (S-005).
