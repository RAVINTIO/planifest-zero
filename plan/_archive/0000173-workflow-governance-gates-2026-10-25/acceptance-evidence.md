# Acceptance evidence - 0000173-workflow-governance-gates

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 4 requirements, 12 criteria. Each requirement has a suite named for it: `test-0000173-req-001-workflow-metrics-script.sh`, `-req-002-thresholds-gate.sh`, `-req-003-metric-markers.sh`, and `-req-004-ship-governance-report.sh`. |
| Full Bash suite, local Bash 3.2 under `env -i` | 155 feature and 19 regression suites pass, on the tree after the P3 fix |
| Self-correction cycles | 0. P3 changed code once, to mitigate three low security findings. |

## Execution evidence

All 12 criteria are `verified`. None failed, and none are `not-verifiable`. See `verification-report.md`.

- `workflow-metrics.mjs` ran on fixture run folders. Known markers gave the expected counts, and two breaches exited 0.
- Prose and fenced `Blocked:` mentions counted 0.
- A folder with no build log exited 1 and named the path on stderr.
- `--standard` with `blocked-stops` at 5 turned the breach into `ok`. A standard with no `gate-corrections` row exited 1 and named the key.
- On the 0000172 archive, the script exits 0 with every value 0. That run predates the markers.
- The skill text cites are `ravintio-implement/SKILL.md:76`, `ravintio-validate-and-accept/SKILL.md:43`, `orchestrator-mid-pipeline-changes.md:21`, `ravintio-orchestrator/SKILL.md:221`, and ship Steps 5 and 9.

## Security

There are no critical, high, or medium findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 a free-text `not measured` reason could publish a local path in the PR body | Low | Mitigated in commit 4c38b8f. The reason is a fixed phrase. |
| S-002 the archive folder sat unquoted in the ship command | Low | Mitigated in commit 4c38b8f. |
| S-003 the script read any entry named `loop-state-*.md`, including a FIFO or a folder | Low | Mitigated in commit 4c38b8f. It reads regular files only. |
| S-004 a copied line that starts with a marker inflates a count | Low | Accepted. The gate never blocks. |
| S-005 to S-008 | Informational | Accepted. See `security-report.md`. |

No dependency, network call, hook, or credential joined the pack. The new script uses Node built-in modules only.

## Deviations

- The orchestrator holds a short `Gate revised: P{N}` line, to fit the 0000151 size budget. The full form lives in the governance standard. See REQ-003.
- The governance standard lists marker forms as bullets. A tie on rework names the lower requirement id. See REQ-001.
