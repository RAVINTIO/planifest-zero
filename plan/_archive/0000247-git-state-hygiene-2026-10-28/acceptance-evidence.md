# Acceptance evidence - 0000247-git-state-hygiene

## Checks

- Feature suites: 214 passed, 0 failed. Regression suite: 19 passed, 0 failed.
- Self-corrections: 1. Hard Limit 8's line changed and failed the base-line check in `test-0000151-req-011`. The rule moved to its own line.

## Security

No findings. See `security-report.md`.

## Execution

- The three new test files pass 10 of 10, 15 of 15, and 5 of 5. On an archive of the commit before the implementation they fail 8, 12, and 3 checks.
- `reserve-id.mjs --commit` commits `plan/backlog/.next-id` alone in a temp repo with a second staged file.
- Skill text measures 1,512 lines against the 1,720 line cap. The orchestrator `SKILL.md` measures under 9,000 bytes.
- Not verifiable: none.
