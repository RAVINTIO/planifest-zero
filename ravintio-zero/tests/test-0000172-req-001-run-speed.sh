#!/usr/bin/env bash
# 0000172 req-001: run-speed-setting
# The orchestrator asks for a run speed and writes plan/.run-speed. A missing
# or unknown value counts as standard, a roadmap step reads its Speed field,
# and ship clears the file with the other sentinels (ADR-002).
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
SHIP="$ZERO_DIR/skills/ravintio-ship/SKILL.md"
ROAD="$ZERO_DIR/standards/roadmap-standards.md"
TPL="$ZERO_DIR/templates/roadmap-entry.template.md"

echo ""
echo "=== 0000172 req-001 run-speed-setting ==="

check() {
  if [ "$2" = "0" ]; then echo "  PASS: $1"; PASS=$((PASS+1)); else echo "  FAIL: $1"; FAIL=$((FAIL+1)); fi
}

section() { awk -v h="$2" 'index($0,h)==1{f=1;next} f&&/^#{1,3} /{f=0} f' "$1"; }

# AC-1: Design Confirmation asks the speed question and records it
sec="$(section "$ORCH" '### Design Confirmation')"
ok=1
if printf '%s\n' "$sec" | grep -qF 'Standard:' \
  && printf '%s\n' "$sec" | grep -qF 'Fast:' \
  && printf '%s\n' "$sec" | grep -qF '`plan/.run-speed`' \
  && printf '%s\n' "$sec" | grep -qF 'Run speed: {fast | standard}'; then ok=0; fi
check "req-001 AC-1: Design Confirmation asks for and records the run speed" "$ok"

# AC-2: missing or unknown counts as standard, roadmap Speed field
ok=1
if printf '%s\n' "$sec" | grep -qi 'missing' \
  && printf '%s\n' "$sec" | grep -qi 'counts as `standard`' \
  && section "$ROAD" '### R-C Run' | grep -qF '**Speed:**' \
  && grep -qF '**Speed:**' "$TPL"; then ok=0; fi
check "req-001 AC-2: missing or unknown is standard, roadmap names Speed" "$ok"

# AC-3: ship Step 8 and the orchestrator cleanup rules delete the file
ok=1
if section "$SHIP" '### Step 8' | grep -qF '`plan/.run-speed`' \
  && grep -F '**Interrupted-ship cleanup.**' "$ORCH" | grep -qF '`plan/.run-speed`' \
  && grep -F '**Stale run-mode**' "$ORCH" | grep -qF '`plan/.run-speed`'; then ok=0; fi
check "req-001 AC-3: ship and cleanup rules delete plan/.run-speed" "$ok"

# plan/.run-mode keeps its two values
ok=1
grep -qF 'No other value is valid' "$ORCH" && ! grep -qE 'run-mode`? *\(?`?fast' "$ORCH" && ok=0
check "req-001: plan/.run-mode keeps gated and autonomous only" "$ok"

print_summary
