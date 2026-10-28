---
title: "ADR 001: record undefined asserts in a file"
summary: "The not-found handler appends to a temp file because it runs in a forked child."
status: "accepted"
version: "0.1.0"
---
# ADR-001 - record undefined asserts in a file

**Skill:** [plan](../../../ravintio-zero/skills/ravintio-plan/SKILL.md)
**Feature:** 0000239-test-suite-reliability
**Component:** ravintio-zero
**Date:** 2026-10-28

## Context

Bash runs `command_not_found_handle` in a forked child. A counter that the handler increments is lost, so the suite still reports success.

## Decision

The handler appends one line to a temp file when the name starts with `assert_`. `print_summary` adds the line count to `FAIL`. Bash 3.2 supports the handler.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Counter variable | No file | Lost in the child | Does not work |
| `set -u` or `set -e` | No helper change | Suites set their own options | Not uniform |
| Lint every suite | Catches it early | A separate tool | New dependency |

## Affected Components

| Component | Impact |
|-----------|--------|
| ravintio-zero | Every Bash suite gets the guard |

## Consequences

**Positive:**
- An undefined assert fails every suite.

**Negative:**
- One temp file per suite run.

**Risks:**
- A suite that sets its own handler loses the guard.

## Related ADRs

- None.

## Supersedes

- None.

## Superseded By

- None.
