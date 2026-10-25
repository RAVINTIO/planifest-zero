---
title: "Security Report - subagent-acceleration"
summary: "Security review of the run-speed sentinel, the fast-batch dispatch rules, the build-log timing rows, and three Bash text suites."
status: "draft"
version: "0.17.0"
---
# Security Report - subagent-acceleration

**Skill:** validate-and-accept
**Feature:** 0000172-subagent-acceleration
**Version:** 0.17.0

> It is advisory. No code changes are made. All findings require human review before action.

## Summary

**Overall risk assessment:** low
**Components reviewed:** ravintio-zero (skills, dispatch standard, roadmap standard, templates, three `test-0000172-*` suites, `component.yml`), `docs/`
**Review scope:** code review | dependency audit | threat model | governance review

The review covers `git diff 1a14101..HEAD -- ravintio-zero docs`. It excludes `plan/`.

No Critical or High finding exists. Three Medium findings sit in the fast-batch rules. They are gaps in text, and no code path is affected. Five Low findings and three informational notes remain.

The diff adds no script, hook, dependency, network call, or `eval`. A scan of the diff for credential patterns found none. The new suites only read pack files with `grep` and `awk`.

## Findings

| ID | Severity | Category | Location | Description | Mitigation | Status |
|----|----------|----------|----------|-------------|------------|--------|
| S-001 | medium | governance | `ravintio-zero/standards/agent-dispatch-standards.md:93`; `ravintio-zero/skills/ravintio-implement/SKILL.md:140-141` | The rules say exception stops "stay as they are". They do not say what a parallel sibling does when one unit hits a stop, such as a schema proposal or a destructive schema operation. The other units in the batch can keep writing while the human has not yet decided. A track could then build on a schema that the human later rejects. | Not mitigated. Add a line that any unit reporting a stop halts the batch, and the parent stops before it dispatches the next batch. | mitigated in P3 |
| S-002 | medium | governance | `ravintio-zero/skills/ravintio-implement/SKILL.md:140`; `ravintio-zero/standards/agent-dispatch-standards.md:90` | The disjoint-write rule covers each track's own files. Parallel tracks also add libraries to the shared manifest and lock file. Two tracks can both add a dependency, and the dependency stop and the library audit see each change out of order. | Not mitigated in text. The CI library audit step catches an avoided library afterwards. Add the manifest and lock file to the shared-file list, so the parent applies dependency changes inline. | mitigated in P3 |
| S-003 | medium | governance | `ravintio-zero/skills/ravintio-ship/SKILL.md:169`; `ravintio-zero/standards/agent-dispatch-standards.md:93` | "Each unit commits its own files" lets two agents run `git commit` at once in one working tree. The second commit can fail on `.git/index.lock` or stage the other unit's files. A failed commit leaves the unit uncommitted, which breaks the commit-continuously rule. No data leaves the repository. | Partly mitigated. The `In progress:` and `Done:` markers show an interrupted unit on resume (`agent-dispatch-standards.md:150`). Add a rule that the parent commits after the batch, or that units retry on a lock. | mitigated in P3 |
| S-004 | low | governance | `ravintio-zero/skills/ravintio-validate-and-accept/SKILL.md:126-131` | The security review runs in parallel with the inline CI checks and self-correct cycles. A fix can change code after the review read it. The report may then describe code that no longer exists. The unmitigated critical or high stop at `:93` still applies to the report as written. | Partly mitigated. The review and the CI result share one commit range. Add a line that the review reads the final commit, or re-checks changed files after the last cycle. | open |
| S-005 | low | governance | `ravintio-zero/standards/agent-dispatch-standards.md:84-96`; `:122` | The Fast batches section does not restate the backlog id rule. Two units in the validate batch (execution verification and security review) can both file a discovery. Line 122 already requires a distinct pre-assigned id per unit, so the rule holds if the dispatcher follows it. | Mitigated by `agent-dispatch-standards.md:122`. Optionally add a pointer in the Fast batches section. | accepted |
| S-006 | low | governance | `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-run-speed.md:30` | On resume, the file keeps the stored speed without asking. A `plan/.run-speed` left by an earlier aborted feature sets `fast` for the new run. The cleanup list (`:33-38`) deletes the file on the interrupted-ship and stale run-mode paths, which narrows the case. A `fast` run weakens no gate. | Mitigated. Cleanup covers the known paths. The build log records the speed at `:16`. | accepted |
| S-007 | low | governance | `ravintio-zero/skills/ravintio-ship/SKILL.md:79`; `ravintio-zero/skills/ravintio-orchestrator/references/orchestrator-run-speed.md:16` | The reference tells the orchestrator to include `plan/.run-speed` in the discovery commit, so the file is tracked on the feature branch. Ship Step 8 deletes it and confirms with `git ls-files` before any push. A ship that stops before Step 8 leaves the file in a pushed branch. A later roadmap step overwrites it from `**Speed:**`. | Mitigated. Step 8 runs before any push. Test `test-0000172-req-001-run-speed.sh:48` checks the Step 8 text only. | accepted |
| S-008 | low | injection | `ravintio-zero/standards/roadmap-standards.md:117`; `ravintio-zero/templates/roadmap-entry.template.md:28` | The roadmap `**Speed:**` field is committed text. It becomes the content of `plan/.run-speed`. Any value other than `fast` or `standard` becomes `standard`, so the content is never written raw. Case and trailing space handling is not stated. | Mitigated by the allowlist at `roadmap-standards.md:117`. Optionally say that matching is exact and case-sensitive. | accepted |
| S-009 | informational | injection | `ravintio-zero/tests/test-0000172-req-001-run-speed.sh:23`, `:29`, `:46` | `section()` passes a heading to `awk -v`. `awk -v` expands backslash escapes. All callers pass constants, and no file content reaches the heading. The suites build no command from file content and run no `eval`. | None needed. | accepted |
| S-010 | informational | path traversal | `ravintio-zero/tests/test-0000172-req-001-run-speed.sh:7-8`; `test-0000172-req-002-fast-batches.sh:6-7`; `test-0000172-req-003-phase-timing.sh:6-7` | Each suite derives `ZERO_DIR` from `$0` and reads fixed pack paths. No path comes from user input, and no suite writes a file or creates a temp folder. | None needed. | accepted |
| S-011 | informational | governance | `ravintio-zero/tests/test-0000172-req-001-run-speed.sh:48-52` | The suites check that the rule text exists. They cannot show that an agent deletes `plan/.run-speed` or follows a fast batch. This matches A-001 in the risk register. | Not mitigated by tests. The build report shows the agent count. | open |

## Checks with no finding

### Gates and stops

- Fast batches change dispatch only. `agent-dispatch-standards.md:92-93` keeps phase order, gates, and exception stops.
- The validate fast batch keeps the stop for unmitigated critical or high findings (`ravintio-validate-and-accept/SKILL.md:93`, unchanged).
- The ship fast batch ends before Step 7. Steps 8 to 10 stay inline and in order, so the PR step and the rule that the human merges to `main` are unchanged (`ravintio-ship/SKILL.md:162-169`).
- The `gh pr merge --squash` carve-out for `roadmap/*` is untouched. No fast-batch unit runs a merge.
- The ship fast batch units write disjoint files: `build-report.md` against `docs/about.md`, `product.yml`, and `component.yml`.
- An unknown or missing speed falls back to `standard`, which is the safe direction.

### Injection and external calls

- The diff adds no `eval`, no `Invoke-Expression`, no command built from file content, and no new call to an external program.
- The Bash suites use `grep -F` or `grep -q` with fixed patterns and `awk` with fixed programs.

### Credentials, dependencies, and data

- The diff holds no secret. The build log rows hold timestamps and whole minutes.
- No package file changes, so no dependency risk is added.
- The acceptance evidence rules at `ravintio-validate-and-accept/SKILL.md:107` are unchanged. The timing rows add no environment value.

## Risk-register cross-reference

| ID | Risk | Result | Evidence |
|----|------|--------|----------|
| R-001 | A fast batch dispatches two units that write the same file | open | The disjoint rule exists at `agent-dispatch-standards.md:90`. S-002 and S-003 show shared files it does not name (manifests and the git index). |
| R-002 | `plan/.run-speed` reaches a roadmap branch | mitigated | Ship Step 8 deletes it before any push (`ravintio-ship/SKILL.md:79`). Cleanup paths cover aborted runs. See S-006 and S-007. |
| A-001 | Phase agents follow a listed fast batch more reliably than a general rule | open | Tests check the text only (S-011). The build report shows the agent count. |

New risks this review adds to the register: S-001 to S-003 as medium risks. P3 mitigated each one. See Mitigations applied.

## Top actions

1. State that a stop in one unit halts the batch and the parent (S-001).
2. Name the manifest and lock file as shared files that the parent writes inline (S-002).
3. Move batch commits to the parent, or add a retry on a lock (S-003).
4. Have the security review read the final commit (S-004).

## Counts

- Critical: 0
- High: 0
- Medium: 3 (all mitigated in P3)
- Low: 5
- Informational: 3
- Unmitigated Critical or High: 0

## Mitigations applied

The orchestrator applied these changes after the review. The fast batch suites, the prose guards, and the dispatch tier suite pass afterwards.

- S-001: `## Fast batches` in `agent-dispatch-standards.md` now says a stop in one unit starts no further unit. Running units finish and commit, then the phase takes the stop.
- S-002: the same section counts a dependency manifest or lock file as shared. At most one unit in a batch may add a dependency.
- S-003: units commit one at a time and stage their own files by path. A commit that meets `.git/index.lock` waits and retries. Ship's fast batch points to the rule.
- R-001 is now mitigated by these rules. A-001 stays open, because the tests check text only.
