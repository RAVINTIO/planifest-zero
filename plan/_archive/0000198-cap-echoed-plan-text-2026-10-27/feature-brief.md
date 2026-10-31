---
title: "Feature Brief - cap echoed plan text"
summary: "The ratchet hook and the consistency check print at most 200 characters of any echoed plan line."
status: "approved"
version: "0.1.0"
---
# Feature Brief - cap echoed plan text

**Feature ID:** 0000198-cap-echoed-plan-text

> Built from backlog entry 0000176 by initiative 0000195 step 3. The entry folder is deleted in the same commit.

## Business Goal

`ratchet-check.mjs` prints each removed line in full when it blocks an edit. `consistency-check.mjs` prints a whole story map row label in a finding. A long or hostile line reaches the agent's context unchanged. Each program prints at most 200 characters of an echoed line and marks the cut. The 0000170 security review rated both findings low.

## Features

| Feature | User Stories | Priority | Wave |
|---------|-------------|----------|------|
| Cap the ratchet block message | US-001: As an agent that a ratchet block stops, I see at most 200 characters of each removed line and a cut marker, so that a long or hostile line never floods my context. | must-have | 1 |
| Cap the consistency finding | US-002: As an agent that runs the consistency check, I see at most 200 characters of a story map row label in a finding and a cut marker, so that a long or hostile label never floods my context. | must-have | 1 |

## Waves

One wave. The release holds two features.

| Wave | Features Included | Ships When |
|------|-------------------|------------|
| 1 | All | One test per program passes with a line over the cap |

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
- `ratchet-check.mjs` truncates each line it echoes in the `removed:` list to 200 characters and marks the cut.
- `consistency-check.mjs` truncates the story map row label in both findings that echo it to 200 characters and marks the cut.
- One new test suite feeds each program a line over the cap and checks the output.
- Docs that describe the printed text name the cap.

### Out of Scope
- Which writes the ratchet blocks, and which findings the consistency check raises.
- Capping the `.ratchet-approve` reason, which already has a 500-character cap.
- Findings that echo file names, requirement ids, or counts.
- The hook-parity and setup wiring.

### Deferred
Nothing deferred.

## Non-Functional Requirements

| NFR | Target | Measurement |
|-----|--------|-------------|
| Block set unchanged | The ratchet blocks and passes the same writes. The consistency check raises the same findings with the same exit codes. | The existing ratchet and consistency suites pass, apart from tests that assert an uncapped line |

## Constraints and Assumptions

### Constraints
- Hard Limits 1 to 7 of the orchestrator apply. No schema change.
- The ratchet hook fails open on unexpected errors. The change keeps that contract.
- The hook installs as a single file under `.claude/hooks/enforcement/`, so it cannot import from `ravintio-zero/scripts/`.

### Assumptions
- The cap counts characters of the echoed line and excludes the cut marker.
- A line of 200 characters or fewer prints unchanged.

## Scenario Paths

**Happy path:** A line of 200 characters or fewer prints exactly as before, in both programs.

> Unchanged output for normal lines.

**First-run path:** The first block in a project that has a long acceptance criterion line shows 200 characters and the cut marker.

> The cap applies from the first message.

**Error / sad path:** A hostile line of thousands of characters is cut to 200 characters plus the marker, and the exit code stays 2 for the ratchet and 1 for the consistency check.

> Output shrinks and exit codes hold.

**Cross-session continuity:** Neither program holds state. Each message is built from the file it reads.

> No state to carry.

## Acceptance Criteria

- [ ] `ratchet-check.mjs` prints at most 200 characters of each removed line and a cut marker, and still exits 2.
- [ ] `consistency-check.mjs` prints at most 200 characters of a story map row label and a cut marker, and still exits 1.
- [ ] Every existing ratchet and consistency test passes unchanged.
