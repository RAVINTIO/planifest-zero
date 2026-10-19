# Build Report (0000039-setup-hardening-release-sizing, 19 Oct 2026)

Source: `build-log.md` in this archive. Figures the log does not record are marked "not captured".

## Model usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary | claude-opus-5-5 | P1 to P5 (orchestrator), P3 (subagents) | 3 subagents |
| Cheaper | claude-sonnet-5-5 | P2, P4 | 4 subagents |

The header now names `claude-sonnet-5-5` as the cheaper model, which matches the subagent notes.

## Skills invoked

| Phase | Skills | Load pattern |
|-------|--------|-------------|
| P1 Discovery | planifest-orchestrator | Session start, read from `planifest-zero/skills/` |
| P2 Plan | planifest-plan | Phase load |
| P3 Implement | planifest-implement, planifest-test-writer, planifest-implementer, planifest-refactor | Phase load. The TDD skills ran inside the three subagents. |
| P4 Validate and Accept | planifest-validate-and-accept | Phase load |
| P5 Ship | planifest-ship | Phase load |

## Subagent dispatch and parallelism

| Phase | Count | Purpose | Parallel |
|-------|-------|---------|----------|
| P1 | 0 | Not applicable | No. The Scope Lock entries carry `draft-accepted`, but the log records no draft subagents. |
| P2 | 3 | Setup requirements, the sizing requirement with ADRs, and scope with risks and glossary | Yes, 1 batch |
| P3 | 3 | One per file group: `setup.sh`, `setup.ps1`, and the skill with templates | Yes, 1 batch |
| P4 | 1 | Security review | Yes, beside verification |
| P5 | 0 | Not applicable | No. The ship steps depend on each other. |

P3 split the work by file rather than by requirement. req-001 and req-002 change the same install step in each script. The orchestrator wrote and registered the shared fixtures before dispatch, which avoided the 0000038 pre-flight failure.

## Self-corrections

| Phase | Count | Avoidable | Notes |
|-------|-------|-----------|-------|
| P2 | 0 | Not applicable | The consistency check was clean on the first run. |
| P3 | 1 parity fix | Yes | The `setup.ps1` subagent indented the error line by two spaces. The orchestrator removed the indent to match `setup.sh` and req-001. |
| P4 | 0 | Not applicable | CI passed every job on the first run. |

## Improvement suggestions

- P1: log the Scope Lock draft count. This gap carries over from 0000038.
- P2: the risk subagent filed backlog 0000118, which repeats req-001. Give that subagent the requirement list before it files backlog entries.
- P3: when two subagents must print the same text, give both the exact string with its whitespace.
- P4: `pwsh` is not installed locally, so only CI proved the `.ps1` side. The `.ps1` RED step was reasoned, not observed.
