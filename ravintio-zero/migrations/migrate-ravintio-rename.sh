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
# This covers each source and target, the two workflow files, and each parent
# folder the helper writes into. A dangling link counts too.
for p in "$OLD_OVERRIDES" "$NEW_OVERRIDES" "$OLD_PACK" "$OLD_WORKFLOW" "$NEW_WORKFLOW" \
         ".claude" ".claude/skills" ".github" ".github/workflows" \
         "ravintio-zero" "ravintio-zero/migrations"; do
    if [ -L "$p" ]; then
        echo "ERROR: $p is a symlink. Refusing to continue. Nothing was moved."
        echo "Replace the link with a real file or folder, or remove it, then run this helper again."
        exit 1
    fi
done

# Run only from the top level of a git repo. Outside git, skip this check.
in_git=0
if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null || true)" = "true" ]; then
    in_git=1
    if [ -n "$(git rev-parse --show-prefix 2>/dev/null || true)" ]; then
        echo "ERROR: this folder is not the top level of its git repo. Nothing was moved."
        echo "Run this helper from the repo root: $(git rev-parse --show-toplevel)"
        exit 1
    fi
fi

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
if { [ -e "$OLD_WORKFLOW" ] || [ -L "$OLD_WORKFLOW" ]; } && { [ -e "$NEW_WORKFLOW" ] || [ -L "$NEW_WORKFLOW" ]; }; then
    echo "ERROR: $NEW_WORKFLOW already exists. Nothing was moved."
    echo "Merge or delete one of $OLD_WORKFLOW and $NEW_WORKFLOW, then run this helper again."
    exit 1
fi

# Step 6 checks run before any move. The helper deletes the old pack folder,
# so it must look like the old pack and hold nothing that git cannot restore.
if [ -d "$OLD_PACK" ]; then
    if [ ! -f "$OLD_PACK/setup.sh" ]; then
        echo "ERROR: $OLD_PACK/ holds no setup.sh, so it may not be the old pack. Nothing was moved."
        echo "Check the folder and remove it yourself if you no longer need it, then run this helper again."
        exit 1
    fi
    if [ "$in_git" -eq 1 ]; then
        dirty="$(git status --porcelain --untracked-files=all -- "$OLD_PACK")"
        if [ -n "$dirty" ]; then
            echo "ERROR: $OLD_PACK/ holds untracked or modified files. Nothing was moved."
            printf '%s\n' "$dirty" | sed 's/^/  /'
            echo "Move or commit these files, then run this helper again."
            exit 1
        fi
    fi
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
    # Write to a temp file in the same folder, then rename it over the target,
    # so the write replaces the file and never follows a link.
    tmp="$(mktemp "$(dirname "$NEW_WORKFLOW")/.ravintio.yml.XXXXXX")"
    cp -p "$NEW_WORKFLOW" "$tmp"
    sed -e 's#planifest-zero/#ravintio-zero/#g' -e 's#PLANIFEST_#RAVINTIO_#g' "$NEW_WORKFLOW" > "$tmp"
    mv -f "$tmp" "$NEW_WORKFLOW"
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
    # Check for a link again right before removal. rm -rf removes a nested link
    # as a link and never deletes the files behind it.
    if [ -L "$OLD_PACK" ]; then
        echo "ERROR: $OLD_PACK became a symlink during the run. Refusing to remove it."
        exit 1
    fi
    rm -rf "$OLD_PACK"
    echo "Removed $OLD_PACK/."
    changed=1
else
    echo "Skipped $OLD_PACK/: not present."
fi

# Archive this migration once it has changed the repo, so the orchestrator
# stops offering it. A repo with no old install keeps it pending.
MIGRATION="ravintio-zero/migrations/0004-ravintio-rename.md"
if [ "$changed" -eq 1 ] && [ -f "$MIGRATION" ] && [ ! -L "$MIGRATION" ]; then
    mkdir -p ravintio-zero/migrations/_done
    mv "$MIGRATION" ravintio-zero/migrations/_done/
    echo "Archived $MIGRATION to ravintio-zero/migrations/_done/."
fi

# Step 7: next step.
if [ "$changed" -eq 0 ]; then
    echo "Nothing to do. This repo already uses the ravintio names."
else
    echo "Done."
fi
echo "Next step: run ravintio-zero/setup.sh claude-code (ravintio-zero/setup.ps1 claude-code on Windows)."
