# Feature Brief - 0000192-rename-runner-lock-and-archive

## Problem

Feature 0000189 renamed the charted unit to "initiative". Two of its names still say "roadmap": the driver lock file and the delivery archive folder. Backlog entry 0000191 records them.

## User stories

| Name | Story | Priority | Order |
|------|-------|----------|-------|
| Runner lock | As a maintainer, I find the driver lock at `plan/.initiative-runner.lock`, so that its name matches the other initiative names. | must-have | 1 |
| Archive folder | As a maintainer, I find a delivered initiative at `plan/_archive/{id}-{slug}-initiative-{date}/`, so that the archive name says what it holds. | must-have | 1 |
| Guard | As a maintainer, I get a failing test when either old name comes back, so that the rename stays complete. | must-have | 2 |

## Acceptance criteria

1. The driver creates `plan/.initiative-runner.lock` while it runs and removes it when it stops.
2. A pre-existing `plan/.initiative-runner.lock` stops a second driver and stays untouched.
3. The driver adds `plan/.initiative-runner.lock` to `.git/info/exclude` once.
4. I-E Delivery names `plan/_archive/{id}-{slug}-initiative-{date}/`.
5. The driver treats an initiative as delivered when its archive folder uses the `-initiative-` form.
6. The driver still treats an initiative as delivered when its archive folder uses the `-roadmap-` form.
7. The old-name guard fails on either old name outside its allowlist.

## Stack

Unchanged from 0000189: Markdown, Node.js ESM, Bash 3.2, PowerShell 5.1 and 7.
