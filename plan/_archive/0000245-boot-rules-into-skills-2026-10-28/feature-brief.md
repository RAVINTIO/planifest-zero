---
title: "Feature Brief - boot rules into skills"
summary: "Shrinks the generated CLAUDE.md to 6,000 bytes or fewer by moving task-bound rules into skills and a reference file."
status: "approved"
version: "0.1.0"
---
# Feature Brief - boot rules into skills

**Feature ID:** 0000245-boot-rules-into-skills

Source: backlog entry 0000222, pulled in by initiative 0000238 step 7. The entry folder is deleted in this run's first commit after the brief.

## Business Goal

Every session loads the whole `CLAUDE.md`, which holds 10,317 bytes in this repo. Many rules apply to one task only. The generated file drops to 6,000 bytes or fewer, with every current override still in force.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Hook Enforcement reference | As a maintainer, I read the hook rules from one reference file, so that the boot file stays small. | must-have | 1 |
| Targeted overrides | As a repo owner, I name a pack skill in an override, so that setup appends the rule to that skill and not to the boot file. | must-have | 1 |
| Repo skills for task rules | As a human, I run `/gutd`, so that the sync rule loads only on demand. | must-have | 1 |
| Separate boot file cap | As a maintainer, I see a test cap the generated `CLAUDE.md` at 6,000 bytes, so that overrides cannot regrow it. | must-have | 1 |

## Wanted outcome

- The generated `CLAUDE.md` is 6,000 bytes or fewer.
- An override that targets a pack skill appears in that installed skill and not in `CLAUDE.md`.
- A repo capability skill installs to `.claude/skills/` with its description intact.
- Setup installs `.claude/skills/gutd/SKILL.md`, and `CLAUDE.md` no longer holds the GUTD rule.
- Each hook block message names the Hook Enforcement reference file.
