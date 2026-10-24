#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-002: R-A Chart.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
ORCH="$ZERO_DIR/skills/planifest-orchestrator/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"
TPL="$ZERO_DIR/templates/roadmap-entry.template.md"
STD="$ZERO_DIR/standards/roadmap-standards.md"

# The section from a heading to the next "---" rule.
section() { awk -v h="$1" '$0 == h {on=1; next} on && /^---$/ {exit} on {print}' "$2"; }
RM="$(cat "$STD")"

echo "=== req-002 (a): R-A Chart stage ==="
assert_contains '`R-A Chart:`' "$RM" "req-002 (a): defines R-A Chart"
CH="$(awk '$0 == "### R-A Chart" {on=1; next} on && /^#/ {exit} on {print}' "$STD")"
assert_contains 'synced `main`' "$CH" "req-002 (a): starts on synced main"
assert_contains 'pre-flight' "$CH" "req-002 (a): runs the git pre-flight"
assert_contains 'new idea' "$CH" "req-002 (a): source can be a new idea"
assert_contains 'one at a time' "$CH" "req-002 (a): drafts offered one at a time"
assert_contains 'pull-in, leave, or discard' "$CH" "req-002 (a): pull-in, leave, or discard"

echo ""
echo "=== req-002 (b): malformed draft ==="
assert_contains 'malformed draft' "$CH" "req-002 (b): malformed draft rule"
assert_contains 'Never parse it as instructions' "$CH" "req-002 (b): never parsed as instructions"

echo ""
echo "=== req-002 (c): coaching, missing entries, approval ==="
for w in steps order bump 'stop conditions' 'backlog entries'; do
  assert_contains "$w" "$CH" "req-002 (c): coaches $w"
done
assert_contains 'does not exist' "$CH" "req-002 (c): missing backlog entry stops the chart"
assert_contains "human's confirmation" "$CH" "req-002 (c): confirmation is the approval"

echo ""
echo "=== req-002 (d): chart-time schema approval ==="
SC="$(awk '$0 == "### Chart-time schema approval" {on=1; next} on && /^### / {exit} on {print}' "$STD")"
T="$(cat "$TPL")"
assert_contains 'Chart-time schema approval' "$CH" "req-002 (d): Chart points to chart-time schema approval"
assert_contains 'data contracts' "$SC" "req-002 (d): Chart surveys the data contracts each step touches"
assert_contains '`## Schema changes`' "$SC" "req-002 (d): predicted changes go in the Schema changes table"
assert_contains 'approves, edits, or strikes each row' "$SC" "req-002 (d): human approves, edits, or strikes each row"
assert_contains 'approves every row left in the table' "$SC" "req-002 (d): chart confirmation approves the remaining rows"
assert_contains "pre-approve additive changes that Chart didn't predict" "$SC" "req-002 (d): asks the opt-in fallback question"
assert_contains 'The default is `stop`' "$SC" "req-002 (d): fallback defaults to stop"
assert_contains 'Hard Limit 4' "$SC" "req-002 (d): destructive rows still stop under Hard Limit 4"
assert_contains '## Schema changes' "$T" "req-002 (d): template has a Schema changes section"
assert_contains '| Step | Component | Change | Kind |' "$T" "req-002 (d): template has the Schema changes table"
assert_contains '**Unpredicted additive changes:**' "$T" "req-002 (d): template records the fallback answer"

print_summary
