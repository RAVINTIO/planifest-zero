#!/usr/bin/env node
/**
 * UserPromptSubmit hook: auto-trigger the ravintio-orchestrator skill.
 *
 * Fires on every user prompt. Performs two fast file-existence checks:
 *   1. ravintio-zero/ exists → this is a ravintio project
 *   2. plan/.orchestrator-active does NOT exist → orchestrator not yet loaded
 *
 * If both conditions are met, outputs an instruction to the model to load
 * the ravintio-orchestrator skill. The instruction appears inline in the
 * model's context before it processes the user prompt.
 *
 * If either condition fails, exits 0 silently (no output, no effect).
 *
 * Initiative case: if plan/current-initiative/initiative.md holds status active,
 * plan/.orchestrator-active is absent, and plan/current/ holds only hidden
 * entries, the instruction names the ravintio-initiative skill instead. This
 * covers a held driver lock (plan/.initiative-runner.lock) and a free lock alike.
 *
 * Environment: RAVINTIO_INITIATIVE_STEP=1 marks a step session started by the
 * initiative driver (`claude -p "Run initiative step N"`). A step session has
 * the lock held, no sentinel, and an empty plan/current/ at start. That looks
 * the same as a driver session, so the driver sets this variable. When it is
 * set, the hook keeps the orchestrator instruction.
 *
 * Design: ADR-003 — auto-trigger via UserPromptSubmit + CLAUDE.md fallback.
 * REQ-002.
 *
 * Exit codes: 0 = pass (no action or instruction emitted)
 * Never exits 2 — this hook does not block user prompts.
 */

import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

import { readStdin } from "./read-stdin.mjs";

// True when initiative.md holds status active, in frontmatter or as "**Status:** active".
function initiativeActive(cwd) {
  try {
    const text = readFileSync(join(cwd, "plan", "current-initiative", "initiative.md"), "utf-8");
    return /^\s*status:\s*["']?active["']?\s*$/im.test(text) ||
      /^\s*\*\*Status:\*\*\s*active\s*$/im.test(text);
  } catch {
    return false;
  }
}

// True when plan/current/ holds no entries other than hidden ones.
function currentIsEmpty(cwd) {
  try {
    return readdirSync(join(cwd, "plan", "current")).every((n) => n.startsWith("."));
  } catch {
    return true; // a missing directory holds no artifacts
  }
}

try {
  const raw = await readStdin();
  const input = JSON.parse(raw);
  const cwd = input?.cwd ?? process.cwd();

  // Check 1 — is this a ravintio project?
  const zeroDir = join(cwd, "ravintio-zero");
  if (!existsSync(zeroDir)) process.exit(0);

  // Check 2 — is the orchestrator already active?
  const sentinelPath = join(cwd, "plan", ".orchestrator-active");
  if (existsSync(sentinelPath)) process.exit(0);

  // Initiative check: an active initiative with an empty plan/current/ means
  // the session drives the initiative. A step session sets
  // RAVINTIO_INITIATIVE_STEP=1 and keeps the orchestrator. Whether the driver
  // lock is held makes no difference here, so the lock is not read.
  if (process.env.RAVINTIO_INITIATIVE_STEP !== "1" && initiativeActive(cwd) && currentIsEmpty(cwd)) {
    process.stdout.write(
      "SYSTEM INSTRUCTION: This is a RAVINTIO project (ravintio-zero/ detected) " +
      "with an active initiative (plan/current-initiative/initiative.md). " +
      "Load the ravintio-initiative skill now, before responding to the user's prompt. " +
      "Begin with resume detection as described in the skill.\n"
    );
    process.exit(0);
  }

  // Both conditions met: emit the instruction to load the orchestrator.
  // Claude Code injects this output into the model's context before the prompt.
  process.stdout.write(
    "SYSTEM INSTRUCTION: This is a RAVINTIO project (ravintio-zero/ detected) " +
    "and the orchestrator has not been loaded yet for this session. " +
    "Load the ravintio-orchestrator skill now, before responding to the user's prompt. " +
    "Begin with resume detection as described in the skill.\n"
  );

  process.exit(0);
} catch {
  // Never interfere with the session on unexpected errors.
  process.exit(0);
}
