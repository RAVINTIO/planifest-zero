# Build Report (0000038-setup-hook-filter-fixes, 19 Oct 2026)

Source: `build-log.md` in this archive. Figures the log does not record are marked "not captured".

## Model usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary | claude-opus-5-5 | P1, P3, P4, P5 (orchestrator), P3 (subagents) | 2 subagents |
| Cheaper | claude-sonnet-5-5 (from subagent notes) | P2, P4 | 3 subagents |

The header names `claude-haiku-5-5` as the cheaper model. The P2 subagent note records `claude-sonnet-5-5` at the cheaper tier. The P4 note records the security subagent as `claude-sonnet-5-5`. The header value is stale for this run.

## Skills invoked

| Phase | Skills | Load pattern |
|-------|--------|-------------|
| P1 Discovery | planifest-orchestrator | Session start, read from `planifest-zero/skills/` |
| P2 Plan | planifest-plan | Phase load |
| P3 Implement | planifest-implement, planifest-test-writer, planifest-implementer, planifest-refactor | Phase load. The TDD skills ran inside the two subagents. |
| P4 Validate and Accept | planifest-validate-and-accept | Phase load |
| P5 Ship | planifest-ship | Phase load |

## Subagent dispatch and parallelism

| Phase | Count | Purpose | Parallel |
|-------|-------|---------|----------|
| P1 | 0 | Not applicable | No. The Scope Lock entries carry `draft-accepted`, but the log records no draft subagents. |
| P2 | 2 | Scope, risk register, glossary, and ADRs | Yes, 1 batch, beside the orchestrator's requirements |
| P3 | 2 | One per script: `setup.sh` and `setup.ps1` | Yes, 1 batch |
| P4 | 1 | Security review | Yes, beside verification and CI |
| P5 | 0 | Not applicable | No. The ship steps depend on each other. |

P3 split the work by script rather than by requirement. Both requirements change the same filter in each script, so a split by requirement would have put two agents on one file.

## Self-corrections

| Phase | Count | Avoidable | Notes |
|-------|-------|-----------|-------|
| P2 | 1 consistency rerun | Yes | The first consistency check found 3 issues: too many criteria on both requirements, and a cross-feature ADR reference. The second run was clean. |
| P3 | 1 cross-agent fix | Yes | The runner pre-flight rejected the shared fixture files. The `setup.sh` subagent added them to `KNOWN_NON_SUITES`. |
| P4 | 0 | Not applicable | CI run 1 failed on the same fixture files, but commit `0b36659` had already fixed it. The log does not count it as a P4 self-correction. |

## Improvement suggestions

- P1: if Scope Lock drafts come from subagents, log their count. The `draft-accepted` source tag implies drafts, but the phase block records 0 agents.
- P2: check criteria counts against the requirement template before the first consistency run.
- P3: when a feature adds fixture files, tell each subagent to register them with the runner pre-flight up front.
- P4: `pwsh` is not installed locally, so only CI proved the `.ps1` side. Installing it would shorten the loop.
- All phases: update the header's cheaper model to the model the subagents use.
