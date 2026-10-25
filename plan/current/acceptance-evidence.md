# Acceptance evidence - 0000185-explain-strict-mode

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 2 requirements, 6 criteria. Each requirement has a suite named for it: `test-0000185-req-001-strict-mode-section.sh` and `test-0000185-req-002-strict-mode-links.sh`. |
| Full Bash suite, local Bash 3.2 under `env -i` | 157 feature and 19 regression suites pass |
| Self-correction cycles | 0 |

## Execution evidence

All 6 criteria are `verified`. None failed, and none are `not-verifiable`. See `verification-report.md`.

- The hook ran in five states. Each output matched the section: silent with no active pipeline, a banner on a missing or different ack, silent on a match, and a timestamp request with no session id.
- All 14 claims in `project-operations.md:46-77` match their sources.
- `getting-started.md:103` and `README.md:96` link to `#strict-orchestrator-mode`, and `project-operations.md:46` holds the heading.

## Security

There are no critical, high, medium, or low findings. The overall rating is low.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 the section explains how the ack silences the banner | Informational | Accepted. Strict mode is a reminder, not an access control. |
| S-002 the suites read fixed repo paths | Informational | Accepted. |

No dependency, network call, hook, or credential joined the pack.

## Deviations

- Backlog entry 0000184 asked for a new subsection. `## Strict Orchestrator Mode` already followed the sentinel section, so the run rewrote it in place. See ADR-001.
- The new text adds two facts the entry's draft left out: the hook acts only while `plan/.orchestrator-active` exists, and it asks for a timestamp when it has no session id.
