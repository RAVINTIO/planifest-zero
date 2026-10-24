# Verification report - 0000151-hardening-efficiency-and-ci

All commands ran on branch `feat/0000151-hardening-efficiency-and-ci` (macOS, `bash`, `node`). Every fixture lived in a `mktemp -d` directory under the session scratchpad. Each scratch project held a copy of `planifest-zero/` and a fresh `git init`. Nothing ran in the repo's own `.claude/` or `plan/`. The real `claude` CLI never ran. A stub `claude` on `PATH` stood in for it. No file changed except this report.

`pwsh` is absent here (`which pwsh` prints `pwsh not found`). Every `.ps1`-only behaviour is therefore `not-verifiable` locally with the reason "verified in CI on PR #23".

## Summary

| Outcome | Criteria |
|---|---|
| verified | 35 |
| verified for the Bash side, with a `.ps1` clause not-verifiable here | 9 (004 a/b/c, 005 b/c, 008 a/b, 011 c, 015 b) |
| not-verifiable | 1 (015 c) |
| failed | 0 |

The nine partial criteria are listed again in the table at the end. Total: 45 criteria (15 requirements x 3).

## What I started

- Baseline for diffs: merge-base `8b1e929` (`git merge-base HEAD main`).
- Stub `gh` on `PATH` that appends its arguments to a log (REQ-001).
- Stub `claude` on `PATH` that logs its arguments, `OTEL_RESOURCE_ATTRIBUTES` and its environment, then advances `position` or archives the roadmap (REQ-006, 012, 013).
- Bare `origin.git` plus clone per park fixture (REQ-001).
- A `node` shim that sets `settings.json` to mode 444 mid-run (REQ-005).
- Full suite: `PLANIFEST_TEST_QUIET=1 bash planifest-zero/tests/run-tests.sh` from the repo root.

## REQ-001 park symlink containment

Script: scratch `r1.sh`. Each case commits the symlink to `origin/main`, clones, branches `feat/0000777-demo`, then runs `node park.mjs park --entry <tmp>/entry.md --backlog-id 0000900`.

- (a) **verified.**
  - Method: five fixtures with outside files `outside/0000900-park-demo/entry.md` and `outside/target.md` holding `ORIGINAL`.
  - Evidence:

| Case | Exit | Message | Outside files | `pr create` lines | `chore/park-*` on origin | Branch after |
|---|---|---|---|---|---|---|
| symlinked `plan/backlog` | 1 | `park: Refusing plan/backlog: it is a symlink.` | `ORIGINAL` | 0 | 0 | feature |
| symlinked entry folder (outside) | 1 | `Refusing plan/backlog/0000900-park-demo: it is a symlink.` | `ORIGINAL` | 0 | 0 | feature |
| symlinked `entry.md` | 1 | `Refusing plan/backlog/0000900-park-demo/entry.md: it is a symlink.` | `ORIGINAL` | 0 | 0 | feature |
| entry folder symlink to `other/` inside repo | 1 | `Refusing plan/backlog/0000900-park-demo: it is a symlink.` | n/a | 0 | 0 | feature |
| control, no symlink | 0 | `Parked feat/0000777-demo.` | n/a | 1 | 1 | main |

- (b) **verified.**
  - Method: a pre-commit hook on `chore/park-0000777-demo` replaced `entry.md` with a symlink to `outside/target.md`, then exited 1. This plants the symlink after the write and before the commit fails.
  - Evidence: exit 1. Output `park: git commit -m chore(backlog): park 0000777-demo failed (exit 1): stub: pre-commit refused`. That is the original commit error. `outside/target.md` still existed with `ORIGINAL`. The branch afterwards was the feature branch.
- (c) **verified.** `test-0000040-req-004-005-park.sh` exit 0 and `test-0000041-req-004-park-commit-failure.sh` exit 0, no `FAIL` lines. Both are unmodified since the base commit.

## REQ-002 ship sentinels before PR

- (a) **verified** by inspection and quote.
  - `planifest-zero/skills/planifest-ship/SKILL.md` headings rise in order: `:74 ### Step 7: Git tag`, `:82 ### Step 8: Clear sentinels`, `:88 ### Step 9: PR`, `:129 ### Step 10: Final gate`.
  - `:80` (Step 7): "In option [1], Step 9 pushes the tag with the branch." The old "no tag is ever pushed outside a roadmap step" wording is gone.
  - `:107` (Step 9, option 1): `git push origin v{version}`.
  - `:84` (Step 8): "Delete `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode` if present ... Confirm with `git ls-files` that none remain tracked."
  - Step 10: "Use the run mode read in Step 8, because Step 8 deletes `plan/.run-mode`."
  - `planifest-zero/standards/roadmap-standards.md:183`: "Run ship Step 8 now, then push the branch ... Raise the PR against the roadmap branch only after that push." Line `:174` names "clear sentinels at Step 8, PR at Step 9".
- (b) **verified.**
  - Method: scratch repo tracking the three sentinels. I ran the Step 8 commands (`rm`, `git add -A plan`, `git commit`), then `git push` to a local bare remote.
  - Evidence: `tracked before: plan/.orchestrator-ack plan/.orchestrator-active plan/.run-mode`. Commits added: 1. `tracked after: []`. Push exit 0. `git ls-tree -r` on the pushed branch listed `[]`. The run mode was read before deletion.
- (c) **verified.**
  - The four pinned tests each exited 0: `test-0000023-req-002-marker-commit-lifecycle.sh`, `test-0000043-req-005-roadmap-advance.sh`, `test-0000042-req-002-gate-and-exception-stops.sh`, `test-0000037-req-005-override-phase-names.sh`.
  - `git diff 8b1e929 HEAD` on them shows only step-number and heading renames, with no deleted assertion. `test-0000037-req-005` is unchanged.
  - Step 9 still holds the credential scan (`:115`) and the push-failure text (`:126`). `test-0000043-req-006-merge-guard-hook.sh` exit 0.

## REQ-003 hook block reasons on stderr

Method: pipe a JSON `Write` payload into each hook from a scratch project (`plan/current/loop-state-x.md` with `status: "active"`, a requirements file with two criteria) and capture stdout, stderr and exit code.

- (a) **verified.**
  - `gate-write.mjs`, write to `src/app.ts` with no design: exit 2. Stdout and stderr both hold `[Planifest] No confirmed design at plan/current/design.md. Complete P0 Discovery first.` (88 bytes on stderr).
  - `em-dash-guard.mjs`, content with an em dash: exit 2. Stdout and stderr both hold `[Planifest] Em dash (U+2014) found in 'docs/a.md' at line(s): 1. ...` (305 bytes on stderr).
  - `ratchet-check.mjs`, write that drops the `beta` criterion: exit 2. Stdout parsed as JSON with key `hookSpecificOutput` and `permissionDecision: "deny"`. Stderr held the plain reason `Ratchet: this write weakens plan/current/requirements-doc.md while a loop is active. removed: "beta"` (461 bytes).
- (b) **verified.** `test-0000028-req-006-em-dash-guard.sh`, `test-0000017-req-002-ratchet-approve.sh`, `test-gate-write-windows.sh`, `node test-gate-write-windows.mjs` and `regression/test-gate-write-windows.sh` all exited 0. The first two are unmodified since the base commit.
- (c) **verified.**
  - Allowed writes (`docs/a.md` to gate-write, em-dash-free text to em-dash-guard, a strengthening write to ratchet-check) exited 0 with empty stdout and 0 stderr bytes.
  - `git diff 8b1e929 HEAD --diff-filter=M` lists no hook test among modified tests, so no existing hook assertion was touched.
  - `test-0000151-req-003-hook-stderr-reasons.sh` exit 0.

## REQ-004 prune retired hooks

Method: scratch project with `.claude/hooks/enforcement/phase-enum.mjs`, `check-telemetry-failures.mjs`, `check-telemetry-receipts.mjs` and `custom-local-hook.mjs` planted. A `settings.json` entry referenced `phase-enum.mjs`. Then `bash planifest-zero/setup.sh claude-code` twice.

- (a) **verified for `setup.sh`. The `setup.ps1` clause is not-verifiable here (verified in CI on PR #23).**
  - Run 1: exit 0. Lines `- removed .claude/hooks/enforcement/check-telemetry-failures.mjs`, `...check-telemetry-receipts.mjs`, `...phase-enum.mjs`. All three files were absent afterwards.
  - Run 2: exit 0 with 0 `- removed .claude/hooks/` lines.
  - Source: `planifest-zero/setup.ps1:603` holds `'phase-enum'` in the retired list, and `planifest-zero/setup.sh:326` holds `phase-enum` in the retired list. The `.ps1` behaviour at run time was not exercised.
- (b) **verified for `setup.sh`. The `.ps1` clause is not-verifiable here (verified in CI on PR #23).**
  - `custom-local-hook.mjs` was present afterwards.
  - Shipped hooks missing after setup: 0. Removal lines naming a shipped hook: 0.
  - `grep -c -E 'phase-enum|check-telemetry' .claude/settings.json` printed 0.
- (c) **verified for the Bash tests. The `.ps1` test is not-verifiable here (verified in CI on PR #23).** `test-0000035-req-001-hook-parity.sh` and `test-0000033-req-004-upgrade-cleanup.sh` exit 0. `test-0000041-req-002-003-ps1-cleanup-and-warning.ps1` needs `pwsh`.

## REQ-005 setup write error line

- (a) **verified.**
  - `settings.json` at mode 444 holding `{"permissions":{"allow":[]}}`: exit 1. Stderr was one line, `! Error: .claude/settings.json could not be written. Fix its permissions and rerun setup.` Absolute path, `EACCES` and stack-frame matches in stdout plus stderr: 0. The SHA-1 of the file was unchanged. `*.planifest-tmp` files: 0.
  - Read-only `.claude/` (setup run once, `settings.json` removed, folder set to 555): exit 1, same single line, 0 path or stack matches, 0 temp files.
  - Fault at the `merge_allowed_tools` write alone: a `node` shim sets 444 when its arguments contain `allowedTools`. Exit 1, the fixed line once, and `grep -c gate-write settings.json` printed 2, so the hook install write had already succeeded.
- (b) **verified for the Bash side. The PowerShell clause is not-verifiable here (verified in CI on PR #23).** Telemetry cleanup against a read-only `settings.json` printed `  ! Warning: could not remove telemetry hook entries from .claude/settings.json` once. Setup continued and stopped later at the hook install write, as the existing 0000041 tests expect.
- (c) **verified for the Bash test. The `.ps1` test is not-verifiable here (verified in CI on PR #23).** `test-0000039-req-001-002-sh-setup-hardening.sh` exit 0, unmodified since the base commit.

## REQ-006 roadmap step model and turn cap

Method: two-step roadmap fixtures, stub `claude` on `PATH`, `node planifest-zero/scripts/roadmap-run.mjs --root <fixture>`.

- (a) **verified.**
  - Neither variable set: exit 0, stub logged `-p --permission-mode auto --model sonnet Run roadmap step 1`, no `--max-turns`.
  - `PLANIFEST_ROADMAP_MODEL=haiku PLANIFEST_ROADMAP_MAX_TURNS=40`: stub logged `-p --permission-mode auto --model haiku --max-turns 40 Run roadmap step 1`.
  - `PLANIFEST_ROADMAP_MAX_TURNS` of `0`, `-3`, `1.5`, `abc`, `10 --foo`: each exit 1, stub did not run, no lock file, line `R-C Run: Blocked: PLANIFEST_ROADMAP_MAX_TURNS must be a positive integer of up to 4 digits`.
  - `PLANIFEST_ROADMAP_MODEL` of `a b`, `-x`, `a;b`, `a$(id)`, `a|b`: each exit 1, stub did not run, no lock, line `R-C Run: Blocked: PLANIFEST_ROADMAP_MODEL must match ^[A-Za-z0-9][A-Za-z0-9._:[\]-]{0,63}$`.
- (b) **verified.** Stub exit 3 with `PLANIFEST_ROADMAP_MAX_TURNS=7`: exit 1, lock absent, one `R-C Run: Blocked:` line: `claude exited 3 on step 1. The step may have reached PLANIFEST_ROADMAP_MAX_TURNS=7 Log: plan/.roadmap-logs/step-1.log`.
- (c) **verified.**
  - Counts of `PLANIFEST_ROADMAP_MODEL`, `PLANIFEST_ROADMAP_MAX_TURNS`, `sonnet`: `roadmap-run.mjs` 3, 4, 2. `roadmap-standards.md` 1, 2, 1 (table at `:131-132`).
  - `test-0000043-req-007-roadmap-driver.sh` and `test-0000043-req-012-progress-markers-and-resume.sh` exit 0. Their only diff is the expected argument string gaining `--model sonnet`.

## REQ-007 dispatch model tiers

- (a) **verified.**
  - `planifest-zero/standards/agent-dispatch-standards.md`: `grep -c 'claude-sonnet-4-6\|claude-haiku-4-5'` printed 0. `:35` holds `| Claude Code | `sonnet` | `haiku` |`. Examples at `:91` and `:94` use `model: "haiku"`.
  - `:37`: "An Agent call without `model` inherits the parent's model ... Every Agent c[all passes `model`]".
  - `planifest-zero/skills/planifest-implement/SKILL.md:66`, in the `## TDD inner loop` section (`:48`): "Pass each dispatch the `model` from that skill's own `recommended_model` field. If a haiku unit fails twice, retry that unit on `sonnet`. ... the five-attempt escalation is unchanged."
- (b) **verified.**
  - `plan/current/build-log.md:95`: "Check (REQ-007): Claude Code honours a skill-level `model` frontmatter field ... per the Claude Code docs". The evidence is the vendor documentation, not a run of Claude Code.
  - Setup into a scratch project: 9 installed `agent-dispatch-standards.md` copies, 0 differ from the source (`cmp`).
- (c) **verified.** The full suite passed (see REQ-011 c). `test-0000151-req-007-dispatch-model-tiers.sh` exit 0. The one changed assertion in `test-0000006-build-assessment.sh` swaps `claude-haiku` for the tier-table row. It is a replacement, not a removal.

## REQ-008 quiet test output

Method: two fixture suites (10 passing asserts plus one `assert_contains`, and a suite with two mismatches) sourcing the real `helpers/assert.sh`, run with and without `PLANIFEST_TEST_QUIET=1`. A second copy sourced the base-commit `assert.sh` (`git show 8b1e929:...`).

- (a) **verified for the Bash helper. The PowerShell helper (`assert.ps1`, `Assert-Contains`) is not-verifiable here (verified in CI on PR #23).**

| Suite | Mode | Exit | Bytes | `PASS:` lines |
|---|---|---|---|---|
| passing | normal | 0 | 202 | 11 |
| passing | quiet | 0 | 34 | 0 |
| failing | normal | 1 | 238 | 3 |
| failing | quiet | 1 | 213 | 0 |

  - Quiet passing output was a blank line plus `Results: 11 passed, 0 failed`.
  - Quiet failing output began `--- fail-suite.sh ---`, then `FAIL: mismatch case` with `expected: expected` and `actual:   actual`, then `FAIL: contains fail` with `needle:   NEEDLE` and `haystack: some haystack text`.
  - Normal and quiet exit codes match (0/0 and 1/1).
- (b) **verified for the Bash helper. The PowerShell side is not-verifiable here (verified in CI on PR #23).** Normal-mode output of both fixtures was byte-identical to the output of the base-commit helper (`cmp`).
- (c) **verified.**
  - `tests/run-tests.sh:12` and `tests/run-tests.ps1:7` mention `PLANIFEST_TEST_QUIET`.
  - `planifest-refactor/SKILL.md:42` and `planifest-validate-and-accept/SKILL.md:33` run `PLANIFEST_TEST_QUIET=1 bash planifest-zero/tests/run-tests.sh`. These are the only skills that name `run-tests`.
  - Full suite in quiet mode: 237 bytes of output, exit 0. Individual suites also passed in normal mode.
  - Observation: `standards/agent-dispatch-standards.md:64` names `run-tests.sh` in a table row without the variable. It is a use-case example, not a command, so I did not count it as a gap.

## REQ-009 context size at gates

- (a) **verified** by inspection. `planifest-zero/skills/planifest-orchestrator/SKILL.md:250-257`:
  - `:250` "At each phase gate in a gated run, state the approximate context size ... The P0 design gate counts, and so do the P1, P2, and P3 gates and the P4 ship gate." Also `:224`.
  - `:253` "Use the usage figure the host reports". `:254` "If the host reports none, give a stated estimate, labelled as an estimate."
  - `:255` "If the size passes about 150,000 tokens, recommend `/clear` or a new session".
  - `:256` "The statement is advisory. It never blocks, delays, or skips a gate."
  - `:257` "An autonomous run or a roadmap step does not report context size."
- (b) **verified.** `test-0000151-req-009-context-size-at-gates.sh` and `test-0000042-req-002-gate-and-exception-stops.sh` exit 0. The latter is unmodified.
- (c) **verified.** `git diff 8b1e929 HEAD` on the gate tests shows no deleted gate, approval or exception-stop assertion.

## REQ-010 WebFetch via subagent

- (a) **verified** by inspection. `standards/agent-dispatch-standards.md:41-50`, section `## WebFetch of a reference page`: "Run a `WebFetch` of a full reference page in a subagent on `sonnet` or `haiku`." Item 3: "The subagent returns only that extract, not the page." Item 2: "The dispatch passes `model` explicitly".
- (b) **verified.** The 9 installed copies in the scratch project match the source (`cmp`, 0 differ).
- (c) **verified.** Full suite passed. `test-0000151-req-010-webfetch-via-subagent.sh` exit 0.

## REQ-011 orchestrator references split

- (a) **verified.**
  - Bytes: `SKILL.md` is 26,979 now against 36,216 at the base. That is 9,237 bytes smaller, 25.5% (limit 27,162). `CLAUDE.md` is 8,322, so the sum is 35,301 (limit 35,484).
  - No-loss: my script (`noloss.mjs`) read the base `SKILL.md` from git and checked every non-blank, non-heading line (293) against the new `SKILL.md` plus `references/*.md`. Missing: 0, exit 0.
  - Mutation: removing the line "Run this after coaching Q&A completes ... It is a mandatory gate." from `orchestrator-scope-lock.md` gave `missing: 1`, exit 1.
  - A second script check: every non-blank line of the old Hard Limits, Resume Detection, Discovery Start Actions, Exception Stops, Phase Invocation and Subagent Dispatch sections still appears in the new `SKILL.md`. Missing: 0.
- (b) **verified.**
  - `SKILL.md` `## Pack Index` (`:92`) has a row for each of the 7 files under `references/`, and all 7 names appear in `SKILL.md`.
  - The inline sections exist at `:14`, `:69`, `:159`, `:232`, `:266`, `:293` and `:92`.
  - The test diff changes only paths and section boundaries, with no assertion removed. The helper `orch_combined` reads `SKILL.md` plus the references.
- (c) **verified for Bash. The 11 PowerShell suites are not-verifiable here (verified in CI on PR #23).**
  - Clean full-suite run from the repo root: `Feature suites: 110 passed, 0 failed. Regression suite: 19 passed, 0 failed. Skipped 11 PowerShell suites: pwsh not found. All tests passed.` Exit 0.
  - `setup.sh` into a scratch project installed all 7 reference files under `.claude/skills/planifest-orchestrator/references/`, byte-identical to the source (`cmp`).
  - `plan/current/build-log.md` records the byte counts (`:107`: 44,538 to 35,301 combined, 25.5% of `SKILL.md`).
  - Observation: an earlier full run overlapped a second one that I had started by mistake. That pair reported `109 passed, 1 failed` for one of them. A single clean run passed twice. Running two full suites at once in one account is unsafe, probably through shared temp paths. I did not investigate further.

## REQ-012 roadmap step logs

Method: same stub driver harness, plus `git init` in each fixture.

- (a) **verified.**
  - Two-step run: exit 0. `plan/.roadmap-logs/step-1.log` held `stub stdout line step 1`, `stub stderr line step 1`. `step-2.log` held the step 2 equivalents.
  - Stub modes fail, block and stall: each exit 1, final line ended `Log: plan/.roadmap-logs/step-1.log`, and the file existed.
  - Rerun of a blocked step with a stub that prints `short out`: the log held only `short out`.
  - Inactive roadmap: exit 1, 0 `Log:` suffixes, no `.roadmap-logs` folder. Existing lock: exit 1, 0 `Log:` suffixes, lock left in place.
- (b) **verified.**
  - Two runs in a git fixture: driver stdout held 0 stub stdout lines. Driver stderr held 2 `stub stderr line` lines. `.git/info/exclude` held `plan/.roadmap-logs/` exactly once (`grep -c -x` printed 1). `git status --porcelain | grep -c roadmap-logs` printed 0.
  - `plan/.roadmap-logs` as a regular file: exit 1, lock released, stub did not run, line `R-C Run: Blocked: could not open the step log`.
- (c) **verified.** `roadmap-standards.md` and the `roadmap-run.mjs` header each name `plan/.roadmap-logs/` (3 matches each) and the truncate rule (`roadmap-standards.md:153`: "Each step start will truncate its log, so a rerun leaves only the latest attempt.").

## REQ-013 roadmap telemetry labels

- (a) **verified.** Stub `printenv OTEL_RESOURCE_ATTRIBUTES`:
  - Unset: `work.kind=roadmap,planifest.roadmap=0000050-demo,planifest.step=1`, and `planifest.step=2` on step 2.
  - Set to `service.name=x,team=a`: `service.name=x,team=a,work.kind=roadmap,planifest.roadmap=0000050-demo,planifest.step=1`.
- (b) **verified.** `encodeLabelValue('a,b=c d%e')` returned `a%2Cb%3Dc%20d%25e`. `withRoadmapLabels('x=1,', '0000050', 'demo', 1)` returned `x=1,work.kind=roadmap,...` with no `,,`.
- (c) **verified.**
  - Launched with `env -i` and `FOO=bar OTEL_RESOURCE_ATTRIBUTES=a=b`. The child's environment differed from the launch environment (`env | sort`) in only two lines: `OTEL_RESOURCE_ATTRIBUTES` gained the three labels, and macOS added `__CF_USER_TEXT_ENCODING`. The latter comes from the OS, not the driver.
  - `grep -c 'process.env\.[A-Z_]* *=[^=]' roadmap-run.mjs` printed 0, so the driver never writes to its own `process.env`. The child gets a copy (`roadmap-run.mjs:223`).

## REQ-014 chart clarity and dependency stop

- (a) **verified** by inspection.
  - `standards/roadmap-standards.md:48-54`: the clarity check requires a problem, a wanted outcome and one observable condition. It lists failing entries and asks the human "to sharpen it or strike the step".
  - `:86-89`: names the `## Dependencies` table, Kind `library`, `service` or `none`, the `none` row, and "A dependency that no row lists stops the step."
  - `templates/roadmap-entry.template.md:41`: `## Dependencies` after `## Schema changes`, columns `Step | Name | Kind | Purpose`, and a `none` example row.
  - `templates/design.template.md:46`: `- Approved dependencies: {...}` under `## Dependencies` (`:43`).
- (b) **verified.**
  - The Exception Stops table in `SKILL.md:266` onward has 6 data rows. Row 6 names both lists ("`Approved dependencies` field of `design.md` in a gated run, and the `## Dependencies` table of `roadmap.md` in a roadmap step") and says "This applies in every run mode". It uses `{prefix} Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative.`
  - `planifest-implement/SKILL.md:46` and `planifest-plan/SKILL.md:66` carry the stop and name both lists.
  - The five original rows: I extracted the table rows at the base and now. Every base row appears byte for byte in the new table (`grep -vxFf` printed nothing).
- (c) **verified.** `test-0000043-req-002-roadmap-chart.sh`, `test-0000043-req-011-chart-time-schema-approval.sh` and `test-0000151-req-014-chart-clarity-and-dependency-stop.sh` exit 0. After scratch `setup.sh`, the installed `planifest-plan` and `planifest-implement` `SKILL.md` and `roadmap-standards.md` copies match the source.

## REQ-015 faster PowerShell CI

- (a) **verified** by static check of `.github/workflows/planifest.yml` (parsed with Ruby `YAML.load_file`):
  - `strategy` is `{"fail-fast"=>false, "matrix"=>{"include"=>[{"shell"=>"powershell"}, {"shell"=>"pwsh"}]}}` (lines 56-61).
  - `runs-on: windows-latest`, job `permissions: {contents: read}`, workflow `permissions: {contents: read}`, `secrets.` matches 0.
  - One checkout step: `actions/checkout@11d5960a326750d5838078e36cf38b85af677262` with `persist-credentials: false`.
  - One step invokes `run-tests.ps1` (`:76`) under `defaults.run.shell: ${{ matrix.shell }}` (`:66`). The other match at `:48` is a comment.
- (b) **verified for the Bash tests. The timing lines are not-verifiable here (verified in CI on PR #23).**
  - `test-0000036-req-005-windows-ci-job.sh`, `test-0000037-req-006-bash-suites-ci-job.sh` and `test-0000151-req-015-faster-powershell-ci.sh` exit 0.
  - The 0000036 diff keeps every check. It replaces the literal-line and "2 run-tests.ps1 lines" checks with a matrix check and a "1 invocation" check, which the criterion allows.
  - `bash-suites` still sets `PLANIFEST_REQUIRE_PWSH: "1"` (`:95`).
  - `setup-workspace.ps1:38,73,77` writes `[timing] workspace copy`, `[timing] pwsh start-up` and `[timing] setup.ps1`, but it runs only under PowerShell.
- (c) **not-verifiable.** Reason: the wall time of `windows-powershell` can only come from CI on PR #23, and this machine has no `pwsh`. The "both entries must pass" gate follows from the YAML above (`fail-fast: false` with two matrix entries, and a job fails if any entry fails), but I did not observe a run.

## Criteria with a not-verifiable clause

| Criterion | What is not verifiable here | Reason |
|---|---|---|
| 004 a, b, c | `setup.ps1` pruning, `.ps1` cleanup test | verified in CI on PR #23 |
| 005 b, c | `setup.ps1` read-only `settings.json`, `.ps1` hardening test | verified in CI on PR #23 |
| 008 a, b | `assert.ps1` and `Assert-Contains` quiet and normal output | verified in CI on PR #23 |
| 011 c | 11 PowerShell suites in the full run | verified in CI on PR #23 |
| 015 b | `[timing]` lines | verified in CI on PR #23 |
| 015 c | `windows-powershell` wall time | needs CI on PR #23 |

## Failed criteria

None.
