# Verification Report - 0000042-autonomous-mode-and-prefixes

## What ran

All commands ran from the repo root on branch `feat/0000042-autonomous-mode-and-prefixes` (macOS). Scratch work stayed under the session scratchpad. No real plan files were changed or deleted.

- **Test suite:** `bash planifest-zero/tests/run-tests.sh` ran once. Exit 0. Feature suites 82 passed, 0 failed. Regression suite 19 passed, 0 failed. Seven PowerShell suites were skipped because `pwsh` is not installed. Output: `All tests passed.`
- **Self-description check:** `node planifest-zero/scripts/self-description-check.mjs .` exited 0. Output: `self-description-check: README structure and folder coverage match the repository`.
- **Setup refresh:** `bash planifest-zero/setup.sh claude-code` exited 0. Stderr held 0 lines. Stdout held 88 lines and ended `Setup complete.`
- **Installed skills:** `diff -r planifest-zero/skills .claude/skills` reports no differing file. It lists only `Only in .claude/skills` entries (`assets/`, `references/`, `.planifest-manifest`), which setup adds at install time.
- **Orchestrator text:** `.claude/skills/planifest-orchestrator/SKILL.md` holds the run-mode question verbatim (`[1] Gated`, `[2] Autonomous`, lines 335-341) and the P0 Discovery to P4 Ship prefix table (lines 36-43).
- **Root `CLAUDE.md`:** the heading reads `# Planifest Zero - Mandatory Pipeline Rules`. Hard Limit 1 cites `discovery phase (P0)`. `grep -ci framework CLAUDE.md` returns 0.
- **gate-write hook:** a scratch repo had no `plan/current/design.md`. I piped a PreToolUse Write for `src/foo/a.js` into `node .claude/hooks/enforcement/gate-write.mjs`. Exit 2. Message: `[Planifest] No confirmed design at plan/current/design.md. Complete P0 Discovery first.`
- **check-design hook:** with no feature brief, `check-design.mjs` exited 0 and emitted `additionalContext` ending `...complete P0 Discovery.` I ran it with and without a `design.md` present. In my minimal scratch copy the output was the same both times, because the hook keys on the brief and sentinel.
- **Tracked files after setup:** `git status --short` shows one tracked change, `M plan/state/claude-code.md`. Only `writtenAt` moved, from `2026-10-19T21:53:24Z` to `2026-10-23T08:37:07Z`. I did not revert or commit it.
- **Per-test runs:** I ran each `test-0000042-req-*.sh` alone. All passed (12, 33, 16, 23, 32, 12, 7, 43, 40, 2 assertions).
- **RED check for req-007:** I extracted `main` with `git archive` to a scratch directory and ran the req-007 test there. It failed 4 of 7 (both name checks, both Planifest Framework checks). It passes 7 of 7 on the branch.

## Grep observations

Excluded paths: `plan/_archive`, `plan/changelog`, `plan/current`, `planifest-zero/migrations/_done`, and `plan/backlog` for the phase grep.

| Check | Command summary | Count |
|---|---|---|
| Retired run-mode values | `git grep -Ei '\b(continuous\|interactive)\b'` filtered to lines mentioning run mode | 0 |
| P5 to P9 and `Phase N` cites | `git grep -E '\bP[5-9]\b\|Phase [0-9]\b'` | 0 |
| Retired letter prefix in skills, templates, hooks, docs | `D:`, `PL:` and similar forms | 0 (one false hit: `P0 exchange (...): Q:` in the orchestrator, not a prefix) |
| Planifest Framework in `product.yml`, `component.yml`, `README.md` | `grep -rn "Planifest Framework"` | 0 (exit 1) |
| Lines naming Planifest Zero as a framework | `git grep -niE` on "zero/pack/pipeline is a framework" patterns | 0 |
| Other "framework" lines (whole word) | `git grep -niw framework` | 241, all generic: test frameworks, web stack standards, the `framework: "none"` stack field, the README link to the separate product, and decisions-index titles for past features |
| `custom-004-p9` references | `git grep -n custom-004-p9` | 5, all in `test-0000042-req-006-*.sh` (asserting absence) |
| Old override file | `ls planifest-overrides/instructions` | `custom-004-ship-push-and-raise-pr.md` only |
| `git diff main --stat` under `plan/_archive` and `plan/changelog` | | no change |

## Feature brief criteria

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| Run-mode question offers exactly `gated` and `autonomous`, and `plan/.run-mode` stores one of them | Read installed `SKILL.md`, run req-001 test | verified | Installed question text matches the design. Test req-001 (a) 5 of 5 pass, including "offers exactly two options" and "rejects any other value". |
| In `autonomous`, no phase skill stops at the P1 to P4 gates and the run ends with a raised PR | Skill text and tests | not-verifiable | A live agent run is not executable here. Governing text: orchestrator gate table (lines 374-377) says `Autonomous: no stop` for P1 to P4, and the ship skill ends `P4 Ship: Complete: PR #{n} ready for your review`. Static assertions in req-002 (b) pass 13 of 13. |
| In `gated`, each of P1 to P4 ends with a confirmation stop | Skill text and tests | not-verifiable | Live gate behaviour is not executable here. The same table says `Gated: STOP` for each phase. req-002 (a) passes 7 of 7. |
| In both modes an unmitigated critical or high security finding stops the run | Skill text and tests | not-verifiable | A live security review is not executable here. Orchestrator line 395 gives `P3 Validate: Blocked: {n} unmitigated critical or high security findings...`. req-002 (c) "stop on an unmitigated critical or high finding" passes. |
| A resume with a missing or unknown `plan/.run-mode` asks the question and names the value found | Skill text and tests | not-verifiable | A live resume is not executable here. Orchestrator Hard Limit 9 (line 80) holds the exact two messages: `` `plan/.run-mode` is missing. `` and `` `plan/.run-mode` holds `{value}`, which is not a valid run mode. `` req-003 (a) passes 7 of 7. |
| Skills, docs, templates, and hooks number phases P0 to P4 only and use the five new prefixes | Grep, hook run, tests | verified | 0 hits for P5 to P9 and `Phase N`. The gate-write run printed `P0 Discovery`. Tests req-004, req-005, req-006 pass. |
| `product.yml` and `component.yml` say `name: "Planifest Zero"` | Grep, test, RED run on `main` | verified | `product.yml:12` and `component.yml:3`. Test passes on the branch and fails 4 of 7 on `main`. |
| No tracked file outside the archive and changelog describes or names Planifest Zero as a framework | Own grep, allowlist test | verified | 0 matching lines in my grep. The req-010 allowlist test passes and flags a planted line. |

## Requirement criteria

| Criterion | Method | Outcome | Evidence |
|---|---|---|---|
| req-001 (a) question text exact, two options, writes only `gated` or `autonomous` | Read installed skill, test | verified | Text at installed `SKILL.md` lines 335-341 matches. Test req-001 (a) 5 of 5. |
| req-001 (b) no `continuous` or `interactive` run-mode value | Grep, test | verified | 0 hits. Test req-001 (b) 7 of 7 and `test-0000023-req-001` asserts `gated` and `autonomous`. |
| req-002 (a) gated stops at P1 to P4 | Skill text, tests | not-verifiable | Live gate not executable. See the brief row for gated. |
| req-002 (b) autonomous skips gates, P3 evidence in PR description, P4 ends with PR-ready message | Skill text, tests | not-verifiable | Live run not executable. Test asserts the orchestrator rows, validate-and-accept evidence routing, and ship's closing message (13 of 13). |
| req-002 (c) four exceptions stop with `Blocked:` in both modes | Skill text, tests | not-verifiable | Live stop not executable. Test asserts all four stops, `Blocked:` messages, committed and pushed work, and same-mode resume (9 of 9). |
| req-003 (a) missing or unknown value triggers the question and names what was found | Skill text, tests | not-verifiable | Live resume not executable. Hard Limit 9 text quoted above. |
| req-003 (b) valid value restores without asking and gated shows its pending gate | Skill text, tests | not-verifiable | Live resume not executable. Hard Limit 9 says restore without asking and show the gate again if no `Gate accepted` line. |
| req-003 (c) `pipeline-reference.md` lets no mode skip a clean acceptance gate | Test, read | verified | Test req-003 (c): "skip-a-stop rule is gone" and "pipeline-reference defers gate behaviour to the skills" pass. |
| req-004 (a) build-log template and Hard Limit 10 use `### P<n>:` with n 0 to 4, no hook-parse claim | Test | verified | Test req-004 (a) 15 of 15. |
| req-004 (b) hook messages say P0 Discovery, Source phase reads P0 to P4 | Hook execution, test | verified | gate-write exit 2 with `Complete P0 Discovery first.` check-design emitted `complete P0 Discovery`. Test req-004 (b) passes. |
| req-004 (c) suite passes after renumbering | `run-tests.sh` | verified | 82 feature and 19 regression passed, 0 failed. |
| req-005 (a) orchestrator and `pipeline-reference.md` list the same five prefixes and status form | Read, test | verified | Installed table lists all five prefixes. Test req-005 (a) 32 of 32. |
| req-006 (a) guard exits 0 on live files | Test | verified | req-006 (a) passes. My grep found 0 hits. |
| req-006 (b) planted `P6`, `PL:`, `Phase 0` fail and name the file, history paths ignored | Test | verified | Tests plant each case in a scratch copy and assert non-zero plus the file and line. 12 of 12. |
| req-006 (c) `custom-004-p9-...` gone, renamed file exists, no old-name reference | `ls`, grep, test | verified | Only `custom-004-ship-push-and-raise-pr.md` exists. The 5 grep hits are all in the req-006 test. |
| req-007 (a) names and ids, same version, templates unchanged | Grep, `product-version.mjs`, `git diff main` | verified | Names and ids present. `product-version.mjs` prints `0.8.0`, equal to `version` in `product.yml` on `main`. `component.template.yml` is unchanged. `product.template.yml` changed in two comment lines only (`P5` to `P4`), as REQ-004 requires. Its `name` placeholder is unchanged. |
| req-007 (b) no "Planifest Framework" in the three files | Grep | verified | `grep -rn` exit 1, 0 matches. README still links the separate `planifest-framework` repo by its lowercase slug. |
| req-007 (c) one test asserts name, id, README check, fails before and passes after | RED run on `main` | verified | 4 of 7 fail on `main`, 7 of 7 pass on the branch. |
| req-008 (a) README and `docs/about.md` have no framework line, README states it is distinct | Grep, test | verified | README line 5: `Planifest Zero is distinct from the product in the planifest/planifest-framework repository.` Test req-008 (a) 3 of 3. |
| req-008 (b) other prose says Planifest Zero, the pack, or the pipeline | Grep, test | verified | 0 matching lines. Test req-008 (b) passes on 38 files. |
| req-008 (c) 21 `test-frameworks.md` and stack evaluations unchanged | Test | verified | Test confirms 21 files, and the stack evaluation line counts of 51 and 47. |
| req-009 (a) every identifier uses the ADR-004 name, no stale reference | Test | verified | 31 assertions pass, including old files gone, new files present, and manifest paths resolving. |
| req-009 (b) `## The pack` heading and `self-description-check.mjs` change together and pass | Execution | verified | The check exited 0 on the repo. |
| req-009 (c) `run-tests.sh` passes with zero failures | Execution | verified | 82 feature and 19 regression passed, 0 failed. |
| req-010 (a) allowlist test reports zero non-allowlisted lines | Test | verified | `req-010 (a)` passes. My count: 0 lines naming Planifest Zero as a framework. |
| req-010 (b) test fails on a planted "Planifest Zero is a framework" line | Test | verified | `req-010 (b)` plants the line in a scratch `README.md` and asserts a flag with file and line. |
| req-010 (c) no diff under `plan/_archive` or `plan/changelog` | `git diff main --stat` | verified | Empty output. |
| req-011 (a) each stop logs `Blocked:` and `Resolved:`, and resume refuses an unresolved stop | Skill text, test | not-verifiable | Live stop and resume not executable. Test req-011 (a) asserts both lines and the resume check (4 of 4). Added at P3 for F-002. |
| req-011 (b) evidence carries no raw output, and ship scans the PR body before `gh pr create` | Skill text, test | not-verifiable | Live ship not executable. Test req-011 (b) asserts the redaction rule, the scan, and its stop message (4 of 4). Added at P3 for F-003. |
| req-011 (c) the Exception Stops table has a fifth credential row that stops before the commit and any push | Read, test | verified | The installed orchestrator table has five rows, and the credential row says "Stop before the commit and before any push." Test req-011 (c) 5 of 5. Added at P3 for F-004. |

## Semantic coverage

| Requirement | Test file | Assertion for each criterion |
|---|---|---|
| req-001 | `test-0000042-req-001-run-mode-question.sh` | (a) "run-mode question block matches the design text exactly", "offers exactly two options", "writes gated or autonomous", "rejects any other value". (b) five "names no retired run mode" checks plus "asserts gated" and "asserts autonomous". |
| req-002 | `test-0000042-req-002-gate-and-exception-stops.sh` | (a) four "stops in gated" rows plus validate and ship. (b) four "does not stop in autonomous" rows, evidence to PR, PR-ready message. (c) four exception stops, "each ... has a Blocked: message", "committed and pushed", "resumes in the same mode". |
| req-003 | `test-0000042-req-003-run-mode-resume.sh` | (a) "missing or unknown value makes the orchestrator ask", "names the value it found", "logs the answer". (b) "valid value restores without a question", "shows its pending gate again". (c) "skip-a-stop rule is gone", "defers gate behaviour to the skills". |
| req-004 | `test-0000042-req-004-phase-numbers-p0-to-p4.sh` | (a) template and Hard Limit 10 checks. (b) hook "says P0 Discovery", "no longer says Phase 0", "Source phase offers P0/P4". (c) no dedicated test. The whole-suite run covers it. |
| req-005 | `test-0000042-req-005-message-prefixes.sh` | (a) five prefixes and five statuses checked in both the orchestrator and `pipeline-reference.md`. |
| req-006 | `test-0000042-req-006-phase-guard-and-stale-cites.sh` | (a) "guard exits 0". (b) planted `P6`, `PL:`, `Phase 0`, history ignored. (c) "custom-004-p9 ... no longer exists", "renamed ... exists", "no live file names custom-004-p9". |
| req-007 | `test-0000042-req-007-product-name-planifest-zero.sh` | (a) name and id checks. "Version unchanged" and "templates unchanged" have no assertion, so I checked both by hand. (b) three "holds no Planifest Framework string" checks. (c) the test itself, RED on `main`. |
| req-008 | `test-0000042-req-008-pack-prose.sh` | (a) README and about checks plus "distinct". (b) 38 per-file checks. (c) "21 test-tool library standards remain" and two stack evaluation line counts. |
| req-009 | `test-0000042-req-009-pack-identifiers.sh` | (a) 14 "no in-scope line names the old ..." checks plus exists and gone checks. (b) "has the ## The pack heading", "passes against the repository". (c) no dedicated test. `run-tests.sh` covers it. |
| req-010 | `test-0000042-req-010-pack-wording-allowlist.sh`, mirrored in `tests/regression/` | (a) "no tracked line outside the allowlist uses the word". (b) "flags the planted line with its file and line number". (c) no test, so I checked `git diff main --stat` by hand. |
| req-011 | `test-0000042-req-011-exception-stop-records-and-redaction.sh` | (a) "appends a Blocked: line", "appends a Resolved: line", "resume checks for an unresolved Blocked: line". (b) "forbids raw output", "scans the PR body". (c) "has a credential row", "has five exception rows". |

Coverage gaps: none. Three criteria (req-004 (c), req-009 (c), req-010 (c)) and two parts of req-007 (a) rely on the whole-suite run or a manual check, not a dedicated assertion.

## Summary

- Verified: 27 (4 brief criteria, 23 requirement criteria).
- Failed: 0.
- Not-verifiable: 11 (4 brief criteria, 7 requirement criteria). All describe live agent run-mode behaviour. The skill text and static assertions that govern them pass.
- Tracked files changed by setup: one, `plan/state/claude-code.md` (`writtenAt` only). Not reverted, not committed.
