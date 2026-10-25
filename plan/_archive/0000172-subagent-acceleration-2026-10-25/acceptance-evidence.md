# Acceptance evidence - 0000172-subagent-acceleration

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 3 requirements, 9 criteria. Each requirement has a suite named for it: `test-0000172-req-001-run-speed.sh` (4 checks), `-req-002-fast-batches.sh` (6), and `-req-003-phase-timing.sh` (3). |
| Full Bash suite, local Bash 3.2 under `env -i` | 151 feature and 19 regression suites pass, on the tree after the P3 fixes |
| PowerShell suites, local `pwsh` 7 | Pass. One later full run hit a .NET culture error at `pwsh` start-up in `test-0000037-req-008-non-array-hook-events.ps1`. That suite then passed 3 runs out of 3. This release changes no PowerShell file. |
| Self-correction cycles | 0 in P3. P2 fixed five suite failures before P3, listed below. |

P2 fixed five suite failures before P3:

- The orchestrator `SKILL.md` passed its 0000151 size budget, and three base lines changed. The run-speed rules moved to `references/orchestrator-run-speed.md`, and the base lines are word for word again.
- Ship Step 8 lost the sentinel wording that the 0000023 suite reads. Step 8 keeps it and adds `plan/.run-speed` in a second sentence.
- Backlog entries 0000177 and 0000182 named the other product as "Framework" alone. Both now say "RAVINTIO Framework".

## Execution evidence

All 9 criteria are `verified`. None failed, and none are `not-verifiable`. See `verification-report.md`.

- Each suite exits 0, and every criterion cites the lines that meet it, for example `references/orchestrator-run-speed.md:10-19`, `roadmap-standards.md:117`, and `build-log.template.md:18,29-30,49-50,77`.
- A mutation check per requirement removed one satisfying line. Each suite then exited 1. Each file was restored, with `git diff --quiet` clean.
- `plan/.run-mode` keeps its two values. The orchestrator still says `No other value is valid`.
- The installed copy of `orchestrator-run-speed.md` matches the source byte for byte. `setup.sh` copies whole skill folders.

## Security

There are no critical or high findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 a stop in one fast batch unit did not halt its siblings | Medium | Mitigated in P3. No further unit starts, and running units finish before the stop. |
| S-002 the disjoint-write rule did not name dependency manifests or lock files | Medium | Mitigated in P3. They count as shared, and at most one unit per batch adds a dependency. |
| S-003 parallel units could commit at once in one working tree | Medium | Mitigated in P3. Units commit one at a time and stage files by path. |
| S-004 to S-008 | Low | Accepted. See `security-report.md`. |
| S-009 to S-011 | Informational | Accepted. The suites use no `eval` and read constants only. |

No dependency, network call, script, hook, or credential joined the pack.

## Outside commits

Another session committed backlog entries 0000179 to 0000182 on this branch while the step ran. They ride into this PR. The run changed one word in 0000182 and two in 0000177 to pass the wording suite, and nothing else in them.
