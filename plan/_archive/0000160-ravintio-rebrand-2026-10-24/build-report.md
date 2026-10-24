# Build report - 0000160-ravintio-rebrand

Source: the archived `build-log.md` in this folder.

## Agents and tiers

| Phase | Agents | Tiers | Parallel batches |
|-------|--------|-------|------------------|
| P0 Discovery | 2 | sonnet 2 (Explore surveys) | 1 |
| P1 Plan | 4 | sonnet 4 | 1 |
| P2 Implement | 4 | sonnet 4 | 1 parallel batch between two sequential ones |
| P3 Validate and Accept | 5 | opus 3 (security review, two fix agents), sonnet 2 | 1 |
| P4 Ship | 0 | none | 0 |
| Total | 15 | primary 3, cheaper 12 | |

The orchestrator itself ran on opus for the whole run. The security reviewer was resumed twice for independent re-reviews, so it counts once.

## Parallelism

- P0 ran two code surveys while the orchestrator wrote the sentinels and the build log.
- P1 drafted six requirements in two agents, beside the ADRs and the scope, risk, and glossary set.
- P2 batch 1 ran in sequence. One scripted pass renamed every path and token, and every other unit depended on it. Batch 2 ran four TDD tracks at once on disjoint files. Batch 3, the living docs, ran in sequence.
- P3 ran the security review, execution verification, and coverage audit at once, beside CI. The fix cycles ran in sequence, because each built on the last.
- P4 ran in sequence. Each step reads the output of the step before.

## Self-corrections

| Cycle | Fault | Avoidable? |
|-------|-------|------------|
| P1 | The consistency check read a cross-feature ADR number as local. | Yes. The drafting prompt did not mention the check's rule. |
| P2 batch 1 | Four suites read pre-rename history: a v0.4.0 tag folder, a byte fixture, and sibling repo allowlist entries. | Partly. The plan did not list tests that read git history. |
| P2 batch 2 | The pack source repo would run its own pending migration 0004. | Yes. The plan did not consider that the source repo self-hosts its migrations. |
| P2 batch 2 | Three suites failed after the tracks merged. | Partly. Tracks ran the full suite while others were mid-change. |
| P3 cycle 1 | Six criteria had no covering test. | Yes. The mechanical pass had no TDD track of its own. |
| P3 cycle 2 | Security: a High for a recursive delete that followed nested junctions on Windows PowerShell 5.1, plus a helper that never parsed. | Yes. `setup.ps1` already handled nested links, and REQ-005 named only a top-level link rule. |
| P3 cycle 3 | macOS Bash 3.2 hid lines from the local brand guard. The bulk rename had changed split old names. | Partly. Local and CI Bash versions differ, and no check flagged it. |
| P3 cycle 4 | The cycle 2 safety stops blocked normal upgrades. | Yes. Cycle 2 added stops instead of removing the delete. |
| P3 cycle 5 | Two more split old names. | Yes. A search of `main` for split literals would have found all four at once. |
| P3 cycle 6 | The two guard tests each needed an entry for the other. Human approved after the five-cycle stop. | Yes. The guard pair was not run with a Bash 3.2-safe reader before the push. |

## Deviations

- PR #25 opened as a draft during P3, so CI could run the PowerShell suites. `pwsh` is not installed locally.
- The harness shell defines a `grep` wrapper. Local suite runs from P3 used `env -i`, so no host function reached them.
- The release is far over the 8-point budget. It could not split.

## Improvement suggestions

- **P0:** for a rename, list every test that reads git history or builds old names from parts, and treat them as their own requirement.
- **P1:** state the consistency check's rules in every drafting prompt, including the ADR reference rule.
- **P2:** give a mechanical pass its own tests before the pass runs. Protect split literals with the same rule as other history names.
- **P3:** for a destructive helper, prefer a design that cannot destroy data over guards around the destroy step. Run the Bash suites under Bash 5 locally, or in CI before the first review.
