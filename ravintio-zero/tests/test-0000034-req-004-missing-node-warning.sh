#!/usr/bin/env bash
# Tests for feature 0000034-setup-hardening, req-004: missing node warning.
#
# remove_legacy_telemetry_wiring skips its settings.json cleanup when node is
# not on the PATH. It must say so once when settings.json exists, and stay
# silent when there is no settings.json to clean (backlog 0000091).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
WARNING="node not found, skipping the telemetry cleanup of"

# Runs only remove_legacy_telemetry_wiring from setup.sh, with a PATH that
# holds no node binary.
run_cleanup() {
  local root="$1" path="$2"
  local fn
  fn="$(sed -n '/^remove_legacy_telemetry_wiring() {/,/^}/p' "$ZERO_DIR/setup.sh")"
  PATH="$path" PROJECT_ROOT="$root" /bin/bash -c "
    TELEMETRY_HOOK_MODULES='emit-event'
    TELEMETRY_MCP_MATCHER='mcp__structured-telemetry-mcp__emit_event'
    $fn
    remove_legacy_telemetry_wiring .claude/settings.json
  " 2>&1
}

NO_NODE_PATH="$(mktemp -d -t ravintio_0000034_req004_bin_XXXXXX)"
for tool in rm rmdir mkdir cat sed grep printf dirname basename; do
  src="$(command -v "$tool" 2>/dev/null)" && ln -s "$src" "$NO_NODE_PATH/$tool"
done

echo ""
echo "=== req-004 (a): node missing with settings.json present warns once ==="

WS=$(mktemp -d -t ravintio_0000034_req004_test_XXXXXX)
mkdir -p "$WS/.claude"
echo '{}' > "$WS/.claude/settings.json"
OUT="$(run_cleanup "$WS" "$NO_NODE_PATH")"
assert_equals "1" "$(printf '%s\n' "$OUT" | grep -c "$WARNING" || true)" \
  "req-004 (a): exactly one missing-node warning"
assert_contains ".claude/settings.json" "$OUT" "req-004 (a): the warning names settings.json"
rm -rf "$WS"

echo ""
echo "=== req-004 (b): node missing with no settings.json stays silent ==="

WS=$(mktemp -d -t ravintio_0000034_req004_test_XXXXXX)
OUT="$(run_cleanup "$WS" "$NO_NODE_PATH")"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c "$WARNING" || true)" \
  "req-004 (b): no warning without settings.json"
rm -rf "$WS"

echo ""
echo "=== req-004 (c): node present prints no warning ==="

WS=$(mktemp -d -t ravintio_0000034_req004_test_XXXXXX)
mkdir -p "$WS/.claude"
echo '{}' > "$WS/.claude/settings.json"
OUT="$(run_cleanup "$WS" "$PATH")"
assert_equals "0" "$(printf '%s\n' "$OUT" | grep -c "$WARNING" || true)" \
  "req-004 (c): no warning when node is on the PATH"
rm -rf "$WS" "$NO_NODE_PATH"

print_summary
