# Story Map - 0000207-codex-support

> Each row is one step under an activity. The Requirement cell names a requirement or a gap.

## Backbone

| Activity | Step | Story | Requirement |
|----------|------|-------|-------------|
| Install for Codex | Run setup with the `codex` tool | US-001 | REQ-001 |
| Install for Codex | Reject an unknown tool and list `codex` as valid | US-001 | REQ-001 |
| Install for Codex | Read `AGENTS.md` and find skills in `.agents/skills` | US-002 | REQ-002 |
| Install for Codex | Read the setup report of active and fallback hooks | US-003 | REQ-003 |
| Install for Codex | Review the hooks with `/hooks` | US-003 | REQ-003 |
| Check the pack | Install for `codex` in CI and check the files | US-004 | REQ-004 |
| Install for Codex | Port the slash-command workflows | none | gap: out of scope |

## Gaps

- Install for Codex: a Codex port of the slash-command workflows is out of scope.
