---
title: "Domain Glossary - driver step fixes"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - driver step fixes

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000251-driver-step-fixes
**Version:** 0.39.1

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Step variable | The environment variable `RAVINTIO_INITIATIVE_STEP`, which the driver sets to `1` in every step session | none | ravintio-zero |
| Attempt log | A kept log of an earlier run of a step, named `step-{n}.attempt-{k}.log` | none | ravintio-zero |
| Current log | The log of the latest run of a step, named `step-{n}.log` | step log | ravintio-zero |
| Probe suite | A test suite that records whether the step variable is set when a runner starts it | none | ravintio-zero |
