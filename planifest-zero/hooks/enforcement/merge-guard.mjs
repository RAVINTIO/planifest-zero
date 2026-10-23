#!/usr/bin/env node
/**
 * PreToolUse hook (matcher: Bash): merge guard (feature 0000043, ADR-003).
 *
 * Blocks any `gh pr merge` command unless both hold:
 *   1. the command uses --squash (and no --merge, --rebase, or --admin)
 *   2. the PR base branch starts with roadmap/
 *
 * The hook reads the base with `gh pr view --json baseRefName` and fails
 * closed: if it cannot read a base, it blocks. It only matches the command
 * text. It never runs, evaluates, or shells out the command.
 *
 * Exit codes: 0 = pass, 2 = block (message on stdout).
 * Any unexpected error exits 0, except a failed base read, which blocks.
 */

import { spawnSync } from "node:child_process";

import { readStdin } from "./read-stdin.mjs";

const MAX_COMMAND = 4096;
const MERGE_RE =
  /(?:^|[\s;&|(])gh\s+(?:(?:-R|--repo)[\s=]\S+\s+)?pr\s+merge\b([^;&|\n]*)/g;
const REPO_RE = /(?:^|\s)(?:-R|--repo)[\s=](\S+)/;
// Flags that take a value, so the value is not mistaken for the PR reference.
const VALUE_FLAGS = new Set([
  "-b", "--body", "-F", "--body-file", "-t", "--subject",
  "-A", "--author-email", "--match-head-commit", "-R", "--repo",
]);
const SAFE_REF = /[^a-zA-Z0-9\-_./#:]/g;

function block(reason) {
  process.stdout.write(
    "[Planifest] Merge blocked. Merges into main are human-only. " +
    "The agent may squash-merge only into roadmap/*. " + reason + "\n"
  );
  process.exit(2);
}

function safe(value) {
  return String(value ?? "").replace(SAFE_REF, "");
}

function parseMerge(argText) {
  const tokens = argText.trim().split(/\s+/).filter(Boolean);
  const flags = new Set();
  let ref = "";
  for (let i = 0; i < tokens.length; i++) {
    const t = tokens[i].replace(/^["']|["']$/g, "");
    if (t.startsWith("-")) {
      const name = t.split("=")[0];
      flags.add(name);
      if (VALUE_FLAGS.has(name) && !t.includes("=")) i++;
    } else if (!ref) {
      ref = safe(t);
    }
  }
  const repo = REPO_RE.exec(argText);
  return { flags, ref, repo: repo ? safe(repo[1]) : "" };
}

function readBase({ ref, repo }) {
  const args = ["pr", "view"];
  if (ref) args.push(ref);
  if (repo) args.push("--repo", repo);
  args.push("--json", "baseRefName");
  const r = spawnSync("gh", args, { encoding: "utf-8", timeout: 30000 });
  if (r.error || r.status !== 0) return "";
  try {
    return safe(JSON.parse(r.stdout).baseRefName);
  } catch {
    return "";
  }
}

let command = "";
try {
  const input = JSON.parse(await readStdin());
  const tool = input?.tool_name;
  if (tool && tool !== "Bash") process.exit(0);
  command = String(input?.tool_input?.command ?? "").slice(0, MAX_COMMAND);
} catch {
  process.exit(0);
}

try {
  for (const match of command.matchAll(MERGE_RE)) {
    const merge = parseMerge(match[1] ?? "");
    const f = merge.flags;
    if (!f.has("--squash") && !f.has("-s")) {
      block("Pass --squash.");
    }
    for (const bad of ["--merge", "-m", "--rebase", "-r", "--admin"]) {
      if (f.has(bad)) block(`The ${bad} flag is not allowed.`);
    }
    const base = readBase(merge);
    if (!base) block("The PR base could not be read, so the merge is blocked.");
    if (!base.startsWith("roadmap/")) {
      block(`The PR base is '${base}'.`);
    }
  }
  process.exit(0);
} catch {
  // Never block the session on unexpected errors.
  process.exit(0);
}
