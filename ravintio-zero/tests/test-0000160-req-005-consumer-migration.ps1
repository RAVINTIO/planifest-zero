# Feature 0000160 req-005: migrate-ravintio-rename.ps1 moves a consumer repo to
# the ravintio names. Covers the clean run, a rerun, each stop condition, and
# symlink refusal, in scratch git repos. Works on Windows PowerShell 5.1 and
# PowerShell 7. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')

$zeroDir = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$helper = Join-Path $zeroDir 'migrations\migrate-ravintio-rename.ps1'
$hostExe = (Get-Process -Id $PID).Path
$old = 'plan' + 'ifest'
$scratch = Join-Path ([System.IO.Path]::GetTempPath()) ('ravintio_0000160_' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $scratch | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding $false

function New-Repo {
    param([string]$Name)
    $d = Join-Path $scratch $Name
    foreach ($sub in @('ravintio-zero', "$old-zero", "$old-overrides\instructions", '.github\workflows', '.claude\skills')) {
        New-Item -ItemType Directory -Path (Join-Path $d $sub) -Force | Out-Null
    }
    [System.IO.File]::WriteAllText((Join-Path $d "$old-overrides\instructions\a.md"), 'mine', $utf8)
    [System.IO.File]::WriteAllText((Join-Path $d ".github\workflows\$old.yml"), "run: bash $old-zero/tests/run-tests.sh`n", $utf8)
    [System.IO.File]::WriteAllText((Join-Path $d ".claude\.$old-setup-flags"), 'x', $utf8)
    [System.IO.File]::WriteAllText((Join-Path $d ".claude\skills\.$old-manifest"), 'x', $utf8)
    [System.IO.File]::WriteAllText((Join-Path $d "$old-zero\file.md"), 'x', $utf8)
    & git -C $d init -q 2>&1 | Out-Null
    & git -C $d config user.email t@example.com
    & git -C $d config user.name t
    & git -C $d add -A 2>&1 | Out-Null
    & git -C $d commit -q -m init 2>&1 | Out-Null
    return $d
}

function Invoke-Helper {
    param([string]$Repo)
    Push-Location $Repo
    $savedCeiling = $env:GIT_CEILING_DIRECTORIES
    $env:GIT_CEILING_DIRECTORIES = Split-Path -Parent $Repo
    try {
        $output = & $hostExe -NoProfile -ExecutionPolicy Bypass -File $helper 2>&1 | Out-String
        $code = $LASTEXITCODE
    }
    finally {
        $env:GIT_CEILING_DIRECTORIES = $savedCeiling
        Pop-Location
    }
    return [PSCustomObject]@{ Code = $code; Output = $output }
}

function Get-Snapshot {
    param([string]$Repo)
    $prefix = $Repo.TrimEnd('\') + '\'
    $names = @(Get-ChildItem -LiteralPath $Repo -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notlike '*\.git\*' -and $_.Name -ne '.git' } |
        ForEach-Object { $_.FullName.Substring($prefix.Length) } | Sort-Object)
    return ($names -join '|')
}

function Read-Text {
    param([string]$Path)
    return [System.IO.File]::ReadAllText($Path, $utf8)
}

try {

Write-Host ""
Write-Host "=== (a) clean run ==="
$r = New-Repo 'clean'
$run = Invoke-Helper $r
Assert-Equal 0 $run.Code 'clean run exits 0'
Assert-Equal 'mine' (Read-Text (Join-Path $r 'ravintio-overrides\instructions\a.md')) 'overrides moved with content'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $r "$old-overrides"))) 'old overrides folder gone'
Assert-True (Test-Path -LiteralPath (Join-Path $r '.github\workflows\ravintio.yml')) 'workflow renamed'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $r ".github\workflows\$old.yml"))) 'old workflow gone'
Assert-Contains 'ravintio-zero/tests/run-tests.sh' (Read-Text (Join-Path $r '.github\workflows\ravintio.yml')) 'workflow paths rewritten'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $r ".claude\.$old-setup-flags"))) 'flags marker removed'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $r ".claude\skills\.$old-manifest"))) 'manifest marker removed'
Assert-True (-not (Test-Path -LiteralPath (Join-Path $r "$old-zero"))) 'old pack folder removed'
Assert-True (Test-Path -LiteralPath (Join-Path $r 'ravintio-zero')) 'new pack folder kept'
Assert-Contains 'Next step: run ravintio-zero/setup.sh claude-code' $run.Output 'prints the setup command'
$renames = @(& git -C $r diff --cached --name-status | Where-Object { $_ -match '^R' })
Assert-Equal 2 $renames.Count 'git records the overrides file and workflow as renames'

Write-Host ""
Write-Host "=== (b) rerun changes nothing ==="
$before = Get-Snapshot $r
$run = Invoke-Helper $r
Assert-Equal 0 $run.Code 'rerun exits 0'
Assert-Equal $before (Get-Snapshot $r) 'rerun changes nothing'
Assert-Contains 'Nothing to do' $run.Output 'rerun says nothing to do'

Write-Host ""
Write-Host "=== (c) untracked folder uses plain move ==="
$r = New-Repo 'untracked'
& git -C $r rm -rq --cached "$old-overrides" 2>&1 | Out-Null
& git -C $r commit -q -m untrack 2>&1 | Out-Null
$run = Invoke-Helper $r
Assert-Equal 0 $run.Code 'untracked run exits 0'
Assert-Equal 'mine' (Read-Text (Join-Path $r 'ravintio-overrides\instructions\a.md')) 'untracked overrides moved'

Write-Host ""
Write-Host "=== (d) no ravintio-zero/ stops ==="
$r = New-Repo 'nopack'
Remove-Item -LiteralPath (Join-Path $r 'ravintio-zero') -Recurse -Force
$before = Get-Snapshot $r
$run = Invoke-Helper $r
Assert-Equal 1 $run.Code 'missing ravintio-zero exits 1'
Assert-Contains 'ravintio-zero/ not found' $run.Output 'names the missing folder'
Assert-Equal $before (Get-Snapshot $r) 'missing ravintio-zero moves nothing'

Write-Host ""
Write-Host "=== (e) both override folders stop ==="
$r = New-Repo 'both'
New-Item -ItemType Directory -Path (Join-Path $r 'ravintio-overrides') | Out-Null
$before = Get-Snapshot $r
$run = Invoke-Helper $r
Assert-Equal 1 $run.Code 'both override folders exit 1'
Assert-Contains 'WARNING: Both' $run.Output 'prints the warning'
Assert-Equal $before (Get-Snapshot $r) 'both override folders move nothing'

Write-Host ""
Write-Host "=== (f) existing ravintio.yml stops before any move ==="
$r = New-Repo 'wf'
[System.IO.File]::WriteAllText((Join-Path $r '.github\workflows\ravintio.yml'), 'new', $utf8)
$before = Get-Snapshot $r
$run = Invoke-Helper $r
Assert-Equal 1 $run.Code 'existing ravintio.yml exits 1'
Assert-Contains 'ravintio.yml already exists' $run.Output 'names the existing workflow'
Assert-Equal $before (Get-Snapshot $r) 'existing ravintio.yml moves nothing'

Write-Host ""
Write-Host "=== (g) symlink refusal ==="
foreach ($name in @("$old-overrides", 'ravintio-overrides', "$old-zero")) {
    $r = New-Repo "link-$name"
    $target = Join-Path $scratch "target-$name"
    New-Item -ItemType Directory -Path $target | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $target 'keep.txt'), 'keep', $utf8)
    $link = Join-Path $r $name
    if (Test-Path -LiteralPath $link) { Remove-Item -LiteralPath $link -Recurse -Force }
    $made = $true
    try { New-Item -ItemType SymbolicLink -Path $link -Target $target -ErrorAction Stop | Out-Null }
    catch { $made = $false }
    if (-not $made) {
        Write-Host "  SKIP: cannot create a symlink for $name on this host"
        continue
    }
    $before = Get-Snapshot $r
    $run = Invoke-Helper $r
    Assert-Equal 1 $run.Code "symlinked $name exits 1"
    Assert-Contains 'is a symlink' $run.Output "symlinked $name is named"
    Assert-Equal $before (Get-Snapshot $r) "symlinked $name moves nothing"
    $item = Get-Item -LiteralPath $link -Force
    Assert-True (($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0) "link $name still a link"
    Assert-Equal 'keep' (Read-Text (Join-Path $target 'keep.txt')) "target of $name untouched"
}

}
finally {
    Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
}

Complete-Suite
