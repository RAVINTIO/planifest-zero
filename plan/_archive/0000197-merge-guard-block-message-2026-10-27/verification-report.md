# Verification report - 0000197-merge-guard-block-message

**Method:** each check fed a JSON payload to `ravintio-zero/hooks/enforcement/merge-guard.mjs` on stdin, as Claude Code does. A stub `gh` on `PATH` answered `gh pr view`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 heredoc naming the merge command | Payload with a heredoc line that names the merge command, under 4096 characters | verified | Exit 2. The message says the command names a merge in text and says to use the Write tool. |
| REQ-001 AC-2 command over 4096 characters | Same heredoc padded past 4096 characters | verified | Exit 2. The message names the length and the Write tool. |
| REQ-001 AC-3 block set unchanged | `test-0000043-req-006-merge-guard-hook.sh` and the new suite | verified | 87 existing assertions and 11 new assertions pass. A plain squash merge into `initiative/*` exits 0. Two merge calls, a quoted string, and a no-flag call exit 2. |

**Full suite:** 171 feature suites and 19 regression suites pass.
