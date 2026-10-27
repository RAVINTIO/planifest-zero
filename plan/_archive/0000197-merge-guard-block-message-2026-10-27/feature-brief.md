---
title: "Feature Brief - merge-guard block message"
summary: "The merge-guard hook names the real reason when it blocks a command that holds merge words in text."
status: "approved"
version: "0.1.0"
---
# Feature Brief - merge-guard block message

**Feature ID:** 0000197-merge-guard-block-message

> Built from backlog entry 0000190 by initiative 0000195 step 2. The entry folder is deleted in the same commit.

## Business Goal

The `merge-guard` hook blocks a Bash command that writes a heredoc naming `gh pr merge`. The block is correct, but the message says the command is over 4096 characters or that the call is not a bare `gh pr merge`. The agent cannot tell that merge words in text caused the block, or that the Write tool avoids it. The hook keeps blocking the same commands and gives the right reason with the right advice.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Name the real block reason | As an agent that writes a file with a heredoc, I get a block message that says the command names a merge in text and tells me to use the Write tool, so that I fix the call at once. | must-have | 1 |

## Waves

One wave. The release holds one feature.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All | The merge-guard suite passes with the new messages |

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
| Language | Node.js (ESM) and Bash |
| Runtime | node, bash |
| Framework | none |
| Frontend | none |
| Database | none |
| ORM | none |
| Testing | pack shell test suites (`run-tests.sh`) |
| IaC | none |
| Cloud | none |
| Compute | none |
| CI | GitHub Actions |
| Build target | local |

## Scope Boundaries

### In Scope
- When a segment holds merge words and is not a bare `gh pr merge` call, the block message says the command names a merge in text that isn't a merge call, and tells the agent to write files with the Write tool.
- The over-4096 message gives the same Write tool advice.
- Update the tests that assert the old message text, and add tests for the new messages.
- Update the docs that describe the block message.

### Out of Scope
- Which commands the hook blocks or passes.
- Skipping heredoc bodies or quoted text.
- Any other hook.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Block set unchanged | Every command that blocked before still exits 2, and every command that passed still exits 0 | The existing merge-guard suite passes, apart from tests that assert the old message text |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of the orchestrator apply. No schema change.
- The hook fails closed. The change touches message text only.

### Assumptions
- The text-versus-call reason applies when `parsePlain()` rejects a segment that holds merge words. Other rejection reasons keep their text.

## Scenario Paths

**Happy path:** A plain `gh pr merge 12 --squash` into `initiative/x` passes. A command with no merge words passes.

> Unchanged pass behaviour.

**First-run path:** An agent writes a Markdown file with a heredoc that names `gh pr merge`. The hook blocks it and the message tells the agent to use the Write tool.

> Block stays, advice added.

**Error / sad path:** A command over 4096 characters that names a merge stays blocked, and its message also names the Write tool.

> Exit 2, both reasons advise the Write tool.

**Cross-session continuity:** The hook holds no state, so each command is judged alone.

> No state to carry.

## Acceptance Criteria

- [ ] A command that writes a heredoc naming `gh pr merge` exits 2 under 4096 characters, and the message says the command names a merge in text and names the Write tool.
- [ ] The same command over 4096 characters exits 2, and the message names the Write tool.
- [ ] Every existing merge-guard test passes unchanged, apart from tests that assert the old message text.
