#!/usr/bin/env bash
# Test: 0000151 req-011 orchestrator-references-split
# Rarely used orchestrator sections live in references/orchestrator-*.md. The
# test proves the size target, that no rule line was lost, that the Pack Index
# lists every reference file, and that setup installs the files.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT_DIR="$(cd "$ZERO_DIR/.." && pwd)"

SKILL_DIR="$ZERO_DIR/skills/ravintio-orchestrator"
SKILL="$SKILL_DIR/SKILL.md"
REFS="$SKILL_DIR/references"
# SKILL.md at the base commit 8b1e929 (36,216 bytes), kept as a fixture so the
# check does not depend on git history.
BASE="$SCRIPT_DIR/fixtures/0000151-orchestrator-skill-base.md"

TMP="$(mktemp -d -t ravintio_0000151_req011_XXXXXX)"
trap 'rm -rf "$TMP"' EXIT

# Print every non-blank, non-heading line of $1 that no later file holds as a
# whole line. Usage: missing_lines base file...
missing_lines() {
  local base="$1"; shift
  local all="$TMP/all.$$"
  cat "$@" > "$all"
  grep -v '^[[:space:]]*$' "$base" | grep -v '^#' | while IFS= read -r line; do
    grep -Fxq -- "$line" "$all" || printf '%s\n' "$line"
  done
}

echo "=== (a) size target ==="
SKILL_BYTES=$(wc -c < "$SKILL" | tr -d ' ')
CLAUDE_BYTES=$(wc -c < "$ROOT_DIR/CLAUDE.md" | tr -d ' ')
assert_equals "36216" "$(wc -c < "$BASE" | tr -d ' ')" "fixture holds the 36,216 byte baseline"
assert_equals "yes" "$([ "$SKILL_BYTES" -le 27162 ] && echo yes || echo no)" "SKILL.md is 27,162 bytes or fewer ($SKILL_BYTES)"
assert_equals "yes" "$([ $((SKILL_BYTES + CLAUDE_BYTES)) -le 35484 ] && echo yes || echo no)" "CLAUDE.md plus SKILL.md is 35,484 bytes or fewer ($((SKILL_BYTES + CLAUDE_BYTES)))"

echo "=== (a) no rule line was lost ==="
REF_FILES=$(ls "$REFS"/orchestrator-*.md 2>/dev/null)
assert_equals "yes" "$([ -n "$REF_FILES" ] && echo yes || echo no)" "reference files exist"
# shellcheck disable=SC2086
MISSING="$(missing_lines "$BASE" "$SKILL" $REF_FILES)"
assert_equals "" "$MISSING" "every base line is in SKILL.md or a reference file"

echo "=== (a) mutation: removing one moved line makes the check fail ==="
MUT_LINE='**Confirmation is human-only, per item.**'
MUT_FILE="$REFS/orchestrator-scope-lock.md"
assert_equals "1" "$(grep -cF -- "$MUT_LINE" "$MUT_FILE")" "the mutation target is in the reference file once"
assert_equals "0" "$(grep -cF -- "$MUT_LINE" "$SKILL")" "the mutation target is not in SKILL.md"
mkdir -p "$TMP/mut"
for f in $REF_FILES; do cp "$f" "$TMP/mut/"; done
grep -vF -- "$MUT_LINE" "$MUT_FILE" > "$TMP/mut/orchestrator-scope-lock.md"
# shellcheck disable=SC2046
MUT_MISSING="$(missing_lines "$BASE" "$SKILL" $(ls "$TMP"/mut/orchestrator-*.md))"
assert_contains "Confirmation is human-only" "$MUT_MISSING" "the check reports the removed line"

echo "=== (b) inline sections keep their original text ==="
section_lines() { # file heading: lines of the section, without the heading
  awk -v h="$2" '$0==h {on=1; next} on && /^## / {exit} on {print}' "$1"
}
for h in '## Hard Limits' '## Resume Detection' '## Exception Stops' '## Phase Invocation (P1 to P4)'; do
  section_lines "$BASE" "$h" > "$TMP/sec.base"
  assert_equals "yes" "$([ -s "$TMP/sec.base" ] && echo yes || echo no)" "base has $h"
  assert_equals "" "$(missing_lines "$TMP/sec.base" "$SKILL")" "$h: every base line is still in SKILL.md"
done
for h in '### Discovery Start Actions'; do
  awk -v h="$h" '$0==h {on=1; next} on && /^### / {exit} on {print}' "$BASE" > "$TMP/sec.base"
  assert_equals "" "$(missing_lines "$TMP/sec.base" "$SKILL")" "$h: every base line is still in SKILL.md"
done
for h in '## Hard Limits' '## Resume Detection' '### Discovery Start Actions' '## Exception Stops' '## Phase Invocation (P1 to P4)' '## Subagent Dispatch' '## Pack Index (JIT Loading)'; do
  assert_equals "1" "$(grep -cxF -- "$h" "$SKILL")" "SKILL.md keeps the heading $h"
done

echo "=== (b) Pack Index lists every reference file ==="
INDEX="$(sed -n '/^## Pack Index/,/^---$/p' "$SKILL")"
COUNT=0
for f in "$REFS"/*; do
  n="$(basename "$f")"
  [ "$n" = ".gitkeep" ] && continue
  COUNT=$((COUNT + 1))
  assert_contains "references/$n" "$INDEX" "Pack Index has a row for $n"
  assert_equals "yes" "$([[ "$n" == orchestrator-*.md ]] && echo yes || echo no)" "$n has the orchestrator- prefix"
done
assert_equals "yes" "$([ "$COUNT" -ge 6 ] && echo yes || echo no)" "at least the required sections moved ($COUNT files)"
assert_contains "Before you act on" "$INDEX" "Pack Index states the read-before-acting rule"
for h in 'Adoption Modes' 'Retrofit Scan' 'Pause Command' 'Park Command' 'Phase Skip Protocol' 'Standalone and Subagent Skills' 'Capability Skills' 'Mid-Pipeline Requirement Changes'; do
  assert_equals "yes" "$(grep -qE "^#+ $h" $REF_FILES && echo yes || echo no)" "$h now lives in a reference file"
  assert_equals "0" "$(grep -cE "^#+ $h" "$SKILL")" "$h is no longer a heading in SKILL.md"
done

echo "=== (c) setup installs the reference files ==="
WS="$(mktemp -d -t ravintio_0000151_req011_ws_XXXXXX)"
cp -r "$ZERO_DIR" "$WS/ravintio-zero"
git init "$WS" >/dev/null 2>&1
(cd "$WS" && GIT_CEILING_DIRECTORIES="$(dirname "$WS")" bash ravintio-zero/setup.sh claude-code >"$WS/setup.out" 2>"$WS/setup.err")
assert_exit_zero "$?" "setup.sh exits 0"
INST="$WS/.claude/skills/ravintio-orchestrator/references"
for f in $REF_FILES; do
  n="$(basename "$f")"
  assert_equals "yes" "$([ -f "$INST/$n" ] && cmp -s "$f" "$INST/$n" && echo yes || echo no)" "installed copy of $n matches the source"
done
rm -rf "$WS"

print_summary
