# Story Map - 0000200-reply-conventions

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Read the rules after a session start or compaction | Find the prefix table and status form in the boot file | US-001 | REQ-001 |
| Read the rules after a session start or compaction | Find the reporting rule in the boot file and the orchestrator skill | US-003 | REQ-001 |
| Work in a phase | See the prefix restated in a phase skill's opening lines | US-001 | REQ-002 |
| Reply outside a phase | Use the out-of-phase prefix | US-001 | REQ-001 |
| End a turn in an active run | Get a warning when the reply lacks a prefix | US-002 | REQ-003 |
| End a turn in an active run | Find the miss in the log | US-002 | REQ-003 |
| Install the pack | Setup wires the Stop hook in both scripts | US-002 | REQ-004 |
| Review the miss rate | Read the log and decide whether to harden the hook | none | gap: out of scope |

## Gaps

- Review the miss rate: the log supplies the data. No tool summarises it, and the entry asks only for measurement to be possible.
