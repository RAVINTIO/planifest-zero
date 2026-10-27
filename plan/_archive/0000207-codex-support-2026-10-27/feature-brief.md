---
title: "Feature Brief - Codex support"
summary: "Let setup install RAVINTIO Zero for the Codex harness, with hooks mapped where Codex has them."
status: "approved"
version: "0.1.0"
---
# Feature Brief - Codex support

**Feature ID:** 0000207-codex-support

## Business Goal

RAVINTIO Zero installs for Claude Code only. A team that uses Codex can't install the pipeline. The human on the loop chose Codex as the first extra harness on 2026-10-25. Source: backlog entry 0000175.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Codex tool target | US-001: As a developer who uses Codex, I run `setup.sh codex` or `setup.ps1 codex`, so that the pack installs for my harness. | must-have | 1 |
| Boot file and skills | US-002: As a developer who uses Codex, I get an `AGENTS.md` boot file and skills in `.agents/skills`, so that Codex loads the pipeline rules and skills. | must-have | 1 |
| Hook mapping | US-003: As a developer who uses Codex, I see which enforcement hooks are active and which fall back to instructions, so that I know what the harness enforces. | must-have | 1 |
| Codex CI check | US-004: As a pack maintainer, I run a CI test that installs for `codex` and checks the files, so that a change cannot break the target. | must-have | 1 |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Skills, standards, templates, scripts, setup, and tests |

### Data Ownership

| Data Store | Owner Component | Shared With |
|------------|----------------|-------------|
| none | none | none |

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash, PowerShell, Node.js (existing hook scripts), Markdown |
| Database | none |
| CI | GitHub Actions |
| Build target | local |

## Constraints

- No new dependency.
- Claude Code install output stays unchanged.
- No hook is wired unless the Codex docs confirm its contract.
