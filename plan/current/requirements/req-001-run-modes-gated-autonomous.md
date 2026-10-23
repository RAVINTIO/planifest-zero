---
title: "Requirement: req-001 - run-modes-gated-autonomous"
summary: "The pipeline offers two run modes, gated and autonomous, with the same exception stops in both."
status: "draft"
version: "0.1.0"
---
# Requirement: req-001 - run-modes-gated-autonomous

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000042-autonomous-mode-and-prefixes
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As a human on the loop, I choose `gated` or `autonomous` at the end of P0, so that the agent either stops for me at each phase gate or runs to a raised pull request.

## Functional Requirements
- The orchestrator ends P0 by asking this question, verbatim:

  ```
  How should the agent run P1 to P4?

    [1] Gated: the agent stops for you at the end of each phase
    [2] Autonomous: the agent runs to a raised PR and stops only for escalations
  ```

- The orchestrator writes `gated` or `autonomous` to `plan/.run-mode` and logs the choice in the build log.
  - No other value is valid.
  - `interactive` and `continuous` are retired. No skill, doc, template, hook, or test uses them as run-mode values.
- The phases are P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. REQ-002 owns this numbering.
- In `gated`, the run stops for human confirmation at the P1, P2, P3, and P4 gates.
  - The P4 gate comes before the PR, as today.
- In `autonomous`, the run stops at none of the P1, P2, P3, or P4 gates.
  - P3 puts its acceptance evidence in the PR description instead of a gate.
  - P4 raises the PR and ends with `P4 Ship: Complete: PR #{n} ready for your review`.
  - The agent never merges the PR and never commits to `main`.
- Both modes stop on these exceptions:
  - A requirement or check still fails after 5 attempts.
  - P2 needs a schema change.
  - The P3 security review finds an unmitigated critical or high issue.
  - A push or `gh pr create` fails.
- Each exception stop prints a message that starts with `Blocked:` and names the action the human needs to take.
  - Work stays committed and pushed before the stop.
  - After the human acts, the run resumes in the same mode.
- On resume, if `plan/.run-mode` is missing or holds an unknown value, the orchestrator asks the run-mode question.
  - The question names the value it found, or says the file is missing.
  - The orchestrator writes the answer to `plan/.run-mode` and logs it in the build log.
- The fresh-start stale check is unchanged.
- In a new session, if `plan/.run-mode` holds a valid mode, the orchestrator restores that mode without asking.
  - It reads `plan/.run-mode` and the build log first, then resumes at the last phase with that phase's prefix.
  - A gated run shows its pending gate again.
- `pipeline-reference.md` drops its rule that let continuous run skip a clean acceptance gate. The skills are the single source for gate behaviour.

## Acceptance Criteria
- [ ] (a) The orchestrator skill holds the run-mode question text exactly as above, offers only `[1] Gated` and `[2] Autonomous`, and writes `gated` or `autonomous` to `plan/.run-mode`.
- [ ] (b) A grep for `continuous` and `interactive` as run-mode values finds no match in the files in reach. The 0000023 tests assert `gated` and `autonomous` instead.
- [ ] (c) In `gated`, the orchestrator and phase skills stop at each of the P1, P2, P3, and P4 gates.
- [ ] (d) In `autonomous`, no phase skill stops at those gates. P3 writes acceptance evidence to the PR description, and P4 ends with `P4 Ship: Complete: PR #{n} ready for your review`.
- [ ] (e) In both modes, each of the four exceptions stops the run with a `Blocked:` message naming the action needed. Work is committed and pushed, and the run resumes in the same mode.
- [ ] (f) A missing `plan/.run-mode` and an unknown value such as `continuous` each make the orchestrator ask the run-mode question, name what it found, write the answer, and log it.
- [ ] (g) A new session with a valid `plan/.run-mode` restores that mode without asking. A gated run shows its pending gate again.
- [ ] (h) `pipeline-reference.md` no longer lets any mode skip a clean acceptance gate.

## Dependencies
- REQ-002 (phase numbering) supplies the phase numbers and prefixes used here.
- 0000023 set the continuous run gate rules that this requirement replaces.
- Files in reach (from a grep for `continuous`, `interactive`, and `run-mode` in `planifest-zero/`, excluding history):
  - `planifest-zero/skills/planifest-orchestrator/SKILL.md`
  - `planifest-zero/skills/planifest-validate-and-accept/SKILL.md` (no current match, but it owns the P3 gate, evidence, and security stop)
  - `planifest-zero/skills/planifest-ship/SKILL.md`
  - `planifest-zero/skills/planifest-migrator/SKILL.md` (matches only the word "interactively" in prose, so check it and change nothing unless it names a run mode)
  - `planifest-zero/pipeline-reference.md`
  - `planifest-zero/getting-started.md`
  - `planifest-zero/workflows/feature-pipeline.md`
  - `planifest-zero/tests/test-0000023-req-001-continuous-run-p1-p3.sh`
  - `planifest-zero/tests/test-0000023-req-002-marker-commit-lifecycle.sh`
- `planifest-zero/standards/reference/frontend-stack-evaluation.md` also matches the grep. It uses the words generically, so leave it unchanged.
