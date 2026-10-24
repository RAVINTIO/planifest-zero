# Tests for feature 0000041-setup-cleanup-and-park-hardening, req-002 and
# req-003, in setup.ps1 under whichever host runs this file.
# req-002: the telemetry cleanup skips a settings.json that fails the parse
# or the shape check. It prints nothing and writes nothing, so the hook
# install step prints its one line and exits 1 (ADR-002).
# req-003: the non-array warning names the event and the file, and never
# prints the old value (ADR-003).
# Every input is built inline. Keep this file ASCII.

. (Join-Path $PSScriptRoot 'helpers\assert.ps1')
. (Join-Path $PSScriptRoot 'helpers\setup-workspace.ps1')

$shapeError = '! Error: .claude/settings.json is valid JSON but not a settings object setup can read. Fix it and rerun setup.'
$invalidError = '! Error: .claude/settings.json is not valid JSON. Fix it and rerun setup.'
$planted = 'PLANTED-SECRET-0000041'

# emit-event is one of the modules in $TelemetryHookModules in setup.ps1.
$telemetryCommand = 'node .claude/hooks/telemetry/emit-event.mjs'
$telemetryEntry = '{"hooks":[{"type":"command","command":"' + $telemetryCommand + '"}]}'

# Runs setup.ps1 in a child process of the same host and keeps stdout and
# stderr apart. Windows PowerShell 5.1 wraps redirected stderr in error
# records, so this reads the raw streams from the process instead.
function Invoke-SetupSplit {
    param([string]$Workspace, [string[]]$SetupArgs)
    $setup = Join-Path $Workspace 'planifest-zero\setup.ps1'
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $global:HostExe
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$setup`" " + ($SetupArgs -join ' ')
    $psi.WorkingDirectory = $Workspace
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.EnvironmentVariables['GIT_CEILING_DIRECTORIES'] = Split-Path -Parent $Workspace
    $proc = [System.Diagnostics.Process]::Start($psi)
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $err = $proc.StandardError.ReadToEnd()
    $proc.WaitForExit()
    $out = $outTask.Result
    return [PSCustomObject]@{ Code = $proc.ExitCode; Stdout = $out; Stderr = $err }
}

function Get-FileBase64 {
    param([string]$Path)
    return [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($Path))
}

# Lists every line of both streams, with line ends removed.
function Get-OutputLines {
    param($Run)
    return @(($Run.Stdout + "`n" + $Run.Stderr) -split "`r?`n")
}

# Lists every error or warning line, from setup's own "! " lines and from
# Write-Warning, which prints "WARNING:".
function Get-ProblemLines {
    param($Run)
    return @(Get-OutputLines $Run | Where-Object {
        $_.Contains('! Error:') -or $_.Contains('! Warning:') -or $_.TrimStart().StartsWith('WARNING:')
    })
}

# Checks one rejected input: exit 1, the one expected line and no other
# error or warning, no cleanup line, and a byte-identical file.
function Assert-OnlyLine {
    param([string]$Workspace, [string]$Json, [string]$Line, [string]$Label)
    Write-SettingsText $Workspace $Json
    $before = Get-FileBase64 (Get-SettingsPath $Workspace)
    $run = Invoke-SetupSplit $Workspace @('claude-code')
    Assert-Equal 1 $run.Code "$Label exits 1"
    $stderrLines = @($run.Stderr -split "`r?`n" | ForEach-Object { $_.Trim() })
    Assert-True ($stderrLines -ccontains $Line) "$Label prints the expected line to stderr"
    $problems = @(Get-ProblemLines $run)
    Assert-Equal 1 $problems.Count "$Label prints exactly one error or warning line"
    $all = $run.Stdout + $run.Stderr
    Assert-True (-not $all.Contains('Could not remove telemetry')) "$Label prints no cleanup warning"
    Assert-True (-not $all.Contains('removed telemetry hook entries')) "$Label prints no cleanup removal line"
    Assert-Equal $before (Get-FileBase64 (Get-SettingsPath $Workspace)) "$Label leaves settings.json byte-identical"
    Assert-True (-not (Test-Path -LiteralPath ((Get-SettingsPath $Workspace) + '.planifest-tmp'))) "$Label leaves no temporary file"
    if ($run.Code -ne 1 -or $problems.Count -ne 1) { Write-Host $run.Stdout; Write-Host $run.Stderr }
}

# Lists "matcher module" for each entry of one event. A non-array value
# lists "not-array". Reads the property directly, never through the
# pipeline, so Windows PowerShell 5.1 can't unwrap a one-item array.
function Get-EventEntries {
    param($Settings, [string]$EventName)
    $value = $Settings.hooks.$EventName
    if (-not ($value -is [array])) { return 'not-array' }
    $lines = @()
    foreach ($entry in $value) {
        $cmds = (@($entry.hooks) | ForEach-Object { "$($_.command)" }) -join ' '
        if ($cmds -match '([A-Za-z0-9-]+)\.mjs') { $lines += "$($entry.matcher) $($Matches[1])" }
        else { $lines += "$($entry.matcher) $cmds" }
    }
    return ($lines -join "`n")
}

$expected = @{
    PreToolUse       = @('Write gate-write', 'Edit gate-write', 'Write ratchet-check',
                         'Edit ratchet-check', 'Write em-dash-guard', 'Edit em-dash-guard',
                         'Bash merge-guard') -join "`n"
    UserPromptSubmit = @('.* auto-trigger-orchestrator', '.* check-orchestrator-presence',
                         '.* check-design') -join "`n"
}

try {

Write-Host ""
Write-Host "=== req-002 (a): a one-item array that holds a telemetry entry ==="

# PowerShell 7 unrolls a one-item top-level array into its object. Before
# req-002 the cleanup then removed the entry and wrote an object back.
$ws = New-SetupWorkspace
$arrayJson = '[{"hooks":{"Stop":[' + $telemetryEntry + ']}}]'
Assert-OnlyLine $ws $arrayJson $shapeError "req-002 (a): $arrayJson"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002 (b): a file that fails the shape check or the parse ==="

$ws = New-SetupWorkspace
foreach ($json in @('null', '{"hooks":"text"}', '{"a":1,"A":2}')) {
    Assert-OnlyLine $ws $json $shapeError "req-002 (b): $json"
}
Assert-OnlyLine $ws '{bad' $invalidError "req-002 (b): {bad"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-002 (c): a settings object with a telemetry entry ==="

$ws = New-SetupWorkspace
$userEntry = '{"hooks":[{"type":"command","command":"node tools/my-stop.mjs"}]}'
Write-SettingsText $ws ('{"hooks":{"Stop":[' + $telemetryEntry + ',' + $userEntry + ']}}')
$run = Invoke-SetupSplit $ws @('claude-code')
Assert-Equal 0 $run.Code "req-002 (c): setup.ps1 exits 0"
if ($run.Code -ne 0) { Write-Host $run.Stdout; Write-Host $run.Stderr }
$stdoutLines = @($run.Stdout -split "`r?`n")
Assert-True ($stdoutLines -ccontains '  - removed telemetry hook entries from .claude/settings.json') "req-002 (c): the cleanup prints its removal line"
$text = [System.IO.File]::ReadAllText((Get-SettingsPath $ws))
Assert-True (-not $text.Contains('emit-event.mjs')) "req-002 (c): the telemetry entry is gone"
Assert-True ($text.Contains('tools/my-stop.mjs')) "req-002 (c): the user entry stays"
Assert-True (-not ($run.Stdout + $run.Stderr).Contains('Could not remove telemetry')) "req-002 (c): the cleanup prints no warning"
Remove-SetupWorkspace $ws

Write-Host ""
Write-Host "=== req-003 (a) and (b): a non-array value never reaches the output ==="

$secretValues = @(
    ('"' + $planted + '"'),
    ('{"matcher":"Write","hooks":[{"type":"command","command":"node tools/check.mjs --token ' + $planted + '"}]}')
)
foreach ($ev in @('PreToolUse', 'UserPromptSubmit')) {
    if ($ev -eq 'PreToolUse') { $other = 'UserPromptSubmit' } else { $other = 'PreToolUse' }
    $warning = "  ! Warning: hooks.$ev in .claude/settings.json is not an array. Setup replaced it with the Planifest entries."
    foreach ($val in $secretValues) {
        $ws = New-SetupWorkspace
        Write-SettingsText $ws ('{"hooks":{"' + $ev + '":' + $val + '}}')
        $run = Invoke-SetupSplit $ws @('claude-code')
        Assert-Equal 0 $run.Code "req-003 (a): setup.ps1 exits 0 with $ev set to $val"
        if ($run.Code -ne 0) { Write-Host $run.Stdout; Write-Host $run.Stderr }
        $stderrLines = @($run.Stderr -split "`r?`n")
        Assert-True ($stderrLines -ccontains $warning) "req-003 (a): the $ev warning is exactly the new line"
        Assert-True (-not $run.Stdout.Contains($planted)) "req-003 (a): the $ev value stays out of stdout"
        Assert-True (-not $run.Stderr.Contains($planted)) "req-003 (a): the $ev value stays out of stderr"
        Assert-True (-not ($run.Stdout + $run.Stderr).Contains('Old value')) "req-003 (a): the $ev warning has no Old value"
        $settings = Read-Settings $ws
        Assert-Equal $expected[$ev] (Get-EventEntries $settings $ev) "req-003 (b): $ev holds only the Planifest entries"
        Assert-Equal $expected[$other] (Get-EventEntries $settings $other) "req-003 (b): $other gets the Planifest entries"
        $text = [System.IO.File]::ReadAllText((Get-SettingsPath $ws))
        Assert-True (-not $text.Contains($planted)) "req-003 (b): settings.json keeps no copy of the $ev value"
        Remove-SetupWorkspace $ws
    }
}

foreach ($case in @('absent', 'null')) {
    $ws = New-SetupWorkspace
    if ($case -eq 'absent') { Write-SettingsText $ws '{"hooks":{}}' }
    else { Write-SettingsText $ws '{"hooks":{"PreToolUse":null,"UserPromptSubmit":null}}' }
    $run = Invoke-SetupSplit $ws @('claude-code')
    Assert-Equal 0 $run.Code "req-003 (b): setup.ps1 exits 0 when both events are $case"
    Assert-True (-not ($run.Stdout + $run.Stderr).Contains('is not an array')) "req-003 (b): no warning when both events are $case"
    Remove-SetupWorkspace $ws
}

Write-Host ""
Write-Host "=== req-003 (c): setup.ps1 holds no old-value text ==="

$setupText = [System.IO.File]::ReadAllText((Join-Path $global:ZeroDir 'setup.ps1'))
Assert-True (-not $setupText.Contains('Old value')) "req-003 (c): setup.ps1 never prints Old value"
Assert-True ($setupText.Contains('"  ! Warning: hooks.$eventName in $SettingsRel is not an array. Setup replaced it with the Planifest entries."')) "req-003 (c): setup.ps1 holds the exact warning line"

}
finally { Remove-AllWorkspaces }

Complete-Suite
