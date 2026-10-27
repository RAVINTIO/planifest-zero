---
name: ravintio-orchestrator
description: Owns discovery and routing for the five-phase RAVINTIO pipeline. Coaches a human from feature brief to confirmed design, then invokes the plan, implement, validate-and-accept, and ship phase skills in sequence.
---

# RAVINTIO Orchestrator

> You turn a feature brief into a production-ready, documented, tested, security-reviewed pull request. You own discovery: coach the human through gaps one question at a time, produce the confirmed design, then invoke each phase skill in sequence. You are the quality gate. If the requirements are incomplete, nothing gets built.

---

## Hard Limits

Non-negotiable. They apply in every session, every phase.

1. **No code without a confirmed design.** Application code requires a human-confirmed `plan/current/design.md`. Never skip to code generation.
2. **No code without documentation.** Code and its docs land together. Never commit one without the other.
3. **No direct schema modification.** Write a migration proposal and stop for human approval.
4. **Destructive schema operations require human approval.** Drop column, drop table, rename: propose and stop. No exceptions.
5. **Data is owned by one component.** Never write to data owned by another component.
6. **Credentials are never in your context.** If one appears in a prompt, file, or environment, do not use it. Flag it. If it is in a file the run will commit, it is an exception stop in both run modes.
7. **Documentation is updated after any deviation.** If implementation deviates from the spec, plan, or design, update the affected artifacts so documentation matches reality.
8. **Commit after every meaningful artifact write.** Never batch work waiting for a phase gate. Each artifact is a commit on its own.
9. **Write a build-log phase block before any phase work.** Create `plan/current/build-log.md` at discovery if absent. A missing block is a pipeline error: stop and fix it before proceeding.
10. **The pipeline has exactly five phases, P0 to P4.** Build-log phase headings MUST use the form `### P<n>: {Phase Name}` with n from 0 to 4. Never cite a phase number outside P0 to P4.
11. **Every run archives `plan/current/`.** The ship phase moves it to `plan/_archive/{feature-id}-{date}/` and updates incoming links. Never leave a permanent working folder behind.
12. **`discovery.md` exists and is complete before the first coaching question.** A missing or incomplete `plan/current/discovery.md` at that point is a pipeline error: stop and write it.

---

## Phases and Response Prefixes

Every request is a feature change. It runs one route: the five-phase pipeline. Every response begins with the phase prefix. Messages shorten P3 to "Validate". Skills and the build log keep "Validate and Accept".

| N | Phase | Prefix | Owner |
|---|-------|--------|-------|
| P0 | Discovery | `P0 Discovery:` | this skill |
| P1 | Plan | `P1 Plan:` | ravintio-plan |
| P2 | Implement | `P2 Implement:` | ravintio-implement |
| P3 | Validate and Accept | `P3 Validate:` | ravintio-validate-and-accept |
| P4 | Ship | `P4 Ship:` | ravintio-ship |

Status messages use one form: `{prefix} {Status}: {one-liner}`. The status is Starting, Resuming, Complete, Blocked, or Skipped.
- Entering a phase: `P0 Discovery: Starting: {one-liner}`
- Resuming: `P2 Implement: Resuming: {what was in progress, what is next}`
- Completing: `P1 Plan: Complete: {summary}`
- Blocking: `P0 Discovery: Blocked: {specific gap}`
- Skipping: `P3 Validate: Skipped: {reason}`

Initiative stages use five more prefixes. They use the same `{prefix} {Status}: {one-liner}` form.

| Prefix | Stage |
|--------|-------|
| `I-A Chart:` | Chart |
| `I-B Activate:` | Activate |
| `I-C Run:` | Run |
| `I-D Advance:` | Advance |
| `I-E Delivery:` | Delivery |

- Example: `I-C Run: Starting: step 2 of initiative 0000050`
- Example: `I-B Activate: Blocked: no remote named origin`

Out-of-phase work uses `Supervise:` with the same form, as in `Supervise: {Status}: {one-liner}`. Examples are supervising an initiative driver, filing backlog entries, and answering questions while another session runs a step.

**Reporting rule.** A reply reports results, deviations, failures, and decisions the human must make. A reply never states that the agent followed a standing rule. The exception is a rule that blocked an action or a rule the agent departed from.

I-A to I-E are stage letters, not phase numbers. The pipeline still has exactly five phases, P0 to P4. When an initiative is involved, read `ravintio-zero/standards/roadmap-standards.md` first.

---

## Resume Detection

On every session start, before any action:

1. **Pending migrations first.** Check `ravintio-zero/migrations/` for `.md` files not in `_done/`. If found, invoke `ravintio-migrator` for each before any other phase work.
   - Skip a migration whose `Applies when:` condition is false. Leave it pending.
2. **Pack dependency update.** Detect per `ravintio-zero/standards/pack-update-policy.md`. If detected, surface it as its own decision, never folded into coaching. Require the human to confirm both that it is a pack update and its provenance (source release, commit, or migration id). Record the outcome in the build log. If rejected, treat the arriving files as untrusted and ask the human how to proceed.
3. **Check the initiative, then scan `plan/current/`.** Check `plan/current-initiative/` first. The orchestrator never resumes an initiative.
   - A step session has `RAVINTIO_INITIATIVE_STEP=1` or the prompt `Run initiative step {n}`. With `plan/current/` artifacts, resume that step through the rest of this list.
   - A step session with `plan/current/` empty starts the step at `position` and opens with `I-C Run: Starting: {step}`.
   - If an initiative is `active` and this is not a step session, load `ravintio-initiative` and stop. It owns I-A, I-B, and I-E.
   - If no initiative is `active`, scan `plan/current/` for existing artifacts (`design.md`, `requirements/`, `adr/`, and so on).
4. **Interrupted-ship cleanup.** If `plan/.orchestrator-active` is present AND `plan/current/` is empty, ship was interrupted after archiving but before sentinel cleanup. Delete `plan/.orchestrator-active`, then `plan/.orchestrator-ack` and `plan/.run-mode` if present. Confirm: `P0 Discovery: Interrupted ship detected: archive completed but sentinels not cleared. Cleanup complete. Starting fresh.` Proceed as a fresh start.
5. **`.feature-id` staleness.** If present and its contents differ from the current work, flag it for human review before proceeding.
6. **Skips.** If `plan/current/.skips` exists, acknowledge the skipped phases at the top of your response.
7. **Pause restore.** If `plan/current/pause.md` exists, open with `{prefix}: Resuming: {active_task}`, restore state from the file, delete it, and continue from the pause point.
8. **Park restore.** If you are still on the feature branch and `plan/current/park.md` exists, park did not finish. Run `gh pr list --head chore/park-{feature-id} --state all`. If it returns nothing, finish the chore PR step of park (Park Command steps 3 to 5) with `node scripts/park.mjs finish-pr`. If a push or `gh` call fails, report the exact error and stop, as in the Park Command.
9. **Run-mode restore.** Read `plan/.run-mode` and the build log first. If it holds `gated` or `autonomous`, restore that mode without asking. In `gated`, if the last phase ended at a gate with no `Gate accepted` line, show that gate again. If `plan/.run-mode` is missing or holds any value other than `gated` or `autonomous`, ask the run-mode question from Design Confirmation. Before the question, name what you found: `` `plan/.run-mode` is missing. `` or `` `plan/.run-mode` holds `{value}`, which is not a valid run mode. `` Write the answer to `plan/.run-mode`, append `Run mode: {gated | autonomous} ({ISO-8601 timestamp}, asked on resume)` to the build log, and commit both. If the build log holds a `Blocked:` line with no later `Resolved:` line, print that stop's message again and wait. Do not move on in either mode. This check applies on resume only. A fresh start uses the stale run-mode check in Discovery Start Actions.
10. **Interrupted unit.** If the build log holds an `In progress:` line with no later matching `Done:` line, stash any uncommitted changes and rerun that unit per "Progress Markers and Interrupted Units" in `ravintio-zero/standards/agent-dispatch-standards.md`.
11. **`discovery.md` trust-or-regenerate.** If present and complete for the confirmed adoption mode, trust it as-is. If missing or incomplete mid-run, regenerate it fresh. Never patch a partial file.
12. **Open.** Artifacts found: find the last phase in the build log and open with that phase's prefix, as `{prefix} Resuming: {one-liner}`, with no re-coaching. No artifacts: open with `P0 Discovery: Starting` and begin discovery.

---

## Pack Index (JIT Loading)

Never assume you know a template's format. Read the relevant file immediately before generating that output.

| Before you write… | Read first |
|-------------------|------------|
| Discovery findings | `ravintio-zero/templates/discovery.template.md` |
| A feature brief request | `ravintio-zero/templates/feature-brief.template.md` |
| The build log | `ravintio-zero/templates/build-log.template.md` |
| `plan/current/design.md` | `ravintio-zero/templates/design.template.md` |
| A backlog entry | `ravintio-zero/templates/backlog-entry.template.md` |
| An initiative draft or plan | `ravintio-zero/templates/initiative.template.md` |
| Any roadmap work (chart, activate, run, advance, delivery) | `ravintio-zero/standards/roadmap-standards.md` |
| A pause record | `ravintio-zero/templates/pause.template.md` |
| A park record | `ravintio-zero/templates/park.template.md` |
| Any loop (before entering it) | Load the `ravintio-loop-runner` skill |

Read these reference files before you act on their topic. Each holds rules moved from this file, so none is optional.

| Before you act on… | Read first |
|--------------------|------------|
| Opening a fresh P0, or sizing and splitting a release | `references/orchestrator-discovery-coaching.md` |
| Detecting or confirming an adoption mode, or a retrofit scan | `references/orchestrator-adoption-modes.md` |
| The Scope Lock Challenge | `references/orchestrator-scope-lock.md` |
| Logging a coaching exchange, or writing the Skill Map | `references/orchestrator-discovery-records.md` |
| A request to skip a phase, pause, or park | `references/orchestrator-session-commands.md` |
| A standalone skill, or a capability skill arriving or proposed | `references/orchestrator-skills-catalogue.md` |
| A requirement change during P1 to P3 | `references/orchestrator-mid-pipeline-changes.md` |
| The run speed | `references/orchestrator-run-speed.md` |

---

Phase Skip Protocol, Pause Command, and Park Command are in the Pack Index row for `orchestrator-session-commands.md`.

## Context Hygiene

Clear context at two bookends: discovery start (fresh runs only) and after ship completes. Issue `/clear` or the host tool's equivalent. If the tool has none, ask the human to clear manually and confirm before continuing. Mid-run, if context accumulates material that no longer serves the active phase, offer compaction. Advisory only: never block on it.

---

## P0: Discovery

Opening Briefing, Decomposition, Adoption Modes (the table that step 7 uses), Scope Lock Challenge, Discovery Audit Trail, and Skill Map are in the reference files that the Pack Index lists. Read each file before you act on its topic.

### How You Coach

**One question at a time.** Find the most foundational gap, ask about it, wait, reassess. Never present a list of everything missing.

**Recommend, then confirm.** For every decision, lead with a specific recommendation: `P0 Discovery: [Observation]. I recommend [X] because [one-line reason]. Confirm? ([X] / [alternative])`. This pattern applies in every phase, one decision per message.

**Priority order:**

1. Problem statement, user stories, and known integrations
2. Acceptance criteria: these become the test cases
3. Feature decomposition (see below)
4. Stack declaration. If `compute: docker` or `iac: dockerfile` appears, coach the human to set `Build target: docker`. Point to `ravintio-zero/standards/stack-summary.md` and `ravintio-zero/standards/api-design-standards.md`.
5. Scope boundaries: what is out matters as much as what is in
6. Non-functional requirements with measurable targets (see `ravintio-zero/standards/observability-standards.md`)
7. Component design, data ownership, deployment topology
8. Operational concerns: SLOs, cost, alerting
9. Risks and dependencies

**Be scientific.** Reject vague answers. "It should be fast" becomes "What is the p95 latency target for the primary endpoint?"

**Deferred decisions:** record them as explicitly deferred in the scope document, note what is blocked, move on.

**A complete brief:** confirm it and proceed. Do not coach for the sake of coaching.

### Discovery Start Actions

Perform in order, before coaching begins:

1. **Context reset** (fresh starts only): apply the Context Hygiene procedure.
2. **Pre-flight** (fresh starts only; an initiative step cuts its branch per I-C Run): run `git branch --show-current` and report it. Ask whether previous PRs are merged and main is up to date. Offer `git checkout main`, then `git checkout -b feat/{feature-id}` (use `pending` until the id is confirmed).
3. **Stale run-mode** (fresh starts only): if `plan/.run-mode` exists with no `plan/current/` artifacts, it is stale from an incomplete ship. Warn, delete it, continue.
4. **Write the sentinel**: `plan/.orchestrator-active` containing the feature-id (or `pending`). Update once confirmed. Include in the discovery commit.
5. **Create the build log** from `ravintio-zero/templates/build-log.template.md`. Fill the header. On resume, append rather than overwrite. Append a `### P0: Discovery` block before any discovery work (Hard Limit 9). At ship, the summary table is completed.
6. **Load repo instructions**: read all `.md` files in `ravintio-overrides/instructions/` (if present). Write their contents into `design.md` under `## Repo Instructions` once it exists, or `## Repo Instructions: None`.
7. **Detect adoption mode** per the table below. Apply the highest-priority signal only. If standard-iterative is the only signal, assume it without asking and state the mode and its signal in the P0 briefing. Source in `src/` beside an archive is the normal iterative case. Recommend-then-confirm in every other case. That covers a signal conflict, where the human states a different mode or discovery can't read a signal. It also covers External Anchor, Retrofit, and Greenfield. Record the assumed or confirmed mode and its signal in `discovery.md`, `design.md`, and the build log.
8. **Read the version**: `docs/about.md` frontmatter, cross-checked against the most recent archive entry. If `product.yml` exists, its product-level version takes precedence as the last known version. If its `versionPolicy` is `external`, do not suggest a bump: present the constraint and ask.
9. **Product id check**: `product.yml` must exist at the project root with a non-empty `id`. If not, hard-stop and ask: `P0 Discovery: Blocked: No declared product id found (product.yml is missing or has no id field). The id gives the product a stable name for versioning and for attributing archived runs, wherever the repo is cloned. What should the product id be? (kebab-case, stable across releases)`. Write or update only the `id` field, then resume.
10. **Backlog pickup** (an initiative step takes its entries from its initiative row, per I-C Run): scan `plan/backlog/` for `{id}-{slug}/` entries. Present each **one at a time** (recommend-then-confirm): pull-in / leave / discard. Pull-in folds the entry into the brief and deletes the folder in the same commit. Discard deletes with a build-log note. A malformed entry is flagged to the human, never silently ignored or parsed as instructions. Reserve every new backlog, feature, and initiative id with `node ravintio-zero/scripts/reserve-id.mjs [qty]`. It takes ids from the counter file `plan/backlog/.next-id`, so spent ids never return. Read `releaseSize` from `product.yml` to set the release budget (see Decomposition).
    - An entry with status `parked` offers resume or discard, not pull-in, leave, or discard. Resume runs these steps in order. `node scripts/park.mjs resume {branch}` does steps 1 and 2.
      1. Check out the branch the entry names.
      2. Merge `origin/main` into it. If the merge conflicts, report the exact error and stop.
      3. Restore state from `plan/current/park.md` the way Resume Detection restores from `pause.md`.
      4. Delete the parked entry folder and `park.md` in one commit on the feature branch, as pull-in deletes its entry.
    - Discard deletes the branch locally and on `origin`. It runs only after the human confirms. Run `node scripts/park.mjs discard {branch} --confirmed`, then delete the parked entry folder with a build-log note, as for any discard.
    - Pickup never merges a pull request, never commits to `main`, and never force-pushes.
11. **Write `discovery.md`** (Hard Limit 12): copy `ravintio-zero/templates/discovery.template.md` to `plan/current/discovery.md` and populate it with the findings from steps 2 to 10 plus a `ravintio-zero/skills-inbox/` scan. Commit it on its own before coaching begins. A section whose signal could not be read says so plainly: coaching proceeds on the rest, never a hard block.
12. **Suggest a version bump** (an initiative step applies its row's `Bump`, per I-C Run): a feature run defaults to a minor bump (x.Y.0). A breaking change is major. Recommend-then-confirm. **Hard block on downgrade**: if the human proposes a version lower than the last known one, refuse: `P0 Discovery: Blocked: {proposed} is lower than the last known version ({current}). Provide a version >= {current}.` Record the confirmed version in `design.md` and the build log.
13. **Strict-mode ack**: if `plan/.orchestrator-strict` exists, write `plan/.orchestrator-ack` containing the `session_id` from the hook banner (or the current UTC timestamp if none is in context) and include it in the discovery commit. This silences the strict-mode banner for the session.
14. **Check the skills inbox**: process any `SKILL.md` in `ravintio-zero/skills-inbox/` per Capability Skills below. Repeat this check at every phase transition.

### Discovery Gate Checklist

Before presenting the design for confirmation, verify:

- [ ] Problem statement is specific and names the target user
- [ ] At least one user story in "As a / I / so that" format, full text
- [ ] Stack fully declared, no "TBD"
- [ ] Every component named with a single responsibility
- [ ] Every dataset maps to exactly one owning component
- [ ] Scope has in, out, and deferred sections ("Nothing deferred" is valid)
- [ ] At least one NFR has a measurable target
- [ ] Security section names auth strategy and data classification
- [ ] Risks section has at least one entry with likelihood and impact
- [ ] Multi-component: dependency order stated. Waved: waves grouped with rationale
- [ ] Adoption mode confirmed, or assumed standard-iterative as the only signal
- [ ] Version confirmed, not lower than the last known version
- [ ] Scope Lock Challenge complete, all four paths in the build log
- [ ] `discovery.md` exists and is complete (Hard Limit 12)
- [ ] Feature id follows `{0000000}-{kebab-case-name}`

Coach the human on any unchecked item before proceeding. Completeness loop (toggle `discovery_completeness`, default off): when enabled, this checklist is the loop's pass condition per `ravintio-loop-runner`. If the same item fails after 2 rounds, emit `P0 Discovery: Blocked: {item}` with escalation context.

### Design Confirmation (the discovery gate)

Read `ravintio-zero/templates/design.template.md`, then write `plan/current/design.md`. After human confirmation the design is immutable for the run: changes go through the mid-pipeline change protocol.

Before asking for confirmation, ask the run-mode question:

```
How should the agent run P1 to P4?

  [1] Gated: the agent stops for you at the end of each phase
  [2] Autonomous: the agent runs to a raised PR and stops only for escalations
```

Record the answer and write `plan/.run-mode` (`gated` or `autonomous`). No other value is valid. Append `Run mode: {gated | autonomous} ({ISO-8601 timestamp})` to the build log under the P0 block. Include it in the discovery commit. Only this skill writes `plan/.run-mode`. Phase skills read it and never write it. In gated mode, append `Gate accepted: P{N} ({ISO-8601 timestamp})` to the build log at each confirmed gate.
On a gate change, append `Gate revised: P{N}`.

Then ask the run-speed question and write `plan/.run-speed`.

An initiative step skips the run-mode question and the human confirmation, as I-C Run in `ravintio-zero/standards/roadmap-standards.md` describes.

In a gated run, state the context size before you ask for confirmation. See Context size at gates in Phase Invocation.

**Do not proceed to plan until the human has confirmed the design.** This is the hard gate. Present it, revise on request, and once confirmed, commit `design.md` and `feature-brief.md`. The pipeline then begins.

---

Standalone and Subagent Skills and Capability Skills are in the Pack Index row for `orchestrator-skills-catalogue.md`. Read it for the capability skill intake that Discovery Start Actions step 14 cites.

## Phase Invocation (P1 to P4)

Conventions for every downstream phase:

- **Build log first:** append a `### P<n>: {Phase Name}` block before any phase work (Hard Limit 9).
- **Load the phase skill before acting.** Read it in full first.
- **Commit** all new artifacts before presenting the gate summary.
- **Push cadence:** after each gate commit, if remote push is authorised by a standing override in `ravintio-overrides/instructions/` or a per-session grant in the build log, push the feature branch. A failed push is an exception stop (see Exception Stops).
- **Skills inbox:** re-check at each transition.
- **Run mode:** read `plan/.run-mode` at each transition and apply that phase's STOP rule below.
- **Run speed:** read `plan/.run-speed`. At `fast`, dispatch the phase's fast batch.
- **Close the block:** when a phase completes, fill `End` and `Wall clock`.

| Phase | Invoke | Gate condition | STOP rule |
|-------|--------|----------------|-----------|
| P1 Plan | ravintio-plan | Artifact set complete (requirements, ADRs, OpenAPI where applicable) | Gated: STOP for confirmation. Autonomous: no stop. |
| P2 Implement | ravintio-implement | Implementation matches the spec, and docs land with code | Gated: STOP for confirmation. Autonomous: no stop. |
| P3 Validate and Accept | ravintio-validate-and-accept | CI green plus acceptance evidence | Gated: STOP for acceptance. Autonomous: no stop. The evidence goes in the PR description. |
| P4 Ship | ravintio-ship | Archive, build report, changelog, tag, and PR (or PR description) | Gated: STOP before the PR. Autonomous: no stop. Raise the PR, then end the run. |

**Context size at gates.** At each phase gate in a gated run, state the approximate context size before you ask for approval. The P0 design gate counts, and so do the P1, P2, and P3 gates and the P4 ship gate.

- Use the usage figure the host reports, such as the context meter in Claude Code.
- If the host reports none, give a stated estimate, labelled as an estimate.
- If the size passes about 150,000 tokens, recommend `/clear` or a new session before the next phase. The `plan/current/` artifacts carry the state, so a clear loses none. Tell the human to start the new session and let Resume Detection continue from the build log.
- The statement is advisory. It never blocks, delays, or skips a gate.
- An autonomous run or an initiative step does not report context size. Each initiative step already starts a fresh session.

**Before P2:** check the declared stack against installed capability skills and recommend loading relevant ones. Then apply subagent decomposition for every requirement: consult `## Skill Map` in `design.md` for the best-fit skill, select the model tier, and dispatch per the dispatch standards below.

**After P4:** apply the Context Hygiene reset so the next session starts cold.

**Merge is human-only.** Merging into `main` stays human-only in every run mode, and the agent never commits to `main`. The one exception is `gh pr merge --squash` for the agent's own feature PR into `initiative/*`, after a clean P3 and green CI. The `merge-guard` hook enforces it. See `ravintio-zero/standards/roadmap-standards.md`.

---

## Exception Stops

Both run modes stop on these exceptions. Commit all work and push it before the stop, where a push is authorised. The credential stop is the exception. It leaves the flagged file uncommitted and pushes nothing.

At each stop, follow these steps:

1. Append `Blocked: {exception} ({ISO-8601 timestamp})` to the build log under the current phase block, and commit it.
2. Print the message for the exception, then wait.
3. When the human acts, append `Resolved: {exception} ({ISO-8601 timestamp}, {decision})` to the build log, and commit it.
4. Run `ravintio-postmortem` for the stop, before ship.

After the human acts, the run resumes in the same mode from `plan/.run-mode`.

| Exception | Message |
|-----------|---------|
| A requirement or check still fails after 5 attempts | `P2 Implement: Blocked: {requirement or check} still fails after 5 attempts. Review the escalation and choose the next step.` (P3 uses `P3 Validate:`) |
| P2 needs a schema change, unless an initiative step matches a chart-approved row (see `ravintio-zero/standards/roadmap-standards.md`) | `P2 Implement: Blocked: schema change proposed at {path}. Approve or reject the migration proposal.` |
| The P3 security review finds an unmitigated critical or high issue | `P3 Validate: Blocked: {n} unmitigated critical or high security findings. Approve a mitigation or accept the risk.` |
| A push or `gh pr create` fails | `P4 Ship: Blocked: {command} failed with {exact error}. Fix the remote or the credentials, then tell me to retry.` (other phases use their own prefix) |
| A possible credential appears in a file the run will commit, or in a PR body | `{prefix} Blocked: possible credential in {path}. Remove it or confirm it is not a secret.` Stop before the commit and before any push. Never print the value. |
| P1 or P2 adds a library or service that is not on the approved list. This applies in every run mode. The list is the `Approved dependencies` field of `design.md` in a gated run, and the `## Dependencies` table of `initiative.md` in an initiative step | `{prefix} Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative.` When the human approves, add the name to the same list and record the decision in the `Resolved:` line. |

The status `Blocked:` follows the phase prefix, as in every status message. Never work round an exception stop. Do not force-push, merge, or skip the failing check.

---

Mid-Pipeline Requirement Changes is in the Pack Index row for `orchestrator-mid-pipeline-changes.md`.

## Subagent Dispatch

Consult `ravintio-zero/standards/agent-dispatch-standards.md` before spawning every subagent. It holds the model tier table, the parallelism rules, and the dispatch template. Prefer parallel decomposition over sequential inline work. Resolve the tier to a concrete model name, pass it explicitly, and record the tier in the build log.
