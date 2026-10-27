# Changelog (0000199-reserve-ids-from-counter, 27 Oct 2026)

**Feature:** reserve ids from a counter
**Version:** 0.21.0
**PR:** #42

## What changed

- `ravintio-zero/scripts/reserve-id.mjs [qty] [--file path] [--init]` reserves a block of ids from `plan/backlog/.next-id` under an exclusive lock and prints one id per line.
- `plan/backlog/.next-id` ships seeded at `0000210`.
- A held lock, a malformed or symlinked counter, and a bad quantity each exit 1 and leave the counter unchanged. `--init` creates a missing counter from the highest id in the plan folders.
- The file-backlog skill, the orchestrator's backlog pickup, both templates, `roadmap-standards.md`, and `agent-dispatch-standards.md` reserve ids from the counter. None states the folder-scan rule.
- A copied entry reserves a local id and names its source id in the text.
- The docs state the conflict answer: keep the higher value and renumber the branch that merges second.
- A new suite covers the script and the docs.

## Why

The folder scan missed ids on other branches, ids that pickup deleted, and ids that a copy carried from another repo. Backlog id 0000026 appears twice in each repo's history. Backlog entry 0000183 asked for a counter.

## Deviations

- Four existing suites asserted the old wording and now assert the counter: 0000025, 0000043, 0000151, and 0000164. The 0000151 suite applies a base-line rewrite for the pickup line, as 0000171 did.
- The plan split into three requirements instead of two, because the consistency check allows three acceptance criteria for each requirement.
- The installed skill copies under `.claude/skills/` keep the old rule until step 13 of initiative 0000195 reruns setup.

## Validation results

173 feature suites and 19 regression suites pass. The consistency check and the self-description check are clean. Eight concurrent reservations returned 24 different ids.

## Skipped phases

None.
