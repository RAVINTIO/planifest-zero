# Changelog (0000242-size-cap-excludes-overrides, 28 Oct 2026)

**Feature:** Size cap excludes overrides
**Version:** 0.31.2
**PR:** pending

## What changed

- The size cap test in `test-0000151-req-011-orchestrator-references-split.sh` measures `CLAUDE.md` without the block between the `ravintio-overrides:instructions` markers.
- The combined cap is now 32,800 bytes of pack content. The pack-only sum was 32,697 bytes, so the margin is 103 bytes.
- Two new checks show that a 5,000 byte override block leaves the measure unchanged and that 104 extra pack bytes fail the cap.

## Why

Each new override in `ravintio-overrides/instructions/` counted against the cap, so adding one could fail a pack test. Initiative 0000195 step 13 raised the cap to 38,200 to absorb one override. Backlog entry 0000214 asked for a lasting fix.

## Deviations

- The TDD loop ran inline because one test file holds every change.
- U-002 found no docs that name the cap, so it changed nothing.
- P2 stopped for a pre-existing wording failure in backlog entry 0000257. The human approved the reword in f2838fa.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
