# Security Report - autonomous-mode-and-prefixes

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Version:** 0.9.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** medium
**Components Reviewed:** planifest-zero (the orchestrator, validate-and-accept, ship, implement, and loop-runner skills, `pipeline-reference.md`, `workflows/feature-pipeline.md`, the four enforcement hooks, `scripts/self-description-check.mjs`, `setup.sh`, `setup.ps1`, `tests/helpers/`, and the 0000042 tests)
**Review Scope:** code review | dependency audit | threat model

No finding is Critical or High. The code changes are safe. Every identifier rename is complete, and no guard now fails open. The hooks changed only fixed message strings. The setup scripts changed only fixed output lines. No credential appears in the diff.

The risk sits in the skill text for autonomous mode. Four Medium findings share one theme. Autonomous removes the human from every point between P0 and the PR, and these paths have no replacement check:

- a committed `plan/.run-mode` value restores autonomous with no question (F-001)
- an exception stop leaves no record that survives a new session (F-002)
- acceptance evidence goes into a public PR body with no redaction rule (F-003)
- a flagged credential does not stop the run before a push (F-004)

No mode merges a PR or commits to `main`. The human still reviews every change before it reaches `main`. That cap keeps each Medium finding below High.

I ran the ten 0000042 suites and three hook suites, and all passed:

| Suite | Result |
|-------|--------|
| `test-0000042-req-001-run-mode-question.sh` | 12 of 12 |
| `test-0000042-req-002-gate-and-exception-stops.sh` | 33 of 33 |
| `test-0000042-req-003-run-mode-resume.sh` | 16 of 16 |
| `test-0000042-req-004-phase-numbers-p0-to-p4.sh` | 23 of 23 |
| `test-0000042-req-005-message-prefixes.sh` | 32 of 32 |
| `test-0000042-req-006-phase-guard-and-stale-cites.sh` | 12 of 12 |
| `test-0000042-req-007-product-name-planifest-zero.sh` | 7 of 7 |
| `test-0000042-req-008-pack-prose.sh` | 43 of 43 |
| `test-0000042-req-009-pack-identifiers.sh` | 40 of 40 |
| `test-0000042-req-010-pack-wording-allowlist.sh` | 2 of 2 |
| `test-0000019-req-002-component-yml-matcher.sh` | 16 of 16 |
| `test-0000035-req-001-hook-parity.sh` | 17 of 17 |
| `test-gate-write-windows.sh` | 13 of 13 |

`pwsh` is not installed here, so I reviewed the `setup.ps1` and `setup-workspace.ps1` changes by reading them.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | medium | auth | planifest-zero | A committed run mode restores autonomous with no question. `plan/.run-mode` is a tracked file (`git ls-files` lists it), and the discovery commit includes it (`skills/planifest-orchestrator/SKILL.md:344`). On resume, `gated` or `autonomous` restores "without asking" (`SKILL.md:80`). Say someone with push access commits `autonomous` to a branch that holds `plan/current/`. The next session on that branch skips the P1 to P4 gates, pushes, and runs `gh pr create` (`skills/planifest-ship/SKILL.md:95`). The human never chose that. `SKILL.md:344` states that only the orchestrator writes the file. No hook enforces it, and `gate-write.mjs` permits writes to `plan/` outside `plan/current/` (`gate-write.mjs:100-116`). Unknown and retired values fail safe. `continuous`, `interactive`, and anything else make the agent ask (`SKILL.md:80`). | When a resumed session reads `autonomous`, confirm it once with the human before the first gate it would skip. Treat a value as valid only when it matches a `Run mode:` line in the build log P0 block. State that the match is exact, with no case folding or extra text. | not mitigated |
| F-002 | medium | auth | planifest-zero | An exception stop leaves no durable record. The stop rules print a `Blocked:` message and wait (`skills/planifest-orchestrator/SKILL.md:389`, `skills/planifest-validate-and-accept/SKILL.md:82-88`). Nothing tells the agent to log the stop in the build log. The resume rule re-shows only a gated gate with no `Gate accepted` line (`orchestrator/SKILL.md:80`). If the session ends at a P3 security stop in autonomous, a new session finds `security-report.md` present. It has no rule that says the stop is unresolved, so it can move on to P4 and raise the PR. The 5-attempt stop is safer, because its loop state file holds `status: escalated` (`skills/planifest-loop-runner/SKILL.md:33`). | Append `Blocked: {exception} ({timestamp})` to the build log at every exception stop, and commit it. On resume, refuse to pass a `Blocked:` line that has no later human resolution line. | not mitigated |
| F-003 | medium | data-exposure | planifest-zero | Acceptance evidence goes into a public PR body with no redaction rule. In autonomous, P3 writes checks, security findings, and "what was run, what was observed" to `plan/current/acceptance-evidence.md` (`skills/planifest-validate-and-accept/SKILL.md:93-100`). P4 copies the contents into the PR body (`skills/planifest-ship/SKILL.md:97`). The repo `planifest/planifest-zero` is public. Raw command output can hold environment values, tokens, or file contents. Open Medium and Low findings become public before any fix. The plan files reach the public branch in both modes, so the PR body is a second copy. The new part is that no human sees the evidence before it is published. | Add a rule to both skills. The evidence lists results and `file:line` cites only, and never raw command output, environment values, or file contents. Before `gh pr create`, scan the body for credential patterns and stop on a match. Consider a summary line for open findings in place of full detail. | not mitigated |
| F-004 | medium | data-exposure | planifest-zero | A flagged credential does not stop the run. Hard Limit 6 says to flag a credential and not use it (`skills/planifest-orchestrator/SKILL.md:23`). The four exception stops do not include it (`SKILL.md:387-396`). In autonomous, the agent pushes after each gate commit where a push is authorised (`SKILL.md:368`), and this repo authorises it (`planifest-overrides/instructions/custom-001-local-git-only.md`). A credential in a committed file can reach the public remote with no human between the flag and the push. In gated mode, the human sees the flag at the next gate. | Add a fifth exception stop. If a credential appears in a file the run will commit, stop before the commit and before any push. | not mitigated |
| F-005 | low | auth | planifest-zero | The security stop depends on the agent's own "mitigated" label. The stop fires only when a Critical or High finding is "not mitigated" (`skills/planifest-validate-and-accept/SKILL.md:82`). The agent that writes the report also sets the label. Nothing defines "mitigated". An agent can mark a finding mitigated because a recommendation exists. The line "Be sure critical and high findings are genuine" on the same line adds pressure to rate lower. | Define "mitigated" as a change made in this run with a cited test or file. Allow "accepted" only with a human-written build-log line. | not mitigated |
| F-006 | low | config | planifest-zero | Autonomous ship pushes without a recorded push grant. Mid-run pushes need a standing override or a per-session grant (`skills/planifest-orchestrator/SKILL.md:368`). Ship in autonomous takes option [1] without asking (`skills/planifest-ship/SKILL.md:95`). In a consumer repo with no push override, the run-mode choice is the only consent. The question text "runs to a raised PR" (`orchestrator/SKILL.md:341`) implies the push but does not name it. | State in `ship/SKILL.md:95` that choosing autonomous grants push and `gh pr create` for this run only. Log that grant with the `Run mode:` line. | partly mitigated |
| F-007 | low | config | planifest-zero | The loop escalation format still names retired prefixes. `skills/planifest-loop-runner/SKILL.md:61` lists "(D, PL, IM, VA, or SH)". The template at `loop-runner/SKILL.md:64` is `{phase-prefix}: Blocked ({loop-id}): ...`. With the new prefix `P2 Implement:`, that renders as a double colon. It also differs from the 5-attempt message in the Exception Stops table (`orchestrator/SKILL.md:393`). An escalation in this form may not match what a human or a later check expects. The req-005 guard missed this file. | Change the list to the five P0 to P4 prefixes and the template to `{prefix} Blocked: ...`. Add `planifest-loop-runner` to the files the req-005 guard checks. | not mitigated |
| F-008 | informational | config | planifest-zero | `pipeline-reference.md:97` says the agent "raises the PR", then names the gated question, then the local-git-only rule. The ship skill checks local-git-only first (`skills/planifest-ship/SKILL.md:84`). An agent that reads the reference alone might push before it checks the override. The reference says the skills are the single source (`pipeline-reference.md:87`). | Reorder the sentence to match the ship skill: local-git-only first, then the run mode. | open |
| F-009 | informational | config | planifest-zero | `workflows/feature-pipeline.md:92` says each stop "starts with `Blocked:`". The design and the skills put the phase prefix first (`orchestrator/SKILL.md:398`). | Change it to "starts with its phase prefix, then `Blocked:`". | open |

## Review notes by area

### Run-mode handling

- **Values.** Only `gated` and `autonomous` are valid (`orchestrator/SKILL.md:344`). Any other value on resume makes the agent ask and name the value it found (`SKILL.md:80`). The tracked file holds `continuous` today, so the refreshed skills will ask on resume. That is the fail-safe path working.
- **Writer rule.** `orchestrator/SKILL.md:344` says "Only this skill writes `plan/.run-mode`. Phase skills read it and never write it." No hook enforces the rule (F-001).
- **Merge and `main`.** Both stay human-only in every mode. See `orchestrator/SKILL.md:383`, `orchestrator/SKILL.md:398`, `ship/SKILL.md:18`, `pipeline-reference.md:87`, and `workflows/feature-pipeline.md:101`. The stop rule forbids force-push and merge as workarounds (`orchestrator/SKILL.md:398`).
- **Exception stops.** The four stops cover an unmitigated Critical or High finding (`validate-and-accept/SKILL.md:82-86`, `orchestrator/SKILL.md:395`). Gaps: the stop has no durable record (F-002), and the label it depends on has no definition (F-005).
- **Ship timing.** Ship reads the run mode before Step 8, because Step 9 deletes the file (`ship/SKILL.md:17`, `ship/SKILL.md:129`). That ordering is correct.

### Acceptance evidence

- The evidence path and its exposure are F-003.
- The archive step runs before the PR (Step 4 before Step 8), so ship reads the archived copy. The path is correct.

### Identifier renames and path handling

- **`auto-trigger-orchestrator.mjs:33-34`.** It renames `frameworkPath` to `zeroDir` on both lines. No other reference exists. `node --check` passes. The guard exits 0 only when `planifest-zero/` is absent, as before.
- **`self-description-check.mjs:88-116`.** It renames `extractFrameworkTable` and `frameworkDir` in full, and the heading regex now matches `## The pack`. A missing heading still adds a finding (`self-description-check.mjs:98`), so the check fails closed. The script reports a clean match on this repo.
- **`setup.sh:673`, `setup.sh:1192`, `setup.ps1:769`, `setup.ps1:1314`.** Only fixed output text changed. The `.gitignore` warning already printed `$gitignore_src`, a path the script builds. `bash -n setup.sh` passes. The setup scripts had no `FRAMEWORK_DIR` variable to rename.
- **`tests/helpers/setup-workspace.ps1:7`, `:33`.** It renames `$global:FrameworkDir` to `$global:ZeroDir`. Both callers use the new name (`test-0000040-req-002-003-ps1-shape-check.ps1:70`, `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1:188`). `git grep` finds no old identifier outside `plan/`.
- **Tests.** The new suites quote every variable. The two that make temp folders remove them with an `EXIT` trap (`test-0000042-req-004-phase-numbers-p0-to-p4.sh:74-75`, `test-0000042-req-010-pack-wording-allowlist.sh:128-129`).

### Hook enforcement

- **`gate-write.mjs`.** The logic is unchanged. Only two fixed strings changed (`gate-write.mjs:108`, `gate-write.mjs:123`). Neither prints input. The sentinel check, the design check, and the component-path check all still exit 2. The Windows path suite passed 13 of 13.
- **`check-design.mjs:52`** and **`ratchet-check.mjs:36`.** One fixed string and one comment changed.
- **Installed copies.** After the setup refresh, `diff` shows the four hooks and the orchestrator and ship skills in `.claude/` match the source.

### Credentials

I grepped every added line for keys, tokens, passwords, bearer strings, `ghp_`, `github_pat`, `AKIA`, and private-key headers. Nothing matched beyond two comment words. No credential appears in the diff.

### Dependency risk

No new dependency. No lock file changed.

## Dependency Audit

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat Model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Run escalates to autonomous without the human's choice | Commit `autonomous` to `plan/.run-mode` on a shared branch | orchestrator, ship | low | medium | Push access needed. Merge stays human-only. | F-001 |
| Run passes an unresolved exception stop | Session ends at a stop, and a new session resumes | orchestrator, validate-and-accept | medium | medium | 5-attempt loops record `status: escalated` | F-002 |
| Secret or open finding published | Evidence copied into a public PR body | validate-and-accept, ship | medium | medium | None | F-003 |
| Credential pushed to the public remote | Credential in a committed file during an autonomous run | orchestrator | low | high | Hard Limit 6 flags it | F-004 |
| High finding labelled mitigated without a fix | The agent sets its own label | validate-and-accept | low | medium | Human reviews the PR before merge | F-005 |
| Agent merges or commits to `main` | Autonomous run reaches the PR | ship | low | high | Human-only rule in four places | None |
| Guard fails open after a rename | Empty or undefined renamed variable | hooks, scripts | low | high | Renames complete. Suites pass. | None |

## Risk register cross-reference

| ID | Status | Evidence |
|----|--------|----------|
| R-005 | mitigated | All ten 0000042 suites pass on the merged tree. No file shows a conflicting edit. |
| R-006 | open | The wording and phase guards pass, but a retired prefix list survives at `planifest-loop-runner/SKILL.md:61` (F-007). |
| R-007 | open | The security stop exists (`validate-and-accept/SKILL.md:82-86`), and the evidence reaches the PR. The stop leaves no durable record (F-002), and its label has no definition (F-005). |
| R-008 | mitigated | The setup refresh has run. The installed hooks and skills in `.claude/` match the source. |
| A-003 | open | No migration exists, by design. Another install that holds `continuous` or `interactive` is asked again on resume, which fails safe. |
| A-004 | mitigated | Old names stay. For example, the header of `test-0000023-req-001-continuous-run-p1-p3.sh:2-8` states the current gated and autonomous behaviour. |

## Recommendations

Ordered by priority:

1. Log every exception stop in the build log, and refuse to resume past an unresolved one (F-002, R-007).
2. Add a redaction rule for acceptance evidence, and scan the PR body for credential patterns before `gh pr create` (F-003).
3. Add a credential exception stop that fires before any commit or push (F-004).
4. Confirm a restored `autonomous` with the human once per resumed session, and check it against the build log (F-001).
5. Define "mitigated" and "accepted" for the security stop (F-005).
6. Fix the loop-runner prefix list and template, and extend the req-005 guard to that file (F-007, R-006).
7. Name the push grant in the ship skill and the run-mode log line (F-006). Fix the two wording points in the reference and the workflow (F-008, F-009).
