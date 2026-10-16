# Changelog (0000033-remove-telemetry-mcp, 16 Oct 2026)

**Feature:** Remove telemetry from planifest-zero
**Pipeline run:** P0 to P9 completed. No phases skipped.
**PR:** pending

## What Was Built

`planifest-zero` no longer ships telemetry. Observability belongs to the host tool, so the framework
offers no replacement and no extension point. These changes deliver it:

- The `hooks/telemetry/` tree, the two telemetry backstop hooks, `telemetry-standards.md`, and
  `phase-enum.mjs` are deleted.
- `setup.sh` and `setup.ps1` drop the `--structured-telemetry-mcp` and `--backend-url` flags. The
  setup record and flags marker now hold `tool`, `flags`, and `writtenAt`.
- Every setup run removes the telemetry wiring an older setup left in a project:
  - hook entries in `.claude/settings.json`
  - the `.claude/telemetry-enabled` sentinel
  - the `plan/.telemetry-failures/` and `plan/.telemetry-receipts/` folders
- Skills, templates, the build log, and the docs no longer describe telemetry.
- `product.yml` keeps its top-level `id`, and discovery still stops when it is missing. The reason is
  now versioning and archive attribution, matching `planifest-framework` 0000030 ADR 007.

`planifest-framework/` in this repo keeps its telemetry. It is out of scope.

## Artifacts Produced

- `discovery.md`, `design.md`, `build-log.md`, `feature-brief.md`
- `execution-plan.md`, `scope.md`, `risk-register.md`, `domain-glossary.md`
- `requirements/req-001` to `req-008` (eight files)
- `adr/ADR-001` to `ADR-003` (three files)
- `security-report.md`, `recommendations.md`, `iteration-log.md`

## Decisions

- **ADR-001:** Telemetry is not a framework concern. Every telemetry-only file is deleted, and the
  setup record drops `backendUrl`, narrowing 0000032 ADR 001.
- **ADR-002 (v0.1.1):** Setup retracts legacy telemetry wiring on every run. It matches only
  `<module>.mjs` at a path boundary, so a user's own hooks survive.
- **ADR-003 (v0.2.0):** The five phase names live in prose in `pipeline-reference.md`. The product
  `id` and its discovery stop stay. The human reversed their removal at P5.

## Security

The P5 review found two medium issues in the new cleanup, and both are fixed inside P5:

- The cleanup matched module names as bare substrings, so it removed a user hook such as
  `./my-tools/emit-event-logger.sh`.
- Windows PowerShell 5.1 followed a symlinked marker folder into its target.

PowerShell matching is now case-sensitive, as in bash. Overall risk is Low with no critical or high
findings. Backlog 0000091 and 0000092 hold the Low and operational items.

## Skipped Phases

None.
