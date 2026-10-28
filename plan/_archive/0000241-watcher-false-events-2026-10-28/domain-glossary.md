---
title: "Domain Glossary - watcher false events"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - watcher false events

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000241-watcher-false-events
**Version:** 0.31.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Watcher | `initiative-watch.mjs`, the read-only progress script | monitor | ravintio-zero |
| Stale state | A commit at least 15 minutes newer than the last build log write | stale log | ravintio-zero |
| Stale key | The log modification time and newest commit sha that identify one stale state | none | ravintio-zero |
| Last-seen commit | The newest commit the watcher has already reported | head | ravintio-zero |
| Branch-change line | One `I-C Run: event: branch changed to {branch}` line that replaces commit lines | none | ravintio-zero |
| Lock file | `plan/.initiative-runner.lock`, present while the driver runs | lock | ravintio-zero |
