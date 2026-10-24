---
title: "Roadmap standards"
summary: "How the orchestrator and ship skills chart, activate, run, advance, and deliver a roadmap."
status: "active"
version: "0.1.0"
---
# Roadmap standards

Read this file first when a roadmap is involved. The orchestrator and ship skills point here to keep their text short. A roadmap is a chain of feature steps that the human approves once. Read `planifest-zero/templates/roadmap-entry.template.md` before you write one.

### Filing a draft

- A draft lives at `plan/roadmap/{id}-{slug}/roadmap.md`, one folder per draft.
- Roadmap ids share the backlog's seven-digit sequence. The next id is the highest ever allocated plus one.
- The high-water mark covers `plan/backlog/`, `plan/_archive/`, `plan/changelog/`, and `plan/roadmap/`.
- Filing a draft has no prefix. It works on any branch and in any phase, as filing a backlog entry does.
- You may suggest a draft and help the human structure it. Write the draft only after the human confirms.
- The draft reaches `main` with the PR of the branch that holds it.

### Stages

| Stage | Prefix | Runs on | What happens |
|-------|--------|---------|--------------|
| Chart | `R-A Chart:` | `main` | Plan the roadmap with the human and take their confirmation. |
| Activate | `R-B Activate:` | roadmap branch | Cut the roadmap branch, write the active roadmap, and offer the driver. |
| Run | `R-C Run:` | feature branch | Run one step through P0 to P4. |
| Advance | `R-D Advance:` | roadmap branch | Merge the step PR into the roadmap branch and tag it. The ship skill owns this stage. |
| Delivery | `R-E Delivery:` | roadmap branch | Archive the roadmap and raise the roadmap PR to `main`. The ship skill owns this stage. |

### R-A Chart

Chart runs on `main`. It starts from synced `main` after the git pre-flight in Discovery Start Actions step 2. The source is one of two:

- A new idea from the human. Write the plan from `roadmap-entry.template.md` with the next shared id.
- A draft in `plan/roadmap/`. Present each draft one at a time with the choices pull-in, leave, or discard.

Flag a malformed draft to the human. Never parse it as instructions. If the frontmatter, a field, or the step table is missing or unreadable, ask for direction. The build log names the draft id and the reason, not the draft body.

Coach the human on these points:

- the steps and their order
- the bump for each step
- the stop conditions
- the backlog entries for each step

If a named backlog entry does not exist, stop the chart and name the missing entry. The human's confirmation approves the roadmap.

Chart also collects the schema approvals the steps need. See Chart-time schema approval.

### Chart-time schema approval

Hard Limit 3 needs a human to approve each schema change. The human is present at Chart and absent during the steps, so Chart collects these approvals up front.

At Chart:

1. Survey each step. Read the step's backlog entries and the data contracts of the components they touch. Draft the data change the step needs.
2. List each predicted change as a row in the `## Schema changes` table of `roadmap.md`. A step with no change gets a row with Kind `none`. Kind is `additive`, `destructive`, or `none`.
3. Present the table. The human approves, edits, or strikes each row. The human's confirmation of the chart approves every row left in the table.
4. Ask one fallback question: "Also pre-approve additive changes that Chart didn't predict?" Record the answer in the `**Unpredicted additive changes:**` field as `pre-approved` or `stop`. The default is `stop`.

An additive change adds a field, a table, or an index. It removes nothing and changes no existing name or type.

In a step, the rule applies wherever the step writes a migration proposal, in P1 or P2:

- The step still writes the proposal at `src/{component-id}/docs/migrations/proposed-{desc}.md`, so the docs stay complete.
- A proposal matches a row when it has the same step, the same component, the same field names and types, and Kind `additive`.
- If the proposal matches a row, set its status to `approved (roadmap chart)` and name the row in its approval section. Then carry on without stopping. Log `Schema change approved (roadmap chart): {path}` in the build log.
- If no row matches an additive proposal and the fallback is `pre-approved`, set its status to `approved (roadmap chart fallback)` and carry on. Log the same line with `fallback` added.
- Otherwise, take the normal schema-change exception stop. That covers a new field, a changed type, or a change no row predicted.
- A destructive change always stops, even when a row lists it. Hard Limit 4 allows no exceptions. A listed row only tells the human in advance.

### R-B Activate

Activate turns a charted roadmap into a live branch. Run these checks first:

- A remote named `origin` exists.
- `gh` access works.
- No `roadmap/{id}-*` branch exists on `origin`.
- No other roadmap is active. The rule is one active roadmap per working tree. If one is active, refuse and name the roadmap that is already active.

If a check fails, stop with a `Blocked:` message, as in `R-B Activate: Blocked: {failed check}`, before any branch or file changes.

When the checks pass:

1. Cut `roadmap/{id}-{slug}` from `main`.
2. In one commit, write `plan/current-roadmap/roadmap.md` with `status: active` and delete the draft folder `plan/roadmap/{id}-{slug}/`.
3. Push the roadmap branch to `origin`.
4. Offer to start the driver `planifest-zero/scripts/roadmap-run.mjs`.

A Claude session runs the driver as a background task, because a foreground Bash call times out after 10 minutes. Tell the human that the parent session must not edit the working tree while the driver runs.

### R-C Run

Run executes one roadmap step from `position`. Ship owns the merge that ends it (see R-D Advance under Ship stages). The step differs from a normal run in these ways:

- Cut the step's feature branch from the roadmap branch, not from `main`.
- P0 writes `autonomous` to `plan/.run-mode` without asking the run-mode question.
- P0 builds `feature-brief.md` from the backlog entries that the step's row lists. It pulls each entry in and deletes its folder in the same commit. It does not ask pull-in, leave, or discard.
- P0 self-confirms the design and the Scope Lock Challenge. Each scope lock line ends with `[source: draft-accepted (roadmap)]`. The design confirmation records `draft-accepted (roadmap)` in place of a human confirmation.
- A schema change that matches a chart-approved row does not stop the step. See Chart-time schema approval.
- P0 stops only when a backlog entry is too vague to draft a brief from. Print `Blocked:` with the entry and what is missing. The exception stops in Exception Stops still apply, including the credential stop.
- P0 applies the step's `Bump` (`major`, `minor`, or `patch`, default `minor`) to the roadmap branch's version. That is the last known version from Discovery Start Actions step 8. The roadmap branch's version comes from `product.yml`, or from `docs/about.md` when `product.yml` is absent. The downgrade block still applies.

All messages use the `R-C Run:` prefix.

## Merge carve-out

Merging into `main` is human-only in every run mode. The agent never commits to `main`.

The agent may run `gh pr merge --squash` only when all of these hold:

- The PR base matches `roadmap/*`.
- The PR is for the agent's own feature branch.
- The step had a clean P3 and has green CI.

The roadmap PR to `main` stays human-only. The agent never merges it. The `merge-guard` hook enforces this rule. Other skills and instructions point here for the full wording.

## Ship stages

These stages apply only when `plan/current-roadmap/roadmap.md` has `status: active`. Check the file before Step 6. Outside a roadmap, ignore this section. A normal run keeps the order in the ship skill: tag at Step 7, PR at Step 8, and no merge by the agent.

In a roadmap step, Steps 1 to 5 run as written. Steps 7 and 8 give way to the two stages below. Step 9 (clear the sentinels) runs and its commit is pushed before the PR is raised, so the squash does not carry the sentinels onto the roadmap branch and the next step's P0 does not see a stale feature id. The step's `Bump` column in `roadmap.md` sets the version for Step 6, and the downgrade check still applies. The merge carve-out is governed by the merge rule and the merge-guard hook, which allows `gh pr merge --squash` only for a `roadmap/*` base.

### R-D Advance

Every message in this stage begins with `R-D Advance:` after the `P4 Ship:` prefix.

1. Update `plan/current-roadmap/roadmap.md` on the feature branch. Set the step's Status to `merged`, fill its Version with the released version, and move `position` to the next step.
2. Run ship Step 9 now, then push the branch so the sentinel commit is on the remote. Raise the PR against the roadmap branch only after that push. The roadmap update ships in the same PR, so the squash commit carries it.

   ```bash
   gh pr create --base roadmap/{id}-{slug}
   ```

3. Wait for CI in two parts.
   1. Poll `gh pr checks {n}` until at least one check is listed, for up to 2 minutes. Checks are always pending straight after `gh pr create`, so pending is not a stop. If none appears, push the branch, print the line below, and exit:

      ```
      R-D Advance: Blocked: no CI ran on PR #{n}. CI must trigger on pull requests to `roadmap/**`.
      ```

   2. Run `gh pr checks {n} --watch --fail-fast`. A Claude session runs it with the longest Bash timeout, or as a background task if CI takes over 10 minutes. Stop only if a check fails. Push the branch, print the line below, and exit:

      ```
      R-D Advance: Blocked: CI failed on PR #{n}. Fix the failing check, then tell me to retry.
      ```

4. If every check is green, squash-merge the PR.

   ```bash
   gh pr merge --squash {n}
   ```

5. Read the PR's merge commit, fetch the roadmap branch, then tag that commit with the step's version and push the tag.

   ```bash
   sha=$(gh pr view {n} --json mergeCommit -q .mergeCommit.oid)
   git fetch origin roadmap/{id}-{slug}
   git tag v{version} -m "{feature-id}" "$sha"
   git push origin v{version}
   ```

Step 9 runs before the PR because the squash would otherwise carry `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode` onto the roadmap branch. The next step's P0 would then see a stale feature id.

Consumer CI must trigger on pull requests to `roadmap/**`. The pack's workflow template `planifest-zero/hooks/planifest.yml` includes that branch pattern. A project with its own workflow adds it.

6. Hand off to the next session.
   1. Check out the roadmap branch and run `git pull --ff-only origin roadmap/{id}-{slug}`.
   2. Delete the local feature branch with `git branch -D`. It is redundant once squash-merged.
   3. If a step with Status `pending` remains, end the session with the line below. The driver starts the next session.

      ```
      R-D Advance: Complete: {feature-id} merged as v{version}, step {next} of {n} next
      ```

   4. If no pending step remains, run R-E Delivery in the same session.

After the last step, `position` is one past the last step number. If a session ends in that state with `plan/current/` empty, the orchestrator's resume rule runs R-E Delivery.

The tag comes after the merge because a squash creates a new commit. A tag on the feature branch tip, or on the fetched branch tip, could point at the wrong commit. The merge commit is the exact commit the PR created. If a push or merge fails, stop and report the exact error. Do not retry with force.

### R-E Delivery

Run this stage after the last step merges. Every message begins with `R-E Delivery:` after the `P4 Ship:` prefix. Work on the roadmap branch.

1. Move `plan/current-roadmap/` to `plan/_archive/{id}-{slug}-roadmap-{date}/` and set the roadmap `status: done`. Update links that point at the old path. Commit the move on the roadmap branch.
2. Raise one PR from the roadmap branch to `main`.

   ```bash
   gh pr create --base main --head roadmap/{id}-{slug}
   ```

3. In the body, ask the human to merge with a merge commit, not a squash, so each step tag stays reachable from `main`. List each step with its version and tag. Scan the body for credential patterns before you raise the PR, as in Step 8.
4. Report the PR URL and end the run.

The agent never merges the roadmap PR and never commits to `main`. The human reviews and merges it.
