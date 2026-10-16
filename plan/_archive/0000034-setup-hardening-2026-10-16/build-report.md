# Build Report (0000034-setup-hardening, 16 Oct 2026)

## Model Usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary    | claude-opus-5-5 | P0 to P7 | 1 (P5 security reviewer) |
| Cheaper    | claude-haiku-5-5 | P8 | 5 (4 Scope Lock drafts, 1 build assessment) |

The P0 row records the primary tier. The cheaper tier for the four Scope Lock drafts appears in the summary only.

## Skills Invoked

| Phase | Skill | Load pattern |
|-------|-------|-------------|
| P0    | planifest-orchestrator | Session start |
| P1    | planifest-spec-agent | Phase start |
| P2    | planifest-adr-agent | Phase start |
| P3    | planifest-codegen-agent | Phase start |
| P4    | planifest-validate-agent | Phase start |
| P5    | planifest-security-agent | Phase start |
| P6    | planifest-docs-agent | Phase start |
| P7    | planifest-ship-agent | Phase start |
| P8    | planifest-build-assessment-agent | Phase start |

The P4 row does not record planifest-verify-by-execution. The log does not show execution-based checks for the acceptance criteria.

## Subagent Dispatch

| Phase | Agent type | Count | Purpose |
|-------|-----------|-------|---------|
| P0    | planifest-scope-lock-agent | 4 | One Scope Lock draft each for the happy, first-run, error and cross-session paths |
| P5    | planifest-security-agent | 1 | Fresh-context security review of the feature diff |
| P8    | planifest-build-assessment-agent | 1 | This report |

**Total agents spawned:** 6

The P0 row records 0 agents. The four drafts appear in the Scope Lock notes and the summary only.

## MCP Tool Usage

| Tool | Call count | Purpose |
|------|-----------|---------|
| None recorded | 0 | Every phase row records 0 MCP calls |

## Parallel Task Bursts

| Phase | Batch count | Tasks parallelised |
|-------|------------|-------------------|
| P0    | 1 (summary only; the P0 row records 0) | Four Scope Lock drafts |

**Phases with no parallelism:** P1, P2, P3, P4, P5, P6, P7, P8

## Self-Corrections

| Phase | Count | Summary |
|-------|-------|---------|
| P4    | 3 (summary) | Three older suites updated to match ADR-001: 0000031 req-004, 0000033 req-002, 0000033 req-003 |

**Total self-corrections:** 3

The P4 notes also record one req-006 assertion reworded. The summary does not count it. The P5 fix commit (b6e13ef), which closed findings S-001 to S-008, is not counted either.

## Artefact Counts

| Category | Count |
|----------|-------|
| Requirements | 6 |
| Scope documents | 1 |
| Risk register entries | 7 (6 at P1, R-007 added at P5) |
| Glossary | 1 |
| ADRs | 2 (ADR-002 revised to v0.1.1 at P5) |
| Regression tests promoted | 2 (test-0000034-req-001, test-0000034-req-003) |
| Test suites | Not captured. P3 gives five counts for six requirements. |
| Backlog entries filed | 2 (0000104, 0000105) |
| Backlog entries removed | 5 (0000088, 0000091, 0000092, 0000096, 0000102) |
| Documentation files updated | 4 (architecture-overview, component-registry, dependency-graph, decisions-index), plus recommendations.md and iteration-log.md |

## Efficiency Observations

The pipeline took 68 minutes 42 seconds from P0 start to P8 start. P0 took 46 minutes 45 seconds of that, about 68 percent.

- P0 is the main cost. The log does not record per-step timings, so the cause is not confirmed. The Scope Lock drafts ran in parallel, but the log records the parallel batch in the summary only.
- P5 took 7 minutes 6 seconds. Its findings concern symlink handling, file mode and `Move-Item -Force` behaviour. ADR-002 needed an additive revision to cover them, which points to a gap in the design.
- The P4 self-corrections came from a known conflict. The P0 notes record that 0000030 ADR-001 rejected retired flags. The spec did not list the existing suites the decision would affect. A spec step that lists affected suites would have caught them before P4.
- Model tier and agent decisions are recorded per phase, not per agent call. A per-call record would show which tasks used the cheaper tier.

## Critical Audit

**Model routing audit**

- The primary tier ran P0 to P7 inline work and the P5 security reviewer. The P6 documentation edits and the P7 archive steps were candidates for the cheaper tier. The log records no routing decision for them.
- The cheaper tier ran P8 and, per the summary, four Scope Lock drafts. Its usage is not near zero, so the zero-usage flag does not apply.
- Tier decisions are recorded per phase, not per agent call. The log is sparse for this purpose. This is an accountability gap, and it is flagged.

**Parallelism audit**

- P1 wrote six independent requirement files inline. The log gives size as the reason, not dependency. Flagged: six independent units meet the project's decomposition rule.
- P2 wrote two ADRs inline. The second ADR reads the first, so the stated reason holds.
- P3 was not decomposed. The reason holds for req-001 to req-004, which edit the same two files. req-005 and req-006 are one-line edits. Flagged: the codegen-agent calls planifest-test-writer and planifest-implementer for each requirement, and the P3 row records 0 agent calls. Either the TDD loop ran without those agents, or the log is incomplete.
- P6 edited four documents inline and called the edits small. The edits were independent of each other. Not evidenced as parallel work, and flagged as a candidate.
- The P0 row records 0 batches, but the summary records P0 as the one parallel phase. This conflict is flagged.

**Phase gate audit**

- The run mode is recorded as continuous run. The basis is the reply "Get on with it" to a run-mode question. The log records the orchestrator's reading of that reply, not the human's chosen words. Treat the pre-authorisation as valid only if the human agrees with that reading.
- The P1 to P5 gates were accepted under continuous run, consistent with that reading.
- The P6 Gate B was auto-accepted. The documentation changes reached P7 without human review. Flagged.
- The P4 gate passed with one failing suite, test-0000031-req-001-rename (cases a and b). The failure predates this feature and is tracked as backlog 0000097. The log records it as overridden in 0000033. The gate passed with a known red test.
- The P7 step promoted two regression candidates without human confirmation. The log says the human can revert them. Flagged.
- The gap between the P6 gate (21:33:54Z) and the P7 start (21:36:19Z) is 2 minutes 25 seconds. The log has no entry for it.
- No P8 to P9 gate or P9 row is recorded.

**Self-correction audit**

- The log records 3 self-corrections. The P4 notes describe 4 changes.
- The three suite updates were avoidable. The conflict between ADR-001 and the older suites was known at P0.
- The req-006 assertion reword has no recorded cause. It cannot be classified.
- The P5 findings (S-001 to S-008) were defects in the atomic write path. They are not counted. Either the count is low or the category is undefined. Flagged.

**Build log integrity**

- The P9 row is missing. The summary says "10 (P0 to P9)" phases completed, but the log has rows for P0 to P8 only.
- The summary is marked "filled at P7", yet it counts the P8 build assessment agent. The timing of the summary is inconsistent.
- The P0 row records 0 agents and 0 batches. The notes and summary record four drafts and a parallel phase. Flagged.
- P3 gives five test-suite counts for six requirements. The P4 totals (49 passed, 1 failed) do not reconcile with the P3 values. Not captured.
- Telemetry is recorded as confirmed-disabled in every row. No telemetry cross-check is possible.
- The rows do not record end timestamps. Durations are derived from the next phase start.
- All other fields are populated for P0 to P8.
