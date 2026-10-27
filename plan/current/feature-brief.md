---
title: "Feature Brief - setup argument checks"
summary: "Setup rejects an invalid tool and any retired flag during argument parsing, before it changes the repo."
status: "approved"
version: "0.1.0"
---
# Feature Brief - setup argument checks

**Feature ID:** 0000196-setup-argument-checks

> Built from backlog entries 0000193 and 0000194 by initiative 0000195 step 1. Both entries are pulled in and their folders deleted in the same commit.

## Business Goal

`setup.sh` and `setup.ps1` change the repo before they reject a bad run. An unknown tool leaves git hooks and workflow files behind. A retired flag prints a warning and carries on, so users keep passing a flag that does nothing. Both scripts validate every argument first and exit 1 with the repo unchanged.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Validate the tool first | As a maintainer, I run setup with a missing or unknown tool and the run exits 1 with no change to the repo, so that a rejected run never enables hooks or adds workflow files. | must-have | 1 |
| Fail on retired flags | As a maintainer, I run setup with a retired flag and the run exits 1 with an error that names the flag, so that I remove a flag that does nothing. | must-have | 1 |
| Refresh reports retired flags | As a maintainer, I refresh setup from a record that holds a retired flag and the refresh names that flag, so that I know why setup refused. | must-have | 1 |

## Waves

One wave. The release holds three features.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All three | Both shells pass the new and updated tests |

## Target Architecture

### Components

| Component | Type | New or Existing | Responsibility |
|-----------|------|-----------------|---------------|
| ravintio-zero | component-pack | existing | Setup scripts, skills, hooks, standards, and tests |

### Data Ownership

No datastore. `ravintio-zero` owns every file.

### Integration Points

None.

## Stack

| Concern | Decision |
|---------|----------|
| Language | Bash and PowerShell |
| Runtime | bash, pwsh |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | pack shell and PowerShell test suites (`run-tests.sh`, `run-tests.ps1`) |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- Move the tool check in `setup.sh` and `setup.ps1` to straight after argument parsing, ahead of the old-folder check and `initialize_repo`.
- Make each retired flag exit 1 during argument parsing. The error names the flag, says it was removed and does nothing, and tells the user to remove it. A `--backend-url` value never appears in the output.
- Update the six existing tests that assert the retired-flag warning.
- Add a fresh-temp-repo test per shell for an unknown tool, and one per shell for each retired flag. Each asserts exit 1, an unchanged tree, and an unset `core.hooksPath`.
- Check that the `ravintio-refresh-setup` skill reports a retired flag in a setup record or marker plainly.
- Update the documentation that describes the warning behaviour.

### Out of Scope
- New valid tools (backlog entry 0000175).
- Changing the usage text or the exit code of the tool check.
- Changes to how unknown flags fail, which already fail during parsing.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Repo change on a rejected run | Zero files added, changed, or removed, and `core.hooksPath` unset | Tree snapshot before and after in the new tests |
| Flag value disclosure | A `--backend-url` value appears in no output | Test asserts the value is absent from stdout and stderr |
| Shell parity | `setup.sh` and `setup.ps1` give the same exit code and error text | Both suites pass |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of the orchestrator apply. No schema change.
- Reverses 0000034 ADR-001 (warn on retired flags). The new ADR supersedes it.

### Assumptions
- The line numbers in the backlog entries are approximate. P2 locates each block by name.
- A tool name that starts with `--` already fails during parsing as an unknown flag.

## Scenario Paths

**Happy path:** A user runs `setup.sh claude-code` with valid flags. Setup validates the arguments, then installs as before.

> Unchanged install flow.

**First-run path:** A user runs setup in a fresh repo with an unknown tool. Setup exits 1 before `initialize_repo`, so the repo gains no structure, hooks, or workflow files.

> Fresh repo stays untouched.

**Error / sad path:** A user passes `--context-mode-mcp`. Setup exits 1 with an error that names the flag and says to remove it.

> Exit 1, flag named, tree unchanged.

**Cross-session continuity:** No state spans sessions. A refresh from a record that holds a retired flag names the flag and changes nothing.

> No partial writes, because validation precedes every write.

## Acceptance Criteria

- [ ] A missing or unknown tool exits 1 straight after argument parsing. In a fresh temp repo the tree is unchanged and `core.hooksPath` is unset, in each shell.
- [ ] Each retired flag exits 1 during argument parsing with an error that names the flag, says it does nothing, and tells the user to remove it, in each shell.
- [ ] Each retired flag leaves the repo unchanged and `core.hooksPath` unset, in each shell.
- [ ] A `--backend-url` value never appears in the output.
- [ ] A setup record or marker that holds a retired flag makes the refresh path name that flag.
- [ ] The six existing retired-flag tests assert the new behaviour and pass.
