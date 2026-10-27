---
title: "Backlog Entry: 0000233 - check the PATH before a report says a program is missing"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000233 - check the PATH before a report says a program is missing

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

Step 12 of initiative 0000195 (`0000207-codex-support`) shipped two false claims about Codex.

- **Missing program.** `plan/.initiative-logs/step-12.log` says "No Codex program was available." The acceptance evidence repeats it (`plan/_archive/0000207-codex-support-2026-10-27/acceptance-evidence.md`, item 3). Yet `/opt/homebrew/bin/codex` existed. It links to `codex` 0.163.0, installed on 2026-10-18, nine days before the step ran.
- **Docs-only claim.** The same log says "Only `merge-guard` is active in Codex", based on the Codex docs alone. The acceptance evidence marks all 12 criteria `verified`, none `not-verifiable`.

Step 14 (`0000217-verify-codex-setup`) ran the real program. Codex skipped `merge-guard` until a person trusted the hook with `/hooks`, so the merge ran (`plan/.initiative-logs/step-14.log`). The step 12 claim was false, and step 14 had to rise from a patch to a minor bump.

`ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md` has no rule for either case. It never asks the agent to search the `PATH` before it reports a missing program. It lets a criterion count as `verified` when only documentation backs it.

## Suggested Action

- Add a rule to `ravintio-validate-and-accept`. Before a report says a program is missing, run `command -v {program}`. Then look in common install paths, such as `/opt/homebrew/bin`, `/usr/local/bin`, and `~/.local/bin`. Record each command and its output in the acceptance evidence.
- Add a status `unverified (docs only)` for any claim that rests only on documentation. A criterion with that status can't count as `verified`.
- Make the report and the acceptance evidence list each unverified claim by name.

## Wanted outcome

No report states that a program is missing without proof from the `PATH`, and no docs-only claim reads as verified. Tests check these conditions:

- The validate-and-accept skill holds the `command -v` rule and names `/opt/homebrew/bin`.
- The skill defines the `unverified (docs only)` status and says it never counts as `verified`.
- The skill's acceptance evidence rules ask for the `PATH` check output and a list of unverified claims.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`. This entry holds one of them.
