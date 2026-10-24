# Acceptance evidence - 0000043-autonomous-roadmaps

Run mode: autonomous. The human reviews this evidence in the PR before merging.

## Checks

| Check | Result |
|---|---|
| Feature suites | 95 passed, 0 failed |
| Regression suites | 19 passed, 0 failed |
| PowerShell suites | 7 skipped, because `pwsh` is not installed |
| Consistency check | clean |
| Skill-text NFR (0000031) | 1383 of 1447 lines |
| Requirement coverage | 12 of 12 requirements map to executing tests (`verification-report.md`) |

P3 ran three review cycles. Cycle 1 fixed four hand-off bugs. Cycle 2 hardened merge-guard after the security review. Cycle 3 fixed the driver's quoted-value parsing. The live run then found four more faults, each fixed with a failing test first.

## Security

Overall risk: medium. No critical or high findings.

- F-001 and F-002 (medium): merge-guard bypass forms. The fail-closed tripwire mitigates F-001 and the `gh api` path of F-002. `git push origin HEAD:main` stays out of the guard's reach, and `main` branch protection covers it. This is not mitigated in the pack.
- F-003 to F-008 (low): F-003 and F-004 are mitigated. F-005 to F-008 stay as recommendations (`security-report.md`).

## Execution

A private throwaway repo, `planifest/pz-roadmap-acceptance-0000043`, ran the pack end to end:

1. Two normal features built a notes CRUD API (PRs #1 and #2, versions 0.1.0 and 0.2.0).
2. A four-step roadmap ran from R-B Activate to R-E Delivery (PRs #3 to #7, versions 0.3.0 to 1.0.0). One human decision was needed, the M-003 schema approval at step 1.
3. A two-step roadmap tested chart-time schema approval and a driver stop and restart (PRs #8 to #10, versions 1.1.0 and 1.2.0). It needed no human input after Activate.

merge-guard blocked the agent's merge into `main` and allowed six squash merges into `roadmap/*`. The human merged both roadmap PRs with a merge commit, and every step tag is reachable from `main`.

Not verified live:

- Draft pickup at R-A Chart. Both charts started from a new idea. Tests `req-001` and `req-002` cover it.
- req-012 progress markers. The test repo's pack predates them. Test `req-012` covers them.

The criterion-by-criterion table is in `plan/current/verification-report.md`, section "Live acceptance run".
