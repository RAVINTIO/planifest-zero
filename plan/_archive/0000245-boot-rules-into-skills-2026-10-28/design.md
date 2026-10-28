# Design - 0000245-boot-rules-into-skills

## Feature
- Problem: The generated `CLAUDE.md` holds 10,317 bytes and loads whole in every session, though many rules serve one task.
- Adoption mode: standard-iterative
- Feature ID: 0000245-boot-rules-into-skills
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I read the hook rules from one reference file, so that the boot file stays small.
  - US-002: As a repo owner, I name a pack skill in an override, so that setup appends the rule to that skill and not to the boot file.
  - US-003: As a human, I run `/gutd`, so that the sync rule loads only on demand.
  - US-004: As a maintainer, I see a test cap the generated `CLAUDE.md` at 6,000 bytes, so that overrides cannot regrow it.
- Acceptance criteria confirmed: 5 (the entry's Wanted outcome)
- Constraints: No step may widen `merge-guard`, `gate-write`, or another fail-closed hook. Bash and PowerShell setup stay in parity. Boot files stay disposable build outputs (0000029 ADR-001).
- Integrations: none

## Architecture Layer
- Latency target: deferred - recorded in scope
- Availability target: deferred - recorded in scope
- Scalability target: deferred - recorded in scope
- Security: No auth. The override `target:` value must match `^[a-z0-9][a-z0-9-]*$` and name an installed skill folder, so a value cannot reach outside the skills directory. Data classification: none.
- Data privacy: no regulated data
- Observability: standard defaults
- Cost boundary: not constrained
- Measurable target: generated `CLAUDE.md` is 6,000 bytes or fewer with every override in force.

## Engineering Layer
- Stack: bash, PowerShell, Node.js (`.mjs` hooks), Markdown. CI: GitHub Actions. Build target: none.
- Components: `ravintio-zero` (single component). Changes: `setup.sh`, `setup.ps1`, `templates/standard-boot.md`, `templates/codex-boot.md`, enforcement hooks (message text only), a new `standards/hook-enforcement.md`, and the repo's `ravintio-overrides/`.
- Data ownership: no datasets.
- Deployment: files installed by setup.
- API versioning: not applicable

## Component Paths
- ravintio-zero/standards
- ravintio-zero/templates
- ravintio-zero/hooks
- ravintio-zero/tests
- ravintio-zero/setup.sh
- ravintio-zero/setup.ps1
- ravintio-overrides
- docs

## Scope
- In:
  - `ravintio-zero/standards/hook-enforcement.md` holds the Hook Enforcement rules. Both boot templates point to it.
  - Each blocking hook message (`gate-write`, `ratchet-check`, `merge-guard`, `em-dash-guard`) and the `commit-msg` git hook name that file.
  - `target:` frontmatter in an override. Setup (bash and PowerShell) appends it between markers to the installed target skill. An invalid or missing target warns and falls back to the boot file.
  - Overrides retargeted: 002 to `ravintio-orchestrator`, 004 to `ravintio-ship`, 006 to `ravintio-refresh-setup`.
  - Capability skills `gutd` and `delete-redundant-branches` replace overrides 003 and 005. 003 and 005 are deleted.
  - A test caps the generated `CLAUDE.md` at 6,000 bytes. `test-0000151-req-014` ignores appended override blocks.
- Out: regenerating this repo's `CLAUDE.md` and `.claude/skills/` (step 15). Changing what `merge-guard` allows.
- Deferred: nothing deferred.

## Assumptions
- A pack skill installs as `{skills dir}/{name}/SKILL.md` - impact if wrong: the append target path fails and setup falls back to the boot file.
- The entry's "pack-only cap" revert is already done by 0000242 - impact if wrong: the pack cap needs a second edit.

## Risks
- A skill-appended override doubles on re-run. Likelihood medium, impact medium. Mitigation: marker-delimited block removed before each append, tested.
- Tests that read boot text break after the move. Likelihood high, impact low. Mitigation: update expected locations and log rework.

## Dependencies
- Upstream: none
- Downstream: step 15 regenerates the install and checks the 6,000-byte cap again.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - hook enforcement reference | ravintio-implement | docs and message text |
| REQ-002 - targeted overrides | ravintio-implement | setup change in two shells |
| REQ-003 - repo skills | ravintio-implement | new skill files and deletions |
| REQ-004 - size cap tests | ravintio-implement | test work |

## Repo Instructions
See `ravintio-overrides/instructions/` (custom-001 to custom-006). Step 7 retargets or replaces five of them.

## Confirmation
Human confirmed this design before proceeding: draft-accepted (initiative) // Date and Time confirmed: 28 Oct 2026 @ 06:50 PM UTC
