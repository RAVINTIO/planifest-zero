---
title: "Postmortem: 2026-10-31 - step 4 content test failed on a coordinator entry"
summary: "A blameless record of why a failure got through earlier phases, and the actions that close the gap."
status: "open"
---
# Postmortem: 2026-10-31 - step 4 content test failed on a coordinator entry

**Trigger:** Blocked stop
**Feature:** 0000242-size-cap-excludes-overrides (initiative 0000238, step 4)
**Date:** 2026-10-31

## Summary

Step 4 stopped in P2, because `test-0000042-req-010` failed on a backlog entry that the step didn't write. The step waited about five hours for the human, from the driver restart until 13:13 UTC.

## Timeline

| Time | Event | Evidence |
|------|-------|----------|
| 2026-10-28 07:33 | The coordinator commits entry 0000257 directly on the initiative branch. Line 38 uses a word that the req-010 allowlist test blocks. | `05abbb9` |
| 2026-10-28 07:45 | The initiative reactivates after the planned restart | `723697a` |
| 2026-10-28 07:47 | Step 4 starts | archived `build-log.md` line 40 |
| 2026-10-28 07:48 | P2 starts. The full suite fails on `plan/backlog/0000257-timestamp-reply-prefixes/entry.md:38`. | archived `build-log.md` lines 69 and 78 |
| 2026-10-28 13:13 | The human approves a reword. The coordinator commits it and the step takes it in. | `f2838fa`, archived `build-log.md` line 79 |
| 2026-10-28 13:20 | P2 completes | archived `build-log.md` line 80 |

The archived build log is `plan/_archive/0000242-size-cap-excludes-overrides-2026-10-28/build-log.md`. Its `Blocked:` line has no time of its own.

First missed chance to catch it: `05abbb9`. A test run or CI on that change would have failed.

## 5 whys

1. Why did step 4 stop? `test-0000042-req-010` failed on a file outside the step's scope.
2. Why was that file on the initiative branch? The coordinator committed entry 0000257 straight to the branch.
3. Why did no test run on that commit? Direct commits on `initiative/*` bypass CI, and the `commit-msg` hook checks only the message.
4. Why did the coordinator commit directly? The initiative skill tells it to commit queued entries on the initiative branch.
5. Why does that matter for every later step? Each step inherits the initiative branch and runs the full suite, so the first step after a bad direct commit pays for it.

**Gap:** coordinator commits reach `initiative/*` without CI or a test run.

## Actions

| Type | Action | Owner | Lives in | Verified by | Filed as |
|------|--------|-------|----------|-------------|----------|
| preventive | Route coordinator work through a titled PR into `initiative/*`, so CI runs the suite before it lands | roadmap standards, initiative skill | `ravintio-zero/standards/roadmap-standards.md` | skill text tests, CI on the chore PR | backlog entry 0000274 |
