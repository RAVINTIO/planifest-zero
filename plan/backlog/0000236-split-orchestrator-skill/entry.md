---
title: "Backlog Entry: 0000236 - split the orchestrator skill into a short core and reference files"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000236 - split the orchestrator skill into a short core and reference files

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-27

---

## Problem

`ravintio-zero/skills/ravintio-orchestrator/SKILL.md` is too big. Every session that loads the orchestrator reads all of it, whatever the task. On 2026-10-27 the installed copy held 27,779 bytes. The size test `ravintio-zero/tests/test-0000151-req-011-orchestrator-references-split.sh` caps it at 27,800 bytes, so 21 bytes of headroom remain. Steps 0000200 and 0000205 each raised that cap.

Feature 0000151 already moved eight rarely used sections into `references/`. The rest stayed inline, including long procedures that apply only at one moment in a run. Sizes measured on 2026-10-27:

| Section | Bytes | Needed in every session? |
|---------|-------|--------------------------|
| Frontmatter and preamble | 622 | yes |
| Hard Limits | 1,903 | yes |
| Phases and Response Prefixes | 2,058 | yes |
| Resume Detection | 4,296 | yes |
| Pack Index (JIT Loading) | 2,059 | yes |
| Context Hygiene | 381 | yes, short |
| P0: Discovery, heading and intro | 254 | yes, as a pointer |
| How You Coach | 1,442 | no, P0 coaching only |
| Discovery Start Actions | 5,505 | no, fresh P0 start only |
| Discovery Gate Checklist | 1,355 | no, P0 gate only |
| Design Confirmation | 1,719 | no, P0 gate only |
| Phase Invocation (P1 to P4) | 3,193 | no, phase transitions only |
| Exception Stops | 2,635 | no, on a stop only |
| Subagent Dispatch | 357 | yes, short |
| **Total** | **27,779** | |

The sections every session needs come to 11,930 bytes. The six task-bound sections come to 15,849 bytes, 57% of the file.

## Suggested Action

- Keep in `SKILL.md`: the preamble, Hard Limits, Phases and Response Prefixes, Resume Detection, the Pack Index, Context Hygiene, Subagent Dispatch, and a short P0 intro.
- Move the six task-bound sections into new files under `references/`, each with the `orchestrator-` prefix. Move each line verbatim, as feature 0000151 did.
- Add a Pack Index row for each new file, with a trigger that names the moment to read it. Examples are "Before a fresh P0 start" and "Before you invoke P1, P2, P3, or P4".
- Update `test-0000151-req-011-orchestrator-references-split.sh`:
  - Set the `SKILL.md` cap to 13,000 bytes.
  - Move the moved headings from case (b) "keeps the heading" into the "now lives in a reference file" list.
  - Keep the no-lost-line check against the base fixture.
- Update each test that greps `SKILL.md` for a moved line to read `SKILL.md` and `references/` together. On 2026-10-27, 38 suites in `ravintio-zero/tests/` read `SKILL.md`. Backlog entry 0000210 asks plan to list such tests up front.

**Target of 13,000 bytes.** The kept sections measure 11,930 bytes. Six new Pack Index rows add about 600 bytes, for about 12,530. The 13,000 target leaves about 470 bytes of headroom for one or two new rules. A rule larger than that belongs in a reference file.

**Not in scope.** This entry covers `SKILL.md` and its own cap only.

- Backlog entry 0000214 owns the combined `CLAUDE.md` plus `SKILL.md` cap, and how it counts overrides. This entry leaves that assertion alone.
- Backlog entry 0000222 owns the size and content of `CLAUDE.md`.

## Wanted outcome

The orchestrator core loads in under half its current bytes, with no rule lost. Tests check these conditions:

- `SKILL.md` is 13,000 bytes or fewer, and `test-0000151-req-011-orchestrator-references-split.sh` asserts that cap.
- Every non-blank, non-heading line of the base fixture is in `SKILL.md` or a `references/orchestrator-*.md` file.
- Each moved section's heading appears in exactly one reference file, and not in `SKILL.md`.
- The Pack Index has one row for every file in `references/`, and each row names its trigger.
- `SKILL.md` keeps the headings Hard Limits, Phases and Response Prefixes, Resume Detection, and Pack Index (JIT Loading).
- Setup installs every new reference file, and each installed copy matches its source.
- The full test suite passes with no other cap raised.

## Why Deferred

The human asked for it at initiative 0000195 delivery. It pairs with backlog entries 0000214 and 0000222, which cover the combined cap and `CLAUDE.md`.
