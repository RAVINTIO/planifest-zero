# Acceptance evidence - 0000189-name-the-roadmap-initiative

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Library audit | No dependency added or changed |
| Semantic coverage | 9 requirements, 21 criteria. REQ-001 to REQ-008 each have a suite named `test-0000189-req-{NNN}-*.sh` that covers every criterion. REQ-009 maps to `test-0000151-req-014-chart-clarity-and-dependency-stop.sh:75`. |
| Syntax | `node --check` passes on the driver, labels, and `merge-guard`. `bash -n` passes on the migration helper and the new suites. The PowerShell helper parses with 0 errors. |
| Full Bash suite, local macOS | 165 feature and 19 regression suites pass |
| PowerShell suites, local pwsh 7 | 16 suites pass |
| Test files | 181 before, 189 after. None removed. |
| Old-name guard | 0 old names outside the allowlist |
| Self-correction cycles in P3 | 0 |

Windows PowerShell 5.1 runs in CI only.

## Execution evidence

All 21 criteria are `verified`. None failed, and none are `not-verifiable`. See `verification-report.md`.

- The driver read `plan/current-initiative/initiative.md` in a stub repo. It wrote `plan/.initiative-logs/step-1.log` with modes 700 and 600, and passed the `initiative` labels to a stub `claude`.
- `merge-guard` allowed a squash merge into `initiative/0000001-demo` (exit 0). It blocked `roadmap/0000001-demo` and `main` (exit 2).
- A `charted` status stopped the driver with an `I-C Run: Blocked:` line.
- Each of the four old variables stopped the driver with the new name, and no step spawned.
- Both migration helpers renamed a draft and the CI pattern. Each stopped on `plan/current-roadmap/` with no change, and a rerun changed nothing.
- A planted old name in a temporary copy failed the guard with its file and line.
- `.claude/skills/` matches `ravintio-zero/skills/` after setup.

## Security

The overall rating is low. There are no critical, high, or medium findings.

| Finding | Severity | Status |
|---------|----------|--------|
| S-001 `initiative-run.mjs:195` sets mode 700 only on a new log folder, so a renamed folder keeps its old mode | Low | Open |
| S-002 `initiative-run.mjs:194-202` has a gap between the symlink check and the open | Low | Accepted. It needs local write access. |
| S-003 `merge-guard.mjs:177` accepts any base that starts `initiative/`, as it did for `roadmap/` | Low | Accepted. No input reached `main`. |
| S-004 `migrate-initiative-rename.sh:100-101` and `.ps1:154` rewrite the workflow in place, and the steps are not atomic | Low | Accepted. Git restores the file. |
| S-005 `initiative-run.mjs:76` still names the lock `.roadmap-runner.lock` | Informational | Backlog 0000191 |

No credential joined the pack. The workflow files change only their trigger.

## Deviations

- The guard allowlists `plan/current/` as a third folder, because this run's plan artifacts name every old name. ADR-005 records it.
- The driver also drops the `PLANIFEST_ROADMAP_*` fallback. ADR-002 records it.
- The driver status check still accepts `draft` and `done`, so older initiative files still parse.
- The lock file and the delivery archive folder keep "roadmap", because the design Names table does not list them. Backlog 0000191 holds the follow-up.
- `test-0000151-req-011` raises its size cap from 35,484 to 35,600 bytes, and its fixture uses the new names.
