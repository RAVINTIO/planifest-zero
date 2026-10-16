---
title: "Build Report - 0000033-remove-telemetry-mcp"
date: "2026-09-09"
archive_date: "16 Oct 2026"
---

# Build Report (0000033-remove-telemetry-mcp, 16 Oct 2026)

## Model Usage

| Model tier | Concrete model | Phases used | Agent call count |
|------------|----------------|-------------|-----------------|
| Primary    | claude-opus-5  | P0 (orchestration), P2, P3, P4, P5, P6, P7 | 10 recorded, plus 1 untiered (P0 Explore) |
| Cheaper    | claude-sonnet-5 (P0, P1), claude-haiku-5-5 (P8) | P0, P1, P8 | 7 |

The build log summary records 17 primary calls and 0 cheaper calls. The per-phase entries contradict that summary. Four scope-lock agents ran on claude-sonnet-5, and two spec agents ran on the cheaper tier. The P8 run executed on claude-haiku-5-5, not the claude-sonnet-5 named in the log header. This report uses the per-phase entries and records 7 cheaper calls.

## Skills Invoked

| Phase | Skill | Load pattern |
|-------|-------|-------------|
| P0    | planifest-orchestrator | Session start (auto-triggered) |
| P1    | planifest-spec-agent | Orchestrator dispatch |
| P2    | planifest-adr-agent | Orchestrator dispatch |
| P3    | planifest-codegen-agent | Orchestrator dispatch |
| P4    | planifest-validate-and-accept | Recorded in the log. No skill of this name appears in the available skill list. Not verified. |
| P5    | planifest-security-agent | Orchestrator dispatch |
| P6    | planifest-docs-agent | Orchestrator dispatch |
| P7    | planifest-ship-agent | Orchestrator dispatch |
| P8    | planifest-ship-agent, planifest-build-assessment-agent | Ship-agent dispatch |

The log lists planifest-orchestrator in every phase entry. The load was recorded once, at P0.

## Subagent Dispatch

| Phase | Agent type | Count | Purpose |
|-------|-----------|-------|---------|
| P0    | Explore | 1 | Map the telemetry surface before Scope Lock. Tier not recorded. |
| P0    | planifest-scope-lock-agent (claude-sonnet-5) | 4 | Scope Lock drafts for the four scenario paths |
| P1    | planifest-spec-agent | 2 | Requirements artefacts. Cheaper tier. |
| P3    | planifest-codegen-agent | 7 | Requirement implementation across four batches |
| P5    | planifest-security-agent | 1 | Fresh-context security review |
| P6    | planifest-docs-agent | 2 | Living docs, and recommendations, iteration log and drift check |
| P8    | planifest-build-assessment-agent | 1 | This report |

**Total agents spawned:** 18 (17 in P0 to P6, plus 1 in P8)

## MCP Tool Usage

| Tool | Call count | Purpose |
|------|-----------|---------|
| (none) | 0 | No MCP calls recorded in any phase |

## Parallel Task Bursts

| Phase | Batch count | Tasks parallelised |
|-------|------------|-------------------|
| P0    | 2 | Batch 1: one Explore agent. Batch 2: four Scope Lock drafts. |
| P1    | 1 | Two spec agents. The split of artefacts across the agents is not itemised. |
| P2    | 0 | ADRs written inline, because they cross-reference one another |
| P3    | 4 | Batch 1: req-001, req-005, req-006 and req-007. Batch 2: req-002 and req-003. Batch 3: req-004. Batch 4: req-008. |
| P4    | 1 | Shell checks batched. No agents. |
| P5    | 1 | One agent |
| P6    | 1 | Two docs agents: living docs, and recommendations with iteration log and drift check |
| P7    | 0 | Archive only |
| P8    | 0 | Single agent |

**Phases with no parallelism:** P2 (justified), P4 (no agent batch), P5 (single agent), P7 (archive), P8 (single agent). Within P3, batches 3 and 4 each held one requirement.

## Self-Corrections

| Phase | Count | Summary |
|-------|-------|---------|
| P3    | 0 (1 requirement change) | req-002 and req-003 acceptance criteria conflicted with req-004 and ADR-002. Amended in place and re-run. |
| P4 (re-run, 2026-10-16) | 1 set (3 defects) | consistency-check found three defects in the reversal edits. Fixed. |
| P5    | 1 set (3 defects) | Security review rated the setup cleanup Medium. Defects: bare substring matching, case-insensitive PowerShell matching, and symlinked marker deletion. Fixed via TDD. |
| P5    | 0 (1 requirement change) | ADR-003 decisions 4 and 5 reversed. Covered in the audit below. |

**Total self-corrections:** 2 (the build log records 0). The audit also counts 2 requirement changes.

## Artefact Counts

| Category | Count |
|----------|-------|
| Requirements | 8 (req-001 to req-008) |
| ADRs | 3 (ADR-002 revised to v0.1.1, ADR-003 to v0.2.0) |
| Feature test suites | 45 (44 passed, 1 failed on a pre-existing failure) |
| Regression suites | 12 (all passed) |
| Scripts | 2 (setup.sh, setup.ps1) |
| Skills | 12 |
| Templates | 2 |
| Files deleted | 35 paths (req-001) |
| Documentation | 5 docs written in P3 (req-007). 5 living docs updated in P6. |
| Backlog items | 6 filed (0000090 to 0000095). 1 discarded (0000085). |

## Efficiency Observations

The run reached P8 with every gate honoured under a pre-authorised continuous run. Four findings need attention. The build log summary contradicts its own phase entries. P9 is missing. The final ship gate is not recorded. The self-correction count is 0, but the log records at least four defects.

**Model routing audit**

- Primary tier: P6 docs agents are recorded as primary. Documentation updates are cheaper-eligible, and the 0000032 run routed its docs agents to the cheaper tier. The log gives no reason for the primary tier. Not evidenced. Treat as not applied.
- Primary tier: the P0 Explore agent mapped the codebase. Codebase discovery is cheaper-eligible. Its tier is not recorded. Not evidenced.
- Primary tier: P4 checks and P7 archiving ran inline on the orchestrator with no agent. Both are mechanical. The log gives no reason for running them inline.
- Cheaper tier: used, and not at zero. P0 scope-lock (4 calls on claude-sonnet-5) and P1 spec (2 calls) are recorded. P8 ran on claude-haiku-5-5.
- Summary contradiction: the summary records 0 cheaper calls. This is wrong. Flag as an accountability finding.
- Recording: sparse. P3 and P6 record one tier for all agents in the phase. The P0 Explore agent has no recorded tier. Flag as an accountability gap.

**Parallelism audit**

- P0: the log counts 2 batches. Batch 1 held one Explore agent, which is not parallel. Only the four Scope Lock drafts ran in parallel, and the log says so.
- P1: one batch with two agents. Evidenced, but the split across the agents is not recorded.
- P2: zero batches. Justified, because the three ADRs cross-reference one another.
- P3: seven agents across four batches. Batches 3 and 4 each held one requirement. The log does not say whether other independent tasks existed. Not evidenced.
- P4: one batch of shell checks with no agents. This is not agent parallelism. The summary counts P4 as a parallel phase. Overstated.
- P5: one agent counted as a batch. This is not parallelism. The summary counts P5 as a parallel phase. Overstated.
- P6: two agents in parallel. Evidenced.
- Summary count: the log lists 6 parallel phases. Evidenced multi-agent parallelism covers 4 phases (P0, P1, P3, P6).
- Single-message dispatch: recorded for P0 and P6 by wording only. Not recorded for P1 or P3.

**Phase gate audit**

- P0 design gate: confirmed by the human on 2026-09-10. Honoured.
- Continuous run: the human chose it at P0, which pre-authorised P1 to P3. The human confirmed it again for P5 onward on 2026-10-16. Honoured.
- P4 gate: reached on 2026-09-10 and accepted on 2026-10-15, after the human overrode a pre-existing failure with a recorded reason. Honoured.
- P5 entry: a telemetry marker needed a human decision. The human chose to keep the product id. Recorded and honoured.
- P6 Gate B: auto-accepted under the continuous run. Permitted by the P0 authority.
- Final ship gate: the log says P7 to P9 stop once at the final ship gate. The log records no human confirmation before P7 archived the feature. Treat as a process violation unless the human confirmed the gate outside the log.
- P9: no entry. See the build log integrity section.

**Self-correction audit**

- P3 criteria conflict: avoidable. The spec agent wrote req-002 and req-003 criteria that req-004 and ADR-002 later contradicted. The P1 cross-artefact check did not catch it. Cause: specification gap.
- P4 re-run: three defects in the reversal edits. Avoidable with a consistency check before the edit. Two cross-repo ADR-007 references read as local. Cause: a wrong assumption about reference conventions.
- P5 Medium finding: avoidable. ADR-002 did not specify path-boundary matching. The codegen agent used bare substring matching and did not escalate the gap. Cause: an unstated assumption.
- P5 ADR-003 reversal: the most costly defect. The P2 ADR removed the product.yml top-level id, which contradicts framework 0000030 ADR 007. The P1 and P2 checks did not catch it. The P3 code and P4 checks were built on the wrong decision. Rework touched req-005, product.yml, the template, the orchestrator skill and one rename test.
- Overall: four defects on a removal feature points to weak cross-artefact checks at P1 and P2. The log records zero self-corrections, which understates the rework.

**Build log integrity**

- Phases: P0 to P8 are represented. P9 has no entry, although the summary says P9 is recorded. Flag.
- Phase fields: model tier, skills, agent count, MCP calls, parallel batches and telemetry are populated for P0 to P8. Tier values contradict the notes in P0 and P1.
- Timestamps: P5 to P8 record dates only, with no times. Phase durations are not captured for those phases. Durations are not computed across the 2026-09-14 to 2026-10-15 pause.
- Telemetry field: recorded as "confirmed-disabled" for P1 to P4. A telemetry marker with 236 occurrences (2026-09-10 to 2026-09-14) surfaced only at P5 start. The log does not record whether the marker was checked during P1 to P4. Flag.
- Skill name: P4 records planifest-validate-and-accept, which does not appear in the available skill list. Not verified. Flag.
- Summary section: total phases (10) does not match the phase entries (9 recorded). Phases using parallelism (6) overstates the evidence. Self-corrections (0) understates the audit count (2). Cheaper calls (0) contradicts the phase entries.

## Key Findings

1. The build log summary contradicts its phase entries on model tier and parallelism. The cheaper tier was used 7 times, not 0.
2. The ADR-003 defect came from P2 and surfaced only at P5. The P3 code and P4 checks were built on the wrong decision.
3. P9 has no entry, and the final ship gate is not recorded before P7 archived the feature.
4. The log records 0 self-corrections. The audit finds 2, plus 2 requirement changes.
5. The telemetry field reads "confirmed-disabled" for P1 to P4, while a marker with 236 occurrences existed from 2026-09-10 to 2026-09-14.
6. Strengths: the P1 subagent claim about phase-enum.mjs was checked at source and found wrong. The P5 fix followed TDD, with failing assertions written first.
