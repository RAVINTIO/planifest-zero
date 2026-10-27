# Domain Glossary - improvement loops

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000202-improvement-loops
**Version:** 0.24.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Improvement loop | The bounded set of cycles that runs after a requirement reaches GREEN and refactor. Each cycle asks whether a simpler or cleaner solution meets the same tests. | none | ravintio-zero |
| Improvement cycle | One reviewer dispatch, plus the applied change and suite run when the reviewer finds something. | cycle | ravintio-zero |
| Reviewer | A subagent in a fresh context that reads the requirement, the test, and the implementation and returns a finding. It edits nothing. | none | ravintio-zero |
| Improve marker | The `Improve:` line that a cycle appends to the build log. | none | ravintio-zero |
