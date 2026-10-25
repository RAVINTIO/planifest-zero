# Build report - 0000170-story-mapping-and-gherkin

> Sourced from the archived `build-log.md`. Roadmap 0000168, step 2.

## Agents and tiers

| Phase | Agents | Tier | Parallel batches |
|-------|--------|------|------------------|
| P0 Discovery | 0 | primary orchestrator | 0 |
| P1 Plan | 2 | 1 primary, 1 cheaper | 1 |
| P2 Implement | 2 | sonnet | 1 |
| P3 Validate and Accept | 2 | cheaper | 1 |
| P4 Ship | 0 | primary orchestrator | 0 |

## Parallelism

- P1 ran the requirements agent and the scope agent together. The orchestrator wrote the story map, ADRs, and execution plan while they ran.
- P2 ran tracks A and B together on disjoint files. Track B kept REQ-003 to REQ-005, because REQ-004 and REQ-005 both change the 0000016 fixtures.
- P3 ran verification and the security review together, and the orchestrator ran the full suite meanwhile.
- P0 and P4 ran in sequence. P0 reads were small, and ship runs in order by design.

## Session break

The P2 session ended after both tracks committed but before the `Done:` lines. The next session found the commits on resume and recorded them. No work was lost or repeated.

## Self-corrections

| Phase | Correction | Avoidable |
|-------|-----------|-----------|
| P2 | Backlog entry 0000175, filed on the roadmap branch during the run, used a word the pack wording test bans. P2 reworded it. | Yes. A wording check when a backlog entry is filed would catch it. |

## Deviations

None.

## Improvement suggestions

- P2: the full suite still inherits the driver's `RAVINTIO_ROADMAP_MODEL`, as step 1 noted. Unset it in tests 0000043 and 0000151, or run the suite under `env -i` by default in a roadmap step.
- P2: write the `Done:` marker in the same commit as each track's last change, so a session break leaves no open marker.
- P3: the two low findings went to backlog 0000176. A cap on printed plan text could join the code-quality standard.
