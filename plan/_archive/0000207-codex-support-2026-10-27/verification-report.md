# Verification report - 0000207-codex-support

Setup ran for `codex` in a scratch project and the wired hook command ran against two payloads. Each criterion also ran as a test suite.

| Requirement | Criterion | Method | Outcome | Observation |
|-------------|-----------|--------|---------|-------------|
| REQ-001 | AC-1 setup accepts codex | `setup.sh codex` in a scratch project | verified | Exit 0 and `plan/state/codex.md` written |
| REQ-001 | AC-2 an unknown tool fails | `test-0000196-req-001-tool-check-first` (Bash and PowerShell) | verified | Exit 1, `Valid tools:` lists `codex`, tree unchanged |
| REQ-001 | AC-3 the refresh skill lists codex | `test-0000207-req-004-codex-ci-check.sh` | verified | 9 passed, 0 failed |
| REQ-002 | AC-1 AGENTS.md is written | `test-0000207-req-001-003-codex-setup.sh` | verified | 29 passed, 0 failed |
| REQ-002 | AC-2 skills are installed | Same suite and the scratch run | verified | `.agents/skills/` holds 16 entries and a manifest |
| REQ-002 | AC-3 no Claude Code files appear | Same suite | verified | No `CLAUDE.md` and no `.claude/` |
| REQ-003 | AC-1 merge-guard is wired | Scratch run, then the wired command | verified | A merge without `--squash` exits 2 with the reason on stderr. `ls` exits 0. A subdirectory run exits 0. |
| REQ-003 | AC-2 the report names both lists | Scratch run output | verified | Active and fallback lists and the `/hooks` line printed |
| REQ-003 | AC-3 invalid JSON stops setup | Both setup suites | verified | Exit 1, fixed line, file unchanged |
| REQ-004 | AC-1 the Bash CI test exists | `test-0000207-req-004-codex-ci-check.sh` | verified | The runners pick up the suite and CI runs the runner |
| REQ-004 | AC-2 the PowerShell CI test exists | `test-0000207-req-001-003-codex-setup.ps1` under `pwsh` 7.6 | verified | 28 passed, 0 failed |
| REQ-004 | AC-3 Claude Code is unchanged | Both setup suites | verified | `CLAUDE.md` and `.claude/settings.json` exist, `AGENTS.md` does not |

Not run: Codex itself. The hooks.json shape and the exit 2 contract come from the Codex docs. No Codex program was available to confirm that it loads the file.
