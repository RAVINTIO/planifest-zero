#!/usr/bin/env bash
# Tests for feature 0000036-test-runner-coverage, req-005 (ADR-003).
#
# The windows-powershell CI job runs run-tests.ps1 under Windows PowerShell
# 5.1 and PowerShell 7, with read-only contents and no secrets. Whether the
# job passes is checked on the PR itself.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

WORKFLOW="$SCRIPT_DIR/../../.github/workflows/planifest.yml"

if [ ! -f "$WORKFLOW" ]; then
  echo "  SKIP: no repo workflow next to planifest-zero/, so this is a consumer copy"
  print_summary
  exit 0
fi

# The job block runs from its key to the next job key at the same indent.
JOB="$(awk '/^  windows-powershell:/{f=1; print; next} f && /^  [a-z][a-z-]*:/{exit} f{print}' "$WORKFLOW")"

assert_equals "yes" "$([ -n "$JOB" ] && echo yes || echo no)" "req-005: the windows-powershell job exists"
assert_contains "runs-on: windows-latest" "$JOB" "req-005: the job runs on windows-latest"
assert_contains "contents: read" "$JOB" "req-005: the job has read-only contents permission"
assert_equals "0" "$(printf '%s\n' "$JOB" | grep -c 'secrets\.' || true)" "req-005: the job uses no secrets"
assert_contains "shell: powershell" "$JOB" "req-005: one step runs under Windows PowerShell 5.1"
assert_contains "shell: pwsh" "$JOB" "req-005: one step runs under PowerShell 7"
assert_equals "2" "$(printf '%s\n' "$JOB" | grep -c 'planifest-zero/tests/run-tests.ps1' || true)" \
  "req-005: both steps run run-tests.ps1"

print_summary
