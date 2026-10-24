# migrate-ravintio-rename.ps1 - Move a consumer repo from the Planifest names to the RAVINTIO names.
# Idempotent: safe to run multiple times. Stops before it moves anything on a conflict.
# Run from the consumer repo root, after you copy in ravintio-zero/.
# Works on Windows PowerShell 5.1 and PowerShell 7. Keep this file ASCII.

$ErrorActionPreference = 'Stop'

$OldOverrides = 'planifest-overrides'
$NewOverrides = 'ravintio-overrides'
$OldWorkflow = '.github/workflows/planifest.yml'
$NewWorkflow = '.github/workflows/ravintio.yml'
$OldPack = 'planifest-zero'
$Markers = @('.claude/.planifest-setup-flags', '.claude/skills/.planifest-manifest')

$changed = $false

function Test-Link {
    param([string]$Path)
    $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) { return $false }
    return (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Test-Present {
    param([string]$Path)
    return ($null -ne (Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue))
}

function Test-Tracked {
    param([string]$Path)
    $saved = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $listed = @(& git ls-files -- $Path 2>$null)
        if ($LASTEXITCODE -ne 0) { return $false }
        return ($listed.Count -gt 0)
    }
    catch { return $false }
    finally { $ErrorActionPreference = $saved }
}

function Move-Entry {
    param([string]$From, [string]$To)
    if (Test-Tracked $From) {
        & git mv $From $To
        if ($LASTEXITCODE -ne 0) { throw "git mv failed for $From" }
    }
    else {
        Move-Item -LiteralPath $From -Destination $To
    }
}

# Refuse a symlink before any other check. Never follow a planted link.
foreach ($p in @($OldOverrides, $NewOverrides, $OldPack)) {
    if (Test-Link $p) {
        Write-Host "ERROR: $p is a symlink. Refusing to continue. Nothing was moved."
        Write-Host "Replace the link with a real folder or remove it, then run this helper again."
        exit 1
    }
}

# Step 1: the new pack must be in place.
if (-not (Test-Path -LiteralPath 'ravintio-zero' -PathType Container)) {
    Write-Host "ERROR: ravintio-zero/ not found. Nothing was moved."
    Write-Host "Copy the new ravintio-zero/ folder into this repo, then run this helper again."
    exit 1
}

# Step 2: both override folders is a conflict.
if ((Test-Path -LiteralPath $OldOverrides -PathType Container) -and (Test-Path -LiteralPath $NewOverrides -PathType Container)) {
    Write-Host "WARNING: Both $OldOverrides/ and $NewOverrides/ exist. Nothing was moved."
    Write-Host "Cannot merge automatically. Please resolve manually:"
    Write-Host "  1. Decide which folder is authoritative."
    Write-Host "  2. Move its contents to $NewOverrides/ if needed."
    Write-Host "  3. Delete $OldOverrides/."
    exit 1
}

# Step 4 conflict check runs before any move, so a stop leaves the repo untouched.
if ((Test-Present $OldWorkflow) -and (Test-Present $NewWorkflow)) {
    Write-Host "ERROR: $NewWorkflow already exists. Nothing was moved."
    Write-Host "Merge or delete one of $OldWorkflow and $NewWorkflow, then run this helper again."
    exit 1
}

# Step 3: overrides.
if (Test-Path -LiteralPath $OldOverrides -PathType Container) {
    Move-Entry $OldOverrides $NewOverrides
    Write-Host "Moved $OldOverrides/ to $NewOverrides/."
    $changed = $true
}
else {
    Write-Host "Skipped $OldOverrides/: not present."
}

# Step 4: workflow.
if (Test-Present $OldWorkflow) {
    Move-Entry $OldWorkflow $NewWorkflow
    $utf8 = New-Object System.Text.UTF8Encoding $false
    $full = (Resolve-Path -LiteralPath $NewWorkflow).Path
    $text = [System.IO.File]::ReadAllText($full, $utf8)
    $text = $text.Replace('planifest-zero/', 'ravintio-zero/')
    [System.IO.File]::WriteAllText($full, $text, $utf8)
    Write-Host "Moved $OldWorkflow to $NewWorkflow."
    $changed = $true
}
else {
    Write-Host "Skipped $OldWorkflow: not present."
}

# Step 5: old markers.
foreach ($m in $Markers) {
    if (Test-Present $m) {
        Remove-Item -LiteralPath $m -Force
        Write-Host "Removed $m."
        $changed = $true
    }
    else {
        Write-Host "Skipped $m: not present."
    }
}

# Step 6: old pack folder.
if (Test-Path -LiteralPath $OldPack -PathType Container) {
    Remove-Item -LiteralPath $OldPack -Recurse -Force
    Write-Host "Removed $OldPack/."
    $changed = $true
}
else {
    Write-Host "Skipped $OldPack/: not present."
}

# Step 7: next step.
if (-not $changed) {
    Write-Host "Nothing to do. This repo already uses the ravintio names."
}
else {
    Write-Host "Done."
}
Write-Host "Next step: run ravintio-zero/setup.sh claude-code (ravintio-zero/setup.ps1 claude-code on Windows)."
exit 0
