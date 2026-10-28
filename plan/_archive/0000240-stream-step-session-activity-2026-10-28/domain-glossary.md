---
title: "Domain Glossary - stream step session activity"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - stream step session activity

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000240-stream-step-session-activity
**Version:** 0.31.0

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Step session | One `claude -p` run that builds one initiative step | step | ravintio-zero |
| Step log | The file `plan/.initiative-logs/step-{n}.log` that holds the session's stdout and stderr | log | ravintio-zero |
| Stream event | One JSON line from `--output-format stream-json` | event | ravintio-zero |
| Activity line | A short line the watcher prints for one stream event, starting `I-C Run: activity:` | summary line | ravintio-zero |
| Watcher | `initiative-watch.mjs`, the read-only progress script | monitor | ravintio-zero |
