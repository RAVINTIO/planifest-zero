# Build Report (0000040-setup-json-checks-and-park, 22 Oct 2026)

Source: `build-log.md` in this archive. Figures the log does not record are marked "not captured".

## Model usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary | claude-opus-5-5 | P1 to P5 (orchestrator), P3 (subagents) | 3 subagents |
| Cheaper | claude-sonnet-5-5 | P2 | 4 subagents |
| Not captured | Not captured | P4 | 2 subagents |

The P2 row in the log reads "primary tier, claude-sonnet-5-5". The header names `claude-sonnet-5-5` as the cheaper model, so this report counts those 4 agents as cheaper tier.

## Skills invoked

| Phase | Skills | Load pattern |
|-------|--------|-------------|
| P1 Discovery | planifest-orchestrator | Session start |
| P2 Plan | planifest-plan | Phase load |
| P3 Implement | planifest-implement, planifest-test-writer, planifest-implementer, planifest-refactor | Phase load. The TDD skills ran inside the three subagents. |
| P4 Validate and Accept | planifest-validate-and-accept | Phase load |
| P5 Ship | planifest-ship | Phase load |

## Subagent dispatch and parallelism

| Phase | Count | Purpose | Parallel |
|-------|-------|---------|----------|
| P1 | 0 | Not applicable | No. The Scope Lock drafts ran inline, as the skill requires. |
| P2 | 4 | Requirements, ADRs, and the scope, risk, and glossary set | Yes, 1 batch |
| P3 | 3 | One per file group: `setup.sh`, `setup.ps1`, and the orchestrator skill with `park.mjs` and templates | Yes, 1 batch |
| P4 | 2 | Security review and execution verification | Yes, 1 batch |
| P5 | 0 | Not applicable | No. The ship steps depend on each other. |

P3 split the work by file, as in 0000039. req-002 and req-003 change the same check path in `setup.ps1`. req-004 and req-005 edit the same skill sections.

## Self-corrections

| Phase | Count | Avoidable | Notes |
|-------|-------|-----------|-------|
| P2 | 1 consistency fix | Yes | The check flagged 5 requirements with more than 3 criteria. The criteria were consolidated with no loss of coverage. |
| P3 | 0 | Not applicable | Each suite went RED, then GREEN. |
| P4 | 2 | Cycle 1 yes, cycle 2 partly | Cycle 1: the park suite compared the gitignored `.claude/` copy, which CI lacks. Cycle 2: the security review found F-001 to F-005 in `park.mjs`. Validation of branch, slug, and id fixed them in `108d1ce`. |

## Improvement suggestions

- P2: the requirement template allows more criteria than the consistency check accepts. Tell plan subagents the 3-criteria limit before they draft.
- P3: give the implementer of any script that calls git a rule to validate every ref argument. That rule would have prevented F-001 to F-005 in P3.
- P3: tests must not read gitignored paths, because CI has none of them.
- P4: record the model tier of each P4 subagent in the log.
- P4: `pwsh` is not installed locally, so only CI proved the `.ps1` side. The `.ps1` RED step was reasoned, not observed. This carries over from 0000039.
