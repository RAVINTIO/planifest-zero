---
title: "Scope - chart rules"
summary: "Defines explicit boundaries of what is in scope and out of scope."
status: "active"
version: "0.1.0"
---
# Scope - chart rules

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000252-chart-rules
**Version:** 0.40.0

## In Scope

- A guard-widening rule in the I-A Chart section of `roadmap-standards.md` and in `ravintio-initiative/SKILL.md`.
- A step confirmation rule in the I-A Chart section, and a confirmation row form in the `## Decisions` table of `initiative.template.md`.
- A `## P1 skips` section in `initiative.template.md`, a rule on which steps chart may mark `yes`, a stop rule in I-C Run, and a build log line rule.
- Three tests: `test-0000252-req-001-guard-widening-rule.sh`, `test-0000252-req-002-step-confirmation-rule.sh`, and `test-0000252-req-003-p1-skip-record.sh`.
- Docs, changelog, and version updates for 0.40.0.

## Out of Scope

- Any change to `merge-guard`, `gate-write`, `ratchet-check`, or another hook.
- A change to the driver or the watcher.
- A new column in the `## Steps` table.
- A change to the active initiative's own `initiative.md`.
- A change to the `ravintio-refresh-setup` skill.

## Deferred

Nothing deferred.
