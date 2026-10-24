#!/usr/bin/env bash
# migrate-ravintio-rename.sh - Move a consumer repo from the Planifest names to the RAVINTIO names.
# Idempotent: safe to run multiple times. Stops before it moves anything on a conflict.
# Run from the consumer repo root, after you copy in ravintio-zero/.

set -euo pipefail

OLD_OVERRIDES="planifest-overrides"
NEW_OVERRIDES="ravintio-overrides"
OLD_WORKFLOW=".github/workflows/planifest.yml"
NEW_WORKFLOW=".github/workflows/ravintio.yml"
OLD_PACK="planifest-zero"
MARKERS=(".claude/.planifest-setup-flags" ".claude/skills/.planifest-manifest")

changed=0

is_tracked() {
    [ -n "$(git ls-files -- "$1" 2>/dev/null | head -n 1)" ]
}

move_path() {
    if is_tracked "$1"; then
        git mv "$1" "$2"
    else
        mv "$1" "$2"
    fi
}

# Refuse a symlink before any other check. Never follow a planted link.
for p in "$OLD_OVERRIDES" "$NEW_OVERRIDES" "$OLD_PACK"; do
    if [ -L "$p" ]; then
        echo "ERROR: $p is a symlink. Refusing to continue. Nothing was moved."
        echo "Replace the link with a real folder or remove it, then run this helper again."
        exit 1
    fi
done

# Step 1: the new pack must be in place.
if [ ! -d "ravintio-zero" ]; then
    echo "ERROR: ravintio-zero/ not found. Nothing was moved."
    echo "Copy the new ravintio-zero/ folder into this repo, then run this helper again."
    exit 1
fi

# Step 2: both override folders is a conflict.
if [ -d "$OLD_OVERRIDES" ] && [ -d "$NEW_OVERRIDES" ]; then
    echo "WARNING: Both $OLD_OVERRIDES/ and $NEW_OVERRIDES/ exist. Nothing was moved."
    echo "Cannot merge automatically. Please resolve manually:"
    echo "  1. Decide which folder is authoritative."
    echo "  2. Move its contents to $NEW_OVERRIDES/ if needed."
    echo "  3. Delete $OLD_OVERRIDES/."
    exit 1
fi

# Step 4 conflict check runs before any move, so a stop leaves the repo untouched.
if [ -e "$OLD_WORKFLOW" ] && [ -e "$NEW_WORKFLOW" ]; then
    echo "ERROR: $NEW_WORKFLOW already exists. Nothing was moved."
    echo "Merge or delete one of $OLD_WORKFLOW and $NEW_WORKFLOW, then run this helper again."
    exit 1
fi

# Step 3: overrides.
if [ -d "$OLD_OVERRIDES" ]; then
    move_path "$OLD_OVERRIDES" "$NEW_OVERRIDES"
    echo "Moved $OLD_OVERRIDES/ to $NEW_OVERRIDES/."
    changed=1
else
    echo "Skipped $OLD_OVERRIDES/: not present."
fi

# Step 4: workflow.
if [ -e "$OLD_WORKFLOW" ]; then
    move_path "$OLD_WORKFLOW" "$NEW_WORKFLOW"
    tmp="$(mktemp)"
    sed 's#planifest-zero/#ravintio-zero/#g' "$NEW_WORKFLOW" > "$tmp"
    cat "$tmp" > "$NEW_WORKFLOW"
    rm -f "$tmp"
    echo "Moved $OLD_WORKFLOW to $NEW_WORKFLOW."
    changed=1
else
    echo "Skipped $OLD_WORKFLOW: not present."
fi

# Step 5: old markers.
for m in "${MARKERS[@]}"; do
    if [ -e "$m" ] || [ -L "$m" ]; then
        rm -f "$m"
        echo "Removed $m."
        changed=1
    else
        echo "Skipped $m: not present."
    fi
done

# Step 6: old pack folder.
if [ -d "$OLD_PACK" ]; then
    rm -rf "$OLD_PACK"
    echo "Removed $OLD_PACK/."
    changed=1
else
    echo "Skipped $OLD_PACK/: not present."
fi

# Step 7: next step.
if [ "$changed" -eq 0 ]; then
    echo "Nothing to do. This repo already uses the ravintio names."
else
    echo "Done."
fi
echo "Next step: run ravintio-zero/setup.sh claude-code (ravintio-zero/setup.ps1 claude-code on Windows)."
