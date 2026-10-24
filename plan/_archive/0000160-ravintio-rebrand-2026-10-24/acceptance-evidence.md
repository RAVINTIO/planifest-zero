# Acceptance evidence - 0000160-ravintio-rebrand

Run mode: autonomous. The human reviews this evidence in the PR before merging.

## Checks

| Check | Result |
|---|---|
| CI jobs on PR #25 | 5 of 5 passed in run `40133961149` on `10228a6` |
| Feature suites (Ubuntu, with `pwsh`) | 129 passed, 0 failed |
| Regression suites | 19 passed, 0 failed |
| PowerShell suites, Windows PowerShell 5.1 | 13 passed, 0 failed |
| PowerShell suites, PowerShell 7 on Windows | 13 passed, 0 failed |
| Brand guard | passes. No tracked path or line outside history names the old brand, apart from narrow allowlist entries for history and the 1.x aliases |
| Consistency check | clean |
| Self-description check | clean |
| Library audit | pass. The diff adds no dependency |
| Requirement coverage | 18 of 18 criteria map to executing tests. P3 added suites for REQ-001 and REQ-004 |

P3 ran six self-correct cycles. The human approved the sixth after the five-cycle stop.

1. Coverage gaps for REQ-001 and REQ-004.
2. The first security fixes, plus a parse error in the PowerShell helper.
3. macOS Bash 3.2 hid lines from the local brand guard, and the bulk rename changed two split old names.
4. The helper redesign that moves the old pack to a backup instead of deleting it.
5. Two more split old names in 0000037 tests.
6. The two guard tests needed an entry for each other.

## Security

Overall risk: low after an independent re-review. It was high at the first review.

- S-001 (high): a nested junction let the Windows PowerShell 5.1 delete reach outside the repo. Mitigated: the helper never deletes the old pack. It moves it to `.ravintio-backup/`.
- S-002 and S-003 (medium): a symlinked workflow and an unprompted delete. Mitigated: link refusals and the backup move.
- S-004 to S-007 and S-009 to S-015 (low): mitigated.
- S-008, S-016, S-017, and S-018 (low): accepted, and recorded in the risk register as R-012 to R-014.

The full table is in `plan/current/security-report.md`.

## Execution

Each criterion ran against scratch repos under the scratchpad. The 18 criteria came out as follows:

- 12 verified
- 5 verified for Bash, with the PowerShell clause verified in CI
- 1 verified at ship: REQ-004 (c), version 1.0.0
- 0 failed

Highlights:

- A real v0.11.0 install upgraded end to end. The new setup refused to run until the migration ran. The helper moved the overrides and the workflow, removed the old markers, moved the old pack to `.ravintio-backup/`, and archived migration 0004. A rerun changed nothing.
- After the upgrade, setup installed only the 12 `ravintio-*` skills and set `core.hooksPath` to `ravintio-zero/hooks`.
- The workflow rewrite renamed the pack variable and left a consumer secret unchanged.
- The roadmap runner took `RAVINTIO_*` values first and fell back to the old names, and it emitted `ravintio.*` labels only.
- History folders match `main` byte for byte.

The criterion-by-criterion table is in `plan/current/verification-report.md`.

## After merge

1. You renamed the GitHub org to `RAVINTIO`.
2. Once you merge this PR, the agent runs `gh repo rename ravintio-zero` and updates `origin`.
