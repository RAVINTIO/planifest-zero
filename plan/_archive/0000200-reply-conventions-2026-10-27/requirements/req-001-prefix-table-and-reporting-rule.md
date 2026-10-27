# Requirement: REQ-001 - prefix table and reporting rule in the boot file and orchestrator

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000200-reply-conventions
**Source:** US-001, US-003
**Priority:** must-have

## User Story

As the human on the loop, I see a valid phase or stage prefix on every reply in an active run, including after compaction and in a supervising session, so that I know which phase a reply belongs to.

As the human on the loop, I read replies that state results, deviations, failures, and decisions only, so that routine compliance with a standing rule does not hide what needs me.

## Functional Requirements
- `ravintio-zero/templates/standard-boot.md` holds a `## Reply Conventions` section. It lists the five phase prefixes `P0 Discovery:` to `P4 Ship:`, the five initiative prefixes `I-A Chart:` to `I-E Delivery:`, and the status form `{prefix} {Status}: {one-liner}`.
- The same section defines `Supervise:` as the prefix for out-of-phase work, such as supervising an initiative driver, filing backlog entries, and answering questions while another session runs a step.
- The same section holds the reporting rule: a reply reports results, deviations, failures, and decisions the human must make. It never states that the agent followed a standing rule, unless the rule blocked an action or the agent departed from it.
- `ravintio-zero/skills/ravintio-orchestrator/SKILL.md` lists `Supervise:` with the other prefixes, and holds the same reporting rule.

## Acceptance Criteria
- [ ] AC-1: the boot file carries the table
  - Given the boot template
  - When a test reads the Reply Conventions section
  - Then it holds all ten prefixes, `Supervise:`, and the status form
- [ ] AC-2: the reporting rule is stated twice
  - Given the boot template and the orchestrator skill
  - When a test searches each for the reporting rule
  - Then both name results, deviations, failures, and decisions, and both bar reporting compliance with a standing rule
- [ ] AC-3: the orchestrator lists the new prefix
  - Given the orchestrator skill
  - When a test reads its prefix lists
  - Then `Supervise:` appears with the status form

## Dependencies
- None
