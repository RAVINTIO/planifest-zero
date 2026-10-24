# Acceptance evidence - 0000151-hardening-efficiency-and-ci

Run mode: autonomous. The human reviews this evidence in the PR before merging.

## Checks

| Check | Result |
|---|---|
| Feature suites | 110 passed, 0 failed |
| Regression suites | 19 passed, 0 failed |
| PowerShell suites (CI, both hosts) | passed in CI run `40106508296` under Windows PowerShell 5.1 and PowerShell 7 |
| CI jobs on PR #23 | 5 of 5 passed |
| Consistency check | clean |
| Self-description check | clean |
| Library audit | pass. The diff imports Node built-ins only |
| Skill-text NFR (0000031) | passes |
| Requirement coverage | 15 of 15 requirements map to executing tests. P3 added three assertions to close coverage gaps |
| Quiet full run output | 237 bytes, against a 10 KB target |

P3 ran two self-correct cycles. Cycle 1 fixed the security findings below. Cycle 2 fixed the REQ-011 byte budget test, which counted CRLF line endings on Windows.

## Security

Overall risk: low after the P3 fixes. It was high before them.

- S-001 (high): a symlink at a roadmap step-log path let the driver overwrite a file outside the repo. Mitigated: the driver refuses a symlinked log path and opens logs with `O_NOFOLLOW` (`planifest-zero/scripts/roadmap-run.mjs`). A regression test covers it.
- S-002 (medium): two `assert.ps1` helpers called themselves. Mitigated, and a test now checks that neither helper calls itself.
- S-003, S-004, and S-007 (low): mitigated. These cover private log modes, junction-safe hook pruning, and temp-file clean-up.
- S-005 and S-006 (low): accepted. These are a local check-then-write race in park and narrow label encoding with no unsafe input today.

The full table is in `plan/current/security-report.md`.

## Execution

Each criterion ran against scratch repos under `mktemp`, never against this repo's own `.claude/` or `plan/`. The 45 criteria came out as follows:

- 44 verified
- 0 failed
- 1 verified only in CI: REQ-015 (c), the wall time

Highlights:

- Park refused four symlink cases with exit 1, and the outside files kept their bytes.
- Each changed hook wrote its block reason to stderr with exit 2.
- Setup removed the three retired hooks and kept a custom one. A read-only `settings.json` gave one fixed line and exit 1.
- The roadmap driver passed `--model sonnet`, wrote per-step logs, and appended telemetry labels to an existing value.
- The orchestrator `SKILL.md` went from 36,216 to 26,979 bytes, 25.5% smaller. The no-loss check found no missing line.
- The `windows-powershell` job took 4 min 15 s with the two hosts in parallel, against up to 7 min 15 s before.

The criterion-by-criterion table is in `plan/current/verification-report.md`.

## Follow-ups

- Backlog `0000159`: `setup.ps1` takes about 75% of PowerShell test time, so batching cases per process would save little.
