# Requirement: REQ-004 - initiative skill and resume split

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-001, US-002
**Priority:** must-have

## User Story

As the human on the loop, I talk to one `ravintio-initiative` session that charts, activates, watches, and delivers an initiative, and I get reports from it, so that I know what each step is doing.

## Functional Requirements
- `ravintio-zero/skills/ravintio-initiative/SKILL.md` has frontmatter `name: ravintio-initiative` and a `description`. It stays under 120 lines.
- The skill owns I-A Chart, I-B Activate, and I-E Delivery. It points to `ravintio-zero/standards/roadmap-standards.md` for the stage rules.
- The skill starts the driver and `initiative-watch.mjs` with the host's background tools. It restarts the monitor when it expires after 30 minutes.
- The skill reports every 5 minutes, at each phase end, and on request. A report names the step, the phase, the last build log line and its age, commits since the last report, any stop, and whether the driver runs. A progress report has an **Initiative** part and a **Current step** part.
- The skill never edits the working tree while a step runs. It writes new backlog entries to `plan/.initiative-queue/` and commits them to the initiative branch after the step merges.
- The skill writes `plan/.initiative-ack`. It never resumes a step and never loads the orchestrator for a step.
- The orchestrator Resume Detection step 3 no longer resumes an initiative. It says an active initiative with a held driver lock belongs to `ravintio-initiative`.
- The driver adds `plan/.initiative-queue/` to `.git/info/exclude`.

## Acceptance Criteria
- [ ] AC-1: the skill exists and is short
  - Given the pack source
  - When a test reads `ravintio-zero/skills/ravintio-initiative/SKILL.md`
  - Then the file has `name: ravintio-initiative` frontmatter and fewer than 120 lines
- [ ] AC-2: the skill states the method
  - Given the skill file
  - When a test reads its text
  - Then the text names I-A Chart, I-B Activate, I-E Delivery, the 5-minute report, the two report parts, the queue folder, `plan/.initiative-ack`, and the rule never to resume a step
- [ ] AC-3: the orchestrator no longer resumes an initiative
  - Given the orchestrator skill
  - When a test reads Resume Detection
  - Then it names `ravintio-initiative` for an active initiative and holds no instruction to resume an initiative step

## Dependencies
- REQ-003
