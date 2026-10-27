# Verification report - 0000198-cap-echoed-plan-text

**Method:** each check fed a JSON payload to `ravintio-zero/hooks/enforcement/ratchet-check.mjs` on stdin, as Claude Code does, or ran `ravintio-zero/scripts/consistency-check.mjs` on a fixture folder. A temporary project held the fixtures and was removed afterwards.

| Criterion | Method | Outcome | Evidence |
|-----------|--------|---------|----------|
| REQ-001 AC-1 long removed line | A loop was active and an edit removed a 5000-character criterion | verified | The `removed:` line printed 200 characters and ` …[truncated]`. The suite asserts exit 2 for a 1000-character line. |
| REQ-001 AC-2 short removed line | Edits that removed a 200-character line and a short line | verified | Both lines printed whole with no marker. |
| REQ-001 AC-3 existing behaviour | The existing ratchet suites | verified | Every existing suite passes. |
| REQ-002 AC-1 long label | Story map row with a 1000-character label, once with an empty Requirement cell and once with a dangling `REQ-009` | verified | Exit 1. Both findings hold 200 characters and the marker. |
| REQ-002 AC-2 short label | Labels of 200 characters and of 10 characters | verified | Both printed whole with no marker. |
| REQ-002 AC-3 existing behaviour | The existing consistency suites | verified | Every existing suite passes. |

**Extra checks in the new suite:** a line with an astral character at the 200th position keeps the character whole in both programs. Both programs print the same capped text for the same line.

**Full suite:** 172 feature suites and 19 regression suites pass.
