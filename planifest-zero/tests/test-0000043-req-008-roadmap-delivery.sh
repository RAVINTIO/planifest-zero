#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-008: roadmap delivery.
#
# After the last step, R-E Delivery archives plan/current-roadmap/ and raises
# one roadmap PR to main that asks for a merge commit. The agent never merges
# it and never commits to main.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/planifest-ship/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"

section() { awk -v h="$1" '$0 == h {on=1; next} on && /^##? / {exit} on {print}' "$2"; }

SEC="$(section '## Roadmap steps' "$SHIP")"
DEL="$(printf '%s\n' "$SEC" | awk '/^### R-E Delivery/ {on=1; next} on && /^### / {exit} on {print}')"

echo ""
echo "=== req-008 (a): archive the roadmap folder, status done ==="
assert_contains 'R-E Delivery:' "$DEL" "req-008 (a): uses the R-E Delivery prefix"
assert_contains 'last step' "$DEL" "req-008 (a): runs after the last step"
assert_contains 'plan/current-roadmap/' "$DEL" "req-008 (a): names the source folder"
assert_contains 'plan/_archive/{id}-{slug}-roadmap-{date}/' "$DEL" "req-008 (a): names the archive path"
assert_contains '`status: done`' "$DEL" "req-008 (a): sets status done"
assert_contains 'roadmap branch' "$DEL" "req-008 (a): commits on the roadmap branch"

echo ""
echo "=== req-008 (b): one PR to main asking for a merge commit ==="
assert_contains 'gh pr create --base main' "$DEL" "req-008 (b): PR targets main"
assert_contains '--head roadmap/{id}-{slug}' "$DEL" "req-008 (b): PR comes from the roadmap branch"
assert_contains 'merge commit' "$DEL" "req-008 (b): body asks for a merge commit"
assert_contains 'not a squash' "$DEL" "req-008 (b): body says not a squash"
assert_contains 'version and tag' "$DEL" "req-008 (b): body lists each step with version and tag"

echo ""
echo "=== req-008 (c): never merge the roadmap PR, never commit to main ==="
assert_contains 'never merges the roadmap PR' "$DEL" "req-008 (c): never merges the roadmap PR"
assert_contains 'never commits to `main`' "$DEL" "req-008 (c): never commits to main"
assert_contains 'merge-guard' "$SEC" "req-008 (c): section points at merge-guard for the merge carve-out"

echo ""
echo "=== req-008: pipeline reference records delivery ==="
SHIPREF="$(section '## Ship Phase' "$REF")"
assert_contains 'merge commit' "$SHIPREF" "req-008: pipeline reference asks for a merge commit"

print_summary
