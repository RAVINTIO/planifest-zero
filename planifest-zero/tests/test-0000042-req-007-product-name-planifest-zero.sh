#!/usr/bin/env bash
# Tests for feature 0000042-autonomous-mode-and-prefixes, req-007: product
# name Planifest Zero.
#
# product.yml and planifest-zero/component.yml set name "Planifest Zero" and
# keep id "planifest-zero". README.md names no product "Planifest Framework".

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

ROOT="$SCRIPT_DIR/../.."
PRODUCT="$ROOT/product.yml"
COMPONENT="$ROOT/planifest-zero/component.yml"
README="$ROOT/README.md"

# First top-level scalar: key at column 0, quotes stripped.
field() {
  grep -m1 -E "^$1:" "$2" | sed -E "s/^$1:[[:space:]]*//; s/[[:space:]]+#.*$//; s/^\"//; s/\"$//"
}
has() { grep -qF -- "$1" "$2" && echo yes || echo no; }

echo ""
echo "=== req-007 (a): name fields ==="

assert_equals "Planifest Zero" "$(field name "$PRODUCT")" \
  "req-007 (a): product.yml name is Planifest Zero"
assert_equals "Planifest Zero" "$(field name "$COMPONENT")" \
  "req-007 (a): component.yml name is Planifest Zero"

echo ""
echo "=== req-007 (a): ids unchanged ==="

assert_equals "planifest-zero" "$(field id "$PRODUCT")" \
  "req-007 (a): product.yml id is planifest-zero"
assert_equals "planifest-zero" "$(field id "$COMPONENT")" \
  "req-007 (a): component.yml id is planifest-zero"

echo ""
echo "=== req-007 (b): no Planifest Framework name ==="

assert_equals "no" "$(has 'Planifest Framework' "$README")" \
  "req-007 (b): README.md holds no Planifest Framework string"
assert_equals "no" "$(has 'Planifest Framework' "$PRODUCT")" \
  "req-007 (b): product.yml holds no Planifest Framework string"
assert_equals "no" "$(has 'Planifest Framework' "$COMPONENT")" \
  "req-007 (b): component.yml holds no Planifest Framework string"

print_summary
