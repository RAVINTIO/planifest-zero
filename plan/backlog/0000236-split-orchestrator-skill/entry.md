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

Three of the kept sections still hold detail that applies only at one moment:

| Detail | Bytes | Needed when |
|--------|-------|-------------|
| Resume Detection, all 12 checks in full | about 3,900 | only when a check finds its signal |
| Initiative stage prefixes block | 1,093 | only in an initiative, and `CLAUDE.md` Reply Conventions already lists the prefixes |
| Pack Index template rows | 961 | only before writing that artifact |

## Suggested Action

- Keep in `SKILL.md`: the preamble, Hard Limits, the P0 to P4 prefix table and status form, a short Resume Detection list, the Pack Index, Context Hygiene, Subagent Dispatch, and a short P0 intro.
- Move the six task-bound sections into new files under `references/`, each with the `orchestrator-` prefix. Move each line verbatim, as feature 0000151 did.
- Cut Resume Detection to the short rule from backlog entry 0000237. A session start script reports the signals, and the agent reads `references/orchestrator-resume-detection.md` for each one it acts on. Entry 0000237 owns the script, the hook change, and the reference file.
- Move the initiative stage prefixes block to `ravintio-zero/standards/roadmap-standards.md`. Keep one line in `SKILL.md` that says the I-A to I-E prefixes exist and where they live.
- Replace the template rows of the Pack Index with one rule: before you write an artifact, read `ravintio-zero/templates/{artifact}.template.md`. Keep the rows that do not follow that pattern, such as roadmap standards and the loop runner.
- Add a Pack Index row for each new reference file, with a trigger that names the moment to read it. Examples are "Before a fresh P0 start" and "Before you invoke P1, P2, P3, or P4".
- Update `test-0000151-req-011-orchestrator-references-split.sh`:
  - Set the `SKILL.md` cap to 9,000 bytes.
  - Move the moved headings from case (b) "keeps the heading" into the "now lives in a reference file" list.
  - Keep the no-lost-line check against the base fixture.
- Update each test that greps `SKILL.md` for a moved line to read `SKILL.md`, `references/`, and the roadmap standards together. On 2026-10-27, 38 suites in `ravintio-zero/tests/` read `SKILL.md`. Backlog entry 0000210 asks plan to list such tests up front.

**Target of 9,000 bytes.** The estimate comes to about 7,800 bytes:

| Change | Bytes |
|--------|-------|
| Kept sections | 11,930 |
| Resume Detection cut to the 0000237 rule | about -3,900 |
| Initiative prefixes moved | about -940 |
| Template rows replaced by one rule | about -760 |
| New Pack Index rows | about +700 |
| **Estimate** | **about 7,030** |

The 9,000 target leaves about 1,970 bytes of headroom. A new rule larger than that belongs in a reference file.

**Dependency.** Run backlog entry 0000237 first. Without it, Resume Detection must stay at one line per check, about 1,200 bytes, and the estimate rises to about 7,830.

**Not in scope.** This entry covers `SKILL.md` and its own cap only.

- Backlog entry 0000214 owns the combined `CLAUDE.md` plus `SKILL.md` cap, and how it counts overrides. This entry leaves that assertion alone.
- Backlog entry 0000222 owns the size and content of `CLAUDE.md`.

## Wanted outcome

The orchestrator core loads in under a third of its current bytes, with no rule lost. Tests check these conditions:

- `SKILL.md` is 9,000 bytes or fewer, and `test-0000151-req-011-orchestrator-references-split.sh` asserts that cap.
- Every non-blank, non-heading line of the base fixture is in `SKILL.md`, a `references/orchestrator-*.md` file, or `roadmap-standards.md`.
- Each moved section's heading appears in exactly one reference file, and not in `SKILL.md`.
- The Pack Index has one row for every file in `references/`, and each row names its trigger.
- `SKILL.md` keeps the headings Hard Limits, Phases and Response Prefixes, Resume Detection, and Pack Index (JIT Loading).
- Setup installs every new reference file, and each installed copy matches its source.
- The full test suite passes with no other cap raised.

## Why Deferred

The human asked for it at initiative 0000195 delivery, then lowered the target from 13,000 to 9,000 bytes. It depends on backlog entry 0000237 and pairs with entries 0000214 and 0000222, which cover the combined cap and `CLAUDE.md`.
