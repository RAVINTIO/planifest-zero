# Scope - plan concurrent work

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Version:** 0.23.0

## In Scope

- Add a Concurrency plan section to the execution plan template and its guide.
- Require the section in the plan skill, in each plan and each re-plan after a reopened phase, and point the mid-pipeline changes reference to the rule.
- Add the default and the reason rule to the dispatch standard, and tell the implement skill to dispatch by the plan's batches.
- Add check 8 to `consistency-check.mjs`.
- Update `component.yml`, the docs that list the checks, and add tests.

## Out of Scope

- A hook that blocks dispatch that departs from the plan.
- Changes to the `fast` batches or to `plan/.run-speed`.
- A tool that compares plan batches to actual dispatch.
- Phases other than P1 and P2.

## Deferred

Nothing deferred.
