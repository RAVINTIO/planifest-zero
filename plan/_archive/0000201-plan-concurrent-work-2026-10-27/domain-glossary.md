# Domain Glossary - plan concurrent work

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000201-plan-concurrent-work
**Version:** 0.23.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Concurrency plan | The `## Concurrency plan` section of the execution plan. It lists the work units, their dependencies, their write targets, and their batches. | none | ravintio-zero |
| Unit | One piece of work that a single agent or step can finish, such as a requirement file or a code change with its test. | work unit | ravintio-zero |
| Batch | A set of units dispatched in one message. Units in one batch share no write target and depend on no unit in the same batch. | none | ravintio-zero |
| Write target | A file a unit creates or edits. | none | ravintio-zero |
| Sequential reason | The text that explains why a unit runs alone in its batch. | none | ravintio-zero |
