# Build Report (0000041-setup-cleanup-and-park-hardening, 22 Oct 2026)

Source: `build-log.md` in this archive. Figures the log does not record are marked "not captured".

## Model usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary | claude-opus-5-5 | P1 to P5 (orchestrator), P3 and P4 (subagents) | 5 subagents |
| Primary | Sonnet | P2 | 7 subagents |
| Cheaper | Haiku | P2 | 1 subagent |

The log's P2 notes name the tiers but not the models. The ship summary names Sonnet for the P2 primary agents and Haiku for the cheaper one. The header names `claude-sonnet-5-5` as the cheaper model, so P2's primary agents ran on the header's cheaper model.

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
| P2 | 8 | Batch 1: four requirements, and the scope, risk, and glossary set. Batch 2: two ADRs and the execution plan. | Yes, 2 batches |
| P3 | 3 | One per file: `setup.sh`, `setup.ps1`, and `park.mjs` | Yes, 1 batch |
| P4 | 2 | Security review and execution verification | Yes, 1 batch |
| P5 | 0 | Not applicable | No. The ship steps depend on each other. |

P2 wrote ADR-001 inline, because it restates the stack. P2 batch 2 waited for the requirements, as the plan skill requires. P3 split by file, so req-003 ran as two halves inside the two setup agents.

## Self-corrections

| Phase | Count | Avoidable | Notes |
|-------|-------|-----------|-------|
| P2 | 1 consistency fix | Yes | The check flagged all 4 requirements with more than 3 criteria. The criteria merged with no loss of coverage. 0000040 recorded the same fix. |
| P3 | 0 | Not applicable | The `setup.sh` and `park.mjs` suites went RED, then GREEN. The `setup.ps1` RED step was reasoned in P3. |
| P4 | 1 | Yes | Security finding F-001: req-004's cleanup could delete the only entry copy when `--entry` named the target path. `parkContext` now refuses that path. |

## Improvement suggestions

- P1: the build log omitted the template's Summary section at creation. Copy the full template when the log is created.
- P2: tell plan subagents the 3-criteria limit before they draft. 0000040 made the same suggestion, and the fix recurred.
- P2: P2 asked the human one design question after the requirement agents reported. A parse-failure probe during discovery would have raised it at P1.
- P3: when a change deletes a path, give the implementer a rule to check that the path can't be the input. That rule would have prevented F-001.
- P4: `pwsh` is still missing locally. A throwaway draft PR observed the `.ps1` RED step in CI. That closes the gap that 0000039 and 0000040 carried over, but it costs one CI run.
