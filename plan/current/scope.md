# Scope - blameless postmortems

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Version:** 0.25.0

## In Scope

- Add the `ravintio-postmortem` skill and a record template.
- Run the skill from the orchestrator after a `Resolved:` line, before ship.
- Add a catalogue row and a build report line that lists the run's records.
- Update `component.yml`, the architecture overview, and the pipeline reference to 14 skills.
- Add tests.

## Out of Scope

- A script that detects triggers or writes records.
- A postmortem for a P3 finding that the run fixed without a stop.
- A ship block on a missing postmortem.

## Deferred

Nothing deferred.
