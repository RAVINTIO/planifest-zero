# Domain Glossary - reply conventions

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Version:** 0.22.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Prefix | The first words of a reply, such as `P2 Implement:`. They name the phase or stage the reply belongs to. | reply prefix | ravintio-zero |
| Status form | The shape `{prefix} {Status}: {one-liner}`. The status is Starting, Resuming, Complete, Blocked, or Skipped. | none | ravintio-zero |
| Out-of-phase prefix | `Supervise:`, for work outside a phase or stage. | none | ravintio-zero |
| Reporting rule | A reply reports results, deviations, failures, and decisions, and never reports compliance with a standing rule. | none | ravintio-zero |
| Miss | A reply in an active run whose first line holds no valid prefix. | none | ravintio-zero |
| Miss log | `plan/.prefix-misses.log`. It holds one line per miss. | none | ravintio-zero |
