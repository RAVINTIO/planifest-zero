#!/usr/bin/env node
// park.mjs - the git and gh steps of the orchestrator's park command (ADR-005).
//
// Usage, run from the repository root:
//
//   node park.mjs park      --entry <file> --backlog-id <id> [--slug <slug>] [--feature-id <id>] [--branch <name>]
//   node park.mjs finish-pr --entry <file> --backlog-id <id> [--slug <slug>] [--feature-id <id>] [--branch <name>]
//   node park.mjs resume    <branch>
//   node park.mjs discard   <branch> --confirmed
//
// Arguments:
//   --entry       A filled backlog entry with status "parked". It must name the
//                 branch in a "**Parked branch:** {branch}" line. Keep it outside
//                 the working tree, or it travels across branch switches.
//   --backlog-id  The next backlog id. The entry lands at
//                 plan/backlog/{backlog-id}-park-{slug}/entry.md.
//   --slug        Defaults to the feature id without its leading number.
//   --feature-id  Defaults to the branch name without its "feat/" prefix.
//   --branch      The feature branch. Defaults to the current branch.
//   --confirmed   Pass it to discard only after the human confirms.
//
// Subcommands:
//   park       Checks that plan/current/park.md is committed, pushes the
//              feature branch, then runs the finish-pr steps.
//   finish-pr  If gh finds no PR for chore/park-{feature-id}, cuts that branch
//              from origin/main, commits the entry, pushes, and runs
//              gh pr create. It then checks out main.
//   resume     Checks out the branch and merges origin/main into it. It leaves
//              plan/current/park.md for the skill to restore.
//   discard    Deletes the branch locally and on origin.
//
// If a git or gh call fails, the script prints the exact error and exits 1.
// A failed park or finish-pr returns the working tree to the feature branch.
// The script never merges a pull request, never commits to main, and never
// force-pushes. It has no dependencies beyond Node and the git and gh tools.

import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname } from 'node:path';

const REMOTE = 'origin';
const MAIN = 'main';
const PARK_RECORD = 'plan/current/park.md';

class ParkError extends Error {}

function run(cmd, args, { allowFail = false } = {}) {
  const r = spawnSync(cmd, args, { encoding: 'utf8' });
  if (r.error) throw new ParkError(`${cmd} ${args.join(' ')} could not start: ${r.error.message}`);
  if (r.status !== 0 && !allowFail) {
    const detail = `${r.stderr || ''}${r.stdout || ''}`.trim();
    throw new ParkError(`${cmd} ${args.join(' ')} failed (exit ${r.status}):\n${detail}`);
  }
  return { ok: r.status === 0, out: (r.stdout || '').trim() };
}
const git = (...args) => run('git', args).out;
const gitOk = (...args) => run('git', args, { allowFail: true }).ok;
const currentBranch = () => git('branch', '--show-current');

function parseArgs(argv) {
  const opts = { positional: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--confirmed') opts.confirmed = true;
    else if (a.startsWith('--')) {
      const value = argv[++i];
      if (value === undefined) throw new ParkError(`${a} needs a value.`);
      opts[a.slice(2)] = value;
    } else opts.positional.push(a);
  }
  return opts;
}

function parkContext(opts) {
  const branch = opts.branch || currentBranch();
  if (!branch || branch === MAIN) throw new ParkError(`Park runs from a feature branch, not "${branch || 'detached HEAD'}".`);
  const featureId = opts['feature-id'] || branch.replace(/^feat\//, '');
  const slug = opts.slug || featureId.replace(/^\d+-/, '');
  if (!opts.entry) throw new ParkError('--entry <file> is required.');
  if (!opts['backlog-id']) throw new ParkError('--backlog-id <id> is required.');
  if (!existsSync(opts.entry)) throw new ParkError(`Entry file not found: ${opts.entry}`);
  const entry = readFileSync(opts.entry, 'utf8');
  if (!entry.includes(`**Parked branch:** ${branch}`)) {
    throw new ParkError(`The entry must name the branch: "**Parked branch:** ${branch}".`);
  }
  return {
    branch,
    featureId,
    chore: `chore/park-${featureId}`,
    entry,
    entryPath: `plan/backlog/${opts['backlog-id']}-park-${slug}/entry.md`,
  };
}

// One park per working tree: refuse while another feature's chore branch exists.
function checkSinglePark(ctx) {
  const others = git('branch', '--list', 'chore/park-*', '--format=%(refname:short)')
    .split('\n').filter((b) => b && b !== ctx.chore);
  if (others.length) {
    throw new ParkError(`Another park is open in this working tree: ${others.join(', ')}. Finish or remove it first.`);
  }
}

function commitOffMain(message) {
  if (currentBranch() === MAIN) throw new ParkError('Refusing to commit to main.');
  git('commit', '-m', message);
}

function finishPr(ctx) {
  const existing = run('gh', ['pr', 'list', '--head', ctx.chore, '--state', 'all']).out;
  if (existing) {
    console.log(`A PR for ${ctx.chore} already exists. Skipping the chore branch.`);
  } else {
    git('fetch', REMOTE, MAIN);
    const remoteChore = `refs/remotes/${REMOTE}/${ctx.chore}`;
    gitOk('fetch', REMOTE, `refs/heads/${ctx.chore}:${remoteChore}`);
    const base = gitOk('rev-parse', '-q', '--verify', remoteChore) ? remoteChore : `${REMOTE}/${MAIN}`;
    git('checkout', '-B', ctx.chore, base);
    mkdirSync(dirname(ctx.entryPath), { recursive: true });
    writeFileSync(ctx.entryPath, ctx.entry);
    git('add', '--', ctx.entryPath);
    if (!gitOk('diff', '--cached', '--quiet')) {
      commitOffMain(`chore(backlog): park ${ctx.featureId}`);
    }
    git('push', '-u', REMOTE, ctx.chore);
    const url = run('gh', [
      'pr', 'create', '--base', MAIN, '--head', ctx.chore,
      '--title', `chore(backlog): park ${ctx.featureId}`,
      '--body', `Files the parked backlog entry for ${ctx.branch}. The work stays on that branch.`,
    ]).out;
    if (url) console.log(url);
  }
  git('checkout', MAIN);
  console.log(`Parked ${ctx.branch}. The working tree is on ${MAIN}.`);
}

// Runs a park step, and on failure returns the working tree to the feature branch.
function onFeatureBranch(ctx, step) {
  try {
    step();
  } catch (err) {
    if (currentBranch() !== ctx.branch) {
      const back = run('git', ['checkout', ctx.branch], { allowFail: true });
      if (!back.ok) err.message += `\nCould not return to ${ctx.branch}. Check out the branch by hand.`;
    }
    throw err;
  }
}

function park(opts) {
  const ctx = parkContext(opts);
  if (currentBranch() !== ctx.branch) throw new ParkError(`Check out ${ctx.branch} before you park it.`);
  checkSinglePark(ctx);
  if (!gitOk('ls-files', '--error-unmatch', '--', PARK_RECORD)) {
    throw new ParkError(`${PARK_RECORD} is not committed on ${ctx.branch}.`);
  }
  if (git('status', '--porcelain', '--', PARK_RECORD)) {
    throw new ParkError(`${PARK_RECORD} has uncommitted changes. Commit it first.`);
  }
  onFeatureBranch(ctx, () => {
    git('push', '-u', REMOTE, ctx.branch);
    finishPr(ctx);
  });
}

function finishPrCommand(opts) {
  const ctx = parkContext(opts);
  if (currentBranch() !== ctx.branch) throw new ParkError(`Check out ${ctx.branch} before you run finish-pr.`);
  checkSinglePark(ctx);
  onFeatureBranch(ctx, () => finishPr(ctx));
}

function resume(opts) {
  const [branch] = opts.positional;
  if (!branch) throw new ParkError('resume needs a branch name.');
  git('fetch', REMOTE);
  git('checkout', branch);
  git('merge', '--no-edit', `${REMOTE}/${MAIN}`);
  console.log(`Resumed ${branch} with ${REMOTE}/${MAIN} merged. Restore state from ${PARK_RECORD}.`);
}

function discard(opts) {
  const [branch] = opts.positional;
  if (!branch) throw new ParkError('discard needs a branch name.');
  if (!opts.confirmed) throw new ParkError(`Discard deletes ${branch}. Pass --confirmed only after the human confirms.`);
  if (branch === MAIN) throw new ParkError('Refusing to delete main.');
  if (currentBranch() === branch) throw new ParkError(`Check out ${MAIN} before you discard ${branch}.`);
  if (gitOk('rev-parse', '-q', '--verify', `refs/heads/${branch}`)) git('branch', '-D', branch);
  if (git('ls-remote', '--heads', REMOTE, branch)) git('push', REMOTE, '--delete', branch);
  console.log(`Discarded ${branch} locally and on ${REMOTE}.`);
}

const COMMANDS = { park, 'finish-pr': finishPrCommand, resume, discard };

try {
  const [cmd, ...rest] = process.argv.slice(2);
  const handler = COMMANDS[cmd];
  if (!handler) throw new ParkError(`Unknown subcommand "${cmd ?? ''}". Use park, finish-pr, resume, or discard.`);
  handler(parseArgs(rest));
} catch (err) {
  console.error(`park: ${err instanceof ParkError ? err.message : err.stack}`);
  process.exit(1);
}
