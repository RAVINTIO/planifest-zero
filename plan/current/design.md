# Design - 0000192-rename-runner-lock-and-archive

## Feature
- Problem: Two names for the charted unit still say "roadmap" after 0000189: the driver lock file and the delivery archive folder.
- Adoption mode: standard-iterative (signal: `plan/_archive/` holds prior runs, the latest 0000189-name-the-roadmap-initiative)
- Feature ID: 0000192-rename-runner-lock-and-archive
- Version: 0.19.0 (no bump. This run joins the unreleased 0.19.0 on PR #37, at the human's request.)
- Discovery: see `plan/current/discovery.md`

## Product Layer
- User stories:
  - US-001: As a maintainer, I find the driver lock at `plan/.initiative-runner.lock`, so that its name matches the other initiative names.
  - US-002: As a maintainer, I find a delivered initiative at `plan/_archive/{id}-{slug}-initiative-{date}/`, so that the archive name says what it holds.
  - US-003: As a maintainer, I get a failing test when either old name comes back, so that the rename stays complete.
- Acceptance criteria confirmed: 7 (see `feature-brief.md`)
- Constraints: no commits to `main`. Bash 3.2 and Windows PowerShell 5.1 compatibility. Existing archive folders keep their names.
- Integrations: none outside the pack. Inside it: the driver and the I-E Delivery stage in `roadmap-standards.md`.

### Names
| Today | New |
|-------|-----|
| `plan/.roadmap-runner.lock` | `plan/.initiative-runner.lock` |
| `plan/_archive/{id}-{slug}-roadmap-{date}/` | `plan/_archive/{id}-{slug}-initiative-{date}/` |

Unchanged: existing folders in `plan/_archive/`, such as `0000168-backlog-clearance-roadmap-2026-10-25`.

## Architecture Layer
- Latency target: not applicable (no runtime service)
- Availability target: not applicable
- Scalability target: not applicable
- Security: no auth surface. Data classification: internal pack source, no personal data.
- Data privacy: no regulated data.
- Observability: standard defaults. No label changes.
- Cost boundary: not constrained
- Rename completeness: 0 old names outside the allowlist, measured by the old-name guard
- Regression: full suite green on Linux, macOS, and Windows in CI, with no test removed

## Engineering Layer
- Stack: Markdown, Node.js ESM, Bash 3.2, PowerShell 5.1 and 7 / no database / no ORM / no IaC / no cloud / GitHub Actions CI / Build target: local
- Components: `ravintio-zero`, the pack
- Data ownership: `ravintio-zero` owns all pack files. No datasets.
- Deployment: consumers install the pack with `setup.sh` or `setup.ps1`.
- API versioning: not applicable. The delivery check reads both archive forms, so no migration is needed.

## Scope
- In:
  - The driver takes and releases `plan/.initiative-runner.lock` and adds it to `.git/info/exclude`.
  - I-E Delivery in `roadmap-standards.md` archives to `plan/_archive/{id}-{slug}-initiative-{date}/`.
  - The driver's delivery check accepts both the `-initiative-` and the `-roadmap-` folder forms.
  - The old-name guard flags both old names.
  - Tests and docs use the new names.
- Out:
  - Renaming existing archive folders.
  - A migration. The lock is transient and the delivery check reads both forms.
  - Backlog 0000190 and entries 0000174 to 0000186.
- Deferred: nothing deferred.

## Assumptions
- No driver is running while a consumer upgrades - impact if wrong: an old driver holding the old lock would not block a new driver. The window is one upgrade, so the impact is low.

## Risks
- A missed reference to the old lock leaves a driver that never releases its lock. Likelihood low, impact medium. Mitigation: the old-name guard and the existing lock tests.
- The delivery check misses an old archive folder and reruns a delivered initiative. Likelihood low, impact high. Mitigation: a test for each folder form.

## Dependencies
- Upstream: 0000189 (same branch)
- Downstream: the next initiative, charted after PR #37 merges.
- Approved dependencies: none

## Active Skills
None

## Skill Map
| Requirement | Best-fit Skill | Rationale |
|-------------|----------------|-----------|
| REQ-001 - runner lock | ravintio-test-writer, ravintio-implementer | Driver constant and lock tests |
| REQ-002 - archive folder | ravintio-test-writer, ravintio-implementer | Delivery check, standards line, and tests |
| REQ-003 - old-name guard | ravintio-test-writer | Two new patterns in the guard |

## Repo Instructions
- custom-001-local-git-only: fetch, pull, push, and `gh pr create` without asking. Work on a `feat/` branch with no worktrees. Committing to `main` and merging into `main` are human-only. Commit granularly.
- custom-002-prefer-subagent-decomposition: split long tasks into parallel subagents by default, and state the reason when work runs in sequence.
- custom-003-git-up-to-date-shorthand: "GUTD" means check out `main`, pull, and list untracked files.
- custom-004-ship-push-and-raise-pr: at ship, push and raise the PR without asking. Never merge into `main`.
- custom-005-delete-redundant-local-branches: delete merged or upstream-gone local branches with `git branch -D`.

## Confirmation
Human confirmed this design before proceeding: yes // Date and Time confirmed: 26 Oct 2026 @ 03:56 a.m. GMT ("First let's build 191 on this open branch and PR. Deliver it fast.")
