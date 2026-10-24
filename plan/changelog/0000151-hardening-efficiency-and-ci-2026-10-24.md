# Changelog (0000151-hardening-efficiency-and-ci, 24 Oct 2026)

**Feature:** hardening-efficiency-and-ci
**Version:** 0.11.0
**PR:** [#23](https://github.com/planifest/planifest-zero/pull/23)

## What changed

Planifest Zero now refuses unsafe park paths, keeps sentinels off `main`, and shows hook block reasons to the agent. It also costs fewer tokens per run and gives faster PowerShell CI. The release pulls ten backlog entries into fifteen requirements.

- req-001: park refuses any symlink in the entry path. It checks each part with `lstat` and the real path against the real `plan/backlog/`, before it creates, writes, or removes anything.
- req-002: ship clears the pipeline sentinels in a commit before the push. Step 7 tags, Step 8 clears, Step 9 pushes and raises the PR, and Step 10 is the final gate.
- req-003: `gate-write`, `em-dash-guard`, and `ratchet-check` write each block reason to stderr and stdout.
- req-004: setup deletes an installed hook only if its name is on the retired list. `phase-enum` joins the list in `setup.sh` and `setup.ps1`.
- req-005: one catch in `writeSettings` prints a fixed line with the relative path and exits 1. `setup.ps1` prints the same line.
- req-006: the roadmap driver passes `--model` (default `sonnet`) and an optional `--max-turns`. A capped step that exits non-zero stops with `R-C Run: Blocked:`.
- req-007: dispatch uses the model names `sonnet` and `haiku`. Every Agent call passes `model`. A haiku unit that fails twice retries on sonnet.
- req-008: `PLANIFEST_TEST_QUIET=1` hides PASS lines and banners and keeps every failure line. A quiet full run prints 237 bytes when every suite passes.
- req-009: at each gate in a gated run, the orchestrator reports the context size. It recommends `/clear` past about 150,000 tokens.
- req-010: the dispatch standard routes a WebFetch of a full reference page through a sonnet or haiku subagent.
- req-011: seven rarely used orchestrator sections moved word for word to `references/orchestrator-*.md`. `SKILL.md` fell from 36,216 to 26,979 bytes.
- req-012: the driver writes `plan/.roadmap-logs/step-{position}.log` for each step. It excludes the folder through `.git/info/exclude`, and every stop line names the log. It refuses a symlinked log path, and the logs are private to the user.
- req-013: the driver appends percent-encoded `work.kind`, `planifest.roadmap`, and `planifest.step` labels to the child's `OTEL_RESOURCE_ATTRIBUTES`.
- req-014: R-A Chart checks that each entry is clear enough to draft from and collects an approved dependency list. A sixth exception stop fires in every run when work adds a library or service that is not on the list.
- req-015: the PowerShell CI job runs Windows PowerShell 5.1 and PowerShell 7 as a two-entry matrix. The test helpers print per-case timing.

New files: `planifest-zero/scripts/roadmap-labels.mjs` and seven files under `planifest-zero/skills/planifest-orchestrator/references/`. The hook count stays at seven.

## Why

Ten backlog entries (0000139, 0000142 to 0000149, and 0000150) named gaps in park, ship, hooks, setup, and the driver. They also named token and CI cost. Park could write through a symlink. Ship sent sentinel files to `main` through the PR. Three hooks blocked with no reason the agent could read.

Decisions:

- ADR-001: the stack stays as declared.
- ADR-002: three hooks write block reasons to stderr and stdout.
- ADR-003: ship clears the sentinels before the PR.
- ADR-004: a sixth exception stop covers unapproved dependencies.
- ADR-005: the driver passes a model and an optional turn cap, and it writes a step log and telemetry labels.
- ADR-006: rarely used orchestrator sections move to reference files.
- ADR-007: setup prunes retired hooks by list.
- ADR-008: park refuses symlinked entry paths.

## Deviations

- The PowerShell tests were not run locally because `pwsh` is absent. They cover req-004, req-005, req-008, req-011, and the CI timing helper. CI runs them on both PowerShell hosts.
- req-011 wrote its test after the split, so it has no RED run. The test checks that every moved line appears in a reference file.
- req-014 says "gated and autonomous run" where the design said "interactive run". The 0000042 backstop test bans the older word.
- The commit titled "mark Track D done" (`1979f36`) holds the req-012 driver change, `roadmap-run.mjs` and its test. A commit race caused it.
- The req-015 workflow first set `shell` on a step, and GitHub rejected it. The matrix shell now sits in the job's `defaults.run.shell`, and the req-015 test pins that.
- P3 found a high-severity symlink write in the new step logs (S-001) and a recursion bug in `assert.ps1` (S-002). P3 fixed both, with tests.
- The REQ-011 PowerShell byte check failed on Windows, which checks out CRLF line endings. It now counts bytes with LF endings.
- PR #23 opened as a draft during P3, so CI could run the PowerShell suites before ship.
- The release is about 19 points against an 8-point budget. The human accepted it.
- The REQ-007 skill-level `model` field was checked against the Claude Code docs. The three TDD skills set `model: haiku`, and each Agent call still passes `model`.

## Validation results

- Full quiet suite after P3: 110 feature suites and 19 regression suites pass. Eleven PowerShell suites skip locally because `pwsh` is not installed.
- CI on PR #23 (run `40106508296`): all five jobs pass. The PowerShell suites pass under Windows PowerShell 5.1 and PowerShell 7.
- The `windows-powershell` job takes 4 min 15 s with both hosts in parallel, against up to 7 min 15 s before.
- Consistency check: clean. Self-description check: clean. Library audit: Node built-ins only.
- Execution verification: 45 criteria, 0 failed. REQ-015 (c), the wall time, was verified in CI.
- Security review: 1 high, 1 medium, and 5 low findings. P3 mitigated the high, the medium, and three lows. Two lows stay accepted. Overall risk is low.

Backlog entries 0000139, 0000142 to 0000150 are folded into this feature. Backlog 0000095, 0000100, and 0000110 stay out of scope.

## Skipped phases

None
