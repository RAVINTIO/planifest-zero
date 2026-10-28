# Changelog (0000244-split-orchestrator-skill, 28 Oct 2026)

**Feature:** Split the orchestrator skill
**Version:** 0.33.0
**PR:** pending

## What changed

- The orchestrator `SKILL.md` falls from 23,912 to 7,985 bytes. The cap in test 0000151 req-011 falls from 27,800 to 9,000 bytes.
- Five new files under `skills/ravintio-orchestrator/references/` hold How You Coach, Discovery Start Actions, the Discovery Gate Checklist and Design Confirmation, Phase Invocation, and Exception Stops. Each moved line is unchanged.
- The initiative stage prefix block moved to `ravintio-zero/standards/roadmap-standards.md`. `SKILL.md` keeps one pointer line.
- The Pack Index holds one rule for template reads and one row per reference file with its trigger.
- 29 feature suites, 3 regression suites, and the `orch_combined` helper now read `SKILL.md`, the references, and the roadmap standards together.
- `docs/architecture-overview.md` describes the new layout.

## Why

Every session read all of `SKILL.md`, though six sections applied at one moment of a run. Backlog entry 0000236 asked for a core of 9,000 bytes or fewer.

## Deviations

- The combined `CLAUDE.md` plus `SKILL.md` cap fell from 32,800 to 15,000 bytes, because the size test measures both. The entry named the `SKILL.md` cap only. Entry 0000222 owns the `CLAUDE.md` share.
- `test-0000171-req-006` skips a token with `{`, because the `{artifact}` placeholder in the Pack Index rule is not one path.
- The move needed no new tests beyond the size test, which gained template rule and prefix checks.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
