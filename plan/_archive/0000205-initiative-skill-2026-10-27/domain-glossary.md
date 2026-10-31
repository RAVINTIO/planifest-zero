# Domain Glossary - initiative skill

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Version:** 0.27.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Initiative skill | The `ravintio-initiative` skill. It coordinates an initiative in the human's session. | initiative coordinator | ravintio-zero |
| Driver | The script `initiative-run.mjs`. It starts one step session after another and holds no AI. | none | ravintio-zero |
| Step session | A `claude -p` process that loads the orchestrator and builds one feature from P0 to P4. | none | ravintio-zero |
| Watch script | The read-only script `initiative-watch.mjs`. It prints event lines and a heartbeat for a monitor. | none | ravintio-zero |
| Initiative ack | The file `plan/.initiative-ack`. It holds the session id of the human's session. | none | ravintio-zero |
| Initiative queue | The folder `plan/.initiative-queue/`. It holds backlog entries filed while a step runs. | none | ravintio-zero |
