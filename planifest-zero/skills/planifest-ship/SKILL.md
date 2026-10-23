---
name: planifest-ship
description: Archive, build assessment, changelog, version, tag, and PR, behind the final gate in a gated run.
bundle_templates: []
bundle_standards: []
---

# Planifest - ship

> You close the run. You write the changelog, archive the plan, assess the build, bump the version, create the tag, and hand off the PR. You do not add features or fix bugs. Your job is a clean, complete handoff.

## Hard Limits

1. Every response begins with `P4 Ship:`. No exceptions.
2. Do not modify application code or pack files during this phase.
3. Never skip the archive step. A populated `plan/current/` breaks resume detection for the next feature.
4. Read `plan/.run-mode` before Step 8. In `gated`, the final gate stops before the PR. In `autonomous`, raise the PR without a stop. The PR is where the human reviews the run.
5. Never merge a PR and never commit to `main`, in any run mode.
6. Credentials are never in your context.
7. One question at a time.

## Sequence

Work through the steps in order. Write each step's artifacts to disk and commit them as they land. Do not batch commits.

### Step 1: Changelog

Write `plan/changelog/{feature-id}-{YYYY-MM-DD}.md`. Audience: PR reviewers, the what and why, not the execution trace.

```markdown
# Changelog ({feature-id}, {DD MMM YYYY})

**Feature:** {feature name from brief}
**Version:** {version}
**PR:** {pending, updated at Step 8}

## What changed
## Why
## Deviations
## Validation results
## Skipped phases
```

### Step 2: Process .skips

If `plan/current/.skips` exists, record its contents in the changelog under `## Skipped phases`, then delete the file. Otherwise write "None".

### Step 3: Build-log summary

Fill the Summary table in `plan/current/build-log.md`: one row per phase with agent counts, parallel batches, and self-corrections.

### Step 4: Archive

1. Determine the archive path: `plan/_archive/{feature-id}-{YYYY-MM-DD}/`. If it exists, suffix `-2`, `-3`, and so on.
2. Search the repo for links pointing at `plan/current/...` (living docs, `docs/decisions-index.md`, `src/*/docs/`). Update each to the archive path.
3. Copy all of `plan/current/` to the archive path, then delete the `plan/current/` contents. Never use an atomic move.
4. `git add` everything: the archive, the deletions, and the link updates. Untracked artifacts must not be left behind. Check with `git status --porcelain` before committing.

### Step 5: Build assessment

Read the archived `build-log.md`. It is now the only copy. Write `build-report.md` into the same archive folder:

- Agent counts and model tiers per phase.
- Parallelism used, and multi-task phases that ran sequentially.
- Self-corrections, with whether each was avoidable.
- One improvement suggestion per phase where warranted.

Source every metric from the build log. Never infer or fabricate. If routing or parallelism is not evidenced, treat it as not applied.

### Step 6: Version bump

Derive the current product version with `node planifest-zero/scripts/product-version.mjs`, then apply the release version to `docs/about.md`, `product.yml`, and `component.yml`. The version must match `[0-9]+\.[0-9]+(\.[0-9]+)?` and must not be lower than the last release tag. If it fails validation, ask the human for the value. Never tag a fabricated version.

### Step 7: Git tag

```bash
git tag v{version} -m "{feature-id}"
```

Local only. Do not push the tag.

### Step 8: PR

If a local-git-only override is active in `planifest-overrides/instructions/`, skip the question and output the description block. Otherwise, follow the run mode.

In `gated`, ask the human:

```
P4 Ship: Git tag v{version} created locally.
Should I raise the PR, or will you?
  [1] Agent pushes + creates PR (git push + gh pr create)
  [2] I'll do it: give me the PR title and description
```

In `autonomous`, take option [1] without asking.

Title: `{feature-id}: {one-line summary}`. Body: summary bullets, key decisions, validation results, test plan. In `autonomous`, add an `## Acceptance evidence` section with the contents of the archived `acceptance-evidence.md`. PR bodies carry no AI attribution.

Before `gh pr create`, scan the PR body for credential patterns, such as `ghp_`, `github_pat_`, `AKIA`, `sk-`, `xox`, and `-----BEGIN` private-key headers. If one matches, stop in both run modes, and never print the value:

```
P4 Ship: Blocked: possible credential in {path}. Remove it or confirm it is not a secret.
```

Use `the PR body` as `{path}`. For option 1, capture the PR number and URL, and update the changelog's `**PR:**` field.

If a push or `gh pr create` fails, stop in both run modes. Report the exact error and do not retry with force:

```
P4 Ship: Blocked: {command} failed with {exact error}. Fix the remote or the credentials, then tell me to retry.
```

### Step 9: Clear sentinels

Delete `plan/.orchestrator-active`, `plan/.orchestrator-ack`, and `plan/.run-mode` if present. Stage the deletions and commit. Confirm with `git ls-files` that none remain tracked.

### Step 10: Final gate

In `gated`, this gate stops. Print:

```
P4 Ship: Complete: {feature-id} shipped.

Archive: plan/_archive/{feature-id}-{YYYY-MM-DD}/
Changelog: plan/changelog/{feature-id}-{YYYY-MM-DD}.md
Build report: plan/_archive/{feature-id}-{YYYY-MM-DD}/build-report.md
Tag: v{version}
PR: {URL, or "see description above"}
```

In `autonomous`, print the same summary, then end the run with this line:

```
P4 Ship: Complete: PR #{n} ready for your review
```

Use the run mode read before Step 8, because Step 9 deletes `plan/.run-mode`. Merging the PR is human-only in every mode, no exception.

## Roadmap steps

This section applies only when `plan/current-roadmap/roadmap.md` has `status: active`. Check the file before Step 6. Outside a roadmap, ignore this section. A normal run keeps the order above: tag at Step 7, PR at Step 8, and no merge by the agent.

In a roadmap step, Steps 1 to 5 and Step 9 run as written. Steps 7 and 8 give way to the two stages below. The step's `Bump` column in `roadmap.md` sets the version for Step 6, and the downgrade check still applies. The merge carve-out is governed by the merge rule and the merge-guard hook, which allows `gh pr merge --squash` only for a `roadmap/*` base.

### R-D Advance

Every message in this stage begins with `R-D Advance:` after the `P4 Ship:` prefix.

1. Update `plan/current-roadmap/roadmap.md` on the feature branch. Set the step's Status to `merged`, fill its Version with the released version, and move `position` to the next step.
2. Raise the PR against the roadmap branch. The roadmap update ships in the same PR, so the squash commit carries it.

   ```bash
   gh pr create --base roadmap/{id}-{slug}
   ```

3. Wait for CI with `gh pr checks`. If any check is red or pending, stop. Push the branch, then print the line below and exit:

   ```
   R-D Advance: Blocked: CI is {red|pending} on PR #{n}. Fix the failing check, then tell me to retry.
   ```

4. If every check is green, squash-merge the PR.

   ```bash
   gh pr merge --squash
   ```

5. Fetch the roadmap branch, then tag the squash commit with the step's version and push the tag.

   ```bash
   git fetch origin roadmap/{id}-{slug}
   git tag v{version} -m "{feature-id}" origin/roadmap/{id}-{slug}
   git push origin v{version}
   ```

The tag comes after the merge because a squash creates a new commit. A tag on the feature branch tip would point at a commit the roadmap branch never holds. If a push or merge fails, stop and report the exact error. Do not retry with force.

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
