# Discovery - 0000251-driver-step-fixes

## Header (all modes)

| Field | Value |
|-------|-------|
| Adoption mode detected | `standard-iterative` |
| Detection signal | Archived runs in `plan/_archive/` beside source in `ravintio-zero/` |
| Git pre-flight | Branch `feat/0000251-driver-step-fixes`, cut from `initiative/0000238-backlog-clearance-two` (step session, no main check) |
| Skills inbox | Empty |

## Mode Findings

### Standard Iterative

- Current version (`docs/about.md`): `0.39.0`.
- Prior features: 0000248, 0000249, 0000250, all archived 2026-10-28.
- Component map: one component, `ravintio-zero`.
- Backlog entries: 0000229 and 0000235.
  - 0000229: `initiative-run.mjs` sets `RAVINTIO_INITIATIVE_STEP=1` in every step session. Tests inherit it and hook tests fail. Neither `run-tests.sh` nor `run-tests.ps1` clears it.
  - 0000235: `openLog` in `initiative-run.mjs` opens `step-{n}.log` with `O_TRUNC`, so a re-run destroys the earlier attempt's log.
- Files in play: `ravintio-zero/tests/run-tests.sh`, `ravintio-zero/tests/run-tests.ps1`, `ravintio-zero/scripts/initiative-run.mjs`, `ravintio-zero/standards/roadmap-standards.md`, `ravintio-zero/tests/test-0000151-req-012-roadmap-step-logs.sh`.
- This session runs with `RAVINTIO_INITIATIVE_STEP=1`, so the suite hits the 0000229 fault. Decisions row 2 says to rerun a failing hook suite with the variable unset and to log the rerun.
- Constraint from the initiative: no step may widen `merge-guard`, `gate-write`, or another fail-closed hook.
- The running driver loaded its code at activation. Step 13 changes `initiative-run.mjs`, so the restart stop from step 12 applies only to a driver that has step 12's code.
- Version: the chart sets a patch bump, so 0.39.1.

## Past retrospectives

- 0000195: the source retrospective for both entries.
