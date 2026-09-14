---
phase: "P4"
active_task: "P4 validation complete, awaiting the human's override decision on one pre-existing test failure before P5 Security begins"
last_artifact: "planifest-zero/component.yml (bumped to 0.4.0), commit 27b27d0"
---
# Pause Record - 0000033-remove-telemetry-mcp

**Paused:** 2026-09-14T18:14:51Z
**Phase:** P4 (Validate)

## In-Progress State

### Where the run stands

P0 to P3 are complete and committed. P4 validation has run in full and passed for
everything this feature touches. The pipeline is stopped at one question only.

**The only open item.** The validate rule blocks the pipeline while any check
fails unless the human overrides. One suite fails:
`planifest-zero/tests/test-0000031-req-001-rename.sh`, on two assertions,
`old folder absent` and `live files referencing the old name`. Both fail
because `planifest-framework/` exists, which PR #4 reintroduced deliberately.
Verified identical on `main` via a `git archive main` export. Backlog 0000086
holds the decision this needs. The human overrode the same failure at P4 of
feature 0000032. The orchestrator recommended overriding again. The human asked
for this pause record instead of answering, so the question is still open.

**On resume, ask exactly this one question first:**
`P4: Override the pre-existing test-0000031-req-001-rename.sh failure and continue to P5? (yes / block)`
Do not re-run the whole validation. It is recorded below and committed.

### What the feature does

Removes telemetry from `planifest-zero` entirely. No replacement, no extension
seam. Observability is a tool-level concern. `planifest-framework/` in this repo
keeps its telemetry and is out of scope, because this repo runs its own pipeline
against that copy.

### Confirmed decisions, all locked at the P0 design gate

- Version 0.4.0, standard-iterative, continuous run mode (`plan/.run-mode`).
- ADR-001: telemetry is not a framework concern. 34 telemetry-only files deleted.
  Decision 6, added during P3: the `backendUrl` field is dropped from the
  setup-config record and the flags marker, which now hold `tool`, `flags`,
  `writtenAt`. This narrows 0000032 ADR 001's record shape.
- ADR-002: every setup run retracts legacy telemetry wiring from an upgraded
  project. Settings entries, the `.claude/telemetry-enabled` sentinel, and the
  `plan/.telemetry-failures/` and `plan/.telemetry-receipts/` directories. One
  line per removal, warn without failing, silent when nothing is present.
- ADR-003: `hooks/enforcement/phase-enum.mjs` deleted, `pipeline-reference.md`
  states the five phase names directly (`discovery`, `plan`, `implement`,
  `validate-and-accept`, `ship`). `product.yml`'s top-level `id` removed and
  the orchestrator's product-id hard stop dropped. `components[].id` stays,
  because `scripts/product-version.mjs` reads it.

### P4 results, already verified, do not repeat

- Syntax clean on `setup.sh` and the three new suites. All seven surviving hook
  modules pass `node --check`.
- `self-description-check`, `consistency-check`, `product-version.mjs` (0.3.0
  from the components entry), and CI parity all pass.
- Full runner: 44 feature suites passed, 1 failed. Regression 12 passed, 0 failed.
  Arithmetic reconciles: 57 baseline, minus 20 deleted, plus 3 new, equals 45.
- Verify by execution, done by hand: seeded a scratch project with telemetry
  settings entries, a sentinel, both marker directories, a user-added hook, and an
  enforcement hook, then ran setup. All four removals printed. Telemetry left the
  settings file. The user's own hook and the enforcement hook survived. Runs two
  and three printed nothing.
- Zero self-corrections.
- One anomaly investigated and dismissed: `test-0000010` prints a `FAIL: 0`
  summary line in a different format and passes with 15 assertions, exit 0.
- Skill prune noise on a setup re-run (`- removed: planifest-orchestrator` and
  the other eleven) confirmed pre-existing on `main`, with all 12 skills present
  afterwards. Worth a line in `recommendations.md` at P6, not a backlog entry.

### One requirement change made during P3, already recorded

req-002 and req-003 each carried an acceptance criterion that
`grep -i telemetry` returns nothing from its setup script. ADR-002 requires the
cleanup function to name nine telemetry module names, the
`mcp__structured-telemetry-mcp__emit_event` matcher, and three telemetry paths,
so no implementation could satisfy both. Resolved by making both criteria more
precise rather than weaker: no telemetry flag, no telemetry hook install, no
telemetry entry, no sentinel write, and every remaining telemetry string must sit
inside the cleanup block or be a reference to it. No design decision changed.

### Backlog filed during this run

- 0000090: `setup.ps1` wires four enforcement hooks, not six. `ratchet-check`
  and `em-dash-guard` have never existed in the PowerShell path. Confirmed on
  `main`. Next free backlog id is 0000091.
- 0000085 was discarded at P0, because this feature deletes the hook it described.

### What happens after the override

P5 Security, P6 Docs, then P7 to P9 via the ship agent. P7 to P9 always stop for
human confirmation even under continuous run. Remaining work for later phases:

- P5: dispatch a fresh-context security review over `git diff main...HEAD`. The
  interesting surface is the new cleanup function, which reads and rewrites a
  project's `.claude/settings.json`. Check that its filter cannot remove a
  non-telemetry entry, and that it cannot be steered by crafted settings content.
- P6: the docs agent must update `docs/about.md` to 0.4.0, `docs/decisions-index.md`
  with this feature's three ADRs, and the other living docs. Also note the skill
  prune noise in `recommendations.md`. `planifest-zero/component.yml` is already
  at 0.4.0. `product.yml` still reads 0.3.0 and is set at P9 by the ship agent.
- P9: the human previously chose agent push plus `gh pr create`. Ask again.

## Resume Instructions

On next session start, the orchestrator will detect this file and open with:

```
P4: Resuming: P4 validation complete, awaiting the human's override decision on one pre-existing test failure before P5 Security begins
```

Read this file, ask the single override question above, then delete this file and
continue. Everything through commit 27b27d0 is committed and pushed on
`feat/0000033-remove-telemetry-mcp`. The working tree is clean.
