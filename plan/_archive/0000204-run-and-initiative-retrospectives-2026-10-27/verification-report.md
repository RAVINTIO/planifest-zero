# Verification Report - 0000204-run-and-initiative-retrospectives

Nothing needed starting. The change is Markdown and Bash tests, so each criterion ran as a test suite.

| Requirement | Criterion | Method | Outcome | Observation |
|-------------|-----------|--------|---------|-------------|
| REQ-001 | AC-1 skill exists and is short | `test-0000204-req-001-retrospective-skill.sh` | verified | 21 passed, 0 failed |
| REQ-001 | AC-2 skill states the method | Same suite | verified | Included in the 21 passes |
| REQ-001 | AC-3 records live outside the archive | Same suite | verified | Included in the 21 passes |
| REQ-002 | AC-1 ship writes the run retrospective | `test-0000204-req-002-hooks-and-reads.sh` | verified | 12 passed, 0 failed |
| REQ-002 | AC-2 delivery writes the initiative retrospective | Same suite | verified | Included in the 12 passes |
| REQ-002 | AC-3 P0 and chart read past records | Same suite | verified | Included in the 12 passes |
| REQ-003 | AC-1 the docs name the skill | `test-0000204-req-003-living-docs.sh` | verified | All checks passed |
| REQ-003 | AC-2 the count tests agree | Tests 0000031 req-003 and req-004, and 0000160 req-001 | verified | All pass with 15 skills |
