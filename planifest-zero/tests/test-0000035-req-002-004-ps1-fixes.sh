#!/usr/bin/env bash
# Tests for feature 0000035-powershell-setup-parity, req-002 to req-004.
#
# req-002: Remove-LegacyTelemetryWiring skips a non-array event value
# (backlog 0000094). req-003: setup.ps1 uses no -AsHashtable, so it runs on
# Windows PowerShell 5.1 (ADR-002). req-004: the flag switch is
# case-sensitive (ADR-003). No pwsh runner exists (backlog 0000084), so these
# checks read the source.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SETUP_PS1="$ZERO_DIR/setup.ps1"

extract_function_body() {
  awk -v name="function $1" '
    $0 ~ "^" name { flag=1 }
    flag && /^function / && $0 !~ "^" name { exit }
    flag { print }
  ' "$SETUP_PS1"
}

echo ""
echo "=== req-002: the legacy cleanup skips a non-array event value ==="

CLEANUP="$(extract_function_body 'Remove-LegacyTelemetryWiring')"
SKIP_LINE="$(printf '%s\n' "$CLEANUP" | grep -n -- '-isnot \[System.Array\]' | head -1 | cut -d: -f1)"
WRAP_LINE="$(printf '%s\n' "$CLEANUP" | grep -n 'entries = @(\$existing.hooks.\$event)' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$SKIP_LINE" ] && echo yes || echo no)" \
  "req-002: the loop tests each event value with -isnot [System.Array]"
assert_equals "yes" "$([ -n "$SKIP_LINE" ] && [ -n "$WRAP_LINE" ] && [ "$SKIP_LINE" -lt "$WRAP_LINE" ] && echo yes || echo no)" \
  "req-002: the test runs before the value is wrapped in an array"
assert_contains "continue" "$(printf '%s\n' "$CLEANUP" | sed -n "${SKIP_LINE:-1}p")" \
  "req-002: a non-array value is skipped with continue"

echo ""
echo "=== req-003: setup.ps1 runs on Windows PowerShell 5.1 ==="

assert_equals "0" "$(cat "$SETUP_PS1" "$ZERO_DIR"/setup/*.ps1 | grep -c -- '-AsHashtable' || true)" \
  "req-003: setup.ps1 and setup/*.ps1 use no -AsHashtable"
ALLOWED="$(extract_function_body 'Merge-AllowedTools')"
assert_contains "Write-SettingsAtomic" "$ALLOWED" \
  "req-003: Merge-AllowedTools still writes through Write-SettingsAtomic"
assert_contains "notcontains 'Agent'" "$ALLOWED" \
  "req-003: Merge-AllowedTools still adds Agent only once"

echo ""
echo "=== req-004: setup.ps1 flags are case-sensitive ==="

assert_equals "1" "$(grep -c 'switch -CaseSensitive (\$args\[\$i\])' "$SETUP_PS1" || true)" \
  "req-004: the argument loop uses switch -CaseSensitive"
assert_equals "1" "$(grep -c "^        '--strict-orchestrator' {" "$SETUP_PS1" || true)" \
  "req-004: the --strict-orchestrator label is lower case"

print_summary
