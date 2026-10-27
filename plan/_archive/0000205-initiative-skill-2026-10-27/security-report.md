# Security Report - 0000205-initiative-skill

## Findings

| Finding | Location | Severity | Mitigation |
|---------|----------|----------|------------|
| Watch script prints build log text | `ravintio-zero/scripts/initiative-watch.mjs` | Low | Each line is cut to 500 characters. The script prints only build log lines and commit subjects, and the credential stop covers committed files. |
| Driver runs `git show` with a branch name from `initiative.md` | `ravintio-zero/scripts/initiative-run.mjs` | Low | `spawnSync` takes an argument array, and the branch must match the existing `initiative/{id}-{slug}` pattern. |
| Archive path built from the step feature id | `ravintio-zero/scripts/initiative-run.mjs` | Low | The driver skips symlinks and ignores a real path outside `plan/_archive/`. |
| Hooks read sentinel files | `ravintio-zero/hooks/enforcement/*.mjs` | Low | Hooks only read files, never exit 2, and sanitise sentinel text. |
| `RAVINTIO_INITIATIVE_STEP` selects the loaded skill | `ravintio-zero/hooks/enforcement/auto-trigger-orchestrator.mjs` | Low | A wrong value loads a skill that shares the same hard limits. No guard changes. |

No finding rates critical or high. Overall risk: low. No guard weakens: `merge-guard`, `gate-write`, and `ratchet-check` are unchanged.

## Risk register

R-001 to R-005 stay open at their stated ratings. R-004 holds because the watch script cuts and limits its output.
