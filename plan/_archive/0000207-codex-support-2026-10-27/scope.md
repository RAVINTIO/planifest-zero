# Scope - Codex support

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000207-codex-support
**Version:** 0.29.0

## In Scope

- Accept `codex` in `setup.sh`, `setup.ps1`, and the refresh-setup skill.
- Add `setup/codex.sh` and `setup/codex.ps1`.
- Add a Codex boot template that setup writes to `AGENTS.md`.
- Install skills in `.agents/skills`.
- Wire `merge-guard` as a `PreToolUse` hook for `Bash` in `.codex/hooks.json`.
- Print which hooks are active and which fall back to instructions.
- Add tests and a CI step for the `codex` target.
- Update the living docs.

## Out of Scope

- Harnesses other than Codex.
- Changes to the Claude Code install.
- A Codex port of the slash-command workflows.

## Deferred

- Wiring `gate-write`, `ratchet-check`, `em-dash-guard`, `check-design`, `auto-trigger-orchestrator`, `check-orchestrator-presence`, and `check-reply-prefix` for Codex. The Codex docs don't state the `apply_patch` input shape or the context format for prompt hooks. Until a feature confirms them, each rule stays an instruction in `AGENTS.md`.
