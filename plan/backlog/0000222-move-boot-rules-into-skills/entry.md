---
title: "Backlog Entry: 0000222 - move boot file rules into skills"
summary: "A human-requested fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000222 - move boot file rules into skills

**Source feature:** none (human request)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

`CLAUDE.md` is too big. Every session loads all of it, whether or not the session needs each rule. On 2026-10-27 it held 10,317 bytes:

| Source | Bytes | Sections |
|--------|-------|----------|
| Boot template | about 5,000 | Hard Limits, Operational Directives, Hook Enforcement, Reply Conventions, Escalation |
| Repo overrides | about 5,300 | Git permissions, commit cadence, subagent decomposition, GUTD shorthand, ship PR rule, branch cleanup, setup refresh approval |

Each new override grows it further. The size cap test in `test-0000151-req-011-orchestrator-references-split.sh` then fails, and a step raises the cap. Four steps have raised it so far, most recently 0000208. Raising the cap treats the symptom. Backlog entry 0000214 stops the test counting overrides, but the agent still loads them in every session.

Many of these rules apply only to one task:

- **GUTD shorthand:** only when the human types `GUTD`.
- **Setup refresh approval:** only when `ravintio-refresh-setup` runs.
- **Ship PR rule:** only in P4 Ship.
- **Branch cleanup:** only when the agent tidies local branches.
- **Hook Enforcement:** only when a hook blocks a write or a commit.

## Suggested Action

Keep in the boot file only the rules that every session needs: the hard limits, the phase prefixes, the reply conventions, and escalation. Move the rest to where the agent loads them on demand:

- Move each task-specific override into a skill with a description that triggers on its task. `ravintio-overrides/capability-skills/` already installs repo skills. For example, the GUTD shorthand becomes a `gutd` skill.
- Let an override target one pack skill, so setup appends it to that skill and not to `CLAUDE.md`. The setup refresh approval then lives in `ravintio-refresh-setup`, and the ship PR rule lives in `ravintio-ship`.
- Move Hook Enforcement into a reference file. Each hook's block message names that file.
- Cap `CLAUDE.md` on its own, apart from the orchestrator skill. Revert the combined cap to its pack-only figure, as entry 0000214 asks.

## Wanted outcome

`CLAUDE.md` in this repo is 6,000 bytes or fewer, with every current override still in force. Tests check these conditions:

- The generated `CLAUDE.md` is 6,000 bytes or fewer.
- An override that targets a pack skill appears in that installed skill and not in `CLAUDE.md`.
- A repo override written as a capability skill installs to `.claude/skills/` with its description intact.
- Each hook block message names the Hook Enforcement reference file.

## Why Deferred

The human asked for it at initiative 0000195 delivery, after accepting the step 13 cap raise. It pairs with backlog entry 0000214.
