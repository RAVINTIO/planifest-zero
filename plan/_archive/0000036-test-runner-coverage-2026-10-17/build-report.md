# Build Report (0000036-test-runner-coverage, 17 Oct 2026)

## Model Usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary    | claude-opus-5-5 | P0 to P7 | 5 |
| Cheaper    | claude-haiku-5-5 | P8 | 1 |

## Skills Invoked

| Phase | Skill | Load pattern |
|-------|-------|-------------|
| P0    | planifest-orchestrator | Session start |
| P1    | planifest-spec-agent | Phase load |
| P2    | planifest-adr-agent | Phase load |
| P3    | planifest-codegen-agent | Phase load. Nested skills not captured. |
| P4    | planifest-validate-agent | Phase load |
| P5    | planifest-security-agent | Phase load |
| P6    | planifest-docs-agent | Phase load |
| P7    | planifest-ship-agent | Phase load |
| P8    | planifest-build-assessment-agent | Phase load |

## Subagent Dispatch

| Phase | Agent type | Count | Purpose |
|-------|-----------|-------|---------|
| P0    | Not captured | 4 | Scope Lock drafts, one per scenario path |
| P5    | Not captured | 1 | Fresh-context security review of the diff from the PR #9 head |
| P8    | Not captured | 1 | Build assessment (this agent) |

**Total agents spawned:** 6

## MCP Tool Usage

| Tool | Call count | Purpose |
|------|-----------|---------|
| None recorded | 0 | Every phase records 0 MCP calls |

## Parallel Task Bursts

| Phase | Batch count | Tasks parallelised |
|-------|------------|-------------------|
| P0    | 1          | 4 Scope Lock drafts |
| P1 to P8 | 0       | None |

**Phases with no parallelism:** P1, P2, P3, P4, P5, P6, P7, P8

## Self-Corrections

| Phase | Count | Summary |
|-------|-------|---------|
| P3    | 4     | A red-phase run called the old runner, which ran the whole pack recursively. Three CI rounds then fixed the PowerShell 7 colon split. |
| P5    | Not recorded | Six findings (S-001 to S-006) fixed with tests after review. See the audit. |

**Total self-corrections:** 4 recorded (P3). P5 fixes not counted.

## Artefact Counts

| Category | Count |
|----------|-------|
| Requirements | 5 |
| ADRs | 3 |
| Risks in the risk register | 5 |
| Scope Lock drafts | 4 (3 accepted, 1 edited) |
| Security findings | 8 (6 fixed, 2 accepted) |
| Feature suites, as recorded in P4 | 56 (see the audit) |
| Regression suites, as recorded in P4 | 15 |
| Regression candidates promoted | 1 |
| Backlog entries pulled in | 1 (0000084) |
| Backlog entries written | 1 (0000108) |
| PowerShell suites in CI | 32, on both hosts |
| Component version | 0.4.3 |

## Efficiency Observations

- The run took 31 minutes 21 seconds, from P0 start to P8 start.
- Phase durations, from the log timestamps: P0 2 min 12 s, P1 24 s, P2 55 s, P3 17 min 43 s, P4 9 s, P5 6 min 50 s, P6 32 s, P7 1 min 58 s.
- P3 took over half of the run. It included three CI rounds.
- The log records that the P3 defect shipped in 0.4.1 and 0.4.2. The log does not say whether a PowerShell 7 check existed before this feature.
- The log records no token or cost counts. This report cannot rate cost by phase.
- The P4 phase took 9 seconds. Its notes cite a green four-job CI run, but the log does not name that run. It may be an earlier run from P3.

## Critical Audit

**Model routing audit**
- The primary tier (claude-opus-5-5) ran P0 to P7. The log records five agent calls at this tier.
- The cheaper tier (claude-haiku-5-5) ran P8 only, with one call. Cheaper-tier usage before P8 is zero.
- Cheaper-eligible work included the P4 checks, the P6 drift check and last-updated edits, and the P7 archive moves. The log records all of these at the primary tier.
- Expected tier for those mechanical steps was cheaper. The actual tier was primary.
- The log records the model tier per phase, not per agent call. The four Scope Lock drafts and the security reviewer have no per-call tier. This is sparse. It is an accountability gap.
- Verdict: not evidenced. Treat model routing as not applied for P0 to P7.

**Parallelism audit**
- P0 recorded one batch of four Scope Lock drafts. This is justified.
- P1 wrote five requirements, a risk register, a glossary, scope, the execution plan and component.yml inline. The log gives no reason. Not evidenced.
- P2 wrote three ADRs inline. Each ADR covers a separate decision. The log gives no reason. Not evidenced.
- P3 gave a reason: req-001 and req-003 edit the same runner, and req-004 and req-005 depend on req-003. That reason does not cover req-002, the `.ps1` manifest check. The log does not say whether req-002 depends on the runner change.
- P4 ran shell checks and CI. No agent batch is recorded. This is acceptable for shell runs. The log should list which checks ran together.
- P5 used one reviewer for one review. This is acceptable.
- P6 updated three living docs and wrote the recommendations, iteration log and backlog 0000108. The log records no batch. Not evidenced.
- P7 ran in sequence. This is acceptable.
- A multi-agent dispatch in a single message is recorded in P0 only.

**Phase gate audit**
- Gates for P0 to P7 are recorded with timestamps. The gaps before P5 (9 seconds) and P7 (11 seconds) are short.
- The P4 gate timestamp equals the P4 start timestamp (00:21:11Z). The gate may have been written before validation finished. Check this.
- Run mode is continuous. The log says it carried over from 0000034. No P0 exchange in this log confirms continuous mode for 0000036. Check that the carry-over was intended.
- The P0 design confirmation is recorded as "Ues", read as yes. Check that the human meant yes.
- The P4 gate accepted a local run with one failing suite, the rename suite (backlog 0000097). The log records no waiver. Check that this acceptance was intended.
- The P6 Gate B was auto-accepted under continuous run. The log does not show that continuous run covers Gate B. Check this against the orchestrator skill.
- Telemetry is confirmed-disabled in every phase, so no telemetry cross-check exists.

**Self-correction audit**
- P3 recorded four self-corrections.
- The first was a red-phase run that called the old runner, which ran the whole pack recursively. This was avoidable. A guard before the first run would have prevented it.
- The other three were CI rounds for the PowerShell 7 colon split. These were partly avoidable. The first fix tested for a trailing colon. A debug print then showed the colon was dropped. A debug step before the first fix would have shown the behaviour sooner.
- The log attributes these causes to a missing guard and platform behaviour. It does not attribute them to spec ambiguity.
- P5 applied six fixes (S-001 to S-006) with tests. The log records no self-corrections for P5. If these count, the total is 10. The log does not state a counting rule.

**Build log integrity**
- All phases P0 to P8 are present. The P8 row has no end time or gate. This is expected at assessment time.
- Every phase row populates the model tier, skills, agent count, MCP calls, parallel batches and telemetry fields.
- Not captured: the agent type for all six agent calls, and the model tier for each call.
- Not captured: the P3 nested skills. The codegen skill definition lists test-writer, implementer and refactor. The P3 row lists only the codegen skill.
- Contradiction: P4 reports 55 of 56 feature suites passing, one failure, and two skipped PowerShell suites. If the two skipped suites sit within the 56, the counts do not reconcile. Check the run output.
- P4 cites a green four-job CI run in 9 seconds. The log does not name the CI run. Check the run ID.
- P6 notes say `tests/README.md` was updated in P5. The P5 row records no documentation change. Check which phase owns that edit.
