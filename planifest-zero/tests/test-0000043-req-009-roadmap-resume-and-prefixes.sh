#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-009: resume detection and R- prefixes.

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
RES="$(section '## Resume Detection' "$ORCH")"
ORCH_SEC="$(section '## Phases and Response Prefixes' "$ORCH")"
REF_SEC="$(section '## Phase Indicators' "$REF")"

echo "=== req-009 (a): resume detection ==="
assert_contains 'plan/current-roadmap/' "$RES" "req-009 (a): names plan/current-roadmap/"
IDX_R="$(printf '%s\n' "$RES" | grep -n 'plan/current-roadmap/' | head -1 | cut -d: -f1)"
IDX_C="$(printf '%s\n' "$RES" | grep -n 'Scan `plan/current/`\|plan/current/` for existing' | head -1 | cut -d: -f1)"
assert_equals "yes" "$([ -n "$IDX_R" ] && [ -n "$IDX_C" ] && [ "$IDX_R" -le "$IDX_C" ] && echo yes || echo no)" \
  "req-009 (a): roadmap is checked before plan/current/"
assert_contains 'holds artifacts, resume that step' "$RES" "req-009 (a): artifacts resume that step"
assert_contains 'is empty, start the step at `position`' "$RES" "req-009 (a): empty starts at position"
assert_contains '`position` is past the last step, run R-E Delivery' "$RES" "req-009 (a): finished roadmap resumes at R-E Delivery"

echo ""
echo "=== req-009 (b): prefix tables ==="
for label in orchestrator pipeline-reference; do
  if [ "$label" = orchestrator ]; then SEC="$ORCH_SEC"; else SEC="$REF_SEC"; fi
  for p in 'R-A Chart:' 'R-B Activate:' 'R-C Run:' 'R-D Advance:' 'R-E Delivery:'; do
    assert_contains "\`$p\`" "$SEC" "req-009 (b): $label lists \`$p\`"
  done
  assert_contains '`{prefix} {Status}: {one-liner}`' "$SEC" "req-009 (b): $label states the status form"
  assert_contains 'stage letters, not phase numbers' "$SEC" "req-009 (b): $label says R-A to R-E are stage letters"
  assert_contains '`R-C Run: Starting: ' "$SEC" "req-009 (b): $label shows an R- status in the colon form"
done

echo ""
echo "=== req-009 (c): Hard Limit 10 unchanged ==="
assert_contains 'The pipeline has exactly five phases, P0 to P4.' "$(cat "$ORCH")" "req-009 (c): Hard Limit 10 text"
for t in test-0000042-req-004-phase-numbers-p0-to-p4.sh test-0000042-req-005-message-prefixes.sh test-0000042-req-006-phase-guard-and-stale-cites.sh; do
  bash "$SCRIPT_DIR/$t" >/dev/null 2>&1
  assert_equals "0" "$?" "req-009 (c): $t passes"
done

print_summary
