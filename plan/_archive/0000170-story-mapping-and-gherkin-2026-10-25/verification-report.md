# Verification report - 0000170-story-mapping-and-gherkin

All checks ran on branch `feat/0000170-story-mapping-and-gherkin` (macOS, `node`). Every fixture lived in a directory from `mktemp -d`, and I removed each one afterwards. No source file changed. This report is the only file added.

## Summary

| Outcome | Criteria |
|---|---|
| verified | 15 |
| failed | 0 |
| not-verifiable | 0 |

Total: 15 criteria across REQ-001 to REQ-005. Two points need a reader's attention:

- **Fixture design file.** `consistency-check.mjs` also flags a missing `design.md` Scope (check 5). Each clean fixture therefore held a `design.md` with a `## Scope` heading. Without it the exit code is 1 for a reason unrelated to this feature.
- **Suite working directory.** The 0000010 suite uses repo-root paths. Run from `ravintio-zero/`, it fails with missing-file errors. Run from the repo root, it passes.

## Outcome per criterion

| REQ | AC | Outcome | Method |
|---|---|---|---|
| REQ-001 | AC-1 | verified | Inspection of the template |
| REQ-001 | AC-2 | verified | Inspection of the plan skill |
| REQ-001 | AC-3 | verified | Inspection of the plan skill |
| REQ-002 | AC-1 | verified | Inspection of the requirement template |
| REQ-002 | AC-2 | verified | Inspection of the plan skill |
| REQ-002 | AC-3 | verified | Ran the 0000010 suite |
| REQ-003 | AC-1 | verified | Ran the consistency check on a fixture |
| REQ-003 | AC-2 | verified | Ran the consistency check on a fixture |
| REQ-003 | AC-3 | verified | Ran the check on a clean fixture and read the script header |
| REQ-004 | AC-1 | verified | Ran the consistency check on a fixture |
| REQ-004 | AC-2 | verified | Ran the consistency check on a fixture |
| REQ-004 | AC-3 | verified | Ran the check on two fixtures |
| REQ-005 | AC-1 | verified | Piped an Edit payload into the hook |
| REQ-005 | AC-2 | verified | Piped an Edit payload into the hook |
| REQ-005 | AC-3 | verified | Grepped the fixtures and ran both 0000016 suites |

## Text criteria (REQ-001, REQ-002)

Method: inspection of each file.

- REQ-001 AC-1: `ravintio-zero/templates/story-map.template.md:9` holds `## Backbone`. Line 11 holds the header row `| Activity | Step | Story | Requirement |`.
- REQ-001 AC-2: `ravintio-zero/skills/ravintio-plan/SKILL.md:4` lists `story-map.template.md` first in `bundle_templates`. Line 31 of the artifact table lists `plan/current/story-map.md`.
- REQ-001 AC-3: the `## Story mapping pass` section starts at `SKILL.md:49`. Line 51 reads "Run this pass before you write any requirement file." Line 59 names `gap: added as US-nnn` and line 60 names `gap: out of scope`. Line 62 reads "In a gated run, ask the human about a gap of the second kind. Ask one question at a time."
- REQ-002 AC-1: `ravintio-zero/templates/requirement.template.md:24` opens `## Acceptance Criteria`. Lines 26 and 30 hold `- [ ] AC-{n}: {short name}`. Lines 27-29 and 31-33 hold indented `Given`, `When`, and `Then` bullets.
- REQ-002 AC-2: `SKILL.md:68` names the `- [ ] AC-{n}: {short name}` format and says `And` and `But` continue the step above. It also says "The limit of three criteria counts checkbox lines, not steps."
- REQ-002 AC-3: see the suite run below. The template still holds `## Functional Requirements` (line 20) and `## Acceptance Criteria` (line 24).

## consistency-check.mjs (REQ-003, REQ-004)

Each case ran `node ravintio-zero/scripts/consistency-check.mjs <fixture-dir>` from the repo root. Each fixture held `requirements/req-00n-x.md`, plus `story-map.md` and `design.md` where noted.

| Case | Fixture | Exit | Relevant output |
|---|---|---|---|
| REQ-003 AC-1 | Criterion with `Given` and `Then`, no `When` | 1 | `req-001-x.md: AC-1 has no When step (Gherkin: Given, When, Then)` |
| REQ-003 AC-2 | Criterion lists `Then` before `When` | 1 | `req-001-x.md: AC-1 steps are out of order (Gherkin: Given, When, Then)` |
| REQ-003 AC-3 | Two criteria, `And` and `But` continuation, `design.md` with `## Scope`, valid map | 0 | `consistency-check: clean` |
| REQ-003 AC-3 (limit) | Same, with four checkbox lines | 1 | `req-001-x.md: 4 acceptance criteria (max 3 per requirement - split the story)` |
| REQ-004 AC-1 | Requirement files, no `story-map.md` | 1 | `story-map.md: missing - requirement files exist but no story map maps them` |
| REQ-004 AC-2 | Map with an empty cell, a `REQ-009` cell, and `US-002` absent | 1 | Three findings, listed below |
| REQ-004 AC-3 (clean) | Map with `REQ-001` and `gap: out of scope` cells | 0 | `consistency-check: clean` |
| REQ-004 AC-3 (empty) | `requirements/` empty, map present, `design.md` present | 0 | `consistency-check: clean` |

REQ-004 AC-2 produced these three story-map findings:

- `story-map.md: US-002 (Source of req-002-x.md) does not appear in the story map`
- `story-map.md: row "empty step" has an empty Requirement cell`
- `story-map.md: row "ghost" names REQ-009 but no req-009-*.md file exists`

Before I added `design.md` to the clean fixtures, each run also printed `design.md: missing - nothing declares component Scope/paths` and exited 1. That finding belongs to check 5, not to this feature.

REQ-003 AC-3 header: `consistency-check.mjs` lines 20-23 document check 6, "Gherkin criteria (feature 0000170, ADR-003)". Lines 24-28 document check 7, the story map.

## ratchet-check.mjs (REQ-005 AC-1, AC-2)

The scratch project held `plan/current/loop-state-x.md` with `status: active` and `plan/current/requirements/req-001-x.md` with one `Given`, `When`, `Then` criterion. Each run piped a JSON payload `{"tool_name":"Edit","tool_input":{"file_path":...,"old_string":...,"new_string":...}}` into `node ravintio-zero/hooks/enforcement/ratchet-check.mjs` with the scratch project as the working directory. The hook takes its project root from `process.cwd()`.

| Case | Edit | Exit | Observed |
|---|---|---|---|
| AC-1 | Remove the `When` line | 2 | stderr: `Ratchet: this write weakens plan/current/requirements/req-001-x.md while a loop is active.` then `  removed: "When the action runs"` |
| AC-2 | Add an `And` line after `Then` | 0 | stderr and stdout empty |
| Control | Remove the `When` line with the loop state set to `done` | 0 | stderr and stdout empty |

The stdout on exit 2 held only the JSON deny object. The stderr named the removed line and no other file content.

## Fixtures and suites (REQ-002 AC-3, REQ-005 AC-3)

Each command ran from the repo root as `env -i HOME=$HOME PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin bash <suite>`.

| Suite | Exit | Result line |
|---|---|---|
| `ravintio-zero/tests/test-0000010-pack-quality-improvements.sh` | 0 | `All tests passed.` |
| `ravintio-zero/tests/test-0000016-pipeline-governance.sh` | 0 | `Results: 66 passed, 0 failed` |
| `ravintio-zero/tests/regression/test-0000016-pipeline-governance.sh` | 0 | `Results: 66 passed, 0 failed` |

A grep of both 0000016 suites shows the same fixtures. The req-014 fixtures hold `Given`, `When`, and `Then` lines at lines 178-184. The req-018 fixtures hold them at lines 261-267 and in the `WEAK` and `STRONG` strings at lines 281 and 286.

## Failures

None.
