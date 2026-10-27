# Changelog (0000198-cap-echoed-plan-text, 27 Oct 2026)

**Feature:** cap echoed plan text
**Version:** 0.20.2
**PR:** #41

## What changed

- The `ratchet-check` block message cuts each `removed:` line to 200 characters and appends ` …[truncated]` if it cut the line.
- The consistency check cuts the story map row label to 200 characters in the two findings that echo it, with the same marker.
- Both cuts count code points, so an astral character stays whole.
- A new suite covers a long line, a line at the cap, a short line, an astral boundary, the exit codes, and parity between the two programs.
- The architecture overview, the pipeline reference, and the component manifest describe the cap.

## Why

The 0000170 security review rated two findings low. A long or hostile plan line reached the agent's context unchanged through the ratchet block message and the consistency check. Backlog entry 0000176 asked for the cap.

## Deviations

- No existing test asserted an uncapped line, so none changed.
- The installed hook copy under `.claude/hooks/enforcement/` stays uncapped until setup refreshes it. Step 13 of initiative 0000195 reruns setup.

## Validation results

172 feature suites and 19 regression suites pass. The consistency check is clean. The programs' exit codes and block sets are unchanged.

## Skipped phases

None.
