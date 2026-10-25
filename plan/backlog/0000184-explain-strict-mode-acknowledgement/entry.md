---
title: "Backlog Entry: 0000184 - explain strict mode and the acknowledgement file"
summary: "A human-requested docs fix, filed for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000184 - explain strict mode and the acknowledgement file

**Source feature:** none (human request)
**Source phase:** none (human request)
**Deferral source:** human request
**Date filed:** 2026-10-25

---

## Problem

No doc explains strict mode or `plan/.orchestrator-ack`. `getting-started.md` links "Orchestrator sentinel and strict mode" to the **Orchestrator Sentinel** section of `ravintio-zero/project-operations.md`, which mentions neither. "Ack" is networking jargon for an acknowledgement, and few readers would expect it as a file name.

## Suggested Action

Add this subsection to `ravintio-zero/project-operations.md`, after the **Orchestrator Sentinel** table. Also add `plan/.orchestrator-strict` and `plan/.orchestrator-ack` to the domain glossary, and point the `README.md` `--strict-orchestrator` row at the new subsection.

````markdown
### Strict mode and the session acknowledgement

Strict mode makes every session prove that it loaded the orchestrator. Turn it on with `setup.sh claude-code --strict-orchestrator`, or the same flag on `setup.ps1`. Setup then writes `plan/.orchestrator-strict`.

Proof works as a handshake:

1. On each prompt, the `check-orchestrator-presence` hook reads the session id that Claude Code passes to it.
2. If `plan/.orchestrator-ack` is missing or holds a different id, the hook prints a `RAVINTIO STRICT MODE` banner. The banner names the session id and asks the agent to load the orchestrator.
3. When the orchestrator loads, it writes that id to `plan/.orchestrator-ack`. The write acknowledges the banner, which is where the file gets its name.
4. While the file holds the current session's id, the hook stays quiet.

`plan/.orchestrator-ack` holds one line: the id of the session that last loaded the orchestrator. It is not a log or a lock. A new session finds an old id there and sees the banner again until its orchestrator loads.

Ship deletes the file with the other sentinels, before it raises the pull request. You never write it by hand.

In a roadmap run, each step session writes its own id. The session that started the driver then sees the banner on every prompt. Leave the file alone, because writing your own id replaces the step session's id. Backlog entry 0000182 covers this case.
````

## Wanted outcome

A reader of `project-operations.md` learns what strict mode does, what `plan/.orchestrator-ack` holds, why it has that name, and what to do in a roadmap run. A test checks that the subsection names both files and the `--strict-orchestrator` flag.

## Why Deferred

The human asked for it during roadmap 0000168 and added it as step 6.
