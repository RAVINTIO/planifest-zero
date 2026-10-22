# Architecture Overview

Last updated: 0000041-setup-cleanup-and-park-hardening

## What this repo is

This repo is the Planifest framework itself. It holds one component, `planifest-zero`, which other projects install into their working tree.

The framework is not a service. It has no runtime of its own. It ships four things:

1. **Skills.** Markdown instructions that Claude Code auto-discovers from `.claude/skills/`. Twelve skills drive the five-phase pipeline.
2. **Hooks.** Node `.mjs` scripts that Claude Code invokes synchronously at tool-call boundaries. Enforcement hooks block or annotate. Git hooks guard commits and pushes. No hook makes an outbound network call.
3. **Standards, templates, and schemas.** The reference material that skills bundle at install time.
4. **Setup scripts.** `setup.sh` and `setup.ps1` copy the above into a target project and wire `.claude/settings.json`.

The repo runs its own pipeline on the `planifest-zero/` it ships. Git reads its hooks from `planifest-zero/hooks` through `core.hooksPath`.

---

## Pipeline

The pipeline runs five phases. There is one route: every change is a feature change, and a small change is a small run. Each agent response carries its phase prefix.

| Phase | Prefix | Owning skill |
|-------|--------|--------------|
| Discovery | `D:` | planifest-orchestrator |
| Plan | `PL:` | planifest-plan |
| Implement | `IM:` | planifest-implement |
| Validate and accept | `VA:` | planifest-validate-and-accept |
| Ship | `SH:` | planifest-ship |

Discovery sizes each release against a budget. The optional `releaseSize` field in `product.yml` sets it to `small`, `medium`, or `large`, and the default is `medium`. Discovery gives each candidate requirement a size class from the files it touches, then recommends a fill up to the budget.

**Park.** When the human says "park", the orchestrator shelves the feature on its branch. It writes `plan/current/park.md`, pushes the branch, and raises a `chore/park-{feature-id}` PR. That PR files a backlog entry with status `parked`. The working tree then returns to `main`. The git and `gh` steps live in the orchestrator's `scripts/park.mjs`. If a local add or commit fails on the chore branch, park unstages and deletes the entry, then returns to the feature branch. Park refuses an `--entry` that is the target path, so that cleanup never deletes the only copy. At a later discovery, backlog pickup offers resume or discard for a parked entry. Park and pickup never merge a PR, never commit to `main`, and never force-push.

The implement phase dispatches a TDD trio per requirement: planifest-test-writer, planifest-implementer, and planifest-refactor. Four support skills complete the set of twelve: planifest-loop-runner, planifest-optimise-agent, planifest-migrator, and planifest-refresh-setup.

---

## Install flow

Setup targets Claude Code only. It copies skills and hooks into `.claude/`, prunes retired skills, writes the boot file, and wires the git hooks.

```
planifest-zero/          setup.sh claude-code          target project
├── skills/          ──────────────────────────────────▶   .claude/skills/
├── templates/       ── bundled per skill frontmatter ──▶   .claude/skills/*/assets/
├── standards/       ── bundled per skill frontmatter ──▶   .claude/skills/*/references/
├── workflows/       ──────────────────────────────────▶   .claude/commands/
├── hooks/enforcement/ ────────── always ──────────────▶   .claude/hooks/enforcement/
└── templates/standard-boot.md ───────────────────────▶   CLAUDE.md
```

Skills bundle selectively. Each `SKILL.md` declares `bundle_templates` and `bundle_standards` in its frontmatter, and setup copies only those files. A skill with no manifest gets everything.

Boot files are disposable build outputs. Every run regenerates `CLAUDE.md` from the template, then re-appends the contents of `planifest-overrides/instructions/` between sentinel markers. Durable local customisation lives in the overrides directory, never in the boot file.

---

## Setup-config record

`setup.sh` and `setup.ps1` write the tracked record of active setup flags to `plan/state/{tool}.md`, creating the folder when it is absent. The record and the gitignored flags marker hold `tool`, `flags`, and `writtenAt`. The `planifest-refresh-setup` skill reads and validates that record before falling back to the gitignored marker and hook inference.

---

## Enforcement model

Enforcement is deterministic where it can be, and instructional where it cannot.

**Deterministic.** A hook exits 2 with a human-readable message and Claude Code blocks the tool call. `gate-write` blocks writes to `src/` without a confirmed design. `ratchet-check` blocks weakening edits to an active loop's artifacts. `em-dash-guard` rejects U+2014 in scoped prose paths.

**Instructional.** Skills tell the agent what to do. The orchestrator's hard limits, the one-question-at-a-time rule, and the phase gates all rely on the agent following its instructions.

Every hook fails open on an unexpected error. Exit 0 with no output means the tool call proceeds. That is deliberate: a broken hook must never stop a session.

---

## Upgrade cleanup

Every setup run retracts telemetry wiring that an earlier install left in the target project. It runs before the enforcement hook install, so that install writes `.claude/settings.json` last. Setup removes these items when present:

- hook entries in `.claude/settings.json` whose command runs a retired telemetry module as `<module>.mjs` at a path boundary
- hook entries whose matcher or command names `mcp__structured-telemetry-mcp__emit_event`
- the `.claude/telemetry-enabled` sentinel
- the `plan/.telemetry-failures/` and `plan/.telemetry-receipts/` directories

The module match is case-sensitive. Setup prints one line per removal and stays silent when nothing is present. If `settings.json` fails the parse or the shape check, the cleanup skips it in silence and writes nothing. The hook install step then reports the fault once. A read or write failure prints a warning and setup carries on.

If `node` isn't on the `PATH` and `settings.json` exists, `setup.sh` prints one warning that it skipped this cleanup.

---

## Re-run safety

Setup is safe to re-run on a project that an older release installed.

**Retired flags.** Setup accepts four flags that earlier releases removed:

- `--structured-telemetry-mcp`
- `--backend-url`
- `--context-mode-mcp`
- `--include-full-skill-library`

Each prints one warning and setup skips it. After `--backend-url`, setup also skips the next argument, unless that argument is a flag or a tool name. Setup never prints or stores that value, in either the spaced or the `=` form. Any other unknown flag still exits 1, and its error shows the flag name only. Matching is exact and case-sensitive in both scripts. The tool name also matches exactly.

PowerShell 7 splits an argument such as `--backend-url=https://x` at its first colon. `setup.ps1` skips the rest of the value too, and never prints a tool name that isn't a plain name.

**Atomic settings writes.** Every `settings.json` write goes to `settings.json.planifest-tmp` in the same folder first, then replaces the target. So `settings.json` is always the old file or the new one. Setup removes a leftover temporary file before it writes, and creates the new one exclusively, so it never follows a planted link. The new file keeps the original's mode, or its ACL on Windows. Setup leaves a read-only `settings.json` unchanged. `setup.sh` writes a symlinked `settings.json` through to its real file. Other files setup writes, such as the boot file, are rewritten whole on each run.

**Leftover temporary file.** Each run removes a leftover `settings.json.planifest-tmp` before its first settings write, even when `node` is missing. It removes a file or a link, never a folder, and never follows a link.

**Two scripts, one result.** `setup.sh` and `setup.ps1` wire the same six hooks, in the same events, matchers, and order. A parity suite fails if they drift. `setup.ps1` runs on Windows PowerShell 5.1 and PowerShell 7. It reads and writes `settings.json` as UTF-8 with no BOM. Flags and the tool name match case in both scripts.

**Hook entry repair.** Both scripts find a Planifest `PreToolUse` entry by its module name, on any matcher. So an older `Write|Edit` entry gives way to one `Write` entry and one `Edit` entry, and `gate-write` runs once per tool. If `PreToolUse` or `UserPromptSubmit` holds a value that isn't an array, setup prints a warning that names the event and the file. The warning never prints the old value, because a hook command can hold a secret. It then replaces the value with the Planifest entries and exits 0. An absent or null value gets the entries with no warning.

**Per-command filter.** Both scripts filter `PreToolUse` and `UserPromptSubmit` one command at a time. Setup removes each Planifest command and keeps any user command in the same entry. If an entry holds only Planifest commands, setup drops it. A `hooks` value that holds one object counts as a one-item array, so setup filters it the same way. An entry with no commands stays as it was. A command counts as Planifest only when it runs `<module>.mjs` at a path boundary, matched case-sensitively.

**Invalid JSON.** If `settings.json` isn't valid JSON, the hook install step prints one fixed line that names the file. The line never holds the file's contents. Setup leaves the file unchanged and exits 1, because it can't install the hooks. The telemetry cleanup prints nothing for this file.

**Not a settings object.** If `settings.json` is valid JSON but not a settings object, both scripts print one fixed line that names the file. That covers a top level that isn't an object, and a `hooks` value that is present and isn't an object. Setup leaves the file unchanged and exits 1. `setup.ps1` also gives this line for keys that differ only by case, because `ConvertFrom-Json` can't read them. `setup.sh` accepts those keys, because Node reads them.

**Nesting cap.** `setup.ps1` checks JSON nesting with a counter and a stack, so the check runs in linear time. Nesting deeper than 1024 levels gets the not-a-settings-object line.

**JSON depth.** `setup.ps1` writes `settings.json` with `ConvertTo-Json -Depth 100`, so a deeply nested user value survives a rewrite.

---

## Tests

`planifest-zero/tests/run-tests.sh` runs every Bash and PowerShell suite. Before any suite runs, it checks every file under `tests/`. A file that is neither a suite nor on its known list fails the run, and the runner names it. Without `pwsh`, it prints how many PowerShell suites it skipped.

The PowerShell suites run `setup.ps1` in temporary projects. In CI, the `windows-powershell` job runs them under Windows PowerShell 5.1 and PowerShell 7. The `bash-suites` job runs `run-tests.sh` on `ubuntu-latest` with `PLANIFEST_REQUIRE_PWSH=1`. So it runs every Bash suite and fails if `pwsh` is missing.

---

## Version derivation

`product.yml` holds the product-level version manifest. Under `versionPolicy: max-component-version`, `scripts/product-version.mjs` reads each listed `component.yml` live and takes the highest. Nothing caches a version, so the list only changes when a component is added or removed.

This project has one component and keeps `product.yml` anyway. Its top-level `id` gives the product a stable name for versioning and for attributing archived runs, wherever the repo is cloned. The orchestrator hard-stops at discovery when that `id` is missing.

The five phase names live in prose in `planifest-zero/pipeline-reference.md`. No module encodes them.
