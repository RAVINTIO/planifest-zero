# Changelog (0000245-boot-rules-into-skills, 28 Oct 2026)

**Feature:** Move boot file rules into skills
**Version:** 0.34.0
**PR:** #62

## What changed

- The generated `CLAUDE.md` in a repo with this repo's overrides falls from 10,317 to 4,701 bytes. A test caps it at 6,000 bytes.
- `ravintio-zero/standards/hook-enforcement.md` holds the Hook Enforcement rules. Both boot templates point to it, and the four blocking hooks and the `commit-msg` hook name it in their messages.
- An override with `target: {skill}` in its frontmatter is appended to that installed skill. A missing or malformed target warns and falls back to the boot file. `setup.sh` and `setup.ps1` behave the same.
- Overrides 002, 004, and 006 now target `ravintio-orchestrator`, `ravintio-ship`, and `ravintio-refresh-setup`.
- The `gutd` and `delete-redundant-branches` capability skills replace overrides 003 and 005.
- The combined cap in `test-0000151-req-011` is now two caps. The boot template has a 3,600 byte cap and `SKILL.md` keeps 9,000.
- `test-0000151-req-014` ignores an appended override block when it compares installed skills with the pack.
- `docs/` and `pipeline-reference.md` describe the `target:` field and the reference file.

## Why

Every session loaded all of `CLAUDE.md`, though many rules serve one task. Backlog entry 0000222 asked for 6,000 bytes or fewer.

## Deviations

- `design.md` gained a `## Component Paths` section, because `gate-write` blocked writes to the paths the plan names.
- Suites 0000009, 0000164, 0000200, and 0000207 now read the hook text from the reference file.
- This repo's own `CLAUDE.md` and `.claude/skills/` stay as they are. Step 15 regenerates them.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
