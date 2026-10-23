---
title: "ADR 006: Self-confirmed roadmap steps and stage prefixes"
summary: "Inside an active roadmap, a step's P0 builds the brief from its backlog entries and self-confirms design and scope lock. R-A Chart confirmation is the single human approval. Stage prefixes R-A to R-E sit beside P0 to P4."
status: "accepted"
version: "0.1.0"
---
# ADR-006 - Self-confirmed roadmap steps and stage prefixes

**Skill:** [plan](../../../.claude/skills/planifest-plan/SKILL.md)
**Feature:** 0000043-autonomous-roadmaps
**Component:** planifest-zero
**Date:** 2026-10-23

## Context

P0 Discovery is interactive. It coaches the human to a confirmed design and a scope lock. A roadmap chain cannot run unattended if every step stops at P0 for the same two confirmations.

The human approves the whole chain once, at R-A Chart. That approval covers the steps, their order, their bumps, and their stop conditions. Each step also draws on backlog entries the human already filed and reviewed.

The roadmap stages also need message prefixes. The human first proposed `R-A Plan:` and then rejected it, because it clashes with `P1 Plan:`. The human chose `R-A Chart:`.

Hard Limit 10 fixes the phase numbers P0 to P4. The new labels must not read as new phases.

## Decision

**Self-confirmed P0.** Inside an active roadmap, a step's P0 builds the feature brief from the step's backlog entries. It then self-confirms the design and the scope lock. It records both as `draft-accepted (roadmap)` in the confirmation line. The design still follows the standard template, and the hooks still read it.

**Stop condition.** P0 stops only when an entry is too vague to draft from. It prints a `Blocked:` message that names the entry and the gap. The exception stops from the 0000042 run-mode ADR apply to every step.

**Single approval.** The human's confirmation at R-A Chart is the one approval for the chain. A runtime check reads `plan/current-roadmap/roadmap.md` with `status: active` before P0 may self-confirm. Outside an active roadmap, P0 keeps both human confirmations.

**Stage prefixes.** The stages use these prefixes beside the phase prefixes:

| Prefix | Stage |
|--------|-------|
| `R-A Chart:` | Write or pick up a plan, and approve it |
| `R-B Activate:` | Cut the roadmap branch and start the driver |
| `R-C Run:` | Run a step from P0 to P4 |
| `R-D Advance:` | Merge the step and move on |
| `R-E Delivery:` | Archive and raise the roadmap PR |

Both sets use the form `{prefix} {Status}: {one-liner}`. The letters A to E are stage letters, not phase numbers. The phases stay P0 to P4, so Hard Limit 10 holds.

## Alternatives Considered

| Alternative | Pros | Cons | Why Rejected |
|-------------|------|------|-------------|
| Keep human confirmation at every step's P0 | Highest control. No new rule | The chain stops at every step, so no run is autonomous | Fails the purpose of a roadmap. The human approved the chain at R-A Chart |
| Skip P0 and run P1 straight from the backlog | Fewer artifacts per step | P1 to P4 and the hooks need a confirmed design and a brief | Hard Limit 1 requires `plan/current/design.md` before code |
| Name the first stage `R-A Plan:` | Matches the natural word for the stage | Clashes with `P1 Plan:` in logs and searches | The human rejected it. `R-A Chart:` carries no clash |
| Use plain stage names with no letter prefix | Shorter messages | A reader cannot tell a stage from a phase, and search is harder | The human wants the two sets distinct and ordered |

## Affected Components

| Component | Impact |
|-----------|--------|
| planifest-zero | The orchestrator gains the self-confirm rule and the five stage prefixes. `pipeline-reference.md` lists both prefix sets. Hook text that checks the confirmation line accepts `draft-accepted (roadmap)` |

## Consequences

**Positive:**
- A chain of steps runs with no coaching stops after one human approval.
- A vague entry still stops the run, so the agent does not guess.
- Stage prefixes make roadmap lines easy to find and never clash with a phase prefix.

**Negative:**
- The agent confirms its own design inside a roadmap. A weak backlog entry can produce a weak design that no human reads before the PR.
- Readers now learn two prefix sets, and the stage letters sit beside the phase numbers.
- The confirmation line gains a second valid form, so any check on it must accept both.

**Risks:**
- A self-confirmed design might drift from what the human meant at R-A Chart. The roadmap PR review is the final check.
- A reader might take R-A to R-E for phases. The design states they are stage letters, and a test checks that no skill treats them as phase numbers.

## Related ADRs

- ADR-002 - depends-on (the roadmap state and `status: active` check come from ADR-002)
- ADR-004 - related-to (the driver depends on steps that need no human confirmation)
- ADR-005 - related-to (the step's Bump column feeds the version at P0)

## Supersedes

- None

## Superseded By

- None
