# Design - 0000039-setup-hardening-release-sizing

## Feature
- Problem: Setup leaks `settings.json` content on invalid JSON, keeps a stale single-object hook, and cuts deep settings on Windows. Discovery sizes every release with a fixed 3-story rule that no repo can change.
- Adoption mode: standard-iterative (assumed, the only signal: `plan/_archive/` and `docs/about.md`)
- Feature ID: 0000039-setup-hardening-release-sizing
- Version: 0.6.0 (minor: a new optional `product.yml` setting)
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001 (0000113): As a user with a malformed `settings.json`, I run setup, so that I get one clear error and none of the file's content reaches my logs.
  - US-002 (0000114): As a user whose hook entry holds one `hooks` object, I rerun setup, so that a stale Planifest command goes and each hook runs once.
  - US-003 (0000115): As a Windows user with deeply nested settings, I run `setup.ps1`, so that no nested value is cut.
  - US-004 (0000109): As a maintainer, I set `releaseSize` in `product.yml`, so that discovery fills each release to the budget I chose.
- Acceptance criteria confirmed: 8 (see `feature-brief.md`)
- Constraints:
  - Settings writes stay atomic (0000034 ADR-002).
  - Setup never logs `settings.json` contents (0000033 req-004).
  - The case-sensitive, path-boundary module match stays (0000035 S-004).
  - Both scripts stay at parity (0000035 ADR-001).
- Integrations: none

## Architecture Layer
- Latency target: not applicable (a local setup script and skill text)
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth. Setup edits only the consumer's own `settings.json`. The change removes the last path that printed its contents.
- Data privacy: no regulated data
- Observability: standard defaults. Setup prints its existing status lines and one new fixed error line.
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell (5.1 and 7), inline Node JavaScript, Markdown skills / GitHub Actions / Build target: local
- Components: `planifest-zero`, the framework. `setup.sh`, `setup.ps1`, the orchestrator skill, two feature brief templates, and their tests change.
- Data ownership: none. The consumer owns `.claude/settings.json` and `product.yml`.
- Deployment: ships as framework files. Consumers rerun setup.
- API versioning: not applicable

### Invalid JSON (req-001)
1. The hook install step catches the parse error in both scripts.
2. It prints one fixed line that names the file: `! Error: {path} is not valid JSON. Fix it and rerun setup.`
3. It leaves the file unchanged and exits 1.
4. The telemetry cleanup keeps its warn-and-continue behaviour.

### Single-object `hooks` (req-002)
1. If an entry's `hooks` value is one object, both scripts treat it as a one-item array.
2. The 0000038 per-command filter then applies.
3. If the command is a Planifest command, the entry goes. A user command keeps the entry as it was.

### Release size (req-004)

| `releaseSize` | Budget (points) |
|---------------|-----------------|
| `small` | 4 |
| `medium` (default) | 8 |
| `large` | 14 |

| Class | Files touched | Points |
|-------|---------------|--------|
| S | 1 to 2 | 1 |
| M | 3 to 6 | 2 |
| L | 7 or more | 4 |

Discovery sizes each candidate, recommends a fill up to the budget, and the human confirms. Above the budget, it recommends a split. An unknown value gets a note and the `medium` budget.

## Scope
- In:
  - The invalid JSON handling, the single-object `hooks` filter, and `-Depth 100` in `setup.ps1`.
  - The `releaseSize` setting, size classes, and budgets in the orchestrator skill.
  - The 3-story rule replaced in the orchestrator skill and both feature brief templates.
  - Cases in the `.sh` and `.ps1` suites, and a suite for the sizing text.
- Out:
  - The telemetry cleanup's error handling.
  - Other hook events.
  - Tooling that counts files automatically.
- Deferred:
  - Nothing deferred.

## Assumptions
- A file count estimated at discovery is close enough to size a release. Impact if wrong: a release runs over or under its budget, and the human corrects the fill at confirmation.

## Risks
- R-001 (technical, likelihood medium, impact medium): Windows PowerShell 5.1 unwraps a one-item array when it rebuilds `entry.hooks`. Mitigation: build arrays with `@()` and test on 5.1 in CI.
- R-002 (technical, likelihood low, impact high): a new error path prints file content. Mitigation: planted-value cases check stdout and stderr in both suites.
- R-003 (operational, likelihood medium, impact low): `pwsh` isn't installed locally, so only CI proves the `.ps1` suites. Mitigation: open a draft PR early so CI runs during implement.
- R-004 (process, likelihood low, impact low): this release scores 9 points against the medium budget of 8. The human confirmed the scope before the rule existed.

## Dependencies
- Upstream: none
- Downstream: every consumer that reruns setup, and every later discovery run

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| req-001 - invalid-json | planifest-implement | TDD change to both setup scripts, with planted-value cases |
| req-002 - single-object-hooks | planifest-implement | TDD change to the shared filter in both scripts |
| req-003 - ps1-json-depth | planifest-implement | TDD change to `setup.ps1`, with a deep-nesting case |
| req-004 - release-size-setting | planifest-implement | Skill and template text, with a suite that checks it |

## Repo Instructions
- custom-001: fetch, pull, push, and `gh pr create` without asking. Never commit to `main` and never merge.
- custom-002: prefer parallel subagents for independent work, or state why not.
- custom-003: `GUTD` means check out `main`, pull, and list untracked files.
- custom-004: in the ship phase, push the branch and tag and raise the PR. Never merge.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 19 Oct 2026 @ 01:34 a.m. UTC
