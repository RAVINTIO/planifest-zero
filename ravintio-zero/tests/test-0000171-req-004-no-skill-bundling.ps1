# Tests for feature 0000171-faster-setup-ps1-tests, req-004, in setup.ps1
# under whichever host runs this file. Setup installs only each skill's own
# folder, byte for byte, with no bundled pack templates, standards, or schemas
# (ADR-004). A rerun removes bundled files an older install left and keeps the
# skill's own files. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

function Get-RelativePath {
    param([string]$Root, [string]$Path)
    return $Path.Substring($Root.Length).TrimStart('\', '/').Replace('\', '/')
}

# Lists every file (as "f path base64") and folder (as "d path") under a
# folder, sorted, so two trees compare as one string.
function Get-TreeListing {
    param([string]$Dir)
    $all = [System.IO.SearchOption]::AllDirectories
    $lines = @()
    if (-not [System.IO.Directory]::Exists($Dir)) { return '(missing)' }
    foreach ($d in [System.IO.Directory]::GetDirectories($Dir, '*', $all)) {
        $lines += 'd ' + (Get-RelativePath $Dir $d)
    }
    foreach ($f in [System.IO.Directory]::GetFiles($Dir, '*', $all)) {
        $lines += 'f ' + (Get-RelativePath $Dir $f) + ' ' + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($f))
    }
    return ((@($lines) | Sort-Object) -join "`n")
}

# Names every skill whose installed folder differs from its source folder.
function Get-TreeDiff {
    param([string]$Workspace)
    $differ = @()
    foreach ($skill in (Get-ChildItem -Path (Join-Path $Workspace 'ravintio-zero\skills') -Directory)) {
        if (-not [System.IO.File]::Exists((Join-Path $skill.FullName 'SKILL.md'))) { continue }
        $installed = Join-Path $Workspace (".claude\skills\" + $skill.Name)
        if ((Get-TreeListing $skill.FullName) -cne (Get-TreeListing $installed)) { $differ += $skill.Name }
    }
    return ($differ -join ', ')
}

function Write-OldFile {
    param([string]$Path)
    [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path)) | Out-Null
    [System.IO.File]::WriteAllText($Path, 'old')
}

try {

Write-Host ""
Write-Host "=== req-004 AC-1: a fresh install holds only each skill's own files ==="
$ws = New-SetupWorkspace
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "AC-1: setup.ps1 exits 0"
Assert-Equal '' (Get-TreeDiff $ws) "AC-1: each installed skill matches its source folder byte for byte"
$bundleLines = @($run.Output -split "\r?\n" | Where-Object { $_ -match '^ +(templates|standards): ' })
Assert-Equal 0 $bundleLines.Count "AC-1: setup prints no templates or standards bundle line"
$setupText = [System.IO.File]::ReadAllText((Join-Path $global:ZeroDir 'setup.ps1'))
Assert-True ($setupText -notmatch 'bundle_(templates|standards)') "AC-1: setup.ps1 does not parse bundle frontmatter"

Write-Host ""
Write-Host "=== req-004 AC-2: a rerun removes bundled files from an older install ==="
$sk = Join-Path $ws '.claude\skills'
$planned = @(
    'ravintio-plan\assets\templates\requirement.template.md',
    'ravintio-plan\assets\schemas\component.schema.json',
    'ravintio-plan\references\formatting-standards.md',
    'ravintio-plan\references\reference\old-reference.md',
    'ravintio-orchestrator\assets\templates\park.template.md',
    'ravintio-orchestrator\references\code-quality-standards.md'
)
foreach ($p in $planned) { Write-OldFile (Join-Path $sk $p) }
# Without the manifest, the rerun cannot wipe the skill folders first, so
# only the prune step can remove the bundled files.
[System.IO.File]::Delete((Join-Path $sk '.ravintio-manifest'))
$run = Invoke-Setup $ws @('claude-code')
Assert-Equal 0 $run.Code "AC-2: the rerun exits 0"
Assert-True (-not [System.IO.Directory]::Exists((Join-Path $sk 'ravintio-plan\assets'))) "AC-2: the bundled assets folder is gone"
Assert-True (-not [System.IO.Directory]::Exists((Join-Path $sk 'ravintio-plan\references'))) "AC-2: the bundled references folder is gone"
Assert-True (-not [System.IO.Directory]::Exists((Join-Path $sk 'ravintio-orchestrator\assets\templates'))) "AC-2: the orchestrator's bundled templates are gone"
Assert-True (-not [System.IO.File]::Exists((Join-Path $sk 'ravintio-orchestrator\references\code-quality-standards.md'))) "AC-2: the orchestrator's bundled standard is gone"
Assert-True ([System.IO.File]::Exists((Join-Path $sk 'ravintio-orchestrator\assets\.gitkeep'))) "AC-2: the orchestrator's own assets file remains"
Assert-True ([System.IO.File]::Exists((Join-Path $sk 'ravintio-orchestrator\references\orchestrator-scope-lock.md'))) "AC-2: the orchestrator's own reference file remains"
Assert-Equal '' (Get-TreeDiff $ws) "AC-2: each installed skill matches its source folder after the rerun"

}
finally {
    Remove-AllWorkspaces
}

Complete-Suite
