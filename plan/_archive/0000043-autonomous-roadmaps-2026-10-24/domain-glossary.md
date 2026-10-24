---
title: "Domain Glossary - autonomous-roadmaps"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.9.0"
---
# Domain Glossary - autonomous-roadmaps

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000043-autonomous-roadmaps
**Version:** 0.9.0

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Roadmap | A roadmap is a chain of steps that delivers work spanning several features. It holds a `roadmap.md` file with a goal, a branch, a status, and a step table. | | planifest-zero |
| Draft roadmap | A draft roadmap is a file in `plan/roadmap/` that no one has charted yet. Anyone can file one on any branch, and R-A Chart can pick it up. | | planifest-zero |
| Step | A step is one feature inside a roadmap, with one row in the step table. Each step runs P0 to P4 on its own feature branch and merges into the roadmap branch. | | planifest-zero |
| Position | Position is the `position` field of `roadmap.md` that names the next step to run. The driver stops when a step ends without moving it. | | planifest-zero |
| Bump | A bump is the `Bump` value of a step: `major`, `minor`, or `patch`, with `minor` as the default. At each step's P0, the agent applies it to the roadmap branch's version. | | planifest-zero |
| Roadmap branch | The roadmap branch is `roadmap/{id}-{slug}`, cut from `main` by R-B Activate. Each step branch starts from it, and each green step squash-merges back into it. | | planifest-zero |
| Current roadmap | The current roadmap is the folder `plan/current-roadmap/`, which holds the active roadmap's `roadmap.md`. The folder exists only while a roadmap is active, and R-E Delivery archives it. | | planifest-zero |
| R-A Chart | R-A Chart is the stage that charts a roadmap from an idea or a draft. The human's confirmation approves the whole chain, and the stage runs on `main`. | | planifest-zero |
| R-B Activate | R-B Activate is the stage that cuts the roadmap branch and writes the current roadmap with `status: active`. It then offers to start the driver. | | planifest-zero |
| R-C Run | R-C Run is the stage that runs one step from P0 to P4 on a feature branch. P0 confirms the step's design and scope lock itself, and the step stops only when an entry is too vague to draft from. | | planifest-zero |
| R-D Advance | R-D Advance is the stage that raises the step PR to the roadmap branch, then squash-merges it after green CI. It then tags the squash commit and pushes the tag. | | planifest-zero |
| R-E Delivery | R-E Delivery is the stage that runs after the last step. It archives `plan/current-roadmap/` and raises the roadmap PR to `main`. | | planifest-zero |
| Driver | The driver is `planifest-zero/scripts/roadmap-run.mjs`, which runs each step in a fresh `claude -p` session. It prints one line per stage, so a parent session can stream it. | | planifest-zero |
| Runner lock | The runner lock is the file `plan/.roadmap-runner.lock`. The driver takes it before the first step and refuses to start while it exists. It releases the lock after R-E Delivery. | | planifest-zero |
| Merge-guard | Merge-guard is a PreToolUse hook on Bash. It blocks `gh pr merge` unless the PR base is `roadmap/*` and the flag is `--squash`. | | planifest-zero |
| Roadmap PR | The roadmap PR is the pull request from the roadmap branch to `main`, raised by R-E Delivery. Its body asks for a merge commit, and the human merges it. | | planifest-zero |
