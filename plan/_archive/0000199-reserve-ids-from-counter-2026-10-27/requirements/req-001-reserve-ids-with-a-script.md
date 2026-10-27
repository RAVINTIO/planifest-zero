# Requirement: REQ-001 - reserve ids with a script

**Skill:** [plan](../skills/ravintio-plan/SKILL.md)
**Feature:** 0000199-reserve-ids-from-counter
**Source:** US-001
**Priority:** must-have

## User Story

As an agent that files an entry or starts a feature, I reserve ids from `plan/backlog/.next-id` with one script, so that two sessions never take the same id.

## Functional Requirements
- `ravintio-zero/scripts/reserve-id.mjs [qty] [--file path] [--init]` reserves `qty` ids, default 1, from the counter file. The default file is `plan/backlog/.next-id` under the current folder.
- To reserve, the script takes an exclusive lock beside the file, reads the next free id `n`, writes `n + qty`, releases the lock, and prints ids `n` to `n + qty - 1`, one per line, padded to the width of the file's number.
- The script writes the new value to a temporary file and renames it over the counter, so a failed write never truncates the counter.
- If the lock is held, the script retries for up to 5 seconds, then exits 1 and names the lock path.
- The script exits 1 and changes nothing if `qty` is not an integer from 1 to 1000, if the counter holds anything but digits, if the counter is a symlink, or if the new value overflows the width.

## Acceptance Criteria
- [ ] AC-1: reserve a block
  - Given the counter file holds 0000188
  - When the script reserves 4 ids
  - Then it prints 0000188 to 0000191 and the file holds 0000192
- [ ] AC-2: concurrent reservations
  - Given the counter file holds 0000100
  - When 8 reservations of 3 ids each start at once
  - Then the 24 printed ids are all different and the file holds 0000124
- [ ] AC-3: a failed reservation changes nothing
  - Given a held lock, a counter with letters, a symlinked counter, or a quantity of 0
  - When the script runs
  - Then it exits 1 and the counter file is byte for byte unchanged

## Dependencies
- None
