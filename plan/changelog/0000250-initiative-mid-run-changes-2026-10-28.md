# Changelog (0000250-initiative-mid-run-changes, 28 Oct 2026)

**Feature:** Initiative mid-run changes
**Version:** 0.39.0
**PR:** #68

## What changed

- `initiative-run.mjs` compares the initiative branch ref before and after each step. If the merged step changed `initiative-run.mjs`, `initiative-watch.mjs`, or `ravintio-initiative/SKILL.md`, the driver prints `I-D Advance: Restart:` with the changed files, releases the lock, and exits 1 (entry 0000227). A step that changes none of them gives no restart.
- `ravintio-initiative/SKILL.md` treats a `Restart:` line as a restart and not a failure. It starts a new driver and a new watcher without asking.
- The skill gains a Repo instructions during a run section. A repo instruction that the human asks for mid-run goes into the scope of the current or next pending step in `initiative.md`. The skill never writes the override itself, so `gate-write` stays as it is (entry 0000226).
- `roadmap-standards.md` holds both rules.
- Two tests: `test-0000250-req-001-routing-and-restart-rules.sh` and `test-0000250-req-002-driver-restart-stop.sh`.
- `docs/architecture-overview.md` and `docs/dependency-graph.md` describe the change.

## Why

Initiative 0000195 step 10 changed the driver, the watcher, and the initiative skill, and the old driver ran steps 11 to 15 on its launch code. In step 13, the human's repo instruction had no route, so the initiative session tried a write that `gate-write` blocked.

## Deviations

None. The running driver predates this change, so it does not stop after this step. The human restarts the driver and the watcher to load the new code.

## Validation results

See `acceptance-evidence.md` in the archive.

## Skipped phases

None.
