# Changelog (0000185-explain-strict-mode, 25 Oct 2026)

**Feature:** explain-strict-mode
**Version:** 0.18.1
**PR:** [#35](https://github.com/RAVINTIO/ravintio-zero/pull/35)

## What changed

`project-operations.md` now explains strict mode and its acknowledgement file. The getting-started and README links reach that explanation.

- req-001: the `## Strict Orchestrator Mode` section now has a `### Strict mode and the session acknowledgement` subsection. It explains the handshake in four steps. It also says what `plan/.orchestrator-ack` holds and why it has that name. It covers when ship deletes the file and what to do in a roadmap run.
- req-002: the `getting-started.md` strict mode row and the `README.md` `--strict-orchestrator` row link to `project-operations.md#strict-orchestrator-mode`.

## Why

Backlog entry 0000184: no doc said what `plan/.orchestrator-ack` holds. "Ack" is networking jargon, and the getting-started link landed on the sentinel section instead.

## Deviations

- The entry asked for a new subsection. A strict mode section already followed the sentinel section, so the run rewrote it in place. ADR-001 records it.
- The text adds two facts the entry's draft left out: the active-pipeline condition and the timestamp fallback.

## Validation results

- 157 feature and 19 regression Bash suites pass under macOS Bash 3.2 with `env -i`.
- All 6 acceptance criteria pass. A hook run in five states and 14 source cites back them.
- Security review: overall low, two informational notes, both accepted.

## Skipped phases

None
