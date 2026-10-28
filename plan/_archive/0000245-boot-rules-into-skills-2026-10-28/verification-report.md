# Verification report - 0000245-boot-rules-into-skills

**Method.** I copied `ravintio-zero/` and `ravintio-overrides/` into a temporary git project and ran `bash ravintio-zero/setup.sh claude-code` twice. The test suites run the same setup against fixtures.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 reference file holds the rules | `test-0000245-req-001` | verified | 29 of 29 checks pass |
| REQ-001 AC-2 boot files point to it | `test-0000245-req-001` | verified | each template holds the path, and neither holds the old list |
| REQ-001 AC-3 block messages name it | Triggered each blocking hook with a fixture | verified | `gate-write`, `ratchet-check`, `merge-guard`, `em-dash-guard` exit 2. `commit-msg` exits 1. Each message names the file |
| REQ-002 AC-1 targeted override lands once | Ran setup twice | verified | The ship, refresh-setup, and orchestrator skills each hold one marker block. The boot file holds none of the three rules |
| REQ-002 AC-2 bad target falls back | `test-0000245-req-002` | verified | Five bad targets warn and land in the boot file |
| REQ-002 AC-3 untargeted override unchanged | `test-0000245-req-002` | verified | The boot file holds it |
| REQ-003 AC-1 gutd installs | Ran setup | verified | `.claude/skills/gutd/SKILL.md` exists and its description names GUTD |
| REQ-003 AC-2 rules survive | `test-0000245-req-003-004` | verified | 16 of 16 checks pass |
| REQ-004 AC-1 size cap | `wc -c` on the generated file | verified | 4,701 bytes against a 6,000 byte cap |
| REQ-004 AC-2 appended blocks ignored | `test-0000151-req-014` | verified | 33 of 33 checks pass |

**Not verifiable.** The PowerShell setup ran one functional check under `pwsh`, reported by the subagent. The suites for it run in `run-tests.sh`.

**Test run.** `run-tests.sh` ran 208 feature suites clean. Two suites, `test-0000042-req-006` and `test-0000043-req-009`, failed in the working tree. Both read `plan/.initiative-logs/step-7.log`, which is git-ignored and holds this step's own test output. Both pass on a clean `git archive` of `HEAD`. Regression suite: 19 of 19.
