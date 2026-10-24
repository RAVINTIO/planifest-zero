#!/usr/bin/env bash
# Tests for feature 0000164-hardening-and-backlog-skill, req-008: guard.
#
# On macOS Bash 3.2, a while-read loop fed by process substitution can silently
# stop yielding lines. No file under tests/ may use that loop form. Feed the
# loop with a herestring of the command output instead, and skip empty lines.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
SELF="$SCRIPT_DIR/$(basename "$0")"

# Built from parts so this file never contains the pattern it searches for.
PATTERN="done"" < ""<("

# Prints each file under the directory $1 that contains the pattern, except this file.
offenders() {
  local f
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ "$f" = "$SELF" ] && continue
    grep -qF -- "$PATTERN" "$f" 2>/dev/null && echo "${f#"$1"/}"
  done <<< "$(find "$1" \( -type f -o -type l \) | LC_ALL=C sort)"
}

echo "=== req-008: no process-substitution loops under tests/ ==="
assert_equals "" "$(offenders "$SCRIPT_DIR")" "no file under tests/ contains the process-substitution loop"

echo "=== req-008: the guard detects a planted file ==="
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
printf 'while read -r l; do :; %s echo x)\n' "$PATTERN" > "$TMP/bad.sh"
printf 'while read -r l; do :; done <<< "$(echo x)"\n' > "$TMP/good.sh"
assert_equals "bad.sh" "$(offenders "$TMP")" "the guard flags only the file with the pattern"

print_summary
