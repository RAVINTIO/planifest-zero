# Scope - initiative skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Version:** 0.27.0

## In Scope

- Add the `ravintio-initiative` skill for I-A Chart, I-B Activate, progress reports, backlog queueing, and I-E Delivery.
- Split resume detection and ack files between the orchestrator and the initiative skill.
- Change the auto-trigger and presence hooks to load the right skill and accept either ack file.
- Add the read-only `initiative-watch.mjs` script.
- Fix three driver bugs and print a final report that names each step.
- Add the three-part table and run sequence to the roadmap standards and project operations.
- Update `component.yml`, the architecture overview, the pipeline reference, the catalogue, and the skill counts.
- Add tests.

## Out of Scope

- Chart-time decisions from past stops, which backlog entry 0000186 covers.
- Changes to how a step builds a feature from P0 to P4.
- A monitor implementation. The skill uses the host's tool.

## Deferred

Nothing deferred.
