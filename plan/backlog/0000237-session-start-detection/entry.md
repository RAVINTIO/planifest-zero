---
title: "Backlog Entry: 0000237 - run resume detection as a script at session start"
summary: "A human-requested capability, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000237 - run resume detection as a script at session start

**Source feature:** none (human request)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

The orchestrator runs Resume Detection by reading 12 checks from `SKILL.md` and carrying them out by hand. The section is 4,296 bytes, and every session loads it. Most checks only test whether a file or a build log line exists:

- pending migrations in `ravintio-zero/migrations/`
- `plan/.orchestrator-active` with an empty `plan/current/`
- `plan/current/.skips`, `pause.md`, and `park.md`
- the value of `plan/.run-mode`
- a `Blocked:` line with no later `Resolved:` line
- an `In progress:` line with no later matching `Done:` line

An agent can skip or misread a check, and no test covers the agent's reading. The `ravintio-initiative` skill runs its own session start checks for the driver lock and the position.

## Suggested Action

Add `ravintio-zero/scripts/resume-detect.mjs` and run it from the session start hook, before any skill loads:

1. `auto-trigger-orchestrator.mjs` runs the script on the prompt where it injects the load instruction.
2. The script prints one line per signal it finds, such as `pending migration: 0007` or `unit in progress: req-003`. If it finds none, it prints `no resume signals`.
3. The hook injects those lines with the instruction to load the orchestrator or the initiative skill, as it chooses today.
4. Resume Detection in `SKILL.md` becomes a short rule. The agent acts on each finding in the order the script prints them. For each finding, it reads that check's section in `references/orchestrator-resume-detection.md`.
5. The `ravintio-initiative` skill uses the same findings, which add the driver lock and the initiative position.

Checks that need judgement stay in the reference file, and the script only reports their signal. Examples are the pack update provenance check and the run-mode question.

Two rules apply:

- **Fixed text only.** The script prints fixed messages, ids, and repo-relative paths. It never prints file contents. `pause.md`, `park.md`, the build log, and backlog entries are tracked files, and a hostile commit could plant instructions in them. Hook output reaches the agent as system context, so it must never carry repo text. An id or path that fails a strict pattern prints as `unreadable`.
- **No silent miss.** If the script fails or times out, the hook still injects the load instruction, with the line `resume detection did not run`. The skill then runs every check from the reference file. A failed run must never read as `no resume signals`.

## Wanted outcome

Every session starts with a tested list of resume signals in context, and Resume Detection in `SKILL.md` is 400 bytes or fewer. Tests check these conditions:

- For each of the 12 checks, a fixture with that signal makes the script print its line, and a fixture without it does not.
- The script prints findings in the order of the current checks.
- A fixture with no signals prints `no resume signals`.
- A fixture whose `pause.md` or build log holds instruction text prints no part of that text.
- If the script exits non-zero or times out, the hook output still holds the load instruction and `resume detection did not run`.
- In a step session (`RAVINTIO_INITIATIVE_STEP=1`) and in an initiative session, the hook injects the same findings with the right skill name.
- `SKILL.md` names `references/orchestrator-resume-detection.md` in its Pack Index, and the reference holds every line of the current Resume Detection section.

## Why Deferred

The human asked for it at initiative 0000195 delivery, while lowering the target for backlog entry 0000236 to 9,000 bytes. Entry 0000236 depends on it.
