#!/usr/bin/env node
// roadmap-run.mjs - runs each roadmap step in a fresh claude -p session (0000043 ADR-004).
//
// Usage, run from the repository root:
//
//   node planifest-zero/scripts/roadmap-run.mjs [--root <dir>]
//
// Arguments:
//   --root   The working tree that holds plan/. Defaults to the current directory.
//
// Environment:
//   CLAUDE_BIN   The claude executable. Defaults to "claude", found through PATH.
//
// What it does:
//   1. Reads plan/current-roadmap/roadmap.md and stops unless status is "active".
//   2. Takes plan/.roadmap-runner.lock. If the lock exists, it refuses to start
//      and leaves the lock alone.
//   3. Runs `claude -p --permission-mode auto "Run roadmap step {position}"`
//      and waits. It never passes --continue or --resume, so each step gets a
//      fresh session. The position goes to claude as one argument, never
//      through a shell.
//   4. After each step it stops if plan/current/build-log.md ends on a
//      "Blocked:" line with no later "Resolved:" line, or if position did not
//      move.
//   5. It repeats until delivery: roadmap.md is gone and
//      plan/_archive/{id}-{slug}-roadmap-*/ exists. It then exits 0.
//
// Output: one line per stage, written and flushed at once so a parent session
// can stream it with Monitor. Lines start with "R-C Run:" or "R-D Advance:"
// and the final line with "R-E Delivery:". A stop line names the reason and,
// for a block, repeats the Blocked: message cut to 500 characters.
//
// Exit codes:
//   0  Delivery is complete.
//   1  A stop: invalid or inactive roadmap, existing lock, block, stalled
//      position, failed claude call, or interruption.
//
// The lock is released on every exit path, including SIGINT and SIGTERM.
// The driver never edits the working tree. The steps it launches do that.
// It has no dependencies beyond Node.

import { spawn, spawnSync } from 'node:child_process';
import { appendFileSync, existsSync, readFileSync, readdirSync, unlinkSync, writeFileSync, writeSync } from 'node:fs';
import { join, resolve } from 'node:path';

const ROADMAP = 'plan/current-roadmap/roadmap.md';
const LOCK = 'plan/.roadmap-runner.lock';
const BUILD_LOG = 'plan/current/build-log.md';
const ARCHIVE = 'plan/_archive';
const STATUS = /^(draft|active|blocked|done)$/;
const POSITION = /^[1-9][0-9]{0,2}$/;
const BRANCH = /^roadmap\/([0-9]{7})-([a-z0-9]+(-[a-z0-9]+)*)$/;
const MAX_LINE = 500;

class Stop extends Error {}

const out = (line) => writeSync(1, `${line}\n`);

function parseArgs(argv) {
  let root = process.cwd();
  for (let i = 0; i < argv.length; i++) {
    if (argv[i] === '--root' && argv[i + 1]) root = argv[++i];
    else throw new Stop(`R-C Run: Blocked: unknown argument "${argv[i].slice(0, 40)}"`);
  }
  return resolve(root);
}

// Reads "name: value" or "- **name:** value" lines. The body wins over the frontmatter,
// because the agent updates the body fields. Falls back to the frontmatter.
// Strips a trailing " # comment" and one matching pair of surrounding quotes.
function field(text, name) {
  const fm = text.match(/^---\r?\n[\s\S]*?\r?\n---\r?\n?/);
  const head = fm ? fm[0] : '';
  const body = text.slice(head.length);
  return fieldIn(body, name) || fieldIn(head, name);
}

function fieldIn(text, name) {
  const re = new RegExp(`^\\s*(?:[-*]\\s+)?\\**${name}\\**\\s*:\\s*\\**\\s*\`?([^\`\\n]*?)\`?\\s*$`, 'mi');
  const m = text.match(re);
  if (!m) return '';
  const v = m[1].replace(/\s+#.*$/, '').trim();
  return /^(["']).*\1$/.test(v) ? v.slice(1, -1).trim() : v;
}

function readRoadmap(root) {
  const file = join(root, ROADMAP);
  if (!existsSync(file)) throw new Stop(`R-C Run: Blocked: ${ROADMAP} is missing`);
  const text = readFileSync(file, 'utf8');
  const status = field(text, 'status');
  const position = field(text, 'position');
  const branch = field(text, 'branch');
  if (!STATUS.test(status)) throw new Stop('R-C Run: Blocked: roadmap status is missing or invalid');
  if (!POSITION.test(position)) throw new Stop('R-C Run: Blocked: roadmap position is missing or invalid');
  const b = branch.match(BRANCH);
  if (!b) throw new Stop('R-C Run: Blocked: roadmap branch is missing or invalid');
  return { status, position, id: b[1], slug: b[2] };
}

// Adds the lock path to .git/info/exclude so a step session's "stage everything"
// never commits the lock. Skips quietly outside a git work tree.
function excludeLock(root) {
  const git = (...args) => spawnSync('git', args, { cwd: root, encoding: 'utf8' });
  const inside = git('rev-parse', '--is-inside-work-tree');
  if (inside.error || inside.status !== 0 || inside.stdout.trim() !== 'true') return;
  const p = git('rev-parse', '--git-path', 'info/exclude');
  if (p.status !== 0) return;
  const file = resolve(root, p.stdout.trim());
  const text = existsSync(file) ? readFileSync(file, 'utf8') : '';
  if (text.split(/\r?\n/).includes(LOCK)) return;
  appendFileSync(file, (text === '' || text.endsWith('\n') ? '' : '\n') + LOCK + '\n');
}

// Returns the last Blocked: line when no Resolved: line follows it, else null.
// Either line may carry a list marker, such as "- " or "* ".
function openBlock(root) {
  const file = join(root, BUILD_LOG);
  if (!existsSync(file)) return null;
  let last = null;
  for (const line of readFileSync(file, 'utf8').split(/\r?\n/)) {
    if (/^\s*(?:[-*+]\s+)?Blocked:/.test(line)) last = line.trim();
    else if (/^\s*(?:[-*+]\s+)?Resolved:/.test(line)) last = null;
  }
  return last === null ? null : last.slice(0, MAX_LINE);
}

function delivered(root, id, slug) {
  if (existsSync(join(root, ROADMAP))) return false;
  const dir = join(root, ARCHIVE);
  if (!existsSync(dir)) return false;
  const prefix = `${id}-${slug}-roadmap-`;
  return readdirSync(dir).some((n) => n.startsWith(prefix));
}

function runStep(root, position) {
  return new Promise((resolveStep) => {
    const bin = process.env.CLAUDE_BIN || 'claude';
    const child = spawn(bin, ['-p', '--permission-mode', 'auto', `Run roadmap step ${position}`], {
      cwd: root,
      stdio: ['ignore', 'ignore', 'inherit'],
    });
    activeChild = child;
    child.on('error', (e) => resolveStep({ error: e.code || 'spawn error' }));
    child.on('close', (code, signal) => resolveStep({ code, signal }));
  });
}

let activeChild = null;
let lockPath = null;

function releaseLock() {
  if (!lockPath) return;
  try {
    unlinkSync(lockPath);
  } catch {
    // Already gone.
  }
  lockPath = null;
}

for (const sig of ['SIGINT', 'SIGTERM', 'SIGHUP']) {
  process.on(sig, () => {
    if (activeChild) activeChild.kill(sig);
    releaseLock();
    out(`R-C Run: Blocked: driver stopped by ${sig}`);
    process.exit(1);
  });
}
process.on('exit', releaseLock);

async function main() {
  const root = parseArgs(process.argv.slice(2));
  let rm = readRoadmap(root);
  if (rm.status !== 'active') throw new Stop(`R-C Run: Blocked: roadmap status is ${rm.status}, not active`);
  const { id, slug } = rm;

  const lock = join(root, LOCK);
  excludeLock(root);
  try {
    writeFileSync(lock, `${process.pid}\n`, { flag: 'wx' });
  } catch (e) {
    if (e.code === 'EEXIST') throw new Stop(`R-C Run: Blocked: ${LOCK} exists, another driver may be running`);
    throw e;
  }
  lockPath = lock;

  for (;;) {
    const position = rm.position;
    out(`R-C Run: Starting: roadmap step ${position} in a fresh session`);
    const res = await runStep(root, position);
    activeChild = null;
    if (res.error) throw new Stop(`R-C Run: Blocked: could not start claude (${res.error})`);
    if (res.code !== 0) {
      throw new Stop(`R-C Run: Blocked: claude exited ${res.code ?? res.signal} on step ${position}`);
    }

    if (delivered(root, id, slug)) {
      out(`R-D Advance: Complete: step ${position} merged`);
      out(`R-E Delivery: Complete: roadmap ${id}-${slug} archived, driver done`);
      return;
    }
    const block = openBlock(root);
    if (block) throw new Stop(`R-C Run: Blocked: step ${position} stopped. ${block}`);

    rm = readRoadmap(root);
    if (rm.position === position) {
      throw new Stop(`R-C Run: Blocked: position stayed at ${position} after step ${position}`);
    }
    if (rm.status !== 'active') throw new Stop(`R-C Run: Blocked: roadmap status is ${rm.status}, not active`);
    out(`R-D Advance: Complete: step ${position} done, position now ${rm.position}`);
  }
}

main().then(
  () => process.exit(0),
  (e) => {
    out(e instanceof Stop ? e.message : `R-C Run: Blocked: driver error ${e.code || e.name}`);
    process.exit(1);
  },
);
