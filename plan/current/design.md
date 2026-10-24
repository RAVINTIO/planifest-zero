# Design - 0000160-ravintio-rebrand

## Feature
- Problem: The product joins the RAVINTIO ecosystem, but every path, name, and doc still says Planifest.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs and `src/` holds source)
- Feature ID: 0000160-ravintio-rebrand
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I find the pack at `ravintio-zero/` with `ravintio-*` skills, so that paths match the brand.
  - US-002: As a consumer, I get hooks, setup, and scripts that detect and write `ravintio` names, so that enforcement keeps working after the rename.
  - US-003: As a roadmap user, I set `RAVINTIO_*` variables, and my old `PLANIFEST_ROADMAP_*` values still work in 1.x.
  - US-004: As a reader, I see "RAVINTIO Zero" in every doc, skill, template, and message.
  - US-005: As a consumer, I run one migration that moves my overrides and workflow and removes old markers, so that my upgrade is safe.
  - US-006: As a maintainer, I get a failing test when "planifest" reappears outside history and the allowlist.
- Acceptance criteria confirmed: 5 (feature brief)
- Constraints:
  - Prose writes the brand as RAVINTIO in block caps: "RAVINTIO Zero", "RAVINTIO Framework".
  - Identifiers use lowercase `ravintio`. Environment variables use `RAVINTIO_`. OTEL labels use `ravintio.`.
  - `plan/_archive/`, `plan/changelog/`, and `ravintio-zero/migrations/_done/` stay as written.
- Integrations: GitHub org and repo rename, after merge.

## Architecture Layer
- Latency target: not applicable
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth change. The migration scripts refuse symlinked targets and never follow a planted link, as setup does.
- Data privacy: no regulated data
- Observability: OTEL labels become `ravintio.roadmap` and `ravintio.step`
- Cost boundary: not constrained

## Engineering Layer
- Stack: Bash, PowerShell 5.1 and 7, Node.js ESM, Markdown. CI on GitHub Actions. Build target local.
- Components: `ravintio-zero` (renamed from `planifest-zero`), the drop-in pipeline pack.
- Data ownership: none
- Deployment: consumers copy the pack folder and run setup
- API versioning: semantic versioning. 1.0.0 marks the breaking rename.

### Rename map

| Old | New |
|-----|-----|
| `planifest-zero/` | `ravintio-zero/` |
| `planifest-overrides/` | `ravintio-overrides/` |
| `planifest-*` skills | `ravintio-*` skills |
| `.github/workflows/planifest.yml`, `hooks/planifest.yml` | `ravintio.yml` |
| `refresh-planifest-zero-dir.ps1` | `refresh-ravintio-zero-dir.ps1` |
| `.planifest-setup-flags`, `.planifest-manifest`, `.planifest-session`, `.planifest-tmp` | `.ravintio-*` |
| `planifest-overrides:instructions` markers | `ravintio-overrides:instructions` |
| `planifest-em-dash-allow` | `ravintio-em-dash-allow`, with the old sentinel still accepted in 1.x |
| `PLANIFEST_*` | `RAVINTIO_*`. `PLANIFEST_ROADMAP_MODEL` and `PLANIFEST_ROADMAP_MAX_TURNS` stay as fallbacks in 1.x |
| `planifest.roadmap`, `planifest.step` OTEL labels | `ravintio.roadmap`, `ravintio.step` |
| `product.yml` and `component.yml` id `planifest-zero` | `ravintio-zero` |
| Test files named `*planifest*` | `*ravintio*` |
| `github.com/planifest/...`, `planifest.github.io/...` | `github.com/ravintio/...`, `ravintio.github.io/...` |

## Scope
- In:
  - The rename map above, across code, tests, CI, docs, skills, templates, and standards.
  - Setup cleanup of old marker files.
  - Migration `0004-ravintio-rename.md` with `migrate-ravintio-rename.sh` and `.ps1`.
  - A guard test, superseding the 0000042 ADR-004 allowlist approach for the brand word.
  - Version 1.0.0.
- Out:
  - History records: `plan/_archive/`, `plan/changelog/`, and `migrations/_done/`.
  - The sibling repos and their names.
  - The local clone folder.
  - Backlog items 0000095, 0000100, 0000110, and 0000159.
- Deferred:
  - The org rename. The human does it in GitHub org Settings. New-org links fail until it lands.
  - The repo rename. The agent runs `gh repo rename ravintio-zero` and updates `origin` after the human merges the PR and renames the org.

## Assumptions
- Sibling repos keep their repo names after the org rename. Impact if wrong: README links to them need a follow-up edit.
- GitHub Pages does not redirect `planifest.github.io`. Impact if wrong: none, because the links move to the new domain anyway.

## Risks
- A mechanical replace corrupts a file, such as the mojibake in `setup.ps1`. Likelihood medium, impact high. Mitigation: replace per token with byte-exact tools and run every suite on all three shells.
- A consumer runs the new setup before the migration. Likelihood medium, impact medium. Mitigation: setup detects a `planifest-zero/` or `planifest-overrides/` folder and tells the consumer to run the migration first.
- Old URLs break before the org rename lands. Likelihood high, impact low. Mitigation: the human renames the org soon after merge.

## Dependencies
- Upstream: none
- Downstream: installed consumer repos, the sibling repos' links
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - pack-identifiers | planifest-implement | Mechanical path and name rename with tests |
| REQ-002 - runtime-names | planifest-implement | Hook, setup, and script logic needs TDD |
| REQ-003 - environment-variables | planifest-implement | Fallback logic needs TDD |
| REQ-004 - brand-prose | planifest-implement | Prose pass across docs and skills |
| REQ-005 - consumer-migration | planifest-implement | New scripts on two shells need TDD |
| REQ-006 - brand-guard | planifest-implement | New allowlist test |

## Repo Instructions

### custom-001-local-git-only.md


### custom-002-prefer-subagent-decomposition.md


### custom-003-git-up-to-date-shorthand.md


### custom-004-ship-push-and-raise-pr.md


### custom-005-delete-redundant-local-branches.md


## Confirmation
Human confirmed this design before proceeding: pending
