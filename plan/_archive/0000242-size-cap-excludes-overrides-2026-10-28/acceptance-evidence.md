# Acceptance evidence - 0000242-size-cap-excludes-overrides

- Checks: full suite passed with 204 feature suites and 19 regression tests. Self-correction cycles: 0.
- Security: 0 findings.
- Execution: the cap test measures `CLAUDE.md` without its override block. A 5,000 byte override leaves the result unchanged. 104 extra pack bytes fail the 32,800 byte cap.
- Not-verifiable criteria: none.
