# Verification Report - 0000192-rename-runner-lock-and-archive

## Setup

Each check ran `ravintio-zero/scripts/initiative-run.mjs` in a scratch git repo with a stub `claude` on `PATH`. The stub records whether the lock exists, then archives the one-step initiative in the form under test. No real `claude` session ran. The scratch repos were deleted afterwards.

## Results

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| REQ-001 AC-1 | Ran the driver to delivery | verified | The stub saw `plan/.initiative-runner.lock` during the step. The lock was gone after exit 0. |
| REQ-001 AC-2 | Pre-created the lock with `other`, then ran the driver | verified | Exit 1 with `I-C Run: Blocked: plan/.initiative-runner.lock exists, another driver may be running`. The lock still held `other`, and the stub never ran. |
| REQ-001 AC-3 | Read `.git/info/exclude` after a run | verified | It held `plan/.initiative-runner.lock` once. `test-0000043-req-007` (d) covers the second run. |
| REQ-002 AC-1 | Read I-E Delivery in `ravintio-zero/standards/roadmap-standards.md` | verified | Step 1 names `plan/_archive/{id}-{slug}-initiative-{date}/`. |
| REQ-002 AC-2 | Stub archived to the `-initiative-` form | verified | Exit 0 and `I-E Delivery: Complete: initiative 0000050-demo archived, driver done`. |
| REQ-002 AC-3 | Stub archived to the `-roadmap-` form | verified | Exit 0 and the same `I-E Delivery: Complete:` line. |
| REQ-003 AC-1 | Ran `test-0000189-req-007-old-name-guard.sh` on the repo | verified | 0 old names outside the allowlist. |
| REQ-003 AC-2 | The guard's planted-name checks | verified | Both planted old names fail with file and line. A real archive folder name passes. |

No criterion is `not-verifiable`.
