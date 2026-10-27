# Requirement: REQ-003 - call the counter from every id rule

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Source:** US-002
**Priority:** must-have

## User Story

As an agent that copies an entry from another repo, I reserve a new local id and name the source id in the text, so that each repo keeps its own sequence and no id clashes.

## Functional Requirements
- `ravintio-file-backlog` reserves the id with `reserve-id.mjs --init --file {target}/plan/backlog/.next-id` in place of the three-folder scan.
- The orchestrator's backlog pickup, `roadmap-standards.md`, both templates, and `agent-dispatch-standards.md` state that ids come from the counter. Feature ids and initiative ids reserve from it too.
- A copied entry reserves a new local id and names its source repo and source id in its text. Each repo keeps its own sequence.
- The docs state the conflict answer: if two branches reserve the same ids, git shows a conflict on `.next-id`. Keep the higher value and renumber the entries on the branch that merges second.
- A dispatching agent that pre-assigns ids to parallel subagents reserves one block with a single call.
- No pack doc states the "highest ever allocated plus one" rule or tells the agent to scan folders for the next id.

## Acceptance Criteria
- [ ] AC-1: skill calls the script
  - Given the `ravintio-file-backlog` skill
  - When its id step is read
  - Then it names `reserve-id.mjs` and `.next-id` and does not scan `plan/_archive/` for an id
- [ ] AC-2: copied entry
  - Given the skill and the backlog template
  - When the copy rule is read
  - Then each says a copied entry gets a local id and names its source id
- [ ] AC-3: no scan rule left
  - Given the six docs that stated the scan rule
  - When they are searched for "highest ever allocated" and `roadmap-standards.md` is read
  - Then no file matches and `roadmap-standards.md` says to keep the higher value and renumber the branch that merges second

## Dependencies
- REQ-001
