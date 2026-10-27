---
title: "Backlog Entry: 0000228 - the ship stage gives a plain merge command"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000228 - the ship stage gives a plain merge command

**Source feature:** none (initiative 0000195 retrospective)
**Source phase:** none (initiative 0000195 delivery)
**Deferral source:** retrospective action
**Date filed:** 2026-10-27

---

## Problem

`merge-guard` blocked the first merge command in 5 of the 15 steps of initiative 0000195. Each first attempt used command substitution, so the guard could not confirm a squash into `initiative/*`. Each step then reran a plain command with a literal PR number, and the guard allowed it:

- Step 3 (0000198) reran `gh pr merge --squash --delete-branch 41` (`plan/.initiative-logs/step-3.log`).
- Step 4 (0000199) reran the same command for PR 42 (`step-4.log`).
- Step 8 (0000203) reran it for PR 46 (`step-8.log`).
- Step 11 (0000206) reran it as a plain command (`step-11.log`).
- Step 13 (0000208) reran it for PR 52 (`step-13.log`).

The ship skill names the carve-out in rule 5 and its `## Initiative steps` section, but it shows no merge command. It points to I-D Advance in `ravintio-zero/standards/roadmap-standards.md`. That stage writes the PR number as the placeholder `{n}` in steps 3 and 4. Step 5 then reads the merge commit with `sha=$(gh pr view {n} ...)`. No text tells the agent to write the PR number as a literal, so agents built the merge line with substitution and met the guard.

## Suggested Action

Give the merge command in `ravintio-zero/skills/ravintio-ship/SKILL.md` as a plain line to copy. Use the form `gh pr merge --squash --delete-branch {n}`. State that `{n}` is the literal PR number from the `gh pr create` output. Forbid command substitution, variables, and pipes on that line. Match the wording in I-D Advance step 4. Leave `merge-guard` as it is.

## Wanted outcome

A test checks these conditions:

- The ship skill holds the line `gh pr merge --squash --delete-branch {n}`.
- The ship skill states that `{n}` is a literal number and forbids substitution on the merge line.
- `merge-guard` allows that line with a literal number, such as `gh pr merge --squash --delete-branch 52`, for an `initiative/*` base.
- `merge-guard` source and its own tests are unchanged.

## Why Deferred

The human asked on 2026-10-27 to file every action from `plan/retrospectives/0000195-backlog-clearance-initiative-2026-10-27.md`.
