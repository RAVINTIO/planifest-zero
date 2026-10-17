# Workspace helpers for the PowerShell setup.ps1 suites (0000036 req-004).
# Each workspace is a fresh temporary project holding a copy of
# planifest-zero/ and its own git repo, so setup.ps1 never touches this
# checkout. Keep this file ASCII: Windows PowerShell 5.1 reads a file with no
# BOM as ANSI.

$global:FrameworkDir = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$global:HostExe = (Get-Process -Id $PID).Path

# The nine entries setup.sh writes, in order (0000035 ADR-001).
$global:ExpectedEntries = @(
    'PreToolUse Write gate-write',
    'PreToolUse Edit gate-write',
    'PreToolUse Write ratchet-check',
    'PreToolUse Edit ratchet-check',
    'PreToolUse Write em-dash-guard',
    'PreToolUse Edit em-dash-guard',
    'UserPromptSubmit .* auto-trigger-orchestrator',
    'UserPromptSubmit .* check-orchestrator-presence',
    'UserPromptSubmit .* check-design'
) -join "`n"

$global:PlanifestModules = @(
    'gate-write', 'ratchet-check', 'em-dash-guard',
    'auto-trigger-orchestrator', 'check-orchestrator-presence', 'check-design'
)

function New-SetupWorkspace {
    $ws = Join-Path ([System.IO.Path]::GetTempPath()) ("planifest_0000036_" + [guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $ws | Out-Null
    Copy-Item -Path $global:FrameworkDir -Destination (Join-Path $ws 'planifest-zero') -Recurse
    New-Item -ItemType Directory -Path (Join-Path $ws '.claude') | Out-Null
    & git -C $ws init -q 2>&1 | Out-Null
    return $ws
}

function Remove-SetupWorkspace {
    param([string]$Workspace)
    Remove-Item -LiteralPath $Workspace -Recurse -Force -ErrorAction SilentlyContinue
}

# Runs setup.ps1 in a child process of the same host. Returns the exit code
# and the combined output.
function Invoke-Setup {
    param([string]$Workspace, [string[]]$SetupArgs)
    $setup = Join-Path $Workspace 'planifest-zero\setup.ps1'
    Push-Location $Workspace
    try {
        $output = & $global:HostExe -NoProfile -ExecutionPolicy Bypass -File $setup @SetupArgs 2>&1 | Out-String
        $code = $LASTEXITCODE
    }
    finally { Pop-Location }
    return [PSCustomObject]@{ Code = $code; Output = $output }
}

function Get-SettingsPath {
    param([string]$Workspace)
    return (Join-Path $Workspace '.claude\settings.json')
}

function Read-Settings {
    param([string]$Workspace)
    $bytes = [System.IO.File]::ReadAllBytes((Get-SettingsPath $Workspace))
    $text = (New-Object System.Text.UTF8Encoding $false).GetString($bytes)
    return ($text.TrimStart([char]0xFEFF) | ConvertFrom-Json)
}

function Write-SettingsText {
    param([string]$Workspace, [string]$Json)
    [System.IO.File]::WriteAllText((Get-SettingsPath $Workspace), $Json, (New-Object System.Text.UTF8Encoding $false))
}

# Lists "event matcher module" for every hook command that names a .mjs file.
function Get-HookEntries {
    param($Settings, [switch]$PlanifestOnly)
    $lines = @()
    foreach ($event in @('PreToolUse', 'UserPromptSubmit')) {
        foreach ($entry in @($Settings.hooks.$event)) {
            if ($null -eq $entry) { continue }
            foreach ($hook in @($entry.hooks)) {
                if ("$($hook.command)" -match '([A-Za-z0-9-]+)\.mjs') {
                    $module = $Matches[1]
                    if ($PlanifestOnly -and $global:PlanifestModules -cnotcontains $module) { continue }
                    $lines += "$event $($entry.matcher) $module"
                }
            }
        }
    }
    return ($lines -join "`n")
}
