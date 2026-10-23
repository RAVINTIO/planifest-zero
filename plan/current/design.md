# Design - 0000042-autonomous-mode-and-prefixes

## Feature
- Problem: Planifest Zero has no run mode that reaches a pull request without stopping. Its phases run P1 to P5 with letter prefixes, and it names itself a framework, which confuses it with Planifest Framework.
- Adoption mode: standard-iterative (assumed, only signal: `plan/_archive/` and `docs/about.md` present)
- Feature ID: 0000042-autonomous-mode-and-prefixes
- Version: 0.9.0 (minor, from 0.8.0, confirmed by the human)
- Run mode: continuous (this run uses the 0.8.0 skills, where `autonomous` does not yet exist)
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories: US-001 to US-005 in `feature-brief.md`.
- Acceptance criteria confirmed: 8 (see `feature-brief.md`)
- Constraints:
  - The human merges every pull request. No mode commits to `main` or merges.
  - Schema proposals and 5-attempt escalations stop the run in both modes.
  - Archive and changelog history stays as written.
- Integrations: git CLI and `gh` (ship only, unchanged)

## Architecture Layer
- Latency target: not applicable (local tooling)
- Availability target: not applicable (local tooling)
- Scalability target: not applicable
- Security: no auth. Plan files are internal. Autonomous adds one stop: an unmitigated critical or high security finding at P3.
- Data privacy: no regulated data
- Observability: standard defaults. The build log records the run mode and every phase block.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Markdown skills, Bash, PowerShell 5.1 and 7, JavaScript (Node). Tests are shell and node scripts under `planifest-zero/tests/`, run by `run-tests.sh` and `run-tests.ps1`. CI is GitHub Actions. Build target: local.
- Components: `planifest-zero`, the pack of skills, hooks, templates, setup scripts, and tests.
- Data ownership:
  - The orchestrator owns `plan/.run-mode` and the build-log header and P0 block.
  - Each phase skill appends only its own phase block.
- Deployment: files in the repo, installed into `.claude/` by `setup.sh` or `setup.ps1`.
- API versioning: not applicable

### Run modes (US-001, US-002)
- The run-mode question at the end of P0 reads:

  ```
  How should the agent run P1 to P4?

    [1] Gated: the agent stops for you at the end of each phase
    [2] Autonomous: the agent runs to a raised PR and stops only for escalations
  ```

- `plan/.run-mode` holds `gated` or `autonomous`. `interactive` and `continuous` are retired.
- `gated` stops at the P1, P2, P3, and P4 gates. The P4 gate comes before the PR, as today.
- `autonomous` stops at none of those gates. P3 presents its acceptance evidence in the PR description instead of a gate. P4 raises the PR and ends with `P4 Ship: Complete: PR #{n} ready for your review`.
- Both modes stop on these exceptions:
  - A requirement or check still fails after 5 attempts.
  - P2 needs a schema change.
  - The P3 security review finds an unmitigated critical or high issue.
  - A push or `gh pr create` fails.
- On resume, a missing or unknown `plan/.run-mode` makes the agent ask the run-mode question and name the value it found. It writes the answer and logs it. The fresh-start stale check stays as it is.
- `pipeline-reference.md` loses the rule that let continuous skip a clean acceptance gate. The skills are the single source.

### Phase numbers and prefixes (US-003)
- The phases become P0 Discovery, P1 Plan, P2 Implement, P3 Validate and Accept, P4 Ship.
- Build-log headings use `### P<n>: {Phase Name}` with n from 0 to 4.
- Every message starts with one of these prefixes, then a status and a one-liner:

  | Phase | Prefix |
  |-------|--------|
  | P0 | `P0 Discovery:` |
  | P1 | `P1 Plan:` |
  | P2 | `P2 Implement:` |
  | P3 | `P3 Validate:` |
  | P4 | `P4 Ship:` |

- Statuses use one form: `{prefix} {Status}: {one-liner}`, for example `P1 Plan: Complete: 4 requirements, 2 ADRs`.
- Hard Limit 10 drops its claim that a hook parses the heading form. No source hook does.
- Old cites of P5 to P9, such as "P0 briefing" and "P9 push", move to the new numbers. That includes `custom-004-p9-push-and-raise-pr.md`.

### Product name and wording (US-004, US-005)
- `product.yml` and `planifest-zero/component.yml` say `name: "Planifest Zero"`.
- Prose that describes Planifest Zero as a framework changes to "Planifest Zero", "the pack", or "the pipeline", whichever reads best.
- Identifiers that name Planifest Zero as a framework take a Zero-specific name. Examples are `FRAMEWORK_DIR` in the setup scripts and `framework-update-policy.md`. P1 fixes the name map in an ADR.
- Generic uses stay. Examples are the `test-frameworks.md` standards, "meta-framework", and references to Planifest Framework itself.
- A test greps every tracked file outside `plan/_archive/` and `plan/changelog/`. It fails on "framework" unless the line matches an allowlist of generic uses.

## Scope
- In:
  - Run modes `gated` and `autonomous`, with the exception stops.
  - Phases P0 to P4 and the five prefixes.
  - The product name in `product.yml` and `component.yml`.
  - "Framework" wording and identifiers across every tracked file.
- Out:
  - Multi-release autonomy (0000098, 0000099).
  - Generic uses of "framework".
  - History under `plan/_archive/` and `plan/changelog/`.
  - Migration for other installs.
  - Stale installed hooks in `.claude/hooks/enforcement/` with no source (filed to backlog).
- Deferred: nothing deferred.

## Assumptions
- No other repo installs Planifest Zero. Impact if wrong: another install breaks on the renamed identifiers and run-mode values.
- Renaming test files that carry old feature ids is unnecessary. Tests keep their names and change their assertions. Impact if wrong: names such as `continuous-run-p1-p3` mislead a reader.

## Risks
- The wording and renumbering edits touch the same files and conflict when run in parallel. Likelihood: high. Impact: medium. Mitigation: P2 runs REQ-002 before REQ-004, or splits subagents by file.
- A stray old phase number or "framework" survives. Likelihood: medium. Impact: low. Mitigation: grep tests for both, run in CI.
- Autonomous hides a P3 finding until the PR. Likelihood: low. Impact: high. Mitigation: the security stop, and P3 evidence in the PR description.
- This run uses the 0.8.0 skills while it edits them. Likelihood: high. Impact: low. Mitigation: setup refreshes `.claude/skills/` at P3, and the run keeps the old numbers in its own log.

## Dependencies
- Upstream: 0000023 (continuous run gate rules), 0000037 (self-hosting).
- Downstream: 0000098 and 0000099 build on `autonomous`.

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - run-modes-gated-autonomous | planifest-implement | TDD change to the orchestrator, phase skills, docs, and the 0000023 test |
| REQ-002 - phase-numbers-and-prefixes | planifest-implement | TDD renumbering across skills, templates, docs, hooks, and tests |
| REQ-003 - product-name-planifest-zero | planifest-implement | Two-field change with a grep test |
| REQ-004 - remove-framework-wording | planifest-implement | TDD wording and identifier change with an allowlist grep test |

## Repo Instructions
- `custom-001-local-git-only.md`: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging PRs are human-only. Commit after every meaningful artifact.
- `custom-002-prefer-subagent-decomposition.md`: split long or multi-unit tasks into parallel subagents by default, and state the reason when a task cannot be split.
- `custom-003-git-up-to-date-shorthand.md`: "GUTD" means check out `main`, pull, and list untracked files.
- `custom-004-p9-push-and-raise-pr.md`: at ship, push the branch and tag, and raise the PR without asking. Never merge.
- `custom-005-delete-redundant-local-branches.md`: delete a local branch whose PR merged or whose upstream is gone, with `git branch -D`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 23 Oct 2026 @ 08:14 a.m. BST
