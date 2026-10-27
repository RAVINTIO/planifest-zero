# Risk Register - Codex support

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0
**Overall Risk Level:** medium

## Risks

| ID | Category | Description | Likelihood | Impact | Mitigation | Status |
|----|----------|------------|------------|--------|-----------|--------|
| R-001 | technical | The Codex hook contract changes | medium | low | `AGENTS.md` repeats every rule that a hook enforces. | open |
| R-002 | operational | A user doesn't trust the project hooks in Codex, so none run | medium | medium | Setup prints the `/hooks` review step and the fallback list. | open |
| R-003 | technical | Shared setup changes regress the Claude Code install | low | high | The existing setup suites run unchanged and a test compares the Claude Code output. | open |
| R-004 | security | Hook install writes outside the project | low | high | Setup writes only to fixed relative paths under the project root. | open |

## Assumptions Logged as Risks

| ID | Assumption | Impact if Wrong | Status |
|----|-----------|----------------|--------|
| A-001 | `.codex/hooks.json` follows the shape in the Codex docs | Codex ignores the file and `AGENTS.md` still states the rule | open |
| A-002 | Exit 2 with the reason on stderr blocks a `Bash` call in Codex | `merge-guard` does not block and the merge rule stays in `AGENTS.md` | open |
