# Verification report - 0000043-autonomous-roadmaps

All commands ran from the repo root on branch `feat/0000043-autonomous-roadmaps` (macOS). Temp fixtures lived in the session scratchpad and are removed. No tracked file changed except this report.

## Test runs

Each `planifest-zero/tests/test-0000043-req-001` to `req-010` script ran alone. All exited 0 with no `FAIL` line. The three 0000042 tests named in req-009 (c) also exited 0.

## Coverage table

| Req | Criterion | Test file and section | Covered |
|---|---|---|---|
| 001 | (a) template, frontmatter, fields, four statuses, six-column table | `test-0000043-req-001-roadmap-drafts.sh`, "req-001 (a)" | yes |
| 001 | (b) shared seven-digit sequence, high-water mark over four folders | same, "req-001 (b)" | yes |
| 001 | (c) no prefix, any branch and phase, write after confirmation | same, "req-001 (c)" | yes |
| 002 | (a) R-A Chart, synced main, pre-flight, one at a time, pull-in/leave/discard | `test-0000043-req-002-roadmap-chart.sh`, "req-002 (a)" | yes |
| 002 | (b) malformed draft flagged, never parsed | same, "req-002 (b)" | yes |
| 002 | (c) coaching, missing entry stops, confirmation is approval | same, "req-002 (c)" | yes |
| 003 | (a) three preflight checks, one-active refusal, `Blocked:` before changes | `test-0000043-req-003-roadmap-activate.sh`, "req-003 (a)" | yes |
| 003 | (b) branch from main, active roadmap file, draft deleted, one commit, push | same, "req-003 (b)" | yes |
| 003 | (c) driver offer, background task, parent must not edit tree | same, "req-003 (c)" | yes |
| 004 | (a) branch from roadmap branch, brief and deletion in one commit, `autonomous` unasked | `test-0000043-req-004-roadmap-step-discovery.sh`, "req-004 (a)" | yes |
| 004 | (b) `draft-accepted (roadmap)`, stop only when too vague | same, "req-004 (b)" | yes |
| 004 | (c) `Bump` values, default `minor`, downgrade block | same, "req-004 (c)" | yes |
| 005 | (a) `--base roadmap/{id}-{slug}`, `merged`, Version, `position` in same PR | `test-0000043-req-005-roadmap-advance.sh`, "req-005 (a)" | yes |
| 005 | (b) green checks, squash, fetch, tag, push tag, `Blocked:` | same, "req-005 (b)" and "(d)" | yes, requirement text updated to match the build |
| 005 | (c) tag-before-PR and no-merge outside a roadmap | same, "req-005 (c)" | yes |
| 006 | (a) squash into `roadmap/*` exits 0, main, no flag, failed `gh` exit 2 with `[Planifest]` | `test-0000043-req-006-merge-guard-hook.sh`, "req-006 (a)" | yes |
| 006 | (b) non-merge, non-Bash, malformed stdin exit 0 | same, "req-006 (b)" | yes |
| 006 | (c) registered under `PreToolUse` with matcher `Bash` in both setup scripts, parity | same, "req-006 (c)" | yes |
| 007 | (a) two-step run, exact arguments, no `--continue` or `--resume`, stage lines, lock released | `test-0000043-req-007-roadmap-driver.sh`, "req-007 (a)" | yes |
| 007 | (b) non-zero exit with no step on non-active or existing lock, lock untouched | same, "req-007 (b)" | yes |
| 007 | (c) stops on `Blocked:`, unchanged position, non-zero stub, lock released | same, "req-007 (c)" | yes |
| 008 | (a) archive path and `status: done` on roadmap branch | `test-0000043-req-008-roadmap-delivery.sh`, "req-008 (a)" | yes |
| 008 | (b) one PR to main, merge commit, steps with version and tag | same, "req-008 (b)" | yes |
| 008 | (c) never merges roadmap PR, never commits to main | same, "req-008 (c)" | yes |
| 009 | (a) resume checks `plan/current-roadmap/` first, both cases | `test-0000043-req-009-roadmap-resume-and-prefixes.sh`, "req-009 (a)" | yes |
| 009 | (b) five `R-` prefixes, status form, stage letters, in both documents | same, "req-009 (b)" | yes |
| 009 | (c) 0000042 tests still pass, Hard Limit 10 unchanged | same, "req-009 (c)" (Hard Limit 10 only) plus my run of the three 0000042 tests | yes, see Gaps |
| 010 | (a) `roadmap/*`, `--squash`, clean P3 and green CI in four files | `test-0000043-req-010-merge-carve-out-governance.sh`, "req-010 (a)" | yes |
| 010 | (b) main and roadmap PR stay human-only | same, "req-010 (b)" | yes |
| 010 | (c) `merge-guard` named, unconditional text gone | same, "req-010 (c)" | yes |
| 011 | (a) data-contract survey, `## Schema changes` table, approve, edit, or strike rows, confirmation approves rows left | `test-0000043-req-011-chart-time-schema-approval.sh`, "req-011 (a)" | yes |
| 011 | (b) opt-in fallback with default `stop`, template table and fallback field | same, "req-011 (b)" | yes |
| 011 | (c) proposal still written, `approved (roadmap chart)` on a match, normal stop otherwise, destructive always stops, implement pointer | same, "req-011 (c)" | yes |
| 012 | (a) `In progress:` and `Done:` lines and their commits in the dispatch standard, skill pointers, template | `test-0000043-req-012-progress-markers-and-resume.sh`, "req-012 (a)" | yes |
| 012 | (b) unmatched `In progress:` marks an interrupted unit, named stash, rerun from start, `Resumed after interruption:` line, Resume Detection step before Open | same, "req-012 (b)" | yes |
| 012 | (c) an unmatched `In progress:` line does not stop the driver | same, "req-012 (c)" | yes |

## Gaps

- **req-004 (c), closed in b4a824b.** The standard names `product.yml` and `docs/about.md` as the source of the roadmap branch's version, and the test asserts both.
- **req-005 (b), closed.** The requirement text now matches the build: pending CI waits, and only no CI after 2 minutes or a failed check blocks.
- **req-009 (c), indirect.** The req-009 test asserts only Hard Limit 10. The three 0000042 tests are covered by the suite run, not by an assertion in the req-009 script.

## Execution evidence

| Item | Method | Outcome | Observation |
|---|---|---|---|
| Driver, two-step active roadmap | `node planifest-zero/scripts/roadmap-run.mjs --root <tmp>` with stub `claude` on `PATH`, roadmap built from the template with frontmatter `status` unquoted | verified | Exit 0. Lines: `R-C Run: Starting`, `R-D Advance: Complete` (step 1), `R-C Run: Starting`, `R-D Advance: Complete`, `R-E Delivery: Complete`. Stub called twice with `-p --permission-mode auto Run roadmap step N`. Lock absent after exit. |
| Driver, `Blocked:` build-log line | Same, stub appends `Blocked:` | verified | Exit 1. Line `R-C Run: Blocked: step 1 stopped. Blocked: ...`. One stub call. Lock absent. |
| Driver, stalled position | Same, stub exits 0 and changes nothing | verified | Exit 1. Line `R-C Run: Blocked: position stayed at 1 after step 1`. Lock absent. |
| Driver, failed `claude` | Same, stub exits 3 | verified | Exit 1. Line `R-C Run: Blocked: claude exited 3 on step 1`. Lock absent. |
| Driver, inactive roadmap | Same, `status` draft | verified | Exit 1. Line `R-C Run: Blocked: roadmap status is draft, not active`. Zero stub calls. |
| Driver, `.git/info/exclude` | Same fixture after `git init` | verified | Exit 0. `plan/.roadmap-runner.lock` on line 7 of `.git/info/exclude`. |
| Driver, roadmap with the template's quoted frontmatter | Same, frontmatter left as `status: "active"` as the template writes it | verified, fixed in 2f0b6ed | Exit 0 after the fix. Before it: exit 1 with `R-C Run: Blocked: roadmap status is missing or invalid`. `field()` now strips one pair of quotes, and the body field wins over the frontmatter. The req-007 test covers a filled-in copy of the template. |
| Template | Read `roadmap-entry.template.md` | verified | Frontmatter `title`, `summary`, `status`. Fields **Goal**, **Branch**, **Status**, **Position**. Section `Stop conditions`. Status comment lists `draft | active | blocked | done`. Header row `| Step | Feature id | Backlog entries | Bump | Version | Status |`. |
| Setup, hook registration | Copied `planifest-zero/` and `product.yml` to a temp project, `git init`, `bash planifest-zero/setup.sh claude-code` | verified | Exit 0, 0 stderr lines. `.claude/settings.json` holds one `PreToolUse` entry for `merge-guard` with matcher `Bash`. `merge-guard.mjs` present in `.claude/hooks/enforcement/`. |
| Setup, generated `CLAUDE.md` | Same project with `planifest-overrides/` copied in, setup rerun | verified | Exit 0. `CLAUDE.md` line 47 and line 78 carry the `roadmap/*` carve-out and name `merge-guard`. Without `planifest-overrides/` the file has no carve-out, because the text comes from the overrides. |
| Merge carve-out citations | Grep with line numbers | verified | Orchestrator `planifest-zero/skills/planifest-orchestrator/SKILL.md:408`. Ship skill `planifest-zero/skills/planifest-ship/SKILL.md:18`. Overrides `planifest-overrides/instructions/custom-001-local-git-only.md:9` and `custom-004-ship-push-and-raise-pr.md:5`. Standard `planifest-zero/standards/roadmap-standards.md:81-91` (section "Merge carve-out"). |
| Resume rules | Grep with line numbers | verified | Orchestrator `SKILL.md:88` checks `plan/current-roadmap/` first. Line 89 resumes a step that holds artifacts. Line 91 runs R-E Delivery when `position` is past the last step. Line 92 starts at `position` when `plan/current/` is empty. |

## Defect

Fixed in 2f0b6ed. The template writes quoted frontmatter such as `status: "draft"`, and the driver rejected the quoted value. `field()` in `planifest-zero/scripts/roadmap-run.mjs` now strips one matching pair of quotes and a trailing comment. It reads the body field first and falls back to the frontmatter.

## Live acceptance run

The run used the private repo `planifest/pz-roadmap-acceptance-0000043`, with the pack copied from this branch. A parent session drove each pipeline run through `claude -p --permission-mode auto`. The human answered the coaching questions through the parent and merged every PR into `main`.

| Run | What ran | Result |
|---|---|---|
| Feature 1 | `0000001-notes-create-read`, PR #1 | Shipped green at 0.1.0. The human merged it. |
| Feature 2 | `0000002-notes-update-delete`, PR #2 | Shipped green at 0.2.0. The pack-update provenance stop fired as designed. |
| Roadmap 1 | `0000007-notes-organisation`, four steps, PRs #3 to #6, roadmap PR #7 | All four steps squash-merged and tagged. One exception stop at step 1 (M-003). |
| Roadmap 2 | `0000010-notes-ordering`, two steps, PRs #8 and #9, roadmap PR #10 | Both steps squash-merged and tagged. The driver stopped mid-step and restarted. |

| Criterion | Outcome | Observation |
|---|---|---|
| merge-guard against a real `gh` and real PRs | verified | It blocked the agent's own merge of PR #1 into `main` with exit 2. It allowed six squash merges into `roadmap/*`: PRs #3 to #6, #8, and #9. |
| 1. A draft roadmap filed on a feature branch reaches `main` and Chart offers it | not-verifiable live | Both live charts started from a new idea. `test-0000043-req-001` and `req-002` cover the draft path. |
| 2. Activate cuts the branch, writes `plan/current-roadmap/`, and commits once | verified | Commits `f91b52c` and `a81267f`, each pushed to a new `roadmap/*` branch. |
| 3. Each step PR targets the roadmap branch, squash-merges after green CI, and is tagged on the squash commit | verified | Tags `v0.3.0` to `v1.0.0` sit on `96f85cc`, `5200447`, `d13e401`, and `cb69977`. Tags `v1.1.0` and `v1.2.0` sit on the squash commits of PRs #8 and #9. |
| 4. Each step's version follows its bump | verified | minor, minor, patch, and major gave 0.3.0, 0.4.0, 0.4.1, and 1.0.0. Two minor bumps then gave 1.1.0 and 1.2.0. |
| 5. merge-guard allows `roadmap/*` and blocks other bases | verified | See the merge-guard row. |
| 6. The driver runs fresh sessions and stops on `Blocked:` or a stalled position | verified | Roadmap 1 step 1 stopped at M-003. The step wrote `- Blocked:`, so the driver reported a stalled position. Commit `1d409ab` fixes that, and the driver now repeats the reason. |
| 7. Delivery archives the roadmap and raises one PR that asks for a merge commit | verified | PRs #7 and #10. The human used a merge commit for both, and every step tag is reachable from `main`. |
| 8. Two features, then a four-step roadmap from Activate to Delivery with no human input | verified with one stop | Roadmap 1 needed one human decision, the M-003 schema approval, as Hard Limit 3 requires. Chart-time schema approval (req-011) closes that gap. Roadmap 2 ran from Activate to Delivery with no human input. |
| Recoverability NFR: a stopped driver resumes the same step | verified | SIGTERM at step 1's P2 stopped the child session and released the lock. The restarted driver finished step 1 and step 2. |
| req-011 chart-time schema approval | verified | Roadmap 2's Chart listed `pinned` as additive. Step 1 marked M-004 `approved (roadmap chart)` and did not stop. |
| req-012 progress markers | not-verifiable live | The test repo's pack predates req-012. `test-0000043-req-012` covers it. |

The run found four faults. Each is fixed on this branch with a failing test first:

- The driver missed `Blocked:` lines written as list items (`1d409ab`).
- merge-guard wrote its block reason only to stdout, which the agent never sees (`96314f2`).
- R-D Advance left feature branches on `origin` (`4fab9d1`).
- The resumed step committed half-written files from the stopped unit and left no trace of the stop (req-012).
