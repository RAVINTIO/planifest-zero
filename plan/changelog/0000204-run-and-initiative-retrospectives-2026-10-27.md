# Changelog (0000204-run-and-initiative-retrospectives, 27 Oct 2026)

**Feature:** run and initiative retrospectives
**Version:** 0.26.0
**PR:** pending

## What changed

- A new `ravintio-retrospective` skill writes one blameless retrospective for a shipped run or a delivered initiative. It has a run mode and an initiative mode. It names what helped, what slowed the work, one thing to keep, and one to change. It rejects any cause that names a person or an agent.
- The initiative mode answers four questions: how the charted steps, bumps, and versions compare with what shipped, which friction repeated, what happened at each stop and how long each step took, and which initiative tooling gaps showed up.
- The skill files each change as a backlog entry or a repo instruction that names its source retrospective. It writes the record to `plan/retrospectives/`, outside `plan/current/`, so the ship archive step leaves it in place.
- A new template, `retrospective.template.md`, holds the record format.
- Ship Step 5 runs the skill in run mode after the build report and lists the record. I-E Delivery runs it in initiative mode after the archive and before the PR to `main`, and the PR body names the record.
- P0 discovery reads the newest three records through the discovery coaching reference. I-A Chart reads the latest records before it coaches.
- The skills catalogue lists the skill. `component.yml`, the architecture overview, and the pipeline reference name it and count 15 skills.

## Why

The build report listed metrics but no step reviewed what went well and what to change, and an initiative ended with no review across its steps. Backlog entry 0000178 asked for a blameless retrospective at both points.

## Deviations

- Adding a skill raised the skill text from 1520 to 1598 lines and the skill count from 14 to 15. Tests 0000031 (two suites), 0000160, and 0000203 state the new budget and count.
- The orchestrator `SKILL.md` has a 27,700 byte cap, so the P0 scan lives in `orchestrator-discovery-coaching.md` and not in Discovery Start Actions.
- Test 0000189 req-008 now passes when entry 0000178 has left the backlog, as it does for entry 0000181.
- The installed copies under `.claude/skills/` keep the 14 old skills until step 13 of initiative 0000195 reruns setup. `test-0000151-req-014` fails locally for that reason.
- The driver that runs this initiative started before this step. Its I-E Delivery runs the initiative retrospective only if the delivery session reads the new standards. If it skips the record, the human runs the skill in initiative mode.

## Validation results

Every suite passes except `test-0000151-req-014`, as noted above. The security review found nothing above low.

## Skipped phases

None.
