#!/usr/bin/env bash
# Tests for feature 0000043-autonomous-roadmaps, req-005: roadmap advance.
#
# The ship skill has a "Roadmap steps" section for R-D Advance. It applies
# when plan/current-roadmap/roadmap.md has status active. A normal run keeps
# the tag-before-PR order and the no-merge rule.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$SCRIPT_DIR/.."
SHIP="$ZERO_DIR/skills/planifest-ship/SKILL.md"
REF="$ZERO_DIR/pipeline-reference.md"
STD="$ZERO_DIR/standards/roadmap-standards.md"

# The section from a heading to the next heading of the same or higher level.
section() { awk -v h="$1" '$0 == h {on=1; next} on && /^##? / {exit} on {print}' "$2"; }

ALL="$(cat "$SHIP")"
SEC="$(section '## Ship stages' "$STD")"
ADV="$(printf '%s\n' "$SEC" | awk '/^### R-D Advance/ {on=1; next} on && /^### / {exit} on {print}')"

echo ""
echo "=== req-005 (a): roadmap-step PR command and roadmap.md update ==="
assert_contains 'plan/current-roadmap/roadmap.md' "$SEC" "req-005 (a): section names the roadmap file"
assert_contains '`status: active`' "$SEC" "req-005 (a): section applies on status active"
assert_contains 'R-D Advance:' "$SEC" "req-005 (a): section uses the R-D Advance prefix"
assert_contains '--base roadmap/{id}-{slug}' "$ADV" "req-005 (a): PR targets the roadmap branch"
assert_contains '`merged`' "$ADV" "req-005 (a): same PR sets the step to merged"
assert_contains 'Version' "$ADV" "req-005 (a): same PR fills Version"
assert_contains '`position`' "$ADV" "req-005 (a): same PR moves position"
assert_contains 'same PR' "$ADV" "req-005 (a): roadmap update rides in the same PR"

echo ""
echo "=== req-005 (b): green CI, squash merge, fetch, tag, push tag ==="
assert_contains 'gh pr checks' "$ADV" "req-005 (b): waits with gh pr checks"
assert_contains 'gh pr merge --squash' "$ADV" "req-005 (b): squash merges"
assert_contains 'Blocked:' "$ADV" "req-005 (b): red or pending CI is a Blocked stop"
assert_contains 'pending' "$ADV" "req-005 (b): pending CI is named"
assert_contains '--json mergeCommit -q .mergeCommit.oid' "$ADV" "req-005 (b): reads the PR merge commit"
assert_contains 'git fetch' "$ADV" "req-005 (b): fetches after the merge"
assert_contains 'git tag v{version}' "$ADV" "req-005 (b): tags the squash commit"
assert_contains 'git push origin v{version}' "$ADV" "req-005 (b): pushes the tag"
order="$(printf '%s\n' "$ADV" | grep -nE 'gh pr checks|gh pr merge --squash|git fetch|git tag v|git push origin v' | cut -d: -f1 | tr '\n' ' ')"
sorted="$(printf '%s\n' $order | sort -n | tr '\n' ' ')"
assert_equals "$sorted" "$order" "req-005 (b): checks, merge, fetch, tag, push appear in order"

echo ""
echo "=== req-005 (c): normal run keeps tag-before-PR and no merge ==="
assert_contains 'git tag v{version} -m "{feature-id}"' "$ALL" "req-005 (c): Step 7 tag command kept"
assert_contains 'Local only. Do not push the tag.' "$ALL" "req-005 (c): Step 7 stays local only"
assert_contains 'Merging into `main` stays human-only in every run mode' "$ALL" "req-005 (c): Hard Limit 5 keeps main human-only"
assert_contains 'Outside a roadmap' "$SEC" "req-005 (c): section says a normal run is unchanged"
s7="$(grep -n '^### Step 7' "$SHIP" | cut -d: -f1)"
s8="$(grep -n '^### Step 8' "$SHIP" | cut -d: -f1)"
rs="$(grep -n '^## Roadmap steps' "$SHIP" | cut -d: -f1)"
assert_equals "yes" "$([ -n "$s7" ] && [ -n "$s8" ] && [ "$s7" -lt "$s8" ] && echo yes || echo no)" "req-005 (c): Step 7 tag precedes Step 8 PR"
assert_equals "yes" "$([ -n "$rs" ] && [ -n "$s8" ] && [ "$rs" -gt "$s8" ] && echo yes || echo no)" "req-005 (c): roadmap section sits after the normal steps"

echo ""
echo "=== req-005: pipeline reference records both tag orders ==="
SHIPREF="$(section '## Ship Phase' "$REF")"
assert_contains 'roadmap' "$SHIPREF" "req-005: pipeline reference Ship Phase mentions roadmap steps"
assert_contains 'squash' "$SHIPREF" "req-005: pipeline reference notes the squash-then-tag order"

print_summary
