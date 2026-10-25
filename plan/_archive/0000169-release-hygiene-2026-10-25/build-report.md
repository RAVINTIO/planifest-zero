# Build report - 0000169-release-hygiene

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 1.

## Agents and tiers

| Phase | Agents | Tier | Parallel batches |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary orchestrator | 0 |
| P1 Plan | 3 | 2 sonnet, 1 haiku | 1 |
| P2 Implement | 4 | sonnet | 2 |
| P3 Validate and Accept | 2 | sonnet | 1 |
| P4 Ship | 0 | primary orchestrator | 0 |

## Parallelism

- P1 ran two requirement agents and the scope agent together. The orchestrator wrote the ADRs and execution plan while they ran.
- P2 ran tracks A, B, and C together. Track D started as soon as track A finished, beside track B, because their files did not overlap.
- P3 ran verification and the security review together.
- P0 and P4 ran in sequence. P0 reads were small, and ship runs in order by design.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P2 | The boot-text edit went 44 bytes over the 0000151 size cap, so track A shortened two bullets. | Yes. The dispatch named the cap, and the agent caught it before the commit. |
| P3 | S-001: the template's write-token job used a floating checkout ref. The fix pinned it. | Yes. The track D brief could have asked for the pinned SHA in both files. |

## Deviations

- `test-0000037-req-003` failed on the roadmap base, because activation recorded `--strict-orchestrator`. The suite now follows the tracked flags.
- The 0000034 byte-compare drops the new `attribution` key.
- REQ-004 criterion b now matches what setup writes.

## Improvement suggestions

- P1: say in the requirement template that "byte-identical" names the field it means. That avoids a P3 reword.
- P2: put "pin every checkout in a job with write access" in any dispatch that edits a workflow.
- P2: the full suite inherits the driver's `RAVINTIO_ROADMAP_MODEL`. Run it under `env -i` in a roadmap step to avoid false failures.
