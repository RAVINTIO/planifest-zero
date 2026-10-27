# Acceptance evidence - 0000208-refresh-setup-record

| Criterion | Evidence |
|-----------|----------|
| `custom-006` holds the exact text | File written from `initiative.md`, a script extracted the fenced block |
| `writtenAt` later than step 12 | `plan/state/claude-code.md` holds `2026-10-27T18:06:24Z` |
| `CLAUDE.md` holds the approval | `grep -c` finds the heading once |
| Queued entries committed | Commits 1c06bd7 (0000210) and 16e3afb (0000211) |

Test run: feature suites 196 passed and 2 failed, regression 19 passed. The two failures were the hook ack tests, which read `RAVINTIO_INITIATIVE_STEP=1` from the step session. With the variable unset, that file passes 32 of 32. The size cap test failed at 38,096 bytes and passes after the cap rose to 38,200.
