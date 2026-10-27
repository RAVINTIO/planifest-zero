# Requirement: REQ-002 - ack split and trigger hooks

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000205-initiative-skill
**Source:** US-003
**Priority:** must-have

## User Story

As the human on the loop, I see strict mode stay quiet in my session and in every step session, so that no session overwrites another's ack.

## Functional Requirements
- `check-orchestrator-presence.mjs` in strict mode passes silently when `plan/.initiative-ack` or `plan/.orchestrator-ack` holds the session id.
- When neither file holds the session id and the initiative driver lock `plan/.initiative-runner.lock` is held, the banner tells the model to load `ravintio-initiative` and write `plan/.initiative-ack`.
- `auto-trigger-orchestrator.mjs` emits an instruction to load `ravintio-initiative` when `plan/current-initiative/initiative.md` holds `status: active` and the driver lock is held or `plan/current/` holds no artifacts and no `plan/.orchestrator-active` file exists. Otherwise it keeps today's behaviour.
- The hooks never exit 2 and never block a prompt.

## Acceptance Criteria
- [ ] AC-1: either ack file silences strict mode
  - Given strict mode and a session id
  - When `plan/.initiative-ack` holds the id, then when `plan/.orchestrator-ack` holds it
  - Then the presence hook prints nothing in both cases
- [ ] AC-2: the banner names the right ack file
  - Given strict mode, an active sentinel, and a held driver lock with no matching ack
  - When the presence hook runs
  - Then its output names `plan/.initiative-ack` and `ravintio-initiative`
- [ ] AC-3: the trigger picks the skill
  - Given an active initiative with the driver lock held and no orchestrator sentinel
  - When the auto-trigger hook runs
  - Then its output names `ravintio-initiative`, and with no initiative it names `ravintio-orchestrator`

## Dependencies
- None
