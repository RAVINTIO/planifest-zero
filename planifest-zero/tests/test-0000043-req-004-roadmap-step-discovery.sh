#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-004: R-C Run step discovery.

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
RC="$(awk '$0 == "### R-C Run" {on=1; next} on && /^#/ {exit} on {print}' "$STD")"
SL="$(section '### Scope Lock Challenge' "$ORCH")"
DC="$(awk '$0 == "### Design Confirmation (the discovery gate)" {on=1; next} on && /^---$/ {exit} on {print}' "$ORCH")"
DSA="$(awk '$0 == "### Discovery Start Actions" {on=1; next} on && /^### Adoption/ {exit} on {print}' "$ORCH")"

echo "=== req-004 (a): branch, brief, run mode ==="
assert_contains '`R-C Run:`' "$RC" "req-004 (a): R-C Run prefix"
assert_contains "step's feature branch from the roadmap branch" "$RC" "req-004 (a): branch cut from the roadmap branch"
assert_contains 'not from `main`' "$RC" "req-004 (a): not from main"
assert_contains 'backlog entries' "$RC" "req-004 (a): brief from the step's backlog entries"
assert_contains 'same commit' "$RC" "req-004 (a): pull-in and deletion in one commit"
assert_contains 'plan/.run-mode' "$RC" "req-004 (a): writes plan/.run-mode"
assert_contains '`autonomous`' "$RC" "req-004 (a): autonomous"
assert_contains 'without asking' "$RC" "req-004 (a): no run-mode question"
assert_contains 'R-C Run' "$DSA" "req-004 (a): Discovery Start Actions points to R-C Run"

echo ""
echo "=== req-004 (b): self-confirmation ==="
assert_contains 'draft-accepted (roadmap)' "$RC" "req-004 (b): records draft-accepted (roadmap)"
assert_contains 'too vague to draft' "$RC" "req-004 (b): stops only when too vague"
assert_contains 'R-C Run' "$SL" "req-004 (b): Scope Lock Challenge points to R-C Run"
assert_contains 'R-C Run' "$DC" "req-004 (b): Design Confirmation points to R-C Run"

echo ""
echo "=== req-004 (c): per-step bump ==="
assert_contains '`Bump`' "$RC" "req-004 (c): Bump field"
assert_contains '`major`, `minor`, or `patch`' "$RC" "req-004 (c): bump values"
assert_contains 'default `minor`' "$RC" "req-004 (c): default minor"
assert_contains "roadmap branch's version comes from \`product.yml\`" "$RC" "req-004 (c): bump applies to the roadmap branch's version from product.yml"
assert_contains '`docs/about.md` when `product.yml` is absent' "$RC" "req-004 (c): docs/about.md fallback"
assert_contains 'downgrade block' "$RC" "req-004 (c): downgrade block kept"
assert_contains 'R-C Run' "$(printf '%s\n' "$DSA" | grep 'Suggest a version bump')" "req-004 (c): version step points to R-C Run"

print_summary
