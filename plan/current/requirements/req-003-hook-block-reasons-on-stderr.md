---
title: "Requirement: req-003 - hook-block-reasons-on-stderr"
summary: "gate-write, em-dash-guard, and ratchet-check write each block reason to stderr as well as stdout, so a blocked agent sees why."
status: "draft"
version: "0.1.0"
---
# Requirement: req-003 - hook-block-reasons-on-stderr

**Skill:** [plan](../../../planifest-zero/skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-003 (backlog 0000146)
**Priority:** must-have

## User Story

As an agent blocked by a hook, I see the block reason, so that I fix the cause instead of working round the gate.

## Functional Requirements
- Claude Code shows the agent only stderr when a PreToolUse hook exits 2. Three hooks write the reason to stdout alone.
- Each hook dual-writes: it keeps its current stdout output and adds the same reason on stderr.
  - `planifest-zero/hooks/enforcement/gate-write.mjs` blocks at lines 106-111, 121-125, and 148-152. Each block also writes its reason to stderr.
  - `planifest-zero/hooks/enforcement/em-dash-guard.mjs` blocks at lines 116-122. The block also writes its reason to stderr.
  - `planifest-zero/hooks/enforcement/ratchet-check.mjs` prints a JSON deny on stdout at lines 243-250, then exits 2. It keeps that JSON on stdout and adds the plain reason text on stderr.
- The stderr text is the reason a person can read. It is not JSON.
- Exit codes do not change. Every block still exits 2 and every allow path still exits 0.
- `check-orchestrator-presence.mjs` is out of scope. It never exits 2, so no agent sees a block from it.
- `merge-guard.mjs` (lines 44-54) already writes both streams and is the model.
- Each hook gets one new test that triggers a block and asserts the reason appears on stderr.

## Acceptance Criteria
- [ ] (a) A `gate-write.mjs` block, triggered by a write to `src/` with no `plan/current/design.md`, exits 2 and writes a non-empty reason on stderr. The same reason stays on stdout.
- [ ] (b) An `em-dash-guard.mjs` block, triggered by a write that holds an em dash, exits 2 and writes a non-empty reason on stderr. The same reason stays on stdout.
- [ ] (c) A `ratchet-check.mjs` block, triggered by a write that removes an acceptance-criteria line while a loop is active, exits 2. Stdout still parses as the same JSON deny and stderr holds the plain reason.
- [ ] (d) Every existing test that reads stdout from these hooks still passes unchanged, including `test-0000028-req-006-em-dash-guard.sh` and `test-0000017-req-002-ratchet-approve.sh`, which discard stderr with `2>/dev/null`.
- [ ] (e) `test-gate-write-windows.sh`, `test-gate-write-windows.mjs`, and their copies under `planifest-zero/tests/regression/` pass. If any of them reads the hook's output streams, the requirement updates them without removing an assertion.
- [ ] (f) No allow path writes to stderr, and no exit code changes. The tests above include one allowed write per hook that asserts empty stderr and exit 0.
- [ ] (g) No existing test assertion is removed or weakened.

## Dependencies
- None on other requirements in this feature.
- Files in reach:
  - `planifest-zero/hooks/enforcement/gate-write.mjs`
  - `planifest-zero/hooks/enforcement/em-dash-guard.mjs`
  - `planifest-zero/hooks/enforcement/ratchet-check.mjs`
  - `planifest-zero/hooks/enforcement/merge-guard.mjs` (reference only, not edited)
  - `planifest-zero/tests/test-0000043-req-006-merge-guard-hook.sh` (model for the stderr tests)
  - `planifest-zero/tests/test-0000028-req-006-em-dash-guard.sh` (existing, reads stdout)
  - `planifest-zero/tests/test-0000017-req-002-ratchet-approve.sh` (existing, reads stdout)
  - `planifest-zero/tests/test-gate-write-windows.sh` and `.mjs`, and the copies in `planifest-zero/tests/regression/` (check only)
  - `planifest-zero/tests/test-0000151-req-003-hook-stderr-reasons.sh` (new, one block test per hook)
