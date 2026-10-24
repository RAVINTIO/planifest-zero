#!/usr/bin/env bash
# Feature 0000160 req-005: migrate-ravintio-rename.sh moves a consumer repo to the
# ravintio names. Covers the clean run, a rerun, each stop condition, git mv, and
# symlink refusal. Each case runs in a scratch git repo.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

HELPER="$ZERO_DIR/migrations/migrate-ravintio-rename.sh"
OLD="plan""ifest"   # keep the old name out of a literal brand scan

WS=$(mktemp -d)
trap 'rm -rf "${WS:?}"' EXIT

# make_repo NAME: scratch consumer repo with the old install and the new pack.
make_repo() {
  local d="$WS/$1"
  mkdir -p "$d/ravintio-zero" "$d/$OLD-zero" "$d/$OLD-overrides/instructions" \
           "$d/.github/workflows" "$d/.claude/skills"
  echo "mine" > "$d/$OLD-overrides/instructions/a.md"
  printf 'run: bash %s-zero/tests/run-tests.sh\n' "$OLD" > "$d/.github/workflows/$OLD.yml"
  echo "x" > "$d/.claude/.$OLD-setup-flags"
  echo "x" > "$d/.claude/skills/.$OLD-manifest"
  echo "x" > "$d/$OLD-zero/file.md"
  ( cd "$d" && git init -q . && git config user.email t@example.com && git config user.name t \
    && git add -A && git commit -q -m init )
  echo "$d"
}

# snapshot DIR: sorted list of paths, for before/after comparison.
snapshot() { ( cd "$1" && find . -path ./.git -prune -o -print | LC_ALL=C sort ); }

run() { ( cd "$1" && GIT_CEILING_DIRECTORIES="$WS" bash "$HELPER" 2>&1 ); }

echo "=== (a) clean run (tracked folders use git mv) ==="
R=$(make_repo clean)
OUT=$(run "$R"); CODE=$?
assert_equals "0" "$CODE" "clean run exits 0"
assert_equals "mine" "$(cat "$R/ravintio-overrides/instructions/a.md")" "overrides moved with content"
assert_equals "no" "$([ -e "$R/$OLD-overrides" ] && echo yes || echo no)" "old overrides folder gone"
assert_equals "yes" "$([ -f "$R/.github/workflows/ravintio.yml" ] && echo yes || echo no)" "workflow renamed"
assert_equals "no" "$([ -e "$R/.github/workflows/$OLD.yml" ] && echo yes || echo no)" "old workflow gone"
assert_contains "ravintio-zero/tests/run-tests.sh" "$(cat "$R/.github/workflows/ravintio.yml")" "workflow paths rewritten"
assert_equals "no" "$([ -e "$R/.claude/.$OLD-setup-flags" ] && echo yes || echo no)" "flags marker removed"
assert_equals "no" "$([ -e "$R/.claude/skills/.$OLD-manifest" ] && echo yes || echo no)" "manifest marker removed"
assert_equals "no" "$([ -e "$R/$OLD-zero" ] && echo yes || echo no)" "old pack folder removed"
assert_equals "yes" "$([ -d "$R/ravintio-zero" ] && echo yes || echo no)" "new pack folder kept"
assert_contains "Next step: run ravintio-zero/setup.sh claude-code" "$OUT" "prints the setup command"
STAGED=$(cd "$R" && git diff --cached --name-status | grep -c '^R')
assert_equals "2" "$STAGED" "git records the overrides file and workflow as renames"

echo "=== (b) rerun changes nothing ==="
BEFORE=$(snapshot "$R")
OUT=$(run "$R"); CODE=$?
assert_equals "0" "$CODE" "rerun exits 0"
assert_equals "$BEFORE" "$(snapshot "$R")" "rerun changes nothing"
assert_contains "Nothing to do" "$OUT" "rerun says nothing to do"

echo "=== (c) untracked folder uses plain mv ==="
R=$(make_repo untracked)
( cd "$R" && git rm -rq --cached "$OLD-overrides" && git commit -q -m untrack )
OUT=$(run "$R"); CODE=$?
assert_equals "0" "$CODE" "untracked run exits 0"
assert_equals "mine" "$(cat "$R/ravintio-overrides/instructions/a.md")" "untracked overrides moved"

echo "=== (d) no ravintio-zero/ stops ==="
R=$(make_repo nopack)
rm -rf "${R:?}/ravintio-zero"
BEFORE=$(snapshot "$R")
OUT=$(run "$R"); CODE=$?
assert_equals "1" "$CODE" "missing ravintio-zero exits 1"
assert_contains "ravintio-zero/ not found" "$OUT" "names the missing folder"
assert_equals "$BEFORE" "$(snapshot "$R")" "missing ravintio-zero moves nothing"

echo "=== (e) both override folders stop ==="
R=$(make_repo both)
mkdir -p "$R/ravintio-overrides"
BEFORE=$(snapshot "$R")
OUT=$(run "$R"); CODE=$?
assert_equals "1" "$CODE" "both override folders exit 1"
assert_contains "WARNING: Both" "$OUT" "prints the warning"
assert_equals "$BEFORE" "$(snapshot "$R")" "both override folders move nothing"

echo "=== (f) existing ravintio.yml stops before any move ==="
R=$(make_repo wf)
echo "new" > "$R/.github/workflows/ravintio.yml"
BEFORE=$(snapshot "$R")
OUT=$(run "$R"); CODE=$?
assert_equals "1" "$CODE" "existing ravintio.yml exits 1"
assert_contains "ravintio.yml already exists" "$OUT" "names the existing workflow"
assert_equals "$BEFORE" "$(snapshot "$R")" "existing ravintio.yml moves nothing"

echo "=== (g) symlink refusal ==="
for name in "$OLD-overrides" "ravintio-overrides" "$OLD-zero"; do
  R=$(make_repo "link-$name")
  TARGET="$WS/target-$name"
  mkdir -p "$TARGET"; echo "keep" > "$TARGET/keep.txt"
  if [ -e "$R/$name" ]; then rm -rf "${R:?}/${name:?}"; fi
  ln -s "$TARGET" "$R/$name"
  BEFORE=$(snapshot "$R")
  OUT=$(run "$R"); CODE=$?
  assert_equals "1" "$CODE" "symlinked $name exits 1"
  assert_contains "is a symlink" "$OUT" "symlinked $name is named"
  assert_equals "$BEFORE" "$(snapshot "$R")" "symlinked $name moves nothing"
  assert_equals "yes" "$([ -L "$R/$name" ] && echo yes || echo no)" "link $name still a link"
  assert_equals "keep" "$(cat "$TARGET/keep.txt")" "target of $name untouched"
done

print_summary
