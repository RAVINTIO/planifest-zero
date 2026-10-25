---
title: "Verification Report - explain-strict-mode"
summary: "Execution and source verification of the strict mode section and its two links."
status: "draft"
version: "0.18.1"
---
# Verification Report - explain-strict-mode

**Skill:** validate-and-accept
**Feature:** 0000185-explain-strict-mode
**Version:** 0.18.1

## What was started

Nothing long-running. A sonnet agent ran `check-orchestrator-presence.mjs` against a temporary `plan/` folder in five states, then removed the folder. It also checked each claim in the section against its source file. The orchestrator ran both `test-0000185-*` suites and the full suite.

## Hook execution

Each case piped JSON to `node ravintio-zero/hooks/enforcement/check-orchestrator-presence.mjs`. Cases 2 to 5 had `plan/.orchestrator-active` and `plan/.orchestrator-strict`.

| Case | Input | Exit | Observed |
|------|-------|------|----------|
| 1 | No `plan/.orchestrator-active` | 0 | Silent |
| 2 | Strict, no ack, session id `abc` | 0 | `RAVINTIO STRICT MODE` banner naming `abc` |
| 3 | Strict, ack holds `abc`, session id `abc` | 0 | Silent |
| 4 | Strict, ack holds another id, session id `abc` | 0 | Banner naming `abc` |
| 5 | Strict, no session id | 0 | Banner asks for the current timestamp |

## Claim check

All 14 claims in `project-operations.md:46-77` match their sources. No claim is a mismatch or `not-verifiable`.

| Claim | Source |
|-------|--------|
| Advisory by default, never blocks | `hooks/enforcement/check-orchestrator-presence.mjs:7-9`, `:76` |
| Flag writes `plan/.orchestrator-strict` | `setup.sh:1114-1118`, `setup.ps1:1346-1352` |
| Hook acts only while `plan/.orchestrator-active` exists | hook `:32-33` |
| Hook reads the session id | hook `:58` |
| Banner on missing or different ack | hook `:61-73` |
| Orchestrator writes the id | `skills/ravintio-orchestrator/SKILL.md:182` |
| Timestamp fallback | hook `:72` |
| Ship deletes the ack before the PR | `skills/ravintio-ship/SKILL.md:79-85`, `standards/roadmap-standards.md:220` |
| One session per roadmap step | `scripts/roadmap-run.mjs:45-48`, `:227-231` |
| Backlog 0000182 covers the driver case | `plan/backlog/0000182-orchestrator-supervises-roadmap-driver/entry.md` |
| Link target exists | `pipeline-reference.md:287` |

## Acceptance criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | Side effect: read the section | verified | `project-operations.md:48-60` names the flag and `plan/.orchestrator-strict`. `:66-72` names `plan/.orchestrator-ack`. |
| REQ-001 AC-2 | Hook run, cases 2 to 5 | verified | The file content, name, and timestamp fallback match hook output. |
| REQ-001 AC-3 | Source check | verified | `project-operations.md:75` names the roadmap case and 0000182. Entry 0000182 describes it. |
| REQ-002 AC-1 | Side effect: read the row | verified | `getting-started.md:103` links to `project-operations.md#strict-orchestrator-mode`. |
| REQ-002 AC-2 | Side effect: read the row | verified | `README.md:96` links to `ravintio-zero/project-operations.md#strict-orchestrator-mode`. |
| REQ-002 AC-3 | Heading check | verified | `project-operations.md:46` holds `## Strict Orchestrator Mode`. |
