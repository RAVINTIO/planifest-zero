#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-001: roadmap drafts.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/planifest-orchestrator/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"
TPL="$ZERO_DIR/templates/roadmap-entry.template.md"

# The section from a heading to the next "---" rule.
section() { awk -v h="$1" '$0 == h {on=1; next} on && /^---$/ {exit} on {print}' "$2"; }
RM="$(section '## Roadmaps' "$ORCH")"

echo "=== req-001 (a): template exists with the required fields ==="
assert_equals "yes" "$([ -f "$TPL" ] && echo yes || echo no)" "req-001 (a): roadmap-entry.template.md exists"
T="$(cat "$TPL" 2>/dev/null)"
for f in 'title:' 'summary:' 'status:' '**Goal:**' '**Branch:**' '**Status:**' '**Position:**' 'Stop conditions'; do
  assert_contains "$f" "$T" "req-001 (a): template has $f"
done
for s in draft active blocked done; do
  assert_contains "$s" "$T" "req-001 (a): template names status $s"
done
assert_contains '| Step | Feature id | Backlog entries | Bump | Version | Status |' "$T" \
  "req-001 (a): template has the six-column step table"

echo ""
echo "=== req-001 (b): shared id sequence ==="
assert_contains 'seven-digit sequence' "$RM" "req-001 (b): ids share the backlog's seven-digit sequence"
assert_contains 'plan/backlog/' "$RM" "req-001 (b): high-water mark covers backlog"
assert_contains 'plan/_archive/' "$RM" "req-001 (b): high-water mark covers archive"
assert_contains 'plan/changelog/' "$RM" "req-001 (b): high-water mark covers changelog"
assert_contains 'plan/roadmap/' "$RM" "req-001 (b): high-water mark covers roadmap"

echo ""
echo "=== req-001 (c): filing rules ==="
assert_contains 'no prefix' "$RM" "req-001 (c): filing has no prefix"
assert_contains 'any branch and in any phase' "$RM" "req-001 (c): any branch and any phase"
assert_contains 'only after the human confirms' "$RM" "req-001 (c): write only after human confirms"
assert_contains 'plan/roadmap/{id}-{slug}/roadmap.md' "$RM" "req-001: draft path stated"

print_summary
