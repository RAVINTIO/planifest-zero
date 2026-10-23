#!/usr/bin/env bash
# Tests for feature 0000023-framework-pipeline-fixes, req-001, as revised by
# 0000042 req-001 and req-002: run modes at the ordinary phase gates.
#
# Covers: the orchestrator's Phase Invocation table and the run-mode question.
# The plan (P1) and implement (P2) gates stop in gated mode and do not stop in
# autonomous mode. The run-mode question offers Gated and Autonomous, and the
# answer is written to plan/.run-mode.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

SKILL="$SCRIPT_DIR/../skills/planifest-orchestrator/SKILL.md"

if [ ! -f "$SKILL" ]; then
  echo "  FAIL: $SKILL not found"
  ((FAIL++)) || true
  print_summary
fi

CONTENT=$(cat "$SKILL")

echo ""
echo "=== req-001: P1/P2 gates stop in gated mode only ==="

TABLE_SECTION=$(printf '%s\n' "$CONTENT" | sed -n '/## Phase Invocation/,/^## Mid-Pipeline/p')

P1_ROW=$(printf '%s\n' "$TABLE_SECTION" | grep '| P1 Plan |')
assert_contains "Gated: STOP for confirmation. Autonomous: no stop." "$P1_ROW" \
  "req-001: P1 Plan row stops in gated mode only"

P2_ROW=$(printf '%s\n' "$TABLE_SECTION" | grep '| P2 Implement |')
assert_contains "Gated: STOP for confirmation. Autonomous: no stop." "$P2_ROW" \
  "req-001: P2 Implement row stops in gated mode only"

echo ""
echo "=== req-001: acceptance and ship gates always stop ==="

P3_ROW=$(printf '%s\n' "$TABLE_SECTION" | grep '| P3 Validate and Accept |')
assert_contains "Acceptance ALWAYS stops." "$P3_ROW" \
  "req-001: P3 acceptance gate stops"

P4_ROW=$(printf '%s\n' "$TABLE_SECTION" | grep '| P4 Ship |')
assert_contains "Final gate. Always stops." "$P4_ROW" \
  "req-001: P4 ship gate always stops"

echo ""
echo "=== req-001: no stray 'No exception' left in the Phase Invocation table ==="

if [[ "$TABLE_SECTION" == *"No exception"* ]]; then
  echo "  FAIL: req-001: 'No exception' still present in the Phase Invocation table"
  ((FAIL++)) || true
else
  echo "  PASS: req-001: 'No exception' fully removed from the Phase Invocation table"
  ((PASS++)) || true
fi

echo ""
echo "=== req-001: run mode is captured and restored ==="

assert_contains "[1] Gated: the agent stops for you at the end of each phase" "$CONTENT" \
  "req-001: the run-mode question offers gated"
assert_contains "[2] Autonomous: the agent runs to a raised PR and stops only for escalations" "$CONTENT" \
  "req-001: the run-mode question offers autonomous"
assert_contains 'write `plan/.run-mode` (`gated` or `autonomous`)' "$CONTENT" \
  "req-001: the answer is persisted to plan/.run-mode"

print_summary
