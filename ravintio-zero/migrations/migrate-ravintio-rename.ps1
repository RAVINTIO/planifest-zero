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

function Get-FullPath {
    param([string]$Path)
    return [System.IO.Path]::GetFullPath((Join-Path (Get-Location).ProviderPath $Path))
}

# Attributes of the entry itself, or $null when nothing is there. A link is
# read as a link, never followed, so a dangling link still counts as present.
function Get-EntryAttributes {
    param([string]$Path)
    try { return [System.IO.File]::GetAttributes((Get-FullPath $Path)) }
    catch { return $null }
}

function Test-Link {
    param([string]$Path)
    $attrs = Get-EntryAttributes $Path
    if ($null -eq $attrs) { return $false }
    return (($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Test-Present {
    param([string]$Path)
    return ($null -ne (Get-EntryAttributes $Path))
}

# Run git and return its output lines, or $null when git fails or is missing.
function Invoke-GitLines {
    param([string[]]$GitArgs)
    $saved = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        $lines = @(& git @GitArgs 2>$null)
        if ($LASTEXITCODE -ne 0) { return $null }
        return ,$lines
    }
    catch { return $null }
    finally { $ErrorActionPreference = $saved }
}

# Delete a folder tree without following links. Windows PowerShell 5.1
# Remove-Item -Recurse walks into a nested junction or directory symlink and
# deletes the files in its target. This walk deletes each reparse point as a
# link only and recurses into plain folders bottom-up.
function Remove-TreeNoFollow {
    param([System.IO.FileSystemInfo]$Entry)
    $attrs = $Entry.Attributes
    $isDir = (($attrs -band [System.IO.FileAttributes]::Directory) -ne 0)
    if (($attrs -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) {
        if ($isDir) {
            # On Windows this removes the junction or directory link itself.
            # On other systems rmdir refuses a link, so unlink it instead.
            try { [System.IO.Directory]::Delete($Entry.FullName) }
            catch { [System.IO.File]::Delete($Entry.FullName) }
        }
        else { [System.IO.File]::Delete($Entry.FullName) }
        return
    }
    if (-not $isDir) {
        [System.IO.File]::SetAttributes($Entry.FullName, [System.IO.FileAttributes]::Normal)
        [System.IO.File]::Delete($Entry.FullName)
        return
    }
    $dir = New-Object System.IO.DirectoryInfo $Entry.FullName
    foreach ($child in $dir.GetFileSystemInfos()) {
        Remove-TreeNoFollow $child
    }
    $dir.Attributes = [System.IO.FileAttributes]::Directory
    [System.IO.Directory]::Delete($Entry.FullName)
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
# This covers each source and target, the two workflow files, and each parent
# folder the helper writes into. A dangling link counts too.
$linkChecks = @($OldOverrides, $NewOverrides, $OldPack, $OldWorkflow, $NewWorkflow,
    '.claude', '.claude/skills', '.github', '.github/workflows',
    'ravintio-zero', 'ravintio-zero/migrations')
foreach ($p in $linkChecks) {
    if (Test-Link $p) {
        Write-Host "ERROR: $p is a symlink. Refusing to continue. Nothing was moved."
        Write-Host "Replace the link with a real file or folder, or remove it, then run this helper again."
        exit 1
    }
}

# Run only from the top level of a git repo. Outside git, skip this check.
$inGit = $false
$inside = Invoke-GitLines @('rev-parse', '--is-inside-work-tree')
if (($null -ne $inside) -and (($inside -join '') -eq 'true')) {
    $inGit = $true
    $prefix = Invoke-GitLines @('rev-parse', '--show-prefix')
    if (($null -ne $prefix) -and (($prefix -join '').Trim() -ne '')) {
        $top = (Invoke-GitLines @('rev-parse', '--show-toplevel')) -join ''
        Write-Host "ERROR: this folder is not the top level of its git repo. Nothing was moved."
        Write-Host "Run this helper from the repo root: $top"
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

# Step 6 checks run before any move. The helper deletes the old pack folder,
# so it must look like the old pack and hold nothing that git cannot restore.
if (Test-Path -LiteralPath $OldPack -PathType Container) {
    if (-not (Test-Path -LiteralPath (Join-Path $OldPack 'setup.sh') -PathType Leaf)) {
        Write-Host "ERROR: $OldPack/ holds no setup.sh, so it may not be the old pack. Nothing was moved."
        Write-Host "Check the folder and remove it yourself if you no longer need it, then run this helper again."
        exit 1
    }
    if ($inGit) {
        $dirty = Invoke-GitLines @('status', '--porcelain', '--untracked-files=all', '--', $OldPack)
        if ($null -eq $dirty) { throw "git status failed for $OldPack" }
        $dirty = @($dirty | Where-Object { $_ -ne '' })
        if ($dirty.Count -gt 0) {
            Write-Host "ERROR: $OldPack/ holds untracked or modified files. Nothing was moved."
            foreach ($line in $dirty) { Write-Host "  $line" }
            Write-Host "Move or commit these files, then run this helper again."
            exit 1
        }
    }
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
    $full = Get-FullPath $NewWorkflow
    $text = [System.IO.File]::ReadAllText($full, $utf8)
    $text = $text.Replace('planifest-zero/', 'ravintio-zero/').Replace('PLANIFEST_', 'RAVINTIO_')
    # Write to a temp file in the same folder, then rename it over the target,
    # so the write replaces the file and never follows a link.
    $tmp = Join-Path ([System.IO.Path]::GetDirectoryName($full)) ('.ravintio.yml.' + [guid]::NewGuid().ToString('N'))
    [System.IO.File]::WriteAllText($tmp, $text, $utf8)
    [System.IO.File]::Delete($full)
    [System.IO.File]::Move($tmp, $full)
    Write-Host "Moved $OldWorkflow to $NewWorkflow."
    $changed = $true
}
else {
    Write-Host "Skipped ${OldWorkflow}: not present."
}

# Step 5: old markers.
foreach ($m in $Markers) {
    if (Test-Present $m) {
        Remove-Item -LiteralPath $m -Force
        Write-Host "Removed $m."
        $changed = $true
    }
    else {
        Write-Host "Skipped ${m}: not present."
    }
}

# Step 6: old pack folder.
if (Test-Path -LiteralPath $OldPack -PathType Container) {
    # Check for a link again right before removal, then delete without
    # following any nested link.
    if (Test-Link $OldPack) {
        Write-Host "ERROR: $OldPack became a symlink during the run. Refusing to remove it."
        exit 1
    }
    Remove-TreeNoFollow (New-Object System.IO.DirectoryInfo (Get-FullPath $OldPack))
    Write-Host "Removed $OldPack/."
    $changed = $true
}
else {
    Write-Host "Skipped $OldPack/: not present."
}

# Archive this migration once it has changed the repo, so the orchestrator
# stops offering it. A repo with no old install keeps it pending.
$Migration = 'ravintio-zero/migrations/0004-ravintio-rename.md'
if ($changed -and (Test-Path -LiteralPath $Migration -PathType Leaf)) {
    $item = Get-Item -LiteralPath $Migration -Force
    if (-not ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
        New-Item -ItemType Directory -Path 'ravintio-zero/migrations/_done' -Force | Out-Null
        Move-Item -LiteralPath $Migration -Destination 'ravintio-zero/migrations/_done/'
        Write-Host "Archived $Migration to ravintio-zero/migrations/_done/."
    }
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
