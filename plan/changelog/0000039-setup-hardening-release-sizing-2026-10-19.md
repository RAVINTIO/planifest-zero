# Changelog (0000039-setup-hardening-release-sizing, 19 Oct 2026)

**Feature:** setup-hardening-release-sizing
**Version:** 0.6.0
**PR:** https://github.com/planifest/planifest-zero/pull/14

## What changed

Setup now stops cleanly on an invalid `settings.json`, removes stale single-object hooks, and keeps deep settings on Windows. Discovery sizes each release from an optional `releaseSize` in `product.yml`.

- req-001: if `settings.json` holds invalid JSON, both scripts print `! Error: {path} is not valid JSON. Fix it and rerun setup.` They exit 1 and leave the file unchanged. No file content reaches stdout or stderr.
- req-002: both scripts treat a single-object `hooks` value as a one-item array. A Planifest command goes, and a user object stays as it was.
- req-003: `setup.ps1` writes `settings.json` with `ConvertTo-Json -Depth 100`, so values deeper than 10 levels survive.
- req-004: the orchestrator skill reads `releaseSize` (`small`, `medium`, or `large`). Budgets are 4, 8, and 14 points, and `medium` is the default. Candidates score 1, 2, or 4 points by files touched. This replaces the fixed 3-story rule in the skill and both feature brief templates.
- `product.template.yml` gains a commented `releaseSize` line.
- Shared fixtures in `planifest-zero/tests/fixtures/0000039-setup-hardening/` give the `.sh` and `.ps1` suites one input each.

## Why

The 0000038 security review left three setup gaps:

- Backlog 0000113: invalid JSON printed the file's content to stderr.
- Backlog 0000114: a single-object `hooks` value kept a stale Planifest command, so the hook ran twice.
- Backlog 0000115: `setup.ps1` cut JSON deeper than 10 levels.

Backlog 0000109 recorded that no repo could change the 3-story sizing rule.

Decisions:

- ADR-001: the stack stays as it is.
- ADR-002: invalid JSON exits 1 with a fixed message.
- ADR-003: setup treats a single-object `hooks` value as an array.
- ADR-004: the release size lives in `product.yml`.

## Deviations

`setup.ps1` checks the text against strict JSON before `ConvertFrom-Json` runs. PowerShell 7 accepts trailing commas and comments, and `JSON.parse` rejects them. The check makes both scripts reject the same files. req-001 records this.

Under the new rule, this release scores 9 points against the `medium` budget of 8. The human confirmed the scope before the rule existed (R-004).

## Validation results

- CI run `39187093043`: all four jobs pass.
- The `.ps1` suite passes 36 of 36 on Windows PowerShell 5.1, PowerShell 7, and Linux.
- The local runner passes 68 feature suites and 18 regression suites.
- Execution verification: 8 of 8 acceptance criteria verified by `setup.sh` runs, file inspection, and CI.
- Security: overall Low, with no critical, high, or medium findings. 0000038 F-001, F-004, and F-005 are mitigated.
- The human accepted the build on 2026-10-19.

Backlog filed during this run:

- 0000118: `setup.sh` allowedTools parse of invalid JSON. req-001 covers it, so discard it at the next pickup.
- 0000120: some valid JSON fails `ConvertFrom-Json`, so `setup.ps1` reports it as invalid.
- 0000121: `setup.sh` accepts any valid JSON, such as an array, as the settings object (F-002).
- 0000122: the strict JSON check in `setup.ps1` slows sharply on deep nesting (F-003).

## Skipped phases

None
