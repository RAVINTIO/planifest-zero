# Verification Report - 0000205-initiative-skill

Run in the repo root with Node and Bash. Nothing was started that needs teardown.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| Skill exists, owns I-A, I-B, I-E, under 120 lines | Counted lines and read headings | verified | 85 lines, `test-0000205-req-004` passes 17 of 17 |
| Orchestrator resumes no initiative | Read Resume Detection | verified | Step 3 says it never resumes an initiative |
| Strict hook silent on either ack | Hook run with each ack file | verified | `test-0000205-req-002` passes 32 of 32 |
| Strict hook names the initiative ack | Ran the presence hook with the lock held | verified | Output names `plan/.initiative-ack` |
| Auto-trigger picks the skill | Hook run per state | verified | Silent while the orchestrator sentinel exists, as designed. Suite covers the other states |
| Watch script events, stale, heartbeat | Ran `initiative-watch.mjs --once` on this repo | verified | Printed a stale line and a heartbeat for step 10, phase P2 |
| Watch script is read-only | Test hashes files and `git status` | verified | `test-0000205-req-003` passes 29 of 29 |
| Archived block stops the driver | Stub step session | verified | `test-0000205-req-001` passes 11 of 11 |
| Position moves only after the merge | Stub step session on a branch | verified | Same suite |
| Environment keeps subagents running | Stub writes its environment | verified | Same suite |
| Final report names each step | Stub merges steps 1 and 2 | verified | `test-0000205-req-006` passes 8 of 8 |
| Docs hold the three parts | Read both documents | verified | `test-0000205-req-005` passes 10 of 10 and `req-007` passes 10 of 10 |

Full suite: 192 passed, 1 failed. The failure is `test-0000151-req-014 (c)`. It fails on `main` too, because the ignored `.claude/skills/` copies of `ravintio-plan` and `ravintio-implement` are older than the pack source. Step 13 reruns setup and clears it.
