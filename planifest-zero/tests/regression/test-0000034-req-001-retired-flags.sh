#!/usr/bin/env bash
# REGRESSION-CANDIDATE: guards a setup contract that older installs depend on.
# Tests for feature 0000034-setup-hardening, req-001: retired flags.
#
# Covers ADR-001 (retired setup flags warn and continue): setup accepts four
# retired flags with one warning each, skips the value after --backend-url
# unless it starts with --, never prints or writes that value, and still
# exits 1 on any other unknown flag. setup.ps1 has no runtime runner here, so
# its half gets static checks.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/../helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/../.."
RETIRED_FLAGS=(--structured-telemetry-mcp --backend-url --context-mode-mcp --include-full-skill-library)
SECRET_URL="http://retired-backend.invalid:9999/path"

make_workspace() {
  local dir
  dir=$(mktemp -d -t planifest_0000034_req001_test_XXXXXX)
  cp -r "$ZERO_DIR" "$dir/planifest-zero"
  git init "$dir" >/dev/null 2>&1
  echo "$dir"
}

count_lines() {
  printf '%s\n' "$1" | grep -c -- "$2" || true
}

# ── (a): all four retired flags warn, setup completes ──────────────────────

echo ""
echo "=== req-001 (a): four retired flags warn once each and setup exits 0 ==="

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh claude-code --structured-telemetry-mcp --backend-url "$SECRET_URL" --context-mode-mcp --include-full-skill-library 2>&1)"
EXIT=$?

assert_exit_zero "$EXIT" "req-001 (a): setup exits 0 with all four retired flags"
for flag in "${RETIRED_FLAGS[@]}"; do
  assert_equals "1" "$(count_lines "$OUT" "retired flag $flag")" \
    "req-001 (a): exactly one warning names $flag"
done
assert_equals "0" "$(count_lines "$OUT" "Unknown flag")" \
  "req-001 (a): no Unknown flag error"
assert_equals "0" "$(count_lines "$OUT" "retired-backend.invalid")" \
  "req-001 (a): the --backend-url value never appears in output"
LEAK="$(grep -rl "retired-backend.invalid" . --exclude-dir=planifest-zero --exclude-dir=.git 2>/dev/null | head -1)"
assert_equals "" "$LEAK" \
  "req-001 (a): the --backend-url value is written to no file"
MARKER_FLAGS="$(node -e 'console.log(JSON.stringify(JSON.parse(require("fs").readFileSync(".claude/.planifest-setup-flags","utf8")).flags))' 2>/dev/null)"
assert_equals "[]" "$MARKER_FLAGS" \
  "req-001 (a): the flags marker records no retired flag"
assert_equals "Setup complete." "$(printf '%s\n' "$OUT" | grep -o 'Setup complete\.' | head -1)" \
  "req-001 (a): setup reaches completion"
cd /; rm -rf "$WS"

# ── (b): the --backend-url value rule ─────────────────────────────────────

echo ""
echo "=== req-001 (b): --backend-url never swallows a following flag ==="

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh claude-code --backend-url --strict-orchestrator 2>&1)"
EXIT=$?
assert_exit_zero "$EXIT" "req-001 (b): --backend-url followed by a flag exits 0"
assert_equals "yes" "$([ -f plan/.orchestrator-strict ] && echo yes || echo no)" \
  "req-001 (b): --strict-orchestrator after --backend-url still applies"
cd /; rm -rf "$WS"

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh claude-code --backend-url 2>&1)"
EXIT=$?
assert_exit_zero "$EXIT" "req-001 (b): --backend-url as the last argument exits 0"
assert_equals "1" "$(count_lines "$OUT" "retired flag --backend-url")" \
  "req-001 (b): --backend-url with no value still warns once"
cd /; rm -rf "$WS"

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh --backend-url claude-code 2>&1)"
EXIT=$?
assert_exit_zero "$EXIT" "req-001 (b): --backend-url before the tool name exits 0"
assert_equals "yes" "$([ -f .claude/settings.json ] && echo yes || echo no)" \
  "req-001 (b): --backend-url never swallows the tool name"
cd /; rm -rf "$WS"

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh claude-code "--backend-url=$SECRET_URL" 2>&1)"
EXIT=$?
assert_exit_zero "$EXIT" "req-001 (b): the --backend-url=value form exits 0"
assert_equals "0" "$(count_lines "$OUT" "retired-backend.invalid")" \
  "req-001 (b): the --backend-url=value form never prints the value"
OUT="$(bash planifest-zero/setup.sh claude-code "--bogus=$SECRET_URL" 2>&1)"
assert_equals "0" "$(count_lines "$OUT" "retired-backend.invalid")" \
  "req-001 (b): an unknown --flag=value prints the flag name only"
cd /; rm -rf "$WS"

# ── (c): other unknown flags still fail, usage hides retired flags ────────

echo ""
echo "=== req-001 (c): an unknown flag still exits 1 ==="

WS=$(make_workspace)
cd "$WS"
OUT="$(bash planifest-zero/setup.sh claude-code --bogus 2>&1)"
EXIT=$?
assert_equals "1" "$EXIT" "req-001 (c): --bogus exits 1"
assert_contains "Unknown flag: --bogus" "$OUT" "req-001 (c): --bogus prints Unknown flag"
USAGE="$(bash planifest-zero/setup.sh 2>&1)"
for flag in "${RETIRED_FLAGS[@]}"; do
  assert_equals "0" "$(count_lines "$USAGE" "$flag")" \
    "req-001 (c): usage text doesn't list $flag"
done
cd /; rm -rf "$WS"

# ── (d): setup.ps1 static checks ──────────────────────────────────────────

echo ""
echo "=== req-001 (d): setup.ps1 holds the same retired flags and value rule ==="

PS1="$ZERO_DIR/setup.ps1"
for flag in "${RETIRED_FLAGS[@]}"; do
  assert_equals "yes" "$(grep -q -- "'$flag'" "$PS1" && echo yes || echo no)" \
    "req-001 (d): setup.ps1 names $flag as retired"
done
assert_equals "yes" "$(grep -q 'retired flag' "$PS1" && echo yes || echo no)" \
  "req-001 (d): setup.ps1 prints a retired flag warning"
assert_equals "yes" "$(grep -q "StartsWith('--')" "$PS1" && echo yes || echo no)" \
  "req-001 (d): setup.ps1 skips the --backend-url value only when it doesn't start with --"
assert_equals "yes" "$(grep -q 'RetiredFlags -ccontains' "$PS1" && echo yes || echo no)" \
  "req-001 (d): setup.ps1 matches retired flags case-sensitively, like setup.sh"
assert_equals "yes" "$(grep -q "StartsWith('--backend-url=')" "$PS1" && grep -q "split '=', 2" "$PS1" && echo yes || echo no)" \
  "req-001 (d): setup.ps1 never prints a --flag=value value"
assert_equals "yes" "$(grep -q 'Unknown flag' "$PS1" && echo yes || echo no)" \
  "req-001 (d): setup.ps1 still rejects other unknown flags"

print_summary
