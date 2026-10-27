# Scope - reply conventions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Version:** 0.22.0

## In Scope

- Add a Reply Conventions section to the boot template with the prefix table, the status form, `Supervise:`, and the reporting rule.
- State the reporting rule and `Supervise:` in the orchestrator skill.
- Restate the prefix in the opening lines of the plan, implement, validate-and-accept, and ship skills.
- Add the `check-reply-prefix.mjs` Stop hook, which warns and logs a miss and never blocks.
- Wire the hook in `setup.sh` and `setup.ps1`, and update the parity suite, `component.yml`, and the docs that list hooks.
- Add tests for the hook, the wiring, and the doc text.

## Out of Scope

- A hook that blocks a reply.
- A hook check of the reporting rule.
- Changes to the existing phase and stage prefixes.
- A tool that summarises the miss log.
- Tools other than Claude Code.

## Deferred

Nothing deferred.
