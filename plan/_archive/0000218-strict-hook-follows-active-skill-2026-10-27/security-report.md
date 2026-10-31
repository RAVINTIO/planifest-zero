# Security report - 0000218-strict-hook-follows-active-skill

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| None above informational. | `check-orchestrator-presence.mjs`, `auto-trigger-orchestrator.mjs`, `.gitignore` | none | Not needed. |

Checked and clean:

- Both hooks only read `plan/current-initiative/initiative.md`. They write nothing and exit 0 on every error.
- The status regexes are the ones the auto-trigger hook already used. They have no nested quantifiers.
- The feature id in the banner keeps its existing sanitising. The hooks print no file content beyond it.
- `plan/.initiative-ack` is now git-ignored, so a step session cannot commit the human's session id.
- No credential appears in the changed files.

Overall risk rating: low. Open risks: none.
