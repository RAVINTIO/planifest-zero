#!/usr/bin/env bash
# Test: 0000151 req-014 chart-clarity-and-dependency-stop
# Chart checks entry clarity and surveys dependencies. A sixth exception stop
# fires in every run for an unapproved library or service.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$ZERO_DIR/.." && pwd)"

STD="$ZERO_DIR/standards/roadmap-standards.md"
ENTRY="$ZERO_DIR/templates/initiative.template.md"
DESIGN="$ZERO_DIR/templates/design.template.md"
ORCH="$ZERO_DIR/skills/ravintio-orchestrator/SKILL.md"
IMPL="$ZERO_DIR/skills/ravintio-implement/SKILL.md"
PLAN="$ZERO_DIR/skills/ravintio-plan/SKILL.md"

has() { grep -qF -- "$1" "$2" && echo yes || echo no; }

echo "=== (a) roadmap-standards clarity check ==="
CHART=$(sed -n '/^### I-A Chart/,/^### Chart-time schema approval/p' "$STD")
assert_contains 'clarity check' "$CHART" "Chart has a clarity check"
assert_contains 'a problem, a wanted outcome, and one observable condition' "$CHART" "names the three things"
assert_contains 'sharpen it or strike the step' "$CHART" "human sharpens or strikes"
assert_contains 'Chart never rewrites an entry itself' "$CHART" "Chart never rewrites"

echo "=== (a) roadmap-standards dependency survey ==="
DEP=$(sed -n '/^### Chart-time dependency approval/,/^### I-B Activate/p' "$STD")
assert_contains '## Dependencies' "$DEP" "names the Dependencies table"
assert_contains '`library`' "$DEP" "kind library"
assert_contains '`service`' "$DEP" "kind service"
assert_contains '`none`' "$DEP" "none row"
assert_contains 'stops the step' "$DEP" "unlisted dependency stops the step"
SCH=$(grep -n '^### Chart-time schema approval' "$STD" | cut -d: -f1)
DPN=$(grep -n '^### Chart-time dependency approval' "$STD" | cut -d: -f1)
assert_equals "yes" "$([ -n "$DPN" ] && [ "$DPN" -gt "$SCH" ] && echo yes || echo no)" "dependency section follows schema approval"

echo "=== (a) templates ==="
assert_equals "yes" "$(grep -n '^## Schema changes' "$ENTRY" | cut -d: -f1 | { read s; d=$(grep -n '^## Dependencies' "$ENTRY" | cut -d: -f1); [ -n "$d" ] && [ "$d" -gt "$s" ] && echo yes || echo no; })" "entry template Dependencies after Schema changes"
assert_equals "yes" "$(grep -q '^| Step | Name | Kind | Purpose |' "$ENTRY" && echo yes || echo no)" "entry template four columns"
assert_equals "yes" "$(grep -q '| none |' "$ENTRY" && echo yes || echo no)" "entry template none row"
assert_equals "yes" "$(has 'Chart-time dependency approval' "$ENTRY")" "header note points to the section"
assert_equals "yes" "$(has 'Approved dependencies' "$DESIGN")" "design template field"

echo "=== (b) Exception Stops ==="
STOPS=$(sed -n '/^## Exception Stops/,/^## Mid-Pipeline/p' "$ORCH")
ROWS=$(echo "$STOPS" | grep -c '^| [^E-]')
assert_equals "6" "$ROWS" "six exception rows"
assert_contains 'Blocked: new dependency {name} is not on the approved list. Approve it or choose an approved alternative.' "$STOPS" "dependency message"
assert_contains 'Approved dependencies' "$STOPS" "names design list"
assert_contains '## Dependencies' "$STOPS" "names roadmap list"
assert_contains 'every run mode' "$STOPS" "applies to both run modes"
for t in 'A requirement or check still fails after 5 attempts' 'P2 needs a schema change, unless an initiative step matches a chart-approved row' 'The P3 security review finds an unmitigated critical or high issue' 'A push or `gh pr create` fails' 'A possible credential appears in a file the run will commit, or in a PR body'; do
  assert_contains "$t" "$STOPS" "original row kept: $t"
done

echo "=== (b) skills ==="
for f in "$IMPL" "$PLAN"; do
  n=$(basename "$(dirname "$f")")
  assert_equals "yes" "$(has 'not on the approved list' "$f")" "$n states the dependency stop"
  assert_equals "yes" "$(has 'Approved dependencies' "$f")" "$n names the design list"
  assert_equals "yes" "$(has '## Dependencies' "$f")" "$n names the initiative list"
done

echo "=== (c) installed copies ==="
# .claude/ exists only after setup, so a clean CI checkout skips this loop.
DIFFS=0
for src in "$IMPL" "$PLAN"; do
  n=$(basename "$(dirname "$src")")
  inst="$ROOT_DIR/.claude/skills/$n/SKILL.md"
  [ -e "$inst" ] || continue
  cmp -s "$src" "$inst" || DIFFS=$((DIFFS + 1))
done
assert_equals "0" "$DIFFS" "installed skill copies match the source"

print_summary
