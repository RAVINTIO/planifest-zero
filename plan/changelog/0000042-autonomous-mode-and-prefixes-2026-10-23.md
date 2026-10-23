# Changelog (0000042-autonomous-mode-and-prefixes, 23 Oct 2026)

**Feature:** autonomous-mode-and-prefixes
**Version:** 0.9.0
**PR:** https://github.com/planifest/planifest-zero/pull/20

## What changed

Planifest Zero now offers a run mode that reaches a raised PR without stopping. Its phases run P0 to P4 with readable prefixes, and it calls itself Planifest Zero everywhere.

- req-001: the run-mode question offers `gated` and `autonomous`. `plan/.run-mode` holds one of them, and `interactive` and `continuous` are gone.
- req-002: `gated` stops at the P1, P2, P3, and P4 gates. `autonomous` stops at none, writes P3 evidence to `plan/current/acceptance-evidence.md`, and ends with `P4 Ship: Complete: PR #{n} ready for your review`.
- req-003: a resume that finds a missing or unknown run mode asks the question again and names the value it found.
- req-004: the phases are P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, and P4 Ship. Build-log headings and hook messages use the new numbers.
- req-005: every message starts with `P0 Discovery:`, `P1 Plan:`, `P2 Implement:`, `P3 Validate:`, or `P4 Ship:`, then one status form.
- req-006: a guard test fails on any phase cite outside P0 to P4. `custom-004-p9-push-and-raise-pr.md` became `custom-004-ship-push-and-raise-pr.md`.
- req-007: `product.yml` and `planifest-zero/component.yml` say `name: "Planifest Zero"`.
- req-008 to req-010: no prose or identifier calls Planifest Zero a framework. ADR-004 maps each rename, such as `FRAMEWORK_DIR` to `ZERO_DIR` and `framework-update-policy.md` to `pack-update-policy.md`. An allowlist test keeps generic uses, such as `test-frameworks.md`.
- req-011: five exception stops apply to both modes. Each stop leaves `Blocked:` and `Resolved:` lines in the build log, and a resumed run doesn't pass an unresolved stop. Acceptance evidence holds results and `file:line` cites only. Ship scans the PR body for credentials before `gh pr create`.

## Why

Continuous run still stopped at acceptance and ship, so no mode reached a PR on its own. The phase numbers started at P1, while Planifest Framework starts at P0. Prefixes such as `D:` and `PL:` needed a legend. The pack also called itself a framework, which confused it with Planifest Framework.

Decisions:

- ADR-001: the stack stays as it is.
- ADR-002: `gated` and `autonomous` replace `interactive` and `continuous`, with five shared exception stops.
- ADR-003: phases P0 to P4 and the five prefixes. Supersedes 0000031 ADR-001 in part.
- ADR-004: the wording rules and the identifier name map.

## Deviations

- In P1, the consistency check allowed three acceptance criteria per requirement, so the four planned requirements became ten. The scope and points stayed the same.
- In P2, the phase guard skips all of `plan/backlog/`. REQ-006 records the change.
- In P2, autonomous P3 writes its evidence to `plan/current/acceptance-evidence.md`, because the PR doesn't exist yet. The design records it.
- In P2, the count of `test-frameworks.md` files was 21, not 22. The requirements and ADR-004 record the correct count.
- In P3, the human chose to fix security findings F-002, F-003, and F-004 in this release. REQ-011 holds the fix, and the design, scope, and ADR-002 record it.

## Validation results

- CI run `40010838474` on PR #20: all four jobs pass, including PowerShell 5.1 and 7 on Windows.
- The local runner passes 83 feature suites and 19 regression suites.
- Execution verification: 27 criteria verified, 0 failed, and 11 not-verifiable. The 11 describe live agent behaviour, and their governing skill text passes its tests.
- Security: no critical or high findings. F-002, F-003, F-004, F-007, and F-009 are fixed. F-001 is the confirmed resume behaviour. F-005, F-006, and F-008 stay open as advisory.
- The human accepted the build on 2026-10-23.

Backlog filed during this run:

- 0000143: three installed hooks in `.claude/` have no source.
- 0000144: ship commits the sentinel deletions after the PR push.
- Planifest Framework 0000190: the same run-mode, prefix, and name overhaul.
- Planifest Framework 0000192: its credential guard misses mid-run commits and the PR body.

## Skipped phases

None
