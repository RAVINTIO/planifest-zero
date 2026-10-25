# Acceptance evidence - 0000169-release-hygiene

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 6 requirements, 18 criteria, each with a covering test |
| Bash suites, local Bash 3.2 under `env -i` | 125 feature and 19 regression suites pass |
| PowerShell suites | 13 skipped locally because `pwsh` is absent. CI runs them on this PR. |
| Self-correction cycles | 1 in P3 |

Cycle 1 pinned the checkout in the template's `release-tag` job (S-001).

## Security

There are no critical or high findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 floating checkout ref in the template's write-token job | Medium | Fixed: pinned to the repo's SHA |
| S-002 floating `@v4` refs in read-only jobs | Low | Open, predates this run |
| S-003 `release-tag` checkout keeps credentials | Low | Accepted. `git push` needs them, and a comment says so. |
| S-004 `github.base_ref` inside `run:` | Low | Open, predates this run |
| S-005 anyone who can push to `main` can mint a tag | Low | Accepted, same power as a push |
| S-006 a PR body over 128 KB fails the check step | Low | Accepted, it fails closed |
| S-007 setup writes the `attribution` key when absent | Low | Accepted, a set value is never overwritten |

## Execution evidence

- `check-attribution.mjs`: each host line and each hook pattern exits 1. Clean prose, an empty file, and stdin exit 0. Bad input exits 2. No input text reached stdout or stderr.
- `commit-msg` hook: both new host lines exit 1. A clean message that mentions attribution exits 0.
- `validate-branch` step, run from both workflow files: an empty or clean body exits 0, and an attribution body exits 1. A body with command substitution and backticks ran nothing.
- Both workflow files parse. Only `release-tag` holds `contents: write`, and it runs only on a push to `main` or `master`.
- `setup.sh` in a temp project: it adds empty `commit` and `pr` strings when absent, keeps a set value, and a rerun is byte-identical.
- `release-tag.mjs` against a temp repo with a bare `origin`: it creates and pushes the tag, skips an existing tag locally or on `origin`, and exits 1 on a bad version or a failed push.
- Not verifiable locally: the PowerShell side of REQ-004. CI covers it.
- Open until the first merge to `main`: whether the host honours empty attribution strings (R-004), and whether the CI token can push a tag (R-005).

## Deviation

`test-0000037-req-003` pinned an empty flags array in `plan/state/claude-code.md`. Roadmap activation recorded the human's `--strict-orchestrator`. The suite now checks the array's shape and runs setup with the tracked flags.
