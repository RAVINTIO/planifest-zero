# Changelog (0000243-session-start-detection, 28 Oct 2026)

**Feature:** Session start detection
**Version:** 0.32.0
**PR:** pending

## What changed

- `ravintio-zero/scripts/resume-detect.mjs` prints one fixed line per Resume Detection signal, in check order, and `no resume signals` when it finds none. It prints no repo text.
- `auto-trigger-orchestrator.mjs` runs the script with a 2 second timeout and injects the lines with the load instruction. A failed run injects `resume detection did not run`.
- The Resume Detection section of the orchestrator `SKILL.md` falls from 4,291 to 339 bytes. The 12 checks live in `references/orchestrator-resume-detection.md`.
- The initiative skill reads the same findings, including the driver lock and the position.
- Ten older tests now read the Resume Detection text from `SKILL.md` and the reference.

## Why

The orchestrator carried out 12 checks by hand from a 4,291-byte section, and no test covered that reading. Backlog entry 0000237 asked for a tested list. Step 6 needs the space it frees.

## Deviations

- The mutation check in the size test now grows the pack by the remaining margin plus one byte, because `SKILL.md` shrank. The cap is unchanged.
- The `step session` finding appears only in a step session, so the two sessions differ by that one line.
- Check 4 and the `plan/current has artifacts` finding can't appear together. The order test uses a second fixture for check 4.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
