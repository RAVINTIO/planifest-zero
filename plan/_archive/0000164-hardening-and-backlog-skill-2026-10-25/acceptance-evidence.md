# Acceptance evidence - 0000164-hardening-and-backlog-skill

## Checks

| Check | Result |
|-------|--------|
| Plan consistency check | Clean |
| Semantic coverage | 11 requirements, 27 criteria, each with a covering test |
| Bash suites, local Bash 3.2 under `env -i` | 119 feature and 19 regression suites pass |
| CI on PR #27 | All five jobs pass: `bash-suites`, both Windows PowerShell jobs, `validate-branch`, and `self-description-check` |
| Self-correction cycles | 2 in P3, plus 1 in P1 |

Cycle 1 shortened the `gate-write` bullet in `standard-boot.md` to fit the 0000151 size budget. Cycle 2 fixed security findings S-002, S-005, S-006, S-007, and S-008, and closed the REQ-003 b coverage gap.

## Security

There are no critical or high findings. The overall rating is medium before cycle 2 and low after it.

| Finding | Severity | Status |
|---------|----------|--------|
| S-005 setup removed user hook entries without a message | Medium | Fixed: one line per removed entry |
| S-006 backlog slug allowed `../` segments | Medium | Fixed: slug pattern and containment check |
| S-001 in-project symlink to outside passes `gate-write` | Low | Accepted in ADR-002 |
| S-002 Unicode NFD path read as outside | Low | Fixed: NFC normalisation |
| S-003 Windows 8.3 short names not expanded | Low | Open, Windows-only |
| S-004 non-string `file_path` exits 0 | Low | Accepted, existing fail-open design |
| S-007, S-008 target template and symlinked folders | Low | Fixed in the skill text |

## Execution evidence

- `gate-write`: 16 cases run through the hook in temp projects. The cases cover outside targets, symlinks both ways, `/tmp` aliasing, and the `plan/backlog/` and `plan/roadmap/` paths. Every exit code matched.
- Setup: a seeded temp consumer kept its telemetry sentinel, markers, and matcher entry. Setup removed the retired `phase-enum.mjs` hook and its settings entry.
- `ravintio-file-backlog`: followed by hand in three temp repos. It chose the right id, left HEAD, branch, and stash unchanged, and wrote nothing on a same-slug rerun.
- Not verifiable locally: the PowerShell side of REQ-004 and REQ-005. CI covers it, and both PowerShell jobs pass.

## Version

This release is 0.13.0. 0000160 is relabelled 0.12.0 (ADR-005). Ship tags `v0.12.0` and deletes `v1.0.0` from `origin`, as the human confirmed.
