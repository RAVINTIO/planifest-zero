---
title: "Retrospective: 2026-10-28 - test suite reliability"
summary: "A blameless review of step 1 of initiative 0000238, and the change it files."
status: "open"
---
# Retrospective: 2026-10-28 - test suite reliability

**Mode:** run
**Subject:** 0000239-test-suite-reliability
**Date:** 2026-10-28

## Summary

The step shipped two test helper fixes as version 0.30.2. Two rework loops came from a shell feature gap and a suite rule.

## What helped

- A concurrency plan that named the shared write target made the sequential order clear (plan/_archive/0000239-test-suite-reliability-2026-10-28/execution-plan.md).
- Running the full suite once after the helper change found the process-substitution rule before P3 (plan/_archive/0000239-test-suite-reliability-2026-10-28/build-log.md, second `Rework:` line).

## What slowed the work

- The plan chose `command_not_found_handle`, which Bash 3.2 lacks. P2 redesigned the check (plan/_archive/0000239-test-suite-reliability-2026-10-28/build-log.md, first `Rework:` line, and ADR-001).
- The first full-suite run in quiet mode hid PASS lines that the new test read. The test now sets the variable (plan/_archive/0000239-test-suite-reliability-2026-10-28/build-log.md).

## Keep

- Putting a helper behind a small unit suite with a fixture copy of the helpers (plan/_archive/0000239-test-suite-reliability-2026-10-28/../../../ravintio-zero/tests/test-0000239-req-001-undefined-assert-fails.sh).

## Change

- The plan skill gives no check of a shell feature against the oldest supported shell (plan/_archive/0000239-test-suite-reliability-2026-10-28/adr/ADR-001-record-undefined-asserts-in-a-file.md).

## Actions

| Change | Owner | Lives in | Verified by | Filed as |
|--------|-------|----------|-------------|----------|
| Check a shell feature against Bash 3.2 at plan time | pack maintainers | ravintio-zero/skills/ravintio-plan/SKILL.md | A fixture ADR in a consistency-check test | plan/backlog/0000255-check-shell-version-in-plan/entry.md |
