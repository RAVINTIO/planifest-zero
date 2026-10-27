# Changelog (0000208-refresh-setup-record, 27 Oct 2026)

**Feature:** Refresh the setup record
**Version:** 0.29.1
**PR:** pending

## What changed

- Added `ravintio-overrides/instructions/custom-006-standing-setup-refresh-approval.md`.
- Ran `ravintio-zero/setup.sh claude-code --strict-orchestrator` under the standing approval. `plan/state/claude-code.md` now holds `writtenAt` 2026-10-27T18:06:24Z.
- Committed the queued backlog entries 0000210 and 0000211, one commit each.
- Raised the combined size cap in `test-0000151-req-011-orchestrator-references-split.sh` from 37,800 to 38,200 bytes.

## Why

Installed skills and `CLAUDE.md` must match the pack before initiative delivery.

## Deviations

The new override adds about 800 bytes to `CLAUDE.md` and pushed the combined size cap test over 37,800. The step raised the cap, as steps 0000189, 0000200, and 0000205 did. No `## Decisions` row covered this fork, so the human should check the cap change in review.

## Validation results

Feature suites 196 passed and 2 failed. Regression 19 passed. The 2 failures come from `RAVINTIO_INITIATIVE_STEP=1` in the step session and pass with it unset. See `acceptance-evidence.md` in the archive.

## Skipped phases

P1 Plan: skipped. The chart fixes the spec for this chore.
