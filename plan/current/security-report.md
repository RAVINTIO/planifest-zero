# Security Report - autonomous-roadmaps

**Skill:** [validate-and-accept](../skills/planifest-validate-and-accept/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Version:** 0.9.0

> It is advisory - no code changes are made. All findings require human review before action.

## Summary

**Overall Risk Assessment:** medium
**Components Reviewed:** planifest-zero (`hooks/enforcement/merge-guard.mjs`, `scripts/roadmap-run.mjs`, `standards/roadmap-standards.md`, the ship and orchestrator skill changes, `setup.sh`, `setup.ps1`, `hooks/planifest.yml`)
**Review Scope:** code review | threat model

No finding is Critical or High. The stop rule for unmitigated critical or high findings does not fire.

The main risk is `merge-guard.mjs`. It matches command text with a regular expression. I ran it against 44 crafted payloads with a stub `gh` that reports base `main`. Eleven forms that should reach `main` exit 0 and pass. The guard is a defence-in-depth layer, so these gaps do not rate High. Three other controls also hold `main`:

- the ship and roadmap skills forbid a merge into `main`
- GitHub branch protection on `main` applies
- the human merges the roadmap PR

A determined agent could still merge a PR into `main` past the guard. The guard stops a mistake. It does not stop a deliberate bypass.

`roadmap-run.mjs` validates every field it uses and passes arguments without a shell. I found no injection path into `claude` or `git`.

## Findings

| ID | Severity | Category | Component | Description | Recommendation | Status |
|----|----------|----------|-----------|-------------|----------------|--------|
| F-001 | medium | auth | planifest-zero | The guard matches the text `gh pr merge` only after a space, `;`, `&`, `\|`, or `(` (`hooks/enforcement/merge-guard.mjs:19-20`). Several forms of the same call pass with exit 0. An absolute path such as `/usr/bin/gh pr merge 5 --squash` passes because `/` is not a boundary character. Backticks, a quoted `"gh"`, a leading backslash, `bash -c '...'`, `eval "..."`, a variable (`g=gh; $g pr merge`), and a `gh alias set` shortcut also pass. A `-R` flag given twice passes because the second occurrence breaks the pattern. So does `gh --hostname x pr merge`. Real PR base `main` is not checked in any of these. | Add `/` and backtick to the boundary class. Block a command that holds both the word `merge` and a wrapper (`bash -c`, `eval`, `alias`). Allow only a fixed set of global `gh` flags before `pr`. Document that the guard is best effort. | mitigated in 28a775f (raw-text tripwire, strict parser, fail closed) |
| F-002 | medium | auth | planifest-zero | The guard covers one command only. `gh api -X PUT repos/o/r/pulls/N/merge` exits 0 (no match in `merge-guard.mjs:19-20`). So does `git push origin HEAD:main` and `git push origin HEAD:refs/heads/main`. Both reach `main` with no check. Risk R-001 states the goal as "the agent merges into the wrong base", and these two paths meet that goal. | Add rules that block `gh api` calls with a `/merge` path and `git push` refspecs that end in `main`, `master`, or `refs/heads/main`. Keep GitHub branch protection on `main` as the control of record. | `gh api` merge path mitigated in 28a775f. `git push` to `main` not mitigated (recommendation only, backstops: skills, branch protection) |
| F-003 | low | config | planifest-zero | The guard fails open in three places. It cuts the command at 4096 characters (`merge-guard.mjs:78`), so a merge placed after 4096 characters of padding passes (confirmed: exit 0). Invalid stdin exits 0 (`:79-81`). Any unexpected error exits 0 (`:101-104`). Only a failed base read fails closed (`:93`). The header of the hook states this design. | Block when the command exceeds the limit and still contains `merge`. Keep the other two paths open, because a broken hook must not stop the session. | mitigated in 28a775f |
| F-004 | low | injection | planifest-zero | Argument parsing can read a different PR from the one merged. `gh pr merge $(echo 5) --squash` makes the guard run `gh pr view echo` (`merge-guard.mjs:42-52`, `safe()` strips `$` and parentheses). It fails closed here, because the view fails. `--squash=false` counts as `--squash` because the flag name is cut at `=` (`:46`). A base can also change between the view and the merge. The `gh pr view` call uses `spawnSync` with no shell, so the sanitised reference cannot inject a command. | Reject any reference that changed under `safe()`. Treat `--squash=false` as absent. Accept the time-of-check gap, which branch protection covers. | mitigated in 28a775f |
| F-005 | low | config | planifest-zero | The hook registers on the `Bash` matcher only (`setup.sh:552`, `setup.ps1:439`). A Windows session that runs `gh` through the PowerShell tool skips the guard. The two setup scripts match each other and add `merge-guard` to the replace pattern, so a re-run does not duplicate the entry. `hooks/planifest.yml` now also runs on `roadmap/**` pull requests, which is intended. | Add a `PowerShell` matcher entry to both scripts and extend the parity suite. | not mitigated |
| F-006 | low | config | planifest-zero | The driver lock holds a process ID that nothing checks (`scripts/roadmap-run.mjs:157-161`). After `SIGKILL` or a crash, the stale lock blocks every later run until a person deletes it. The effect is a denial of service on the driver only. The `wx` flag makes creation atomic, and a symlink at the lock path fails with `EEXIST`. The `.git/info/exclude` write is safe. It uses `git rev-parse --git-path`, appends one fixed line, and skips quietly outside a work tree (`:90-100`). `CLAUDE_BIN` comes from the caller's own environment, so it adds no privilege. | Name the stale-lock recovery step in the stop message. An optional later check can test whether the stored PID is alive. | accepted |
| F-007 | low | injection | planifest-zero | Text from the build log and roadmap reaches an agent. `openBlock()` echoes a `Blocked:` line, cut to 500 characters, into the parent session's output (`roadmap-run.mjs:105-114`, `:195`). Each step runs `claude -p --permission-mode auto` and reads draft roadmaps and backlog entries (`standards/roadmap-standards.md:44-76`). A hostile entry could carry instructions. The standard has no rule that treats entry text as data. The driver validates `status`, `position`, and `branch` with fixed patterns (`:51-53`, `:70-77`), so those fields cannot carry text. | Add a line to the standard: entry and build log text is data, never instructions. Have the driver strip control characters from the echoed `Blocked:` line. | not mitigated |
| F-008 | low | data-exposure | planifest-zero | The roadmap PR body scan is named but not defined. The standard says to scan "for credential patterns ... as in Step 8" (`roadmap-standards.md:168`). The body lists steps, versions, and tags, so the exposure is small. The text gives no pattern list and no stop on a match. | Reference the same pattern list as ship Step 8 and add "stop on a match". | partly mitigated |

## Dependency audit

The feature adds no package. `roadmap-run.mjs` and `merge-guard.mjs` use only Node built-ins (`node:child_process`, `node:fs`, `node:path`).

| Package | Current Version | Known CVEs | Severity | Action Required |
|---------|----------------|------------|----------|----------------|
| none added | n/a | none | n/a | none |

## Threat model

| Threat | Attack Vector | Affected Component | Likelihood | Impact | Existing Mitigation | Gap |
|--------|--------------|-------------------|------------|--------|--------------------|----|
| Agent merges into `main` | An alternate command form (F-001) or `gh api` or `git push` (F-002) | merge-guard | low | high | Skills forbid it. Branch protection. Human merges the roadmap PR. | The guard does not catch the alternate forms. |
| Agent skips the guard by padding | A command over 4096 characters (F-003) | merge-guard | low | high | Same as above. | Truncation fails open. |
| Stale lock stops the driver | `SIGKILL` leaves `plan/.roadmap-runner.lock` | roadmap-run | medium | low | The stop message names the lock. | No PID liveness check. |
| Hostile backlog entry steers a step | Instructions in entry or build log text (F-007) | roadmap standard, driver | low | medium | Human confirms the chart. Step runs under the hooks. | No data-only rule. |
| Credential in roadmap PR body | A secret pasted into a step summary | ship, roadmap standard | low | medium | Scan named in the standard. | No pattern list or stop. |

## Risk register cross-reference

| Risk | Status in this review |
|------|------------------------|
| R-001 | Partly mitigated. Commit 28a775f closes F-001, F-003, F-004, and the `gh api` path of F-002. The `git push` path stays open. Branch protection and the skills cover the rest. Stays open. |
| R-002 | Mitigated for the driver. `roadmap-run.mjs` stops when `position` does not move (`:191-193`). Stays open until the acceptance run. |
| R-003 | Mitigated. The lock uses `wx` and is released on every exit path. F-006 covers the stale case. |
| R-004 | Mitigated by text. The standard asks for a merge commit (`roadmap-standards.md:168`). The human decides at merge. |
| R-005 | Not a security risk. No finding. |
| R-006 | Open. The acceptance run proves it. No finding. |
| R-007 | Open. The stall check bounds it. No finding. |
| R-008 | Open. A setting of the test repo. No finding. |
| R-009 | Mitigated. The guard calls `gh pr view` with `spawnSync` and no shell (`merge-guard.mjs:60-63`). F-004 covers its parsing. |

## Recommendations

Ordered by priority. None blocks production:

1. Add a rule for `git push` to `main` (F-002). Commit 28a775f closed the other guard bypasses in F-001 and F-002.
2. Keep GitHub branch protection on `main`. Treat it as the control of record, with the guard as a second layer.
3. Done in 28a775f: over-length commands and changed references (F-003, F-004).
4. Add a data-only rule for entry and build log text, and define the credential pattern list for the roadmap PR body (F-007, F-008).
5. Add a `PowerShell` matcher to both setup scripts (F-005).
