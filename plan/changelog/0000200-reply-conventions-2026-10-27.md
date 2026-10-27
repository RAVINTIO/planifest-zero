# Changelog (0000200-reply-conventions, 27 Oct 2026)

**Feature:** reply conventions
**Version:** 0.22.0
**PR:** pending

## What changed

- The boot template holds a Reply Conventions section with the ten phase and stage prefixes, the status form, `Supervise:` for out-of-phase work, and the reporting rule.
- The reporting rule says a reply reports results, deviations, failures, and decisions, and never reports compliance with a standing rule.
- The orchestrator skill lists `Supervise:` and holds the same reporting rule.
- The plan, implement, validate-and-accept, and ship skills restate their prefix in their opening lines.
- A new `Stop` hook, `check-reply-prefix.mjs`, warns when a reply in an active run lacks a valid prefix. It logs each miss to `plan/.prefix-misses.log`, adds that file to `.git/info/exclude`, and always exits 0.
- `setup.sh` and `setup.ps1` wire the hook, and keep any `Stop` entry the user added.
- The pipeline reference, the project operations guide, the architecture docs, and `component.yml` name the hook.

## Why

Replies lost their prefixes after the harness compacted a supervising session, and replies reported routine compliance with standing rules. Backlog entries 0000181 and 0000209 asked for both fixes.

## Deviations

- Seven existing suites and one fixture asserted text the change altered, and now match it. A `Stop` key no longer counts as a foreign event in the non-array suites.
- The size caps in the 0151 req-011 suites rose to 27,700 bytes for `SKILL.md` and 37,800 bytes for `CLAUDE.md` plus `SKILL.md`. The combined cap covers the section that step 13 installs into `CLAUDE.md`.
- Verification by execution found that the miss log was not excluded from git. The hook now adds it to `.git/info/exclude`.
- The installed copies under `.claude/` and `CLAUDE.md` keep the old rules until step 13 of initiative 0000195 reruns setup. The new hook stays unwired in this repo until then.
- The hook starts as a warning. Hardening it waits for the miss rate in the log.

## Validation results

176 feature suites and 19 regression suites pass. The consistency check and the self-description check are clean. `setup.ps1` did not run, because the setup suites have no PowerShell runner here. A source check confirms it declares the same entry.

## Skipped phases

None.
