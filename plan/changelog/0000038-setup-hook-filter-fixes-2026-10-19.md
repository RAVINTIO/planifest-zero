# Changelog (0000038-setup-hook-filter-fixes, 19 Oct 2026)

**Feature:** setup-hook-filter-fixes
**Version:** 0.5.1
**PR:** https://github.com/planifest/planifest-zero/pull/13

## What changed

Both setup scripts now remove Planifest hook commands one at a time. A user command that shares a hook entry with a Planifest command stays.

- req-001: `setup.sh` and `setup.ps1` remove only Planifest commands from `PreToolUse` and `UserPromptSubmit` entries. An entry with no commands left goes. A second setup run gives a byte-identical `settings.json`.
- req-002: `setup.sh` matches `UserPromptSubmit` commands by path boundary, as `setup.ps1` does. Substring and case variants such as `my-check-design-helper.sh` and `Check-Design.mjs` now stay.
- Shared fixtures in `planifest-zero/tests/fixtures/0000038-hook-filter/` give both suites one input and one expected result.
- If a `hooks` value holds a single object, `setup.sh` now keeps the entry. Before this change it exited 1 on that input.

## Why

Before this change, setup removed a whole hook entry when any command in it was a Planifest command. That deleted user commands in the same entry. Backlog 0000112 (0000037 security finding S-001) recorded the loss. Backlog 0000111 recorded that `setup.sh` matched `UserPromptSubmit` by bare substring, so it removed user scripts that `setup.ps1` kept.

Decisions:

- ADR-001: the stack stays as it is.
- ADR-002: setup filters hook entries one command at a time. This refines 0000037 ADR-003.

## Deviations

None. The single-object `hooks` behaviour came from the shared filter and matches the design. Security finding F-001 records it.

## Validation results

- CI run `39074719087`: all four jobs pass.
- The `.ps1` suite passes 32 of 32 on Windows PowerShell 5.1, PowerShell 7, and Linux.
- The local runner passes 66 feature suites and 18 regression suites.
- Execution verification: 6 of 6 acceptance criteria verified by running `setup.sh` and by CI.
- Security: overall Low, with no critical, high, or medium findings. 0000037 S-001 is mitigated.
- The human accepted the build on 2026-10-19.

Backlog filed during this run:

- 0000113: invalid JSON in `settings.json` prints its content to stderr.
- 0000114: a single-object `hooks` value keeps a stale Planifest command (F-001).
- 0000115: `setup.ps1` cuts JSON deeper than 10 levels (F-004).

Deferred: a user script with a Planifest basename in another folder is still removed. The fix needs a narrower match on the hooks folder.

## Skipped phases

None
