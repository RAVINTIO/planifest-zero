#!/usr/bin/env bash
# Tests for feature 0000042-autonomous-mode-and-prefixes, req-008: pack
# prose.
#
# Prose in the files that req-008 names says "Planifest Zero", "the pack", or
# "the pipeline". It never calls Planifest Zero by the old word. Generic uses
# (test and web stacks, the separate Planifest product) stay. This test builds
# the old word from two parts, so it never matches its own source.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ZERO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$ZERO_DIR/.." && pwd)"

WORD="frame""work"
CAP="Frame""work"

# Generic uses that stay. Each pattern names a stack, a test tool, or the
# separate product, never Planifest Zero.
GENERIC=(
  "test[- ]${WORD}"                       # test tools and their library standards
  "testing ${WORD}"                       # the testing tool a project declares
  "meta-${WORD}"                          # React meta tools such as Next.js
  "language or ${WORD} in use"            # formatting-standards.md
  "independent of language or ${WORD}"    # code-quality-standards.md
  "where the ${WORD} expects it"          # code-quality-standards.md naming rule
  "${WORD} internals"                     # testing-standards.md
  "[Ww]eb ${WORD}"                        # the web layer in a user's stack
  "[Ff]rontend ${WORD}"                   # the frontend layer in a user's stack
  "stack\\.(${WORD}|frontend|testing)"    # component-guide.md stack fields
  "^[0-9]+:[[:space:]]*${WORD}:"           # the stack field in YAML templates
  "\\| ${CAP} \\|"                      # stack tables in templates and standards
  "${CAP}-specific terms"               # domain-glossary-guide.md
  "Planifest ${CAP}"                    # the separate product
  "planifest/planifest-${WORD}"           # the separate product's repo
  "planifest-${WORD}/"                    # the old folder that 0000030 renamed
  "${WORD}-cut-down"                      # the 0000030 feature id
)

FILES=(
  README.md
  docs/about.md
  docs/architecture-overview.md
  docs/dependency-graph.md
  docs/decisions-index.md
  plan/feature-structure.md
  plan/README.md
  .github/workflows/planifest.yml
  planifest-zero/pipeline-reference.md
  planifest-zero/project-operations.md
  planifest-zero/getting-started.md
  planifest-zero/component.yml
  planifest-zero/setup.sh
  planifest-zero/setup.ps1
  planifest-zero/hooks/enforcement/ratchet-check.mjs
  planifest-zero/templates/component-guide.md
  planifest-zero/templates/standard-boot.md
  planifest-zero/templates/feature-brief.template.md
  planifest-zero/templates/domain-glossary-guide.md
  planifest-zero/templates/component.template.yml
  planifest-zero/templates/loop-toggles.template.yml
  planifest-zero/skills/planifest-migrator/SKILL.md
  planifest-zero/skills/planifest-optimise-agent/SKILL.md
  planifest-zero/skills/planifest-ship/SKILL.md
  planifest-zero/skills/planifest-test-writer/SKILL.md
  planifest-zero/skills/planifest-loop-runner/SKILL.md
  planifest-zero/skills/planifest-orchestrator/SKILL.md
  planifest-zero/skills/planifest-implement/SKILL.md
  planifest-zero/skills/planifest-validate-and-accept/SKILL.md
  planifest-zero/skills/planifest-refresh-setup/SKILL.md
  planifest-zero/standards/language-quirks-en-gb.md
  planifest-zero/standards/code-quality-standards.md
  planifest-zero/standards/formatting-standards.md
  planifest-zero/standards/stack-summary.md
  planifest-zero/standards/pack-update-policy.md
  planifest-zero/tests/README.md
  planifest-zero/tests/helpers/assert.sh
)

generic_re="$(IFS='|'; echo "${GENERIC[*]}")"

# Prints file:line for each line in $1 that uses the old word and matches no
# generic pattern.
stray() {
  local f="$1"
  [ -f "$REPO_ROOT/$f" ] || return 0
  grep -niE -- "$WORD" "$REPO_ROOT/$f" \
    | grep -vE -- "$generic_re" \
    | cut -d: -f1 | sed "s|^|$f:|"
}

echo ""
echo "=== req-008 (a): README.md and docs/about.md ==="

assert_equals "" "$(stray README.md)" "req-008 (a): README.md never calls Planifest Zero by the old word"
assert_equals "" "$(stray docs/about.md)" "req-008 (a): docs/about.md never calls Planifest Zero by the old word"
assert_equals "yes" "$(grep -qiE "distinct from .*planifest/planifest-${WORD}" "$REPO_ROOT/README.md" && echo yes || echo no)" \
  "req-008 (a): README.md says Planifest Zero is distinct from the separate product"

echo ""
echo "=== req-008 (b): prose in the listed files ==="

for f in "${FILES[@]}"; do
  case "$f" in README.md|docs/about.md) continue ;; esac
  assert_equals "" "$(stray "$f")" "req-008 (b): $f never calls Planifest Zero by the old word"
done

assert_equals "yes" "$(grep -qF "the pack's own behaviour" "$ZERO_DIR/component.yml" && echo yes || echo no)" \
  "req-008 (b): component.yml says the pack's own behaviour"

echo ""
echo "=== req-008 (c): generic uses stay ==="

count="$(git -C "$REPO_ROOT" ls-files "planifest-zero/standards/library-standards/*/test-${WORD}s.md" | wc -l | tr -d ' ')"
assert_equals "21" "$count" "req-008 (c): 21 test-tool library standards remain"
for f in backend-stack-evaluation.md frontend-stack-evaluation.md; do
  n="$(grep -ciE -- "$WORD" "$ZERO_DIR/standards/reference/$f")"
  assert_equals "yes" "$([ "$n" -gt 40 ] && echo yes || echo no)" \
    "req-008 (c): $f keeps its web stack wording ($n lines)"
done
assert_equals "yes" "$(grep -qE "^[[:space:]]*${WORD}:" "$ZERO_DIR/templates/component.template.yml" && echo yes || echo no)" \
  "req-008 (c): component.template.yml keeps the stack web-layer field"

print_summary
