#!/usr/bin/env bash
# REGRESSION-CANDIDATE: guards a setup contract that older installs depend on.
# Tests for feature 0000034-setup-hardening, req-003: atomic settings writes.
#
# Covers ADR-002: every settings.json write goes to settings.json.planifest-tmp
# in the same folder, then renames over the target. A failed write leaves the
# original byte-identical and removes the temporary file. A current-flags run
# writes the same bytes as before.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

FRAMEWORK="$SCRIPT_DIR/.."
REPO_ROOT="$(cd "$FRAMEWORK/.." && pwd)"

make_workspace() {
  local dir
  dir=$(mktemp -d -t planifest_0000034_req003_test_XXXXXX)
  cp -r "$1" "$dir/planifest-zero"
  git init "$dir" >/dev/null 2>&1
  echo "$dir"
}

# ── (a): a failed write leaves the original intact and no temporary file ──

echo ""
echo "=== req-003 (a): a failed settings.json write keeps the original ==="

WS=$(make_workspace "$FRAMEWORK")
cd "$WS"
mkdir -p .claude
cat > .claude/settings.json << 'JSON'
{"allowedTools":["Agent","Bash(ls:*)"],"hooks":{"PreToolUse":[{"matcher":"Bash","hooks":[{"type":"command","command":"./mine.sh"}]}]}}
JSON
ORIGINAL="$(shasum .claude/settings.json | cut -d' ' -f1)"
# A read-only leftover temporary file makes the temporary write fail.
echo "partial" > .claude/settings.json.planifest-tmp
chmod 444 .claude/settings.json.planifest-tmp
bash planifest-zero/setup.sh claude-code >/dev/null 2>&1
assert_equals "$ORIGINAL" "$(shasum .claude/settings.json | cut -d' ' -f1)" \
  "req-003 (a): settings.json is byte-identical after the failed write"
assert_equals "no" "$([ -e .claude/settings.json.planifest-tmp ] && echo yes || echo no)" \
  "req-003 (a): the failed write leaves no settings.json.planifest-tmp"
cd /; chmod -R u+w "$WS" 2>/dev/null; rm -rf "$WS"

# ── (b): a normal run writes the same bytes and clears a leftover ─────────

echo ""
echo "=== req-003 (b): a current-flags run writes the same settings.json ==="

WS=$(make_workspace "$FRAMEWORK")
cd "$WS"
mkdir -p .claude
echo "leftover" > .claude/settings.json.planifest-tmp
bash planifest-zero/setup.sh claude-code >/dev/null 2>&1
assert_exit_zero "$?" "req-003 (b): setup exits 0 with a leftover temporary file"
assert_equals "no" "$([ -e .claude/settings.json.planifest-tmp ] && echo yes || echo no)" \
  "req-003 (b): the leftover temporary file is gone after the run"
NEW_SETTINGS="$(cat .claude/settings.json)"
cd /; rm -rf "$WS"

# Compare with the v0.4.0 script when the tag is reachable. A shallow CI
# checkout has no tags, so fall back to the canonical format check.
if git -C "$REPO_ROOT" rev-parse -q --verify "refs/tags/v0.4.0" >/dev/null 2>&1; then
  OLD_DIR=$(mktemp -d -t planifest_0000034_req003_old_XXXXXX)
  git -C "$REPO_ROOT" archive v0.4.0 planifest-zero | tar -x -C "$OLD_DIR"
  WS=$(make_workspace "$OLD_DIR/planifest-zero")
  cd "$WS"
  bash planifest-zero/setup.sh claude-code >/dev/null 2>&1
  OLD_SETTINGS="$(cat .claude/settings.json)"
  cd /; rm -rf "$WS" "$OLD_DIR"
  assert_equals "$OLD_SETTINGS" "$NEW_SETTINGS" \
    "req-003 (b): settings.json matches the v0.4.0 script byte for byte"
else
  CANON="$(printf '%s' "$NEW_SETTINGS" | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>process.stdout.write(JSON.stringify(JSON.parse(d),null,2)))')"
  assert_equals "$CANON" "$NEW_SETTINGS" \
    "req-003 (b): settings.json keeps the two-space JSON format (no v0.4.0 tag)"
fi

# ── (c): no settings.json write goes straight to the target ───────────────

echo ""
echo "=== req-003 (c): every settings.json write uses the temporary file ==="

SH="$FRAMEWORK/setup.sh"
PS1="$FRAMEWORK/setup.ps1"
assert_equals "0" "$(grep -c 'writeFileSync(sf' "$SH" || true)" \
  "req-003 (c): setup.sh has no direct writeFileSync to settings.json"
assert_equals "yes" "$(grep -q 'renameSync' "$SH" && echo yes || echo no)" \
  "req-003 (c): setup.sh renames the temporary file over settings.json"
assert_equals "0" "$(grep -E 'ConvertTo-Json.*Set-Content -Path \$(SettingsPath|settings)' "$PS1" | wc -l | tr -d ' ')" \
  "req-003 (c): setup.ps1 has no direct Set-Content to settings.json"
assert_equals "yes" "$(grep -q 'planifest-tmp' "$PS1" && grep -q 'Move-Item' "$PS1" && echo yes || echo no)" \
  "req-003 (c): setup.ps1 moves a planifest-tmp file over settings.json"

print_summary
