# Changelog (0000170-story-mapping-and-gherkin, 25 Oct 2026)

**Feature:** story-mapping-and-gherkin
**Version:** 0.15.0
**PR:** pending

## What changed

P1 now maps user stories before it writes requirements, and every acceptance criterion uses Gherkin steps. The release adds no dependency.

- req-001: the plan skill runs a story mapping pass first. It writes `plan/current/story-map.md` from the new `templates/story-map.template.md`. A gap the brief states or implies becomes a story. Any other gap goes out of scope.
- req-002: the requirement template writes each criterion as one checkbox line with `Given`, `When`, and `Then` bullets under it. The limit of three counts checkbox lines.
- req-003: `scripts/consistency-check.mjs` reports a criterion that lacks a step or holds steps out of order, with the file and criterion.
- req-004: the consistency check reports a plan with requirements but no story map. It also reports a story missing from the map and a mapped requirement with no file.
- req-005: `ratchet-check` guards each Gherkin step line, so a loop edit that removes or rewords one exits 2. The 0000016 governance fixtures now use Gherkin criteria.

## Why

Nothing checked the user stories for gaps, so a story the brief missed never became a requirement. Free-text criteria also kept tests from mapping to them line by line.

## Deviations

None. P2 also reworded backlog entry 0000175, because it used a word the pack wording test bans.

## Validation results

- 143 feature and 19 regression Bash suites pass under macOS Bash 3.2 with `env -i`. CI runs the PowerShell suites.
- 15 acceptance criteria verified by execution.
- Security review: overall low, with no critical or high findings. Backlog 0000176 holds the two low findings about uncapped printed lines.

## Skipped phases

None
