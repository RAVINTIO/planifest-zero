# Requirement: REQ-001 - postmortem skill and record template

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000203-blameless-postmortems
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the human on the loop, I get one postmortem record per `Blocked:` stop or CI failure, with a timeline and a 5 whys chain that ends at a process or tool gap, so that the same failure does not return.

## Functional Requirements
- `ravintio-zero/skills/ravintio-postmortem/SKILL.md` defines the skill with frontmatter `name` and `description`. It stays under 120 lines.
- The skill names its triggers: a failed CI run, a `Blocked:` stop, a P2 self-correction that a test should have caught, an escaped defect, and a human request.
- The skill states the blameless rules. It names no person or agent as a cause.
- The skill requires a timeline with evidence and a 5 whys chain. The chain ends at a gap in a process, check, standard, or tool. If a chain ends at a person or an agent, the skill rejects it and asks why again.
- The skill requires corrective, preventive, and detective actions. Each names its owner, where it lives, and what verifies it.
- Each action becomes a backlog entry or a repo instruction. The skill files it and links it from the record.
- The skill writes the record to `plan/postmortems/{date}-{slug}.md` and creates the folder if it is missing. It writes nothing under `plan/current/`.
- `ravintio-zero/templates/postmortem.template.md` holds the record format: summary, timeline, 5 whys, and actions.
- `ravintio-zero/tests/test-0000031-req-003-five-phases.sh` lists the new skill and raises the skill-text line budget from 1447 to 1520. `test-0000031-req-004-setup-execution.sh` and `test-0000160-req-001-pack-identifiers.sh` count 14 skills.

## Acceptance Criteria
- [ ] AC-1: the skill exists and is short
  - Given the pack source
  - When a test reads `ravintio-zero/skills/ravintio-postmortem/SKILL.md`
  - Then the file has `name: ravintio-postmortem` frontmatter and fewer than 120 lines
- [ ] AC-2: the skill states the method
  - Given the skill file
  - When a test reads its text
  - Then the text names the five triggers, the blameless rule, the timeline, the 5 whys stop at a process or tool gap, the rejection of a chain that ends at a person or agent, and the three action types
- [ ] AC-3: records live outside the archive
  - Given the skill and the template
  - When a test reads them
  - Then the skill writes to `plan/postmortems/`, never under `plan/current/`, and the template has timeline, 5 whys, and actions sections

## Dependencies
- None
