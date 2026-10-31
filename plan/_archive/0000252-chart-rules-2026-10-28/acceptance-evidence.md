# Acceptance evidence - 0000252-chart-rules

## Checks

- Feature suites: 222 passed, 2 failed. Regression suite: 19 passed, 0 failed.
- The two failures are `test-0000042-req-006` and `test-0000043-req-009`. They scan the git-ignored step log (entry 0000264) and pass on a clean archive of `HEAD`.
- Self-corrections: 1, a skill wording change after the first GREEN run of the REQ-001 test.

## Security

No findings. See `security-report.md`.

## Execution

- The guard widening test passes 10 of 10 checks. The confirmation test passes 10 of 10. The P1 skip test passes 13 of 13.
- The standard, the template, and the initiative skill hold all three chart rules. I-C Run stops a step with no `yes` row that would skip P1.
- The driver test passes 40 of 40 with the new `## P1 skips` section in the template.
- Skill text measures 1,545 lines against the 1,720 line cap. The orchestrator `SKILL.md` measures 8,098 bytes against 9,000.
- The branch diff holds no change to a hook, `merge-guard`, `gate-write`, or `ratchet-check`.
- This step edits the initiative skill, so the driver stops with `I-D Advance: Restart:` after the merge. The initiative skill starts a new driver and watcher.
- Not verifiable: none.
- Searches for missing programs: none were needed. `command -v node git gh` found all three.
