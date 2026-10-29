# Verification report - 0000253-refresh-setup

Method: ran the commands and inspected the files they produced.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| The command run is exactly `ravintio-zero/setup.sh claude-code --strict-orchestrator` | CLI: compared the attempted command in the marker with the command in override `custom-006` | verified | Marker `attemptedCommand` and override text are identical. Setup exited 0 and printed `Setup complete.` |
| `.claude/skills/` matches `ravintio-zero/skills/` | Side effect: `diff -rq` per skill | verified | 16 pack skills present. Three differ (`ravintio-orchestrator`, `ravintio-refresh-setup`, `ravintio-ship`) by appended override text only, with 0 removed lines. Two capability skills added (`gutd`, `delete-redundant-branches`). |
| `CLAUDE.md` is 6,000 bytes or fewer, with every override in force | Side effect: `wc -c CLAUDE.md` | verified | 4,701 bytes. Setup printed `Appending override instructions from ravintio-overrides/instructions/`. |
| Marker records completion | Side effect: read `.claude/.ravintio-setup-flags` | verified | `attemptStatus: "completed"` |

The step 15 criterion in `initiative.md` has the same two checks and both pass.
