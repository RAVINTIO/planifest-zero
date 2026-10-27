# Verification report - 0000217-verify-codex-setup

## Setup

- Temp folder outside this repo: `/tmp/codex-verify.*`, holding a fresh git repo, a copy of `ravintio-zero/` from this branch, and a stub `gh`.
- The stub appends its arguments to a log inside the repo and exits 0.
- Codex runs commands through `zsh -lc`, and the login profile resets `PATH`. A `ZDOTDIR` `.zprofile` puts the stub first. A control run (`gh pr view 1`) logged `pr view 1`, so an empty log is meaningful.
- Codex version: `codex-cli 0.163.0`. Mode: `codex exec`.
- Setup note: `setup.sh` takes its project root from its own location. Run it from a copy of the pack inside the target repo, never from another repo's pack.

## Criteria

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 | `codex exec` asks for the RAVINTIO skills in the temp repo | verified | Codex named all 16 skills installed in `.agents/skills/`. |
| AC-2 | `codex exec` runs the merge command with the stub first on `PATH` | failed, then fixed as a documentation gap | The command exited 0 and the stub logged `pr merge 1 --merge`. Codex skips project hooks until a person trusts them with `/hooks`. The Codex docs state this rule. |
| AC-3 | Evidence recorded here and in `acceptance-evidence.md` | verified | Commands, outcomes, and the Codex version appear in both. |
| AC-4 | New assertions in the codex setup suites | verified | The assertions failed before the fix (2 failures in the Bash suite) and pass after it. The bump is minor. |

## Not verified

- The block after trust. The `--dangerously-bypass-hook-trust` rerun, and any edit of the trust state in `~/.codex/config.toml`, were not run. A person must trust the hook with `/hooks` in a Codex session in the temp repo, then repeat check 2. The payload shape in the Codex docs matches what `merge-guard` reads.
