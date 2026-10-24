---
title: "Domain Glossary - hardening-efficiency-and-ci"
summary: "Definitions of domain terms used within this feature."
status: "active"
version: "0.1.0"
---
# Domain Glossary - hardening-efficiency-and-ci

**Skill:** [plan](../skills/planifest-plan/SKILL.md) (updated by any agent that introduces a new domain term)
**Feature:** 0000151-hardening-efficiency-and-ci
**Version:** 0.1.0

> The ubiquitous language for this feature. If the glossary says "Order", the code says `Order` - not "Purchase" or "Transaction". Never invent new terms without adding them here.

## Terms

| Term | Definition | Aliases | Used In |
|------|-----------|---------|---------|
| Sentinel | A sentinel is a marker file such as `plan/.orchestrator-active` that records pipeline state. Ship clears the sentinels in a commit before it pushes, so no PR carries them. | | planifest-zero |
| Retired hook | A retired hook is a hook the pack no longer ships, named on the retired list in setup. Setup deletes an installed copy and never deletes a hook absent from that list. | | planifest-zero |
| Quiet mode | Quiet mode is `PLANIFEST_TEST_QUIET=1`. It hides PASS lines and banners and keeps every FAIL line, its detail, the failing suite name, the summary, and the exit codes. | | planifest-zero |
| Step log | A step log is `plan/.roadmap-logs/step-{position}.log`. The driver writes a step's stdout and stderr there, and every stop line names it. | | planifest-zero |
| Telemetry label | A telemetry label is a percent-encoded roadmap identifier that the driver appends to `OTEL_RESOURCE_ATTRIBUTES` in the child env. It lets telemetry attribute cost per step. | | planifest-zero |
| Approved dependency | An approved dependency is a library or service that the human approved. The list sits in `design.md` for an interactive run and in `roadmap.md` for a roadmap step. | | planifest-zero |
| Dependency stop | The dependency stop is the sixth exception stop. It fires in every run when work adds a library or service missing from the approved list. | | planifest-zero |
| Turn cap | The turn cap is `PLANIFEST_ROADMAP_MAX_TURNS`, passed to `claude -p` as `--max-turns`. No default ships. Reaching it stops the driver with `R-C Run: Blocked:`. | | planifest-zero |
| Reference file | A reference file is a file under a skill's `references/` folder. It holds a rarely used section moved out of `SKILL.md`, with every rule kept. | | planifest-zero |
| Pack Index | The Pack Index lists every reference file with a one-line trigger. A test fails if a reference file has no row. | | planifest-zero |
| Block reason | A block reason is the text a hook prints when it exits 2. `gate-write`, `em-dash-guard`, and `ratchet-check` write it to stderr and stdout. | | planifest-zero |
| Model tier | A model tier is `sonnet` or `haiku`, the value an Agent call passes as `model`. A haiku unit that fails twice retries on sonnet. | | planifest-zero |
| Park containment | Park containment is the `realpathSync` and `lstatSync` check in `park.mjs`. It refuses any entry path with a symlink or a real path outside `plan/backlog/`. | | planifest-zero |
| Driver | The driver is `planifest-zero/scripts/roadmap-run.mjs`, which runs each roadmap step in a fresh `claude -p` session. | | planifest-zero |
| R-A Chart | R-A Chart is the roadmap stage that charts a roadmap from an idea or a draft. REQ-014 adds a clarity check and the approved dependency list to it. | | planifest-zero |
