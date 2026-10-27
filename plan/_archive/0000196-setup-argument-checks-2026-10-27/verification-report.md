# Verification report - 0000196-setup-argument-checks

**Method:** each check ran `setup.sh` in a fresh temp git repo that held a copy of the pack. The PowerShell suites ran `setup.ps1` under local `pwsh`.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 unknown tool | `setup.sh codex` | verified | Exit 1, `Unknown tool: codex`, tree holds only `.git` and `ravintio-zero`, `core.hooksPath` unset |
| REQ-001 AC-2 missing tool | `setup.sh` with no argument | verified | Exit 0, usage text, tree and `core.hooksPath` unchanged |
| REQ-001 AC-3 valid tool | `test-0000196-req-001` suites, both shells | verified | Exit 0, `core.hooksPath` is `ravintio-zero/hooks` |
| REQ-002 AC-1 named error | `setup.sh claude-code --context-mode-mcp` | verified | Exit 1, error names the flag, says it does nothing, says to remove it |
| REQ-002 AC-2 repo unchanged | same run | verified | Tree and `core.hooksPath` unchanged |
| REQ-002 AC-3 value hidden | spaced and `=` forms of `--backend-url` with a distinctive URL | verified | Exit 1, zero occurrences of the URL in output |
| REQ-003 AC-1 to AC-3 refresh skill | structural suite over `SKILL.md` Step 3 | not-verifiable by execution | The skill is Markdown that an agent follows. The suite checks its text only. |

**Full suite:** 170 feature suites and 19 regression suites pass.
