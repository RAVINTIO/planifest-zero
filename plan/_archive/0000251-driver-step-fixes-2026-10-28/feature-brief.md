---
title: "Feature Brief - driver step fixes"
summary: "Clears the step variable in both test runners and keeps every attempt's step log when the driver re-runs a step."
status: "approved"
version: "0.1.0"
---
# Feature Brief - driver step fixes

**Feature ID:** 0000251-driver-step-fixes

Source: backlog entries 0000229 and 0000235, pulled in by initiative 0000238 step 13. Both entry folders are deleted in the commit that adds this brief.

## Business Goal

Two faults in the step environment cost evidence and time. A step session passes `RAVINTIO_INITIATIVE_STEP=1` to every test it runs, so hook tests see a step session they did not expect and fail. The driver also truncates `step-{n}.log` when it re-runs a step, so the first attempt's stop text is lost. Both test runners clear the variable. The driver keeps each earlier attempt's log under a numbered name.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Clear the step variable in both runners | As a maintainer, I run the full suite inside a step session and see the same result as outside it, so that I do not rerun suites by hand. | must-have | 1 |
| Keep each attempt's step log | As a maintainer, I see the log of every earlier attempt after the driver re-runs a step, so that a retrospective can quote the first stop. | must-have | 1 |
| Name the attempt logs in a stop line | As a maintainer, I see the earlier attempt logs named in the driver's stop line, so that I find them without listing the folder. | should-have | 1 |

## Wanted outcome

- `RAVINTIO_INITIATIVE_STEP=1 bash ravintio-zero/tests/run-tests.sh` passes every suite that passes with the variable unset.
- The same holds for `run-tests.ps1` with `$env:RAVINTIO_INITIATIVE_STEP = '1'`.
- A probe suite run through each runner sees the variable as unset.
- A step that runs twice leaves `step-1.attempt-1.log` with the first output and `step-1.log` with the second.
- A step that runs three times leaves `attempt-1` and `attempt-2` files and a current `step-1.log`, each with its own output.
- An attempt file has mode 600, and a symlink at an attempt path stops the driver with the symlink refusal.
- A step that runs once leaves only `step-1.log`.

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Holds the driver, both test runners, the roadmap standards, and the tests |

### Data Ownership

No data store. The component owns the pack files and the git-ignored log folder `plan/.initiative-logs/`.

### Integration Points

None new. The driver keeps its `git` calls and its `claude -p` spawn as they are.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Node.js with no dependencies for the driver. Bash and PowerShell for the runners. Bash tests |
| Testing | Bash suites under `ravintio-zero/tests/` |
| CI | GitHub Actions, already configured |
| Build target | local |

## Scope Boundaries

### In Scope
- `unset RAVINTIO_INITIATIVE_STEP` in `run-tests.sh` and the matching removal in `run-tests.ps1`, before any suite starts.
- A rotation step in `openLog` of `initiative-run.mjs` that renames an existing `step-{n}.log` to the next free `step-{n}.attempt-{k}.log`.
- The same symlink refusals and modes for attempt files: folder 700, file 600.
- Attempt logs named in the driver's stop line.
- The new rule in the driver header, `roadmap-standards.md`, and `test-0000151-req-012-roadmap-step-logs.sh` case (a).
- New tests, docs, changelog, and the version bump to 0.39.1.

### Out of Scope
- What the driver writes into the log while a step runs (backlog entry 0000219, done in step 2).
- A cap on the number of attempt logs, or pruning of old attempts.
- Any change to `merge-guard`, `gate-write`, or another fail-closed hook.
- Removing the per-suite `env -u RAVINTIO_INITIATIVE_STEP` calls in the two step 15 suites. They may stay.

### Deferred
- Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Log privacy | Attempt folder mode 700 and attempt file mode 600 | the driver test |
| Skill text | 1,720 lines or fewer across all pack skills | `test-0000031-req-003-five-phases.sh` |

## Constraints and Assumptions

### Constraints
- No change to `merge-guard`, `gate-write`, or another fail-closed hook.
- No new library or service.
- The driver stays dependency-free and never uses a shell.

### Assumptions
- Renaming a file keeps its mode, so an attempt file keeps mode 600. Impact if wrong: the rotation sets the mode again.
- A suite that needs the variable sets it for its own hook call. Impact if wrong: the suite fails once the runner clears the variable, and the step adds the setting to that suite.

## Scenario Paths

**Happy path:** The driver re-runs step 1 after a first attempt stopped.

> The driver renames `step-1.log` to `step-1.attempt-1.log`, opens a fresh `step-1.log`, and the second run writes there. Both logs hold their own output.

**Alternative path:** The driver runs a step for the first time, or a runner starts a suite from a shell where the variable is unset.

> No attempt file appears. The runner's `unset` changes nothing.

**Error / sad path:** A symlink sits at the next attempt path, at the step log, or at the log folder.

> The driver stops with `I-C Run: Blocked: refused a symlinked step log path` and renames nothing.

**Cross-session continuity:** A new driver starts after a stop, and earlier attempt files exist.

> The driver counts the existing attempt files and uses the next free number. No state carries across except the files.

## Acceptance Criteria

- [ ] `RAVINTIO_INITIATIVE_STEP=1 bash ravintio-zero/tests/run-tests.sh` gives the same pass and fail result as a run with the variable unset, and a probe suite sees the variable as unset.
- [ ] `run-tests.ps1` clears the variable the same way, and a probe suite sees it unset.
- [ ] A step that runs twice leaves `step-1.attempt-1.log` with the first output and `step-1.log` with the second. A step that runs three times leaves both attempt files and a current log, each with its own output.
- [ ] An attempt file has mode 600, and a symlink at an attempt path stops the driver with the symlink refusal.
- [ ] A step that runs once leaves only `step-1.log`, and a stop line names every attempt log that exists.
