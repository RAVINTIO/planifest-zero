---
title: "Requirement: req-006 - roadmap-step-model-and-turn-cap"
summary: "The roadmap driver starts each step on a chosen model with an optional turn cap, and stops with a Blocked line when the cap ends a step."
status: "draft"
version: "0.1.0"
---
# Requirement: req-006 - roadmap-step-model-and-turn-cap

**Skill:** [plan](../skills/planifest-plan/SKILL.md)
**Feature:** 0000151-hardening-efficiency-and-ci
**Source:** US-006 (backlog 0000148, change 1)
**Priority:** must-have

## User Story

As the person paying for runs, I want each headless roadmap step to run on a cheaper model with a turn limit, so that one step cannot spend an Opus-sized share of my allowance.

## Functional Requirements
- `planifest-zero/scripts/roadmap-run.mjs` passes `--model {model}` to every `claude -p` call.
  - The model comes from `PLANIFEST_ROADMAP_MODEL`.
  - If the variable is unset or empty, the model is `sonnet`.
  - The driver passes the model as one argument and never through a shell.
- The driver passes `--max-turns {n}` when `PLANIFEST_ROADMAP_MAX_TURNS` is set.
  - If the variable is unset or empty, the driver passes no `--max-turns` and the step has no cap.
  - The value must be a positive integer. Any other value stops the driver before it takes the lock.
  - A default cap would end valid long steps, so no default ships. The human chooses a cap per run.
- The full argument list is `-p --permission-mode auto --model {model} [--max-turns {n}] "Run roadmap step {position}"`.
  - The driver still passes no `--continue` and no `--resume`.
- If `claude` exits non-zero while a cap is set, the stop line names the cap.
  - The stop line starts `R-C Run: Blocked:` and says the step may have reached `PLANIFEST_ROADMAP_MAX_TURNS={n}`.
  - The driver never retries the step or raises the cap itself.
  - The existing non-zero exit stop is the only stop path. This requirement adds no exit-code case.
- The header comment of `roadmap-run.mjs` documents both variables under `Environment:`.
- `planifest-zero/standards/roadmap-standards.md` documents both variables, the default, and the stop behaviour in a section on the driver environment.

## Acceptance Criteria
- [ ] (a) Driver arguments and input validation. Every check below holds.
  - With a stub `claude` and neither variable set, the stub logs `-p --permission-mode auto --model sonnet Run roadmap step 1`, with no `--max-turns`.
  - With `PLANIFEST_ROADMAP_MODEL=haiku` and `PLANIFEST_ROADMAP_MAX_TURNS=40`, the stub logs `--model haiku --max-turns 40` before the prompt.
  - For each of `0`, `-3`, `1.5`, `abc`, and `10 --foo` in `PLANIFEST_ROADMAP_MAX_TURNS`, the driver exits 1, prints a `R-C Run: Blocked:` line, runs no step, and creates no lock.
  - For a model value with a space, a leading hyphen, or a shell metacharacter, the driver exits 1 with the same effect as (c).
- [ ] (b) Failure handling. Every check below holds.
  - When the stub exits non-zero with a cap set, the driver prints one `R-C Run: Blocked:` line that names `PLANIFEST_ROADMAP_MAX_TURNS={n}`, releases the lock, and exits 1.
- [ ] (c) Documentation and existing tests. Every check below holds.
  - The header comment of `roadmap-run.mjs` and `roadmap-standards.md` each contain both variable names and the word `sonnet`.
  - Every earlier stop in `test-0000043-req-007-roadmap-driver.sh` and `test-0000043-req-012-progress-markers-and-resume.sh` still passes, with only their expected argument string updated for `--model sonnet`.

## Dependencies
- Assumption: `claude -p` accepts both `--model` and `--max-turns`, and exits non-zero when the turn cap ends a session.
  - Impact if wrong: the flags are ignored or rejected, and every step fails or runs uncapped.
  - A separate check confirms the flags against `claude --help` and one real capped call. This requirement does not depend on the result, because tests use a stub.
- REQ-012 (step logs) changes the same `runStep` call. Build REQ-006 first, then REQ-012.
- Files in reach:
  - `planifest-zero/scripts/roadmap-run.mjs` (edit `runStep` and the header comment)
  - `planifest-zero/standards/roadmap-standards.md` (add the driver environment section)
  - `planifest-zero/tests/test-0000043-req-007-roadmap-driver.sh` (update the expected argument string)
  - `planifest-zero/tests/test-0000043-req-012-progress-markers-and-resume.sh` (update any argument match)
  - `planifest-zero/tests/test-0000151-req-006-roadmap-step-model-and-turn-cap.sh` (new, uses the stub `claude` pattern of the req-007 test)

## Input Validation

- [ ] Input source: environment variables `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS`
- [ ] Allowed character pattern: the model must match `^[A-Za-z0-9][A-Za-z0-9._:\[\]-]{0,63}$`. The turn cap must match `^[1-9][0-9]{0,3}$`. Any other value stops the driver
- [ ] maximum length: 64 characters for the model and 4 digits for the turn cap
- [ ] Failure behaviour: print `R-C Run: Blocked:` with the variable name and the rule, exit 1, take no lock, and launch no `claude`
- [ ] Logging policy: the stop line prints the variable name and never the rejected value
