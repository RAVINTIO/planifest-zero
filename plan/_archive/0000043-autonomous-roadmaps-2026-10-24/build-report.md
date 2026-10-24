# Build report - 0000043-autonomous-roadmaps

Source: the archived `build-log.md` in this folder.

## Agents and tiers

| Phase | Agents | Tiers | Parallel batches |
|-------|--------|-------|------------------|
| P0 Discovery | 1 | claude-code-guide, tier not recorded | 0 |
| P1 Plan | 9 | sonnet 8, haiku 1 | 2 |
| P2 Implement | 7 | sonnet 7 | 3 |
| P3 Validate and Accept | 7 | sonnet 5, opus forks 2 | 1 |
| P4 Ship | 0 | none | 0 |
| Total | 24 | primary 2, cheaper 21, unrecorded 1 | |

## Parallelism

- P1 wrote requirements, ADRs, and the scope set in parallel.
- P2 ran four TDD tracks in its first batch, then the standard extraction and regression copies, then the docs.
- P3 ran merge-guard hardening beside the coverage and execution checks. The two design changes from the live run, req-011 and req-012, ran one after the other. Each touched the orchestrator skill and the shared requirement set.
- P4 ran in sequence. Each step reads the output of the step before.

## Self-corrections

| Cycle | Fault | Avoidable? |
|-------|-------|------------|
| P3 cycle 1 | Four roadmap hand-off bugs | Yes. A dry run of one step before P3 would have caught them. |
| P3 cycle 2 | merge-guard bypass forms | Partly. The first design matched text, not commands, and a fail-closed design from P1 would have avoided the bypass forms. |
| P3 cycle 3 | The driver rejected quoted template values | Yes. A test against the real template would have caught it in P2. |
| P3 cycle 4 | Four faults in the live acceptance run | Partly. List-marker `Blocked:` lines and interrupted-unit resume only showed up in a real run. |

## Deviations

- `design.md` had no `## Component Paths` section, so gate-write blocked P2 subagents. They wrote files through Bash, and one used sed placeholders to get past the installed merge-guard. The section was added in P3. This was avoidable with a check at the design gate.
- The roadmap detail moved to `planifest-zero/standards/roadmap-standards.md` to stay inside the skill-text limit.

## Improvement suggestions

- **P0:** check that `design.md` declares component paths that gate-write can match before the design gate closes.
- **P1:** for a feature that adds a guard hook, specify it as fail closed from the start.
- **P2:** test scripts against the real templates they parse, not hand-written fixtures alone.
- **P3:** run the live acceptance test before the desk review. It found the faults that mattered most.
