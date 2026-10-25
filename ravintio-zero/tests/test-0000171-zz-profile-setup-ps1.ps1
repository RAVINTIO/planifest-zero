# TEMPORARY profiling suite for feature 0000171-faster-setup-ps1-tests.
# Remove it before PR #32 merges. It times each setup.ps1 function and each
# top-level statement on the CI hosts, then prints the slowest items. It always
# passes, so it only reports. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

# Builds setup-profile.ps1 beside setup.ps1. Each function X becomes X__orig
# plus a wrapper X that records inclusive and self time. Each top-level
# statement is timed under the label top:L{line}.
function New-ProfiledSetup {
    param([string]$SetupPath, [string]$OutPath)
    $text = [System.IO.File]::ReadAllText($SetupPath)
    $tokens = $null; $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($text, [ref]$tokens, [ref]$errors)
    $edits = @()
    foreach ($st in $ast.EndBlock.Statements) {
        $start = $st.Extent.StartOffset
        $len = $st.Extent.EndOffset - $start
        $orig = $text.Substring($start, $len)
        if ($st -is [System.Management.Automation.Language.FunctionDefinitionAst]) {
            $name = $st.Name
            $pattern = [regex]('(?i)^function\s+' + [regex]::Escape($name))
            $renamed = $pattern.Replace($orig, "function ${name}__orig", 1)
            $wrapper = "function $name { __Enter; try { ${name}__orig @args } finally { __Leave '$name' } }"
            $new = $renamed + "`n" + $wrapper
        }
        else {
            $label = 'top:L' + $st.Extent.StartLineNumber
            $new = "__Enter`n" + $orig + "`n__Leave '$label'"
        }
        $edits += [PSCustomObject]@{ Start = $start; Len = $len; New = $new }
    }
    foreach ($e in ($edits | Sort-Object Start -Descending)) {
        $text = $text.Remove($e.Start, $e.Len).Insert($e.Start, $e.New)
    }
    $prelude = @'
$global:ProfStart = [System.Diagnostics.Stopwatch]::StartNew()
$global:ProfLaunch = ((Get-Date) - (Get-Process -Id $PID).StartTime).TotalMilliseconds
$global:ProfData = @{}
$global:ProfStack = New-Object System.Collections.Stack
function __Enter { $global:ProfStack.Push(@{ Child = 0.0; Watch = [System.Diagnostics.Stopwatch]::StartNew() }) }
function __Leave {
    param([string]$Name)
    $frame = $global:ProfStack.Pop()
    $t = $frame.Watch.Elapsed.TotalMilliseconds
    if (-not $global:ProfData.ContainsKey($Name)) { $global:ProfData[$Name] = @{ N = 0; Inc = 0.0; Self = 0.0 } }
    $row = $global:ProfData[$Name]
    $row.N++
    $row.Inc += $t
    $row.Self += ($t - $frame.Child)
    if ($global:ProfStack.Count -gt 0) { $global:ProfStack.Peek().Child += $t }
}
function __Dump {
    $rows = @()
    foreach ($k in $global:ProfData.Keys) {
        $r = $global:ProfData[$k]
        $rows += ('{0}|{1}|{2:F1}|{3:F1}' -f $k, $r.N, $r.Inc, $r.Self)
    }
    $rows += ('launch-to-script|1|{0:F1}|{0:F1}' -f $global:ProfLaunch)
    $rows += ('script-total|1|{0:F1}|0' -f $global:ProfStart.Elapsed.TotalMilliseconds)
    [System.IO.File]::WriteAllLines($env:RAVINTIO_PROFILE_OUT, [string[]]$rows)
}
try {
'@
    $text = $prelude + "`n" + $text + "`n}`nfinally { __Dump }`n"
    [System.IO.File]::WriteAllText($OutPath, $text, (New-Object System.Text.UTF8Encoding $true))
}

# Runs the profiled setup once in a fresh or reused workspace and returns rows.
function Invoke-ProfiledSetup {
    param([string]$Workspace)
    $setup = Join-Path $Workspace 'ravintio-zero\setup.ps1'
    $prof = Join-Path $Workspace 'ravintio-zero\setup-profile.ps1'
    if (-not (Test-Path $prof)) { New-ProfiledSetup -SetupPath $setup -OutPath $prof }
    $out = Join-Path $Workspace 'profile.txt'
    $env:RAVINTIO_PROFILE_OUT = $out
    $savedCeiling = $env:GIT_CEILING_DIRECTORIES
    $env:GIT_CEILING_DIRECTORIES = Split-Path -Parent $Workspace
    Push-Location $Workspace
    try {
        $wall = [System.Diagnostics.Stopwatch]::StartNew()
        $null = & $global:HostExe -NoProfile -ExecutionPolicy Bypass -File $prof 'claude-code' 2>&1 | Out-String
        $wallMs = $wall.Elapsed.TotalMilliseconds
    }
    finally {
        Pop-Location
        $env:GIT_CEILING_DIRECTORIES = $savedCeiling
    }
    $rows = @()
    if (Test-Path $out) { $rows = [System.IO.File]::ReadAllLines($out) }
    $rows += ('process-wall|1|{0:F1}|0' -f $wallMs)
    return $rows
}

try {

$runs = 3
$totals = @{}
foreach ($kind in @('fresh', 'rerun')) {
    $totals[$kind] = @{}
    for ($i = 0; $i -lt $runs; $i++) {
        $ws = New-SetupWorkspace
        if ($kind -eq 'rerun') { $null = Invoke-ProfiledSetup $ws }
        foreach ($line in (Invoke-ProfiledSetup $ws)) {
            $p = $line -split '\|'
            if (-not $totals[$kind].ContainsKey($p[0])) { $totals[$kind][$p[0]] = @(0.0, 0.0, 0) }
            $t = $totals[$kind][$p[0]]
            $t[0] += [double]$p[2] / $runs
            $t[1] += [double]$p[3] / $runs
            $t[2] = [int]$p[1]
        }
        Remove-SetupWorkspace $ws
    }
}

$hostName = if ($PSVersionTable.PSEdition -eq 'Core') { 'pwsh ' + $PSVersionTable.PSVersion } else { 'powershell ' + $PSVersionTable.PSVersion }
foreach ($kind in @('fresh', 'rerun')) {
    Write-Host ""
    Write-Host "=== [profile] $hostName, $kind install, mean of $runs runs, ms ==="
    Write-Host ('[profile] {0,-36} {1,6} {2,10} {3,10}' -f 'item', 'calls', 'inclusive', 'self')
    $sorted = $totals[$kind].GetEnumerator() | Sort-Object { $_.Value[1] } -Descending
    foreach ($name in @('process-wall', 'script-total', 'launch-to-script')) {
        $v = $totals[$kind][$name]
        if ($v) { Write-Host ('[profile] {0,-36} {1,6} {2,10:F1} {3,10:F1}' -f $name, $v[2], $v[0], $v[1]) }
    }
    $shown = 0
    foreach ($e in $sorted) {
        if (@('process-wall', 'script-total', 'launch-to-script') -contains $e.Key) { continue }
        Write-Host ('[profile] {0,-36} {1,6} {2,10:F1} {3,10:F1}' -f $e.Key, $e.Value[2], $e.Value[0], $e.Value[1])
        $shown++
        if ($shown -ge 20) { break }
    }
}

Assert-True $true "profile: report printed"

}
finally { Remove-AllWorkspaces }

Complete-Suite
