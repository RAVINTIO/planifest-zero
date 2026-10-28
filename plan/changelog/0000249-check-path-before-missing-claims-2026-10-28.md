# Changelog (0000249-check-path-before-missing-claims, 28 Oct 2026)

**Feature:** PATH check before a missing-program claim
**Version:** 0.38.0
**PR:** pending

## What changed

- `ravintio-validate-and-accept/SKILL.md` tells the agent to run `command -v {program}` before a report says a program is missing. It then names the common install folders `/opt/homebrew/bin`, `/usr/local/bin`, and `~/.local/bin`, and asks the report to list each command it ran (entry 0000233).
- The skill's outcomes list gains `unverified (docs only)` for a claim that rests on documentation alone. The outcome never counts as `verified`.
- Item 4 of the Acceptance gate asks for the `PATH` check commands and each unverified claim by name.
- One test: `test-0000249-req-001-path-check-and-docs-only-status.sh`.
- `docs/architecture-overview.md` and `component.yml` describe the change.

## Why

In initiative 0000195, step 12 reported that no Codex program was available, though `/opt/homebrew/bin/codex` existed. It also marked a docs-only claim `verified`. Step 14 ran the real program, found the claim false, and had to rise from a patch to a minor bump.

## Deviations

None.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
