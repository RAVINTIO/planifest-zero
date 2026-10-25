# Build report - 0000171-faster-setup-ps1-tests

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 3.

## Agents and tiers

| Phase | Agents | Tier | Parallel batches |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary orchestrator | 0 |
| P1 Plan | 1 | cheaper | 1 |
| P2 Implement | 2 | sonnet | 1 |
| P3 Validate and Accept | 2 | cheaper | 1 |
| P4 Ship | 0 | primary orchestrator | 0 |

## Parallelism

- P1 ran the scope agent while the orchestrator wrote the story map, requirements, ADRs, and execution plan. The requirements share the profile findings, so one writer kept them in step.
- P2 ran tracks A and B together on disjoint files. REQ-001 has no code of its own, so batch 2 measured it.
- P3 ran verification and the security review together, and the orchestrator ran the full suite meanwhile.
- P0 and P4 ran in sequence. Each P0 profiling probe depended on the one before, and ship runs in order by design.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P2 | A new `setup.ps1` comment used a word the pack wording test bans, in a .NET version name. P2 reworded it. | Yes. The track brief could name the banned word for code comments as well as prose. |

## Deviations

None.

## Improvement suggestions

- P0: profiling `setup.ps1` with function-level wrappers found the slow step in one run. A reusable profile script in `tests/helpers/` would let later runs repeat it.
- P2: REQ-001 AC-1 can only pass in CI. A speed target like this could carry a CI-only marker in the requirement template, so P3 does not count it as unverified.
- P4: the archive step's glob removal of `plan/current/` hit a safety check. `git rm -r plan/current` after the copy does the same job on tracked files.
