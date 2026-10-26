---
title: "Verification Report - name-the-roadmap-initiative"
summary: "Execution verification of the initiative rename across the driver, hooks, migration, guard, and skills."
status: "draft"
version: "0.1.0"
---
# Verification Report - name-the-roadmap-initiative

**Skill:** validate-and-accept
**Feature:** 0000189-name-the-roadmap-initiative

## What was started

Nothing long-running. Each check ran in a temporary folder from `mktemp -d`. A stub `claude` script sat first on `PATH` and logged its arguments, so the real binary never ran. A stub `gh` script returned a chosen `baseRefName` for the merge-guard runs. The guard test ran once on the clean tree and once on a temporary copy with a planted old name. Both migration helpers ran under `bash` and `pwsh` on fixtures.

## Acceptance criteria

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 | Read the section | verified | `project-operations.md:81` holds `## Roadmap and initiative glossary` with "Roadmap" and "Roadmap initiative" entries. |
| REQ-001 AC-2 | Read the section | verified | "Initiative states" lists `proposed`, `charted`, `active`, `delivered`, `blocked` with the setting stage. |
| REQ-001 AC-3 | Resolve the anchor | verified | `roadmap-standards.md:11` links `../project-operations.md#roadmap-and-initiative-glossary`. The heading slug matches and the target file exists. |
| REQ-002 AC-1 | Driver run, status active, one step | verified | `initiative-run.mjs --root` exit 0. It read the file (stub saw id `0000001-demo`). `plan/.initiative-logs` mode 700, `step-1.log` mode 600. Stub env held `OTEL_RESOURCE_ATTRIBUTES=work.kind=initiative,ravintio.initiative=0000001-demo,ravintio.step=1`. |
| REQ-002 AC-2 | `merge-guard.mjs` with JSON on stdin and stub `gh` | verified | Base `initiative/0000001-demo` exit 0. Base `roadmap/0000001-demo` exit 2. Base `main` exit 2. |
| REQ-002 AC-3 | grep both workflows | verified | `.github/workflows/ravintio.yml:5` and `ravintio-zero/hooks/ravintio.yml:5` read `branches: [ main, master, 'initiative/**' ]`. Neither lists `roadmap/**`. |
| REQ-003 AC-1 | grep stage tables | verified | Orchestrator `SKILL.md:54-58` and `roadmap-standards.md:38-42` list `I-A` to `I-E`. grep for `R-[A-E]` stage prefixes in `ravintio-zero` and `.claude/skills` found none. `SKILL.md:63` keeps "stage letters, not phase numbers". |
| REQ-003 AC-2 | Driver run, status charted | verified | Exit 1. Output `I-C Run: Blocked: initiative status is charted, not active`. The stub was not called. |
| REQ-004 AC-1 | grep template | verified | `initiative.template.md:4` reads `proposed \| charted \| active \| delivered \| blocked`. |
| REQ-004 AC-2 | grep standard | verified | `roadmap-standards.md:16-21` maps each state to its stage. |
| REQ-005 AC-1 | `migrate-initiative-rename.sh`, then `.ps1` via `pwsh`, on fresh fixtures | verified | Both exit 0. Both leave `initiative.md`, `branches: [ main, 'initiative/**' ]`, and `plan/.initiative-logs/`. |
| REQ-005 AC-2 | Both helpers with `plan/current-roadmap/` added | verified | Both exit 1 with `ERROR: plan/current-roadmap/ exists.` Checksums of every file were unchanged. |
| REQ-005 AC-3 | Rerun both helpers on migrated fixtures | verified | Both exit 0, print "Nothing to do", and leave checksums unchanged. |
| REQ-006 AC-1 | Driver with `RAVINTIO_ROADMAP_MODEL=sonnet` and `PLANIFEST_ROADMAP_MODEL=sonnet` | verified | Exit 1 each. Line `I-C Run: Blocked: {old} is no longer read. Set RAVINTIO_INITIATIVE_MODEL instead.` No stub log, so no step spawned. |
| REQ-006 AC-2 | Driver with `RAVINTIO_ROADMAP_MAX_TURNS=40` and `PLANIFEST_ROADMAP_MAX_TURNS=40` | verified | Exit 1 each. Line names `RAVINTIO_INITIATIVE_MAX_TURNS`. No step spawned. |
| REQ-006 AC-3 | Driver with `RAVINTIO_INITIATIVE_MODEL=opus` and `RAVINTIO_INITIATIVE_MAX_TURNS=40` | verified | Exit 0. Stub args: `-p --permission-mode auto --model opus --max-turns 40 Run initiative step 1`. |
| REQ-007 AC-1 | Run `test-0000189-req-007-old-name-guard.sh` | verified | Exit 0. `PASS: req-007 AC-1: 0 old names outside the allowlist`. |
| REQ-007 AC-2 | Temporary copy of tracked files with `plan/current-roadmap/` appended to a skill file, then the guard test | verified | Exit non-zero in the copy. Printed `ravintio-zero/skills/ravintio-file-backlog/SKILL.md:69`. |
| REQ-008 AC-1 | Guard run (REQ-007 AC-1) covers `plan/backlog` | verified | 0 old names outside the allowlist. |
| REQ-008 AC-2 | grep entries | verified | 0000178 holds "post-initiative retrospective". 0000181 holds `I-A`. 0000182 holds `ravintio-initiative` and `plan/.initiative-ack`. |
| REQ-009 AC-1 | `diff -rq ravintio-zero/skills .claude/skills` | verified | Only difference is `Only in .claude/skills: .ravintio-manifest`, which is not a skill file. Every skill file matches. |

## Findings

No failed criterion. One note: `diff -rq` exits 1 because of `.claude/skills/.ravintio-manifest`. The installer writes that file, so the exit code does not signal a skill mismatch.

## Summary

21 verified, 0 failed, 0 not-verifiable.
