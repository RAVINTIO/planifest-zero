#!/usr/bin/env bash
# REGRESSION-CANDIDATE: fails when the setup.sh telemetry cleanup reports a parse or shape fault, or the non-array warning prints the old value.
# Tests for feature 0000041-setup-cleanup-and-park-hardening.
#
# req-001: the telemetry cleanup in setup.sh skips in silence when
# settings.json fails the parse or the 0000040 shape rule (ADR-002). The hook
# install step then prints its one line and exits 1. A write error still warns.
#
# req-003: the non-array warning names the event and the file and never
# prints the old value (ADR-003). setup.sh and setup.ps1 carry the same text.
#
# Every planted file is built inline in a temporary workspace.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers/assert.sh"

FRAMEWORK="$SCRIPT_DIR/.."
PLANTED="PLANTED-SECRET"
SHAPE_LINE="! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup."
INVALID_LINE="! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup."
CLEANUP_WARNING="could not remove telemetry hook entries"
REMOVAL_LINE="  - removed telemetry hook entries from .claude/settings.json"
TELEMETRY_SETTINGS='{"hooks":{"Stop":[{"hooks":[{"type":"command","command":"node .claude/hooks/emit-event.mjs"}]}]}}'

# One copy of the framework serves every case. Each case gets a fresh project.
TEMPLATE="$(mktemp -d -t planifest_0000041_req001_tpl_XXXXXX)"
cp -r "$FRAMEWORK" "$TEMPLATE/planifest-zero"

new_workspace() {
  local ws
  ws=$(mktemp -d -t planifest_0000041_req001_test_XXXXXX)
  cp -r "$TEMPLATE/planifest-zero" "$ws/planifest-zero"
  git init "$ws" >/dev/null 2>&1
  mkdir -p "$ws/.claude"
  printf '%s\n' "$ws"
}

# Runs setup and writes stdout and stderr to files in the workspace root.
run_setup() {
  (cd "$1" && GIT_CEILING_DIRECTORIES="$(dirname "$1")" bash planifest-zero/setup.sh claude-code \
    >"$1/setup.out" 2>"$1/setup.err")
}

same_file() {
  if cmp -s "$1" "$2"; then echo yes; else echo no; fi
}

echo ""
echo "=== req-001 (a): a value that is not a settings object prints only the shape line ==="

for input in 'null' '["x"]' '{"hooks":"text"}'; do
  WS="$(new_workspace)"
  printf '%s\n' "$input" > "$WS/.claude/settings.json"
  cp "$WS/.claude/settings.json" "$WS/settings-before.json"
  run_setup "$WS"
  SETUP_EXIT=$?
  assert_equals "1" "$SETUP_EXIT" "req-001 (a): setup.sh exits 1 on $input"
  assert_equals "$SHAPE_LINE" "$(cat "$WS/setup.err")" \
    "req-001 (a): stderr holds only the shape line on $input"
  assert_equals "0" "$(grep -c -F -- "telemetry" "$WS/setup.out" || true)" \
    "req-001 (a): stdout holds no cleanup line on $input"
  assert_equals "0" "$(grep -c -F -- "$CLEANUP_WARNING" "$WS/setup.err" || true)" \
    "req-001 (a): stderr holds no cleanup warning on $input"
  assert_equals "yes" "$(same_file "$WS/settings-before.json" "$WS/.claude/settings.json")" \
    "req-001 (a): settings.json is byte-identical on $input"
  rm -rf "$WS"
done

echo ""
echo "=== req-001 (b): invalid JSON prints only the invalid JSON line ==="

WS="$(new_workspace)"
printf '%s\n' '{bad' > "$WS/.claude/settings.json"
cp "$WS/.claude/settings.json" "$WS/settings-before.json"
run_setup "$WS"
SETUP_EXIT=$?
assert_equals "1" "$SETUP_EXIT" "req-001 (b): setup.sh exits 1 on {bad"
assert_equals "$INVALID_LINE" "$(cat "$WS/setup.err")" \
  "req-001 (b): stderr holds only the invalid JSON line on {bad"
assert_equals "0" "$(grep -c -F -- "telemetry" "$WS/setup.out" || true)" \
  "req-001 (b): stdout holds no cleanup line on {bad"
assert_equals "yes" "$(same_file "$WS/settings-before.json" "$WS/.claude/settings.json")" \
  "req-001 (b): settings.json is byte-identical on {bad"
rm -rf "$WS"

echo ""
echo "=== req-001 (c): a valid settings object still loses its telemetry entry ==="

WS="$(new_workspace)"
printf '%s\n' "$TELEMETRY_SETTINGS" > "$WS/.claude/settings.json"
run_setup "$WS"
SETUP_EXIT=$?
assert_exit_zero "$SETUP_EXIT" "req-001 (c): setup.sh exits 0 on a valid settings object"
assert_equals "1" "$(grep -c -F -x -- "$REMOVAL_LINE" "$WS/setup.out" || true)" \
  "req-001 (c): stdout holds the removal line once"
assert_equals "0" "$(grep -c -F -- "emit-event.mjs" "$WS/.claude/settings.json" || true)" \
  "req-001 (c): the telemetry entry is gone from settings.json"
assert_equals "0" "$(grep -c -F -- "$CLEANUP_WARNING" "$WS/setup.err" || true)" \
  "req-001 (c): stderr holds no cleanup warning on a valid settings object"
rm -rf "$WS"

echo ""
echo "=== req-001 (c): a write error still warns and setup continues ==="

if [ "$(id -u)" = "0" ]; then
  # root ignores file mode, so a read-only file does not make the write fail.
  echo "  SKIP: req-001 (c) write failure cannot be planted when running as root"
else
  WS="$(new_workspace)"
  printf '%s\n' "$TELEMETRY_SETTINGS" > "$WS/.claude/settings.json"
  chmod 444 "$WS/.claude/settings.json"
  run_setup "$WS"
  assert_equals "1" "$(grep -c -F -x -- "  ! Warning: $CLEANUP_WARNING from .claude/settings.json" "$WS/setup.err" || true)" \
    "req-001 (c): a failed cleanup write prints the cleanup warning once"
  # The hook install step copies its modules after the cleanup, so its
  # output proves setup carried on past the failed write.
  assert_equals "1" "$(grep -c -F -- "+ .claude/hooks/enforcement/gate-write.mjs" "$WS/setup.out" || true)" \
    "req-001 (c): setup continues to the hook install step after a failed cleanup write"
  chmod 644 "$WS/.claude/settings.json"
  rm -rf "$WS"
fi

echo ""
echo "=== req-003 (a, b): the non-array warning names the event and the file only ==="

for EV in PreToolUse UserPromptSubmit; do
  WS="$(new_workspace)"
  printf '{"hooks":{"%s":"%s"}}\n' "$EV" "$PLANTED" > "$WS/.claude/settings.json"
  run_setup "$WS"
  SETUP_EXIT=$?
  assert_exit_zero "$SETUP_EXIT" "req-003 (a): setup.sh exits 0 with a non-array $EV"
  assert_equals "  ! Warning: hooks.$EV in .claude/settings.json is not an array. Setup replaced it with the Planifest entries." \
    "$(cat "$WS/setup.err")" "req-003 (a): stderr holds exactly the new warning for $EV"
  assert_equals "0" "$(cat "$WS/setup.out" "$WS/setup.err" | grep -c -F -- "$PLANTED" || true)" \
    "req-003 (a): the secret reaches neither stdout nor stderr for $EV"
  assert_equals "0" "$(grep -c -F -- "Old value" "$WS/setup.err" || true)" \
    "req-003 (a): stderr holds no Old value text for $EV"
  assert_equals "ok" "$(node -e '
    const s = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"));
    const v = s.hooks[process.argv[2]];
    const planifest = /\.claude\/hooks\/enforcement\/[A-Za-z0-9-]+\.mjs/;
    const ok = Array.isArray(v) && v.length > 0 &&
      v.every(e => (e.hooks || []).every(h => planifest.test(h.command || "")));
    console.log(ok && !JSON.stringify(v).includes(process.argv[3]) ? "ok" : "bad");
  ' "$WS/.claude/settings.json" "$EV" "$PLANTED")" \
    "req-003 (b): $EV holds only the Planifest entries after the run"
  rm -rf "$WS"
done

for CASE in absent null; do
  WS="$(new_workspace)"
  if [ "$CASE" = "absent" ]; then
    printf '{"hooks":{}}\n' > "$WS/.claude/settings.json"
  else
    printf '{"hooks":{"PreToolUse":null,"UserPromptSubmit":null}}\n' > "$WS/.claude/settings.json"
  fi
  run_setup "$WS"
  assert_exit_zero "$?" "req-003 (b): setup.sh exits 0 when both events are $CASE"
  assert_equals "0" "$(grep -c -F -- "is not an array" "$WS/setup.err" || true)" \
    "req-003 (b): no warning when both events are $CASE"
  rm -rf "$WS"
done

echo ""
echo "=== req-003 (c): setup.sh and setup.ps1 carry the same warning text ==="

# The two scripts build the line from different expressions. Reduce each to
# its literal text with the event and the file as {event} and {file}.
SH_TEXT="$(node -e '
  const src = require("fs").readFileSync(process.argv[1], "utf8");
  const m = /process\.stderr\.write\(("  ! Warning: hooks\."[\s\S]*?)\);/.exec(src);
  if (!m) { console.log("unparsed"); process.exit(0); }
  const text = m[1]
    .replace(/"\s*\+\s*ev\s*\+\s*"/g, "{event}")
    .replace(/"\s*\+\s*process\.env\.PLANIFEST_SETTINGS_REL\s*\+\s*"/g, "{file}");
  console.log(/^"[^"]*\\n"$/.test(text) ? text.slice(1, -3) : "unparsed: " + text);
' "$FRAMEWORK/setup.sh")"
PS_TEXT="$(grep -F 'is not an array. Setup replaced' "$FRAMEWORK/setup.ps1" | head -1 | node -e '
  const line = require("fs").readFileSync(0, "utf8");
  const m = /WriteLine\("(.*)"\)/.exec(line);
  if (!m) { console.log("unparsed"); process.exit(0); }
  console.log(m[1].replace("$eventName", "{event}").replace("$SettingsRel", "{file}"));
')"
EXPECTED_TEXT="  ! Warning: hooks.{event} in {file} is not an array. Setup replaced it with the Planifest entries."
assert_equals "$EXPECTED_TEXT" "$SH_TEXT" "req-003 (c): setup.sh carries the exact warning text"
assert_equals "$EXPECTED_TEXT" "$PS_TEXT" "req-003 (c): setup.ps1 carries the exact warning text"
assert_equals "$SH_TEXT" "$PS_TEXT" "req-003 (c): the warning text is identical in setup.sh and setup.ps1"

rm -rf "$TEMPLATE"
print_summary
