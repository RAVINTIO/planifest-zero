# Build Report (0000037-self-host-on-planifest-zero, 17 Oct 2026)

Source: `build-log.md` in this archive. Figures not recorded in the log are marked "not captured".

## Model usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary    | claude-opus-5-5 (header value) | P0 to P7 | 17 recorded. P3 batches 2 and 3 not captured. |
| Cheaper    | claude-haiku-4-5 (header value) | P8 | 1 |

The log records tier per phase, not per agent call. The cheaper row shows the header value. This assessment runs on claude-haiku-5-5, so the header value may be stale, and the concrete model for P8 is not recorded.

## Skills invoked

| Phase | Skill | Load pattern |
|-------|-------|-------------|
| P0 | planifest-orchestrator | Session start |
| P1 | planifest-orchestrator, planifest-spec-agent | Phase load. Resumed from `pause.md`. |
| P2 | planifest-adr-agent | Phase load |
| P3 | planifest-codegen-agent | Phase load. The TDD sub-skills (test-writer, implementer, refactor) are not logged. |
| P4 | planifest-validate-agent | Phase load. planifest-verify-by-execution is not logged. |
| P5 | planifest-security-agent | Phase load |
| P6 | planifest-docs-agent | Phase load |
| P7 | planifest-ship-agent | Phase load |
| P8 | planifest-build-assessment-agent | Phase load |

## Subagent dispatch

| Phase | Agent type | Count | Purpose |
|-------|-----------|-------|---------|
| P0 | Not captured | 4 | Scope Lock drafts, one per scenario path |
| P1 | Not captured | 3 | Requirements 001 to 005, requirements 006 to 009, plan artefacts |
| P2 | Not captured | 2 | ADR-001 and ADR-002, then ADR-003 and ADR-004 |
| P3 | Not captured | 6 | Batch 1: req-001, req-002, req-003, req-005, req-009, and req-007 with req-008 |
| P3 | Not captured | Not captured | Batch 2 (req-004) and batch 3 (req-006). Dispatch method not logged. |
| P5 | Not captured | 1 | Security review |
| P6 | Not captured | 1 | Living docs and version records |
| P8 | Not captured | 1 | This report |

**Total agents spawned:** 18 recorded. The count excludes P3 batches 2 and 3.

## MCP tool usage

| Tool | Call count | Purpose |
|------|-----------|---------|
| None recorded | 0 | Every phase records zero MCP calls. |

## Parallel task bursts

| Phase | Batch count | Tasks parallelised |
|-------|------------|-------------------|
| P0 | 1 | 4 Scope Lock drafts |
| P1 | 1 | 3 spec agents |
| P2 | 1 | 2 ADR agents. Overlapped P1. |
| P3 | 1 (logged as "3 planned") | 6 agents in batch 1. Batches 2 and 3 ran as single tasks. |
| P5 | 1 | Batch shared with P4 CI and P6 |
| P6 | 1 | Batch shared with P4 CI and P5 |

**Phases with no parallelism:** P4 (0 batches recorded), P7 (0 batches), P8 (single task).

P4 records zero batches, but P5 and P6 each record a batch shared with P4. The same batch appears in three phases.

## Self-corrections

| Phase | Count | Summary |
|-------|-------|---------|
| P4 | 1 | Three suites failed on the Linux `bash-suites` job (R-007). Causes: `PLANIFEST_REQUIRE_PWSH=1` inherited by the runner suite, GNU `stat -f` behaviour, and GNU `grep` and `sed` reading a backslash-backtick as a buffer anchor. Fixed in `e83d594`. |

**Total self-corrections:** 1 recorded. The iteration log states "None recorded". See the audit below.

## Artefact counts

| Category | Count |
|----------|-------|
| Requirements | 9 (req-001 to req-009), all GREEN |
| ADRs | 4 |
| Plan artefacts in archive | 11 (build log, design, discovery, feature brief, scope, execution plan, risk register, glossary, iteration log, recommendations, security report) |
| Commits above `main` | 39 |
| Backlog items filed | 4 (0000109, 0000110, 0000111, 0000112) |
| Backlog items folded into scope | 5 (0000097, 0000103, 0000106, 0000107, 0000108) |
| Backlog items discarded | 3 (0000086, 0000089, 0000093) |
| Local suites passing | 65 feature and 16 regression. 3 PowerShell suites skipped (no `pwsh`). |
| Suites promoted to regression | 2 (req-007 and req-008) |
| Branch rebuilds | 2 (cherry-pick onto `main` after squash merges of PR #9 and PR #11) |

## Efficiency observations

### Model routing audit

- **Primary tier used for cheaper-eligible work.** The primary model ran P4 validation fixes and the P7 archive and changelog. The brief names validation and formatting as cheaper-eligible. The log records no cheaper-tier call for either phase.
- **Cheaper tier effectively unused.** Expected: P4 validation, P7 archive, and the P6 drift fixes (a retired flag in `README.md` and a stale table in `docs/about.md`). Actual: none of these ran on the cheaper tier. The only cheaper-tier phase is P8. Finding: cheaper-tier routing was not applied.
- **Routing not recorded per call.** Only the phase tier is logged. Per-call tier, agent type, and model are missing. This is an accountability gap.
- **Concrete model drift.** The header lists `claude-haiku-4-5` as the cheaper model. P8 runs on a different concrete model, and the log does not record it.

### Parallelism audit

- **P4 (validate): no batches, three independent failures.** CI run 1 failed three suites for separate causes, plus two regression copies. The fixes touched separate files. Parallel fixes were possible. The log gives no reason for serial work. Finding: parallelism not evidenced for a multi-task phase.
- **P3 batches 2 and 3: serial, reason not recorded.** `req-004` and `req-006` each ran as a single task after batch 1. The log does not state a dependency. If the two were independent, each added a serial cycle. Finding: serial dispatch not justified.
- **P3 batch 1 shared one agent for req-007 and req-008.** The log does not record why. Two requirements shared one TDD context. Finding: decision not recorded.
- **P6 (docs): one agent for about eight living documents.** Most files are separate: architecture overview, component registry, dependency graph, decisions index, `about.md`, `README.md`, `product.yml`, and `component.yml`. Some depend on others. The log records no split decision. Finding: parallelism not evidenced.
- **P7 (archive): no batches.** The changelog, test report, `.feature-id`, and suite promotions are mostly independent. Impact is low. Finding: not evidenced.
- **P5 and P6 batch attribution.** The batch shared with P4 CI is counted in P5 and P6, and P4 records zero. Finding: log attribution is inconsistent.
- **The human asked for maximum parallelism.** P0, P1, P2, and P3 batch 1 used parallel agents. P4, P6, and P7 did not show evidence of the same.

### Phase gate audit

- **P0 gate honoured.** The design was confirmed at 01:58:09Z. The version was confirmed at 0.4.4, then at 0.5.0 after the scope extension. The design was re-confirmed at 09:43:01Z.
- **Continuous run was pre-authorised.** The P0 exchange records "continuous? / A: agreed". Runs without stops from P1 onward are covered by that exchange.
- **P1 gate recorded in the wrong block.** P1 has no end timestamp. Its completion and gate line sit in the P2 block. P2 started at 10:12Z, before the P1 gate was logged. Finding: gate timing is not evidenced.
- **P3 started before P2 closed.** The P2 completion line sits in the P3 block. ADR-003 and ADR-004 were "in progress" when batch 1 started. The P3 notes then record a change to ADR-003 (compact JSON for the req-008 warning). The log does not show whether the req-008 agent saw the final text. Finding: codegen ran ahead of the confirmed ADR.
- **P4 and P5 and P6 started together.** P4 started at 11:20Z and P5 and P6 at 11:22Z. The continuous run covers this, but the P4 gate has no timestamp.
- **P6 gate auto-accepted.** The log records "Gate B (continuous run, auto-accepted)". The P0 exchange covers it, but the log does not show a human confirmation for this gate.
- **P7 human decision honoured.** The human chose to promote two regression suites. The log records the decision.

### Self-correction audit

- **One self-correction, avoidable.** The causes are portability and isolation. The suites were run and written on macOS (BSD tools). CI runs on Ubuntu (GNU tools). A Linux run before the push, or a portability rule in the codegen step, would have caught all three causes. The runner suite also did not clear `PLANIFEST_REQUIRE_PWSH`. The spec did not require environment isolation.
- **Conflicting records.** The iteration log says "None recorded" and "Each P3 requirement went RED then GREEN on its first cycle". The build log records one self-correction in P4. The records must agree.
- **Deviation, not counted as a self-correction.** In P3, req-001 removed case (e) of `test-0000031-req-003-five-phases.sh`. The orchestrator made the edit. The log gives a reason (the telemetry job was removed) and classes it as cosmetic. Finding: a test edit made by the orchestrator, not the agent.
- **Unverified acceptance criterion.** AC 14 (`setup.ps1` on both hosts) was not run locally. CI proved it. The log does not show planifest-verify-by-execution running in P4. Finding: acceptance criteria were checked by CI only.

### Build log integrity

- **All phases present.** P0 to P7 and P8 have entries.
- **End timestamps missing.** Only start times are logged. P1 to P7 have no end time. P1 and P3 gate timestamps are missing.
- **Parallel batch fields use plan values.** The P3 field reads "3 planned", which is a plan, not a record.
- **Identical timestamps.** P5 and P6 both start at 11:22:00Z. The value was likely written at dispatch, not measured.
- **P3 agent count incomplete.** Batches 2 and 3 are not counted.
- **No token or cost data.** Telemetry is "confirmed-disabled" in every phase. Cost efficiency cannot be measured.

### Other observations

- **Elapsed time.** P1 started at 10:05Z and P7 at 11:45Z. Spec through archive took about 1 hour 40 minutes by start times. The log records a pause between P0 (01:58Z) and P1 (10:05Z) and does not separate active time from pause time.
- **Two rebuilds from stacking.** The P0 decision to stack on open PRs #9 and #10 led to two cherry-pick rebuilds after squash merges. The log records the cost in words, not in time. Stacking on open PRs is the main avoidable overhead in this run.
- **Commit granularity.** The branch holds 39 commits above `main`, matching the commit-granular rule.
- **Recommended next step for this run.** Record per-call tier, agent type, and parallel reasons. Add end timestamps for each phase. Reconcile the iteration log with the build log on self-corrections.
