# Build report - 0000151-hardening-efficiency-and-ci

Source: the archived `build-log.md` in this folder.

## Agents and tiers

| Phase | Agents | Tiers | Parallel batches |
|-------|--------|-------|------------------|
| P0 Discovery | 4 | sonnet 4 (Explore surveys) | 1 |
| P1 Plan | 11 | sonnet 10, claude-code-guide 1 (sonnet) | 3 |
| P2 Implement | 9 | sonnet 9 | 1, then 2 sequential batches |
| P3 Validate and Accept | 4 | opus 1 (security review), sonnet 3 | 2 |
| P4 Ship | 0 | none | 0 |
| Total | 28 | primary 1, cheaper 27 | |

The orchestrator itself ran on opus for the whole run.

## Parallelism

- P0 ran four code surveys at once while the orchestrator wrote the discovery files.
- P1 drafted 15 requirements in five parallel agents, beside a fact check. The ADRs ran beside the scope, risk, and glossary set. Three agents then regrouped the acceptance criteria in parallel.
- P2 ran seven TDD tracks at once. The three orchestrator requirements ran in sequence afterwards, because each edits `SKILL.md`. The docs ran last.
- P3 ran the security review, execution verification, coverage audit, and full suite at once.
- P4 ran in sequence. Each step reads the output of the step before.

## Self-corrections

| Cycle | Fault | Avoidable? |
|-------|-------|------------|
| P1 | All 15 requirements had more than three acceptance criteria. | Yes. The drafting prompt did not state the consistency check's limit of three. |
| P2 fix-up 1 | Two older suites broke on the `setup.ps1` changes. | Partly. Track A ran only the tests that named its files, and these suites checked the file by pattern. |
| P2 fix-up 2 | GitHub rejected the workflow, because a step's `shell` key takes no expression. | Yes. No local check parses workflow expressions. |
| P3 cycle 1 | Security: a symlinked step-log path (high) and recursive `assert.ps1` helpers (medium). | Yes. The step-log requirement did not apply the park symlink rule from the same release. The recursion came from an unrun PowerShell edit. |
| P3 cycle 2 | The REQ-011 byte check failed on Windows CRLF checkouts. | Yes. The test measured raw file length. |

## Deviations

- Parallel tracks committed into one working tree. A ref-lock race put the REQ-012 driver change in a commit titled "mark Track D done".
- `pwsh` was absent locally, so PR #23 opened as a draft during P3 to run the PowerShell suites in CI.
- REQ-011 wrote its test after the split, so it has no RED run.

## Improvement suggestions

- **P0:** check that `pwsh` is installed when a run edits PowerShell, and offer to install it before P2.
- **P1:** put the consistency check's criteria limit in every requirement-drafting prompt.
- **P2:** have parallel tracks stage and commit through one serialised helper, or let the dispatcher commit, so no commit takes in another track's files. Run the full quiet suite after each batch, not only per track.
- **P3:** when a release adds a write path, check it against every containment rule in the same release before P3.
