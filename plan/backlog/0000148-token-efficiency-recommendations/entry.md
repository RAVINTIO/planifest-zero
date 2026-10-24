---
title: "Backlog Entry: 0000148 - Token efficiency recommendations"
summary: "A discovered-but-out-of-scope item deferred for pickup at a future discovery run."
status: "open"
---
# Backlog Entry: 0000148 - Token efficiency recommendations

**Source feature:** rapid-prototypes 0000008-claude-usage-observability (usage analysis)
**Source phase:** P4
**Deferral source:** human request
**Date filed:** 2026-10-24

---

## Problem

Claude Code OpenTelemetry measured this repo from 2026-10-17 19:00 BST to 2026-10-24 about 08:00 BST. The week used an API-equivalent $97.79. The human is on a Max plan, so this figure is a proxy for allowance used, not a charge.

Across all measured repos, context (cache reads and writes) drives about 76% of cost. Output drives about 20%. Large tool results get cached and then re-read on every later turn. Each subagent pays to cache its own starting prompt. Sonnet costs about half of Opus per token.

In this repo, four causes stand out:

- Opus served 84.4% of cost, although `planifest-zero/standards/agent-dispatch-standards.md` names Sonnet as its primary tier.
- Haiku served 38 requests ($0.10), although three TDD skills declare `recommended_model: haiku`.
- Bash returned 4,117,768 bytes into context. One full `run-tests.sh` run prints 208,724 bytes.
- The headless roadmap driver runs every step on the default model, with no turn cap.

### Evidence: planifest-zero, interactive and subagent use

| Measure | Value |
|---|---|
| Cost (API-equivalent) | $97.79 |
| Requests | 2,186 |
| Sessions | 6 |
| User prompts | 184 |
| Cost per request | $0.0447 ($97.79 / 2,186) |
| Model mix by cost | Opus 84.4% ($82.55), Sonnet 15.5% ($15.15), Haiku 0.1% ($0.10) |
| Main thread | 52.8% ($51.61, 853 requests) |
| Subagents (`agent:builtin:general-purpose`) | 39.0% ($38.18, 1,002 requests, 81 completed) |
| Subagent progress summaries (`agent_summary`) | 5.6% ($5.50, 269 requests) |
| Subagent share in total | 44.6% (39.0% + 5.6%) |
| Cost split (fitted, approximate) | cache read 43.5%, cache write 32.3%, output 22.8%, input 1.4% |
| Context per request | median 86,635, p90 208,064, max 305,735 tokens |
| Compactions | 1 |

| Tool | Calls | Bytes returned | Largest result |
|---|---|---|---|
| Bash | 1,488 | 4,117,768 | 28,720 |
| Read | 52 | 257,590 | 32,287 |
| WebFetch | 10 | 247,105 | 87,565 |
| Agent | 76 | 83,600 | 1,100 |

Bash returned 86.8% of all tool result bytes (4,117,768 / 4,744,168). Two WebFetch results exceeded 50 KB.

| Session | Requests | Cost | Span | Max context |
|---|---|---|---|---|
| `4bf98c91` | 594 | $26.64 | 2026-10-23 05:04 to 19:39 | 269,289 |
| `d73cb944` | 623 | $21.07 | 2026-10-23 19:55 to 2026-10-24 06:46 | 305,735 |
| `b97f3169` | 282 | $16.03 | 2026-10-20 07:22 to 2026-10-22 20:51 | 216,007 |
| `aa7a435d` | 315 | $15.15 | 2026-10-22 20:51 to 2026-10-23 00:21 | 246,102 |
| `15e51474` | 253 | $12.75 | 2026-10-18 23:24 to 2026-10-19 21:56 | 230,143 |

The top five sessions hold 93.7% of cost ($91.64 / $97.79).

By skill, `planifest-implement` cost $12.57, `planifest-validate-and-accept` $7.99, and `planifest-plan` $5.28. Work outside any skill cost $66.33 (67.8%).

### Evidence: repo measurements made while filing

- `bash planifest-zero/tests/run-tests.sh` printed 208,724 bytes over 4,222 lines on 2026-10-24. It took 163 seconds.
- That output holds 2,667 `PASS:` lines from `planifest-zero/tests/helpers/assert.sh`. The useful summary is the last 8 lines.
- The largest Bash result was 28,720 bytes, so Claude Code most likely cut each full run to about that size. One cut run adds about 7,180 tokens (28,720 / 4 bytes per token). That is about 8% of the median request context (7,180 / 86,635).
- `planifest-refactor/SKILL.md` runs the full suite after each significant change, once per requirement or more.
- `CLAUDE.md` (8,322 bytes) and the orchestrator `SKILL.md` (35,872 bytes) load at the start of each session. Together that is about 11,000 tokens (44,194 / 4).

### Evidence: related acceptance clone `pz-roadmap-acceptance-0000043`

The private repo `planifest/pz-roadmap-acceptance-0000043` is an acceptance test of feature 0000043. `planifest-zero/scripts/roadmap-run.mjs` drove it headless. The planifest-zero profile above does not include it.

| Measure | Value |
|---|---|
| Cost (API-equivalent) | $11.71 |
| Requests | 202 |
| Sessions | 4, from 2026-10-23 23:40Z to 2026-10-24 00:42Z |
| Headless share (`sdk` query source) | 98.2% ($11.50, 188 requests) |
| Model mix by cost | Opus 98.2% ($11.50), Sonnet 1.6%, Haiku 0.3% |
| Cost per request | $0.058 ($11.71 / 202) |
| Context per request | median 106,973, p90 174,166, max 190,257 tokens |
| Costliest session | `4330931e`: 97 requests, $5.08, 23:40 to 23:56 (16 minutes) |
| Bash returned | 427,950 bytes over 176 calls |
| Cost by skill | `planifest-plan` 34.0%, `planifest-orchestrator` 23.3%, `planifest-implement` 12.4% |

`roadmap-run.mjs` line 137 spawns `claude -p --permission-mode auto "Run roadmap step {n}"`. It passes no `--model` and no `--max-turns`. Each step therefore runs on the session default, which was Opus.

## Recommendation prompt

Paste this block into a Claude Code session in this repo.

```text
Goal: reduce Claude Code token use in this repo without weakening any quality
gate. Base every change on the usage evidence in
plan/backlog/0000148-token-efficiency-recommendations/entry.md.

Rules for this task:
- Propose all changes first, as a numbered list with the exact diff for each.
  Then stop and wait for my approval. Apply nothing until I approve.
- Do not weaken any quality gate. Every test suite, hook, TDD step, review,
  and acceptance check keeps running with the same pass criteria. A change
  may shorten what a check prints. It must never skip, sample, or relax it.
- Edit the source files under planifest-zero/ only. Then re-run setup so the
  installed copies under .claude/ match. Do not hand-edit .claude/skills/.
- Run this as a normal Planifest run, with a feature brief from this entry.

Changes, in order of expected saving:

1. Headless roadmap steps run on Sonnet, with a turn cap.
   File: planifest-zero/scripts/roadmap-run.mjs (spawn at about line 137).
   Add --model and --max-turns to the claude -p arguments. Read both from
   environment variables, for example PLANIFEST_ROADMAP_MODEL (default
   sonnet) and PLANIFEST_ROADMAP_MAX_TURNS. Document both in the header
   comment and in planifest-zero/standards/roadmap-standards.md. If a step
   reaches the cap, the driver stops with a clear "R-C Run: Blocked:" line.
   Reason: in the acceptance clone, Opus served 98.2% of $11.71. One
   16-minute step session cost $5.08. Sonnet costs about half of Opus per
   token. The dispatch standard already names Sonnet as the primary tier.

2. Subagent model tiers that Claude Code applies.
   Files: planifest-zero/standards/agent-dispatch-standards.md and each
   skill's references/agent-dispatch-standards.md copy.
   Replace the stale IDs claude-sonnet-4-6 and claude-haiku-4-5 with the
   Agent tool's model values sonnet and haiku. State that every Agent call
   passes model explicitly, because a call without it inherits the parent's
   model (Opus here).
   Files: planifest-zero/skills/planifest-implement/SKILL.md (TDD inner
   loop). Make each dispatch of planifest-test-writer, planifest-implementer,
   and planifest-refactor pass the model from that skill's
   recommended_model field. Check whether Claude Code reads a skill-level
   model field. If it does, use it, because recommended_model is not one.
   If haiku fails a requirement twice, retry it on sonnet. The five-attempt
   escalation rule stays as it is.
   Reason: subagents cost 44.6% of $97.79. Opus served 84.4% of all cost.
   Haiku served only 38 requests, so the haiku tier is not taking effect.

3. Quiet test output that keeps every failure detail.
   Files: planifest-zero/tests/helpers/assert.sh,
   planifest-zero/tests/helpers/assert.ps1, planifest-zero/tests/run-tests.sh,
   planifest-zero/tests/run-tests.ps1.
   Add a quiet mode, for example PLANIFEST_TEST_QUIET=1. It hides PASS lines
   and suite banners. It still prints every FAIL line with its expected and
   actual values, the failing suite name, and the final summary. Exit codes
   do not change. Then make planifest-zero/skills/planifest-refactor/SKILL.md,
   planifest-zero/skills/planifest-validate-and-accept/SKILL.md, and any
   other skill that runs the suite use quiet mode. Add a test that proves a
   failing assertion still prints its detail in quiet mode.
   Reason: Bash returned 4,117,768 bytes, 86.8% of all tool result bytes.
   One full run prints 208,724 bytes, of which 2,667 lines are PASS lines.
   A cut run still adds about 7,180 tokens. Every later turn re-reads them.

4. Shorter sessions at phase boundaries.
   File: planifest-zero/skills/planifest-orchestrator/SKILL.md.
   At the end of each phase gate in an interactive run, tell the human the
   current context size. Recommend /clear or a new session before the next
   phase when context passes about 150,000 tokens. The plan/current/
   artifacts already carry state between sessions.
   Reason: the top five sessions hold 93.7% of cost. Two ran over 590
   requests, and context peaked at 305,735 tokens. There was 1 compaction.

5. Large web pages go through a subagent.
   File: planifest-zero/standards/agent-dispatch-standards.md.
   Add a rule that WebFetch of a full reference page runs in a sonnet or
   haiku subagent that returns only the needed extract.
   Reason: 10 WebFetch calls returned 247,105 bytes. Two results passed
   50 KB, and the largest was 87,565 bytes.

6. A smaller starting context for headless steps.
   Files: planifest-zero/skills/planifest-orchestrator/SKILL.md and
   planifest-zero/standards/roadmap-standards.md.
   Measure what a fresh roadmap step loads before its first tool call.
   Propose moving roadmap-only and rarely used orchestrator sections into
   references/ files that load on demand. Keep every rule, and move text
   rather than delete it.
   Reason: CLAUDE.md and the orchestrator SKILL.md add about 11,000 tokens
   to every fresh session. The roadmap driver starts one per step. Median
   headless context was 106,973 tokens.

For each change, give the evidence line it rests on and the expected saving
with its arithmetic. Say how you will confirm that no gate got weaker.
```

## Expected effect

These estimates are rough. They assume the same workload and the cross-repo ratio of Sonnet at about half the Opus price per token.

| Change | Estimate | Basis |
|---|---|---|
| 1. Headless on Sonnet | About $5.75 saved on a run set like the acceptance clone, about 49% of $11.71 | $11.50 of Opus cost halved |
| 2. Subagent tiers | About $11.50 a week, about 12% of $97.79 | Assumes all 609 Sonnet requests were subagent requests. Then Opus subagent cost is about $23.03 ($38.18 minus $15.15), and halving it saves about $11.50. Haiku for TDD steps would save more. |
| 3. Quiet tests | Up to about 7,180 fewer tokens per full run, re-read on every later turn | 28,720 bytes / 4. The saving per week depends on run count, which the profile does not hold. |
| 4. Shorter sessions | Lower p90 and max context per request | Top five sessions hold 93.7% of cost. No per-turn data exists to size it. |
| 5. WebFetch | Up to about 61,000 tokens fewer in the main context a week | 247,105 bytes / 4, less the subagent extracts |
| 6. Starting context | Part of about 11,000 tokens per fresh session | 44,194 bytes / 4 |

The model changes (1 and 2) are the surest savings, because they cut price per token on most requests. The context changes (3 to 6) act on cache reads and writes, which make up about 76% of cost.

### How to measure

1. After the changes ship, run the rapid-prototypes `0000008-claude-usage-observability` profile for this repo over one full week.
2. Compare these values with the tables above:
   - Opus share of cost, and Haiku request count
   - Bash bytes returned, and bytes per Bash call (was 2,767)
   - median and p90 context per request (was 86,635 and 208,064)
   - cost per request (was $0.0447)
3. Repeat the 0000043 acceptance run with the new driver. Compare cost per step session with `4330931e` ($5.08 for 97 requests).
4. Check that the same suites ran and passed, and that the build logs record the same gates.

## Suggested Action

Paste the recommendation prompt into a Claude Code session in this repo. Review the proposed diffs, then approve them one at a time.

## Why Deferred

The analysis ran in rapid-prototypes, which must not edit this repo's skills or scripts. The changes touch the framework's dispatch standard, skills, and roadmap driver. They need their own Planifest run.
