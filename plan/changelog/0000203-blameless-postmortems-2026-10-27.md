# Changelog (0000203-blameless-postmortems, 27 Oct 2026)

**Feature:** blameless postmortems
**Version:** 0.25.0
**PR:** #46

## What changed

- A new `ravintio-postmortem` skill writes one blameless postmortem for a failed CI run, a `Blocked:` stop, a P2 self-correction, an escaped defect, or a human request. It builds a timeline with evidence and a 5 whys chain that ends at a gap in a process, check, standard, or tool. It rejects a chain that ends at a person or an agent.
- The skill files each corrective, preventive, or detective action as a backlog entry or a repo instruction, and writes the record to `plan/postmortems/`, outside `plan/current/`, so the ship archive step leaves it in place.
- A new template, `postmortem.template.md`, holds the record format.
- The orchestrator runs the skill after a `Resolved:` line, before ship. The skills catalogue lists it.
- The ship build assessment lists the postmortems the run wrote, or `Postmortems: none`.
- `component.yml`, the architecture overview, and the pipeline reference name the skill and count 14 skills.

## Why

The pipeline fixed a failure and moved on, so nothing asked why earlier phases let it through. Backlog entry 0000177 asked for a blameless postmortem with actions that close the gap.

## Deviations

- Adding a skill raised the skill text from 1447 to 1520 lines and the skill count from 13 to 14. Tests 0000031 (two suites) and 0000160 state the new budget and count.
- The installed copies under `.claude/skills/` keep the 13 old skills until step 13 of initiative 0000195 reruns setup. `test-0000151-req-014` fails locally for that reason.
- The skill is invoked by the orchestrator text only. No script detects triggers.

## Validation results

The feature suites pass except `test-0000151-req-014`, as noted above. The regression suite passes. The consistency check is clean on this run's plan. The security review found nothing above low.

## Skipped phases

None.
