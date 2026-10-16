# Build Report (0000035-powershell-setup-parity, 17 Oct 2026)

## Summary

The build used the primary tier for every phase except this assessment. The log records no parallel task batches and no MCP calls. Three findings need human attention:

- The P1 to P7 gates passed under a continuous run setting that the log inherits from feature 0000034.
- The P4 gate passed with two failing cases in the rename suite.
- The P0 row records zero agents, but four Scope Lock drafts carry agent tags.

## Model Usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|---------------|-------------|-----------------|
| Primary    | claude-opus-5-5 | P0 to P7 | 1 (P5) |
| Cheaper    | claude-haiku-5-5 | P8 | 1 (P8, self-recorded) |

## Skills Invoked

| Phase | Skill | Load pattern |
|-------|-------|-------------|
| P0 | planifest-orchestrator | Session start |
| P1 | planifest-spec-agent | Phase start |
| P2 | planifest-adr-agent | Phase start |
| P3 | planifest-codegen-agent | Phase start |
| P4 | planifest-validate-agent | Phase start |
| P5 | planifest-security-agent | Phase start |
| P6 | planifest-docs-agent | Phase start |
| P7 | planifest-ship-agent | Phase start |
| P8 | planifest-build-assessment-agent | Phase start |

The log records the skill loaded at each phase. It does not record the load pattern, so "Phase start" reflects the phase row.

## Subagent Dispatch

| Phase | Agent type | Count | Purpose |
|-------|-----------|-------|---------|
| P0 | Scope Lock drafting | 0 recorded (four drafts tagged in log) | Draft four Scope Lock answers |
| P5 | planifest-security-agent | 1 | Fresh-context review of the `setup.sh` and `setup.ps1` diff |
| P8 | planifest-build-assessment-agent | 1 | This assessment |

**Total agents spawned:** 2 recorded (P5 and P8). The P0 drafts are not counted. See Build Log Integrity.

## MCP Tool Usage

| Tool | Call count | Purpose |
|------|-----------|---------|
| None | 0 | No MCP calls recorded in any phase |

## Parallel Task Bursts

| Phase | Batch count | Tasks parallelised |
|-------|------------|-------------------|
| P0 to P8 | 0 | None |

**Phases with no parallelism:** all phases, P0 to P8.

## Self-Corrections

| Phase | Count | Summary |
|-------|-------|---------|
| P3 | 2 | Two tests matched wording in the implementer's own code. One check matched a quoted literal. One comment named `-AsHashtable`. |

**Total self-corrections:** 2

The eight P5 security fixes came from review, so this report counts them as rework, not self-corrections.

## Artefact Counts

| Category | Count |
|----------|-------|
| Requirements | 5 |
| Architecture decision records | 3 |
| Risk register entries | 5 |
| Scope Lock drafts | 4 |
| New test assertions at P3 | 36 (27 failing before code) |
| Security findings | 8 (S-001 Medium, S-002 to S-008 Low) |
| New security suite assertions | 19 |
| Regression candidates promoted | 1 |
| Living docs edited | 2 (plus Last updated lines on 4 docs) |
| Backlog items filed | 2 (0000106, 0000107) |
| Backlog items picked up | 4 (0000090, 0000094, 0000104, 0000105) |

## Efficiency Observations

Durations come from the log timestamps. The pipeline ran about 28 minutes from the P0 start to the P7 gate.

| Phase | Recorded time | Note |
|-------|---------------|------|
| P0 | About 7 min 36 s | Includes human dialogue |
| P1 | About 1 min | |
| P2 | About 1 min 30 s | |
| P3 | About 4 min | |
| P4 | Not measurable | Start and gate share one timestamp |
| P5 | About 12 min | Includes eight fixes and a 19-assertion suite |
| P6 | About 35 s | |
| P7 | About 22 s | |

- P5 was the longest phase. The log does not separate review time from fix time.
- The log records one model tier for each phase. It holds no cost data, so no cost comparison is possible.
- Every phase ran in sequence. No phase recorded parallel work.

## Critical Audit

**Model routing audit**

- The primary tier ran P0 to P7. Cheaper-tier eligible tasks also ran on the primary tier. These were the P4 checks (`run-tests.sh`, `bash -n`, consistency-check), the P6 Last updated line edits, and the P7 archive, changelog, and test report.
- The cheaper tier ran only at P8. Expected: P4, P6, and P7 mechanical work on the cheaper tier. Actual: zero of the eight build phases. This is a routing finding.
- Tier decisions are recorded per phase, not per agent call. The P5 reviewer has no recorded tier of its own. The log is sparse, which is an accountability gap.

**Parallelism audit**

- P0: four Scope Lock drafts carry agent tags, and the Scope Lock default is parallel dispatch. The log records zero batches. Parallelism is not evidenced. Treat as not applied.
- P3: five requirements, zero batches. The log gives a reason. Requirements 001 to 004 edit neighbouring functions in `setup.ps1`, and requirement 005 edits a run sequence shared by both scripts. That reason covers the shared-file edits. The log does not show whether the red tests depended on each other, so the absence is only partly evidenced.
- P4: `run-tests.sh`, `bash -n`, and the consistency check are independent. Zero batches. Parallelism is not evidenced.
- P6: four living docs, the recommendations, the iteration log, and two backlog items. Zero batches. The log gives edit size as the reason. The absence is acceptable only for single-task phases, so this is a finding.
- P7: archive, changelog, test report, and regression promotion. Zero batches and no reason recorded. This is a finding.
- P5: one reviewer for one review. A single task, so the absence is acceptable.
- No phase records multiple Agent calls in one message.

**Phase gate audit**

- P0: the human confirmed the design gate with "Yes accept all". The run mode was not confirmed for this feature. The log says it carries over from 0000034 and is written to `plan/.run-mode`. The pre-authorisation for 0000035 is inherited, not recorded at P0.
- P1 to P7: each gate reads "Gate accepted ... continuous run". The log records no human confirmation at these transitions. The human should confirm that the inherited continuous run covers them.
- P6: the log labels Gate B as auto-accepted. Confirm that this gate allows automatic acceptance.
- P4: the gate passed with the rename suite failing, cases (a) and (b). The log says the failure predates this feature and is tracked in backlog 0000097. The gate still passed without human sign-off. The human should confirm this is acceptable.

**Self-correction audit**

- Both self-corrections occurred in P3 and were avoidable. The tests checked comment wording, not behaviour. Test behaviour so that comment edits do not fail the tests.
- The P5 review found eight issues. S-001 (PowerShell 5.1 reads `settings.json` as ANSI) is the most serious. The log does not show whether the spec covered file encoding. If it did not, the spec is the likely cause. ADR-002 covers 5.1 support but the log does not link it to encoding.

**Build log integrity**

- Every phase from P0 to P8 has a row. Each row fills its model tier, agent count, MCP count, batch count, and telemetry fields.
- P0 records zero agents and zero batches. The Scope Lock entries carry the tags `agent-draft-edited` and `agent-draft-accepted`. Either the drafts were not agent-produced, or the P0 counts are undercounted. The human should resolve this discrepancy.
- The P4 start and gate share the timestamp 23:38:59. That is also the P3 gate time. The phase records no measurable duration for its test runs. The timing is sparse.
- Telemetry is `confirmed-disabled` in every phase. No external record exists to check these counts against.
- The run mode appears only in the P0 notes. The log header has no field for it.
