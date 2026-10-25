# Acceptance evidence - 0000170-story-mapping-and-gherkin

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 5 requirements, 15 criteria, each with a covering test named for its requirement |
| Bash suites, local Bash 3.2 under `env -i` | 143 feature and 19 regression suites pass |
| PowerShell suites | Skipped locally because `pwsh` is absent. CI runs them on this PR. |
| Self-correction cycles | 0 in P3 |

P2 fixed one suite failure before P3. Backlog entry 0000175 used a word the pack wording test bans, so the entry now names "the pack".

## Security

There are no critical or high findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 the ratchet prints each removed line with no length cap | Low | Open, filed as backlog 0000176 |
| S-002 a story map finding echoes the whole row label | Low | Open, filed as backlog 0000176 |
| S-003 both programs read whole plan files with no size limit | Low | Accepted. The plan owner controls the files, and the hook fails open. |
| S-004 the new step-line regex | Informational | Accepted. It is anchored, and a 40,000-character line ran in 0.043 s. |
| S-005 `new RegExp` takes only a `US-\d+` capture | Informational | Accepted |
| S-006 path handling from tool input | Informational | Accepted, unchanged by this run |

No dependency, shell call, or credential joined the pack.

## Execution evidence

- `consistency-check.mjs` on scratch plans: a criterion with no `When` step exits 1 and names the file and criterion. Steps out of order exit 1 with an "out of order" finding. Four checkbox criteria exit 1.
- The same script reports a plan with requirements but no `story-map.md`. It also reports a story missing from the map, an empty requirement cell, and a mapped requirement with no file. A clean plan and a plan with no requirements both exit 0.
- `ratchet-check.mjs` in a scratch project with an active loop: an edit that removes a `When` line exits 2 and names the removed line. An edit that adds an `And` line exits 0 with no output. With the loop `done`, the same removal exits 0.
- The plan skill and both templates hold the story mapping pass and the Gherkin criterion form (`ravintio-plan/SKILL.md:49-68`, `requirement.template.md:24-33`, `story-map.template.md:9-11`).
- Both copies of the 0000016 governance suite pass with Gherkin fixtures.

## Environment note

Run outside `env -i`, suites 0000043 req-007 and 0000151 req-006 fail locally. The roadmap driver exports `RAVINTIO_ROADMAP_MODEL` into the step session, and the tests read it. With the variable unset, both pass.
