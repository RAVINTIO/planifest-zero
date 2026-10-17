# Changelog (0000037-self-host-on-planifest-zero, 17 Oct 2026)

**Feature:** self-host-on-planifest-zero
**Pipeline run:** P0 to P9 completed, none skipped
**PR:** https://github.com/planifest/planifest-zero/pull/12

## What Was Built

This repo now runs its own pipeline on the `planifest-zero/` it ships. The old `planifest-framework/` copy is gone, so the rename suite passes in full. Version 0.5.0.

- req-001: the `validate-telemetry-schema` CI job is gone. It was the only step that read a secret.
- req-002: `refresh-planifest-zero-dir.ps1` passes no retired flag.
- req-003: the setup record moved to `plan/state/claude-code.md`, with an empty `flags` array.
- req-004: `core.hooksPath` points at `planifest-zero/hooks`, and `git rm -r` removed the old folder.
- req-005: the push override names the ship phase, not P9.
- req-006: a `bash-suites` CI job runs `run-tests.sh` on `ubuntu-latest`, with `pwsh` required.
- req-007: `setup.sh` matches Planifest `PreToolUse` entries by module name on any matcher.
- req-008: both setup scripts warn and replace a non-array `PreToolUse` or `UserPromptSubmit` value.
- req-009: the `planifest-zero` orchestrator assumes standard-iterative mode when it's the only signal.

## Artifacts Produced

- `design.md`, `feature-brief.md`, `discovery.md`, and `build-log.md`
- `execution-plan.md`, `scope.md`, `risk-register.md`, and `domain-glossary.md`
- `requirements/req-001` to `req-009`
- `adr/ADR-001` to `ADR-004`
- `security-report.md`, `iteration-log.md`, and `recommendations.md`

## Decisions

- ADR-001: the repo self-hosts on `planifest-zero/`, and the human reinstalls after merge.
- ADR-002: the Bash suites run in CI on `ubuntu-latest`, with a pinned checkout and read-only contents.
- ADR-003: setup repairs the hook entries it owns, and warns before it replaces a non-array value.
- ADR-004: P0 states standard-iterative mode without asking when it's the only signal.

## Skipped Phases

None

## Backlog Filed

- 0000110: subagent acceleration
- 0000111: `UserPromptSubmit` filter parity
- 0000112: per-command hook filter (security finding S-001)

## After Merge

1. Run `planifest-zero/setup.sh claude-code` to reinstall `.claude/` and `CLAUDE.md` on the five-phase pipeline.
2. In every other clone, run `git config core.hooksPath planifest-zero/hooks`, or rerun setup. Otherwise git skips `commit-msg` with no error (S-004).
