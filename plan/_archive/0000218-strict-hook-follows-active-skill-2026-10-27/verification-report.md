# Verification report - 0000218-strict-hook-follows-active-skill

## Setup

- Hooks run through `node` with a JSON payload on stdin, in temp workspaces with `RAVINTIO_INITIATIVE_STEP` cleared by `env -u`.
- `git check-ignore` runs in this repo.

## Criteria

| Criterion | Method | Outcome | Observation |
|-----------|--------|---------|-------------|
| AC-1 | Active initiative, lock free, strict and advisory | verified | Both hooks name `ravintio-initiative`. |
| AC-2 | Active initiative, lock held, with and without open step artifacts | verified | Both hooks name `ravintio-initiative`. |
| AC-3 | `RAVINTIO_INITIATIVE_STEP=1` with the lock held and free | verified | Both hooks name `ravintio-orchestrator`. |
| AC-4 | No initiative, lock free and held | verified | Both hooks name `ravintio-orchestrator`. |
| AC-5 | Each case runs both hooks and compares | verified | The two names match in all 14 cases. |
| AC-6 | `git check-ignore plan/.initiative-ack` | verified | Exit 0. `plan/.orchestrator-ack` stays tracked. |
