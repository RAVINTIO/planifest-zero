# Runs every test-*.ps1 suite in tests/ and tests/regression/ under the
# PowerShell host that started this script (0000036 ADR-002). CI runs it once
# with powershell (Windows PowerShell 5.1) and once with pwsh (PowerShell 7).
# run-tests.sh runs the same suites with pwsh, alongside the bash suites.

$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$hostExe = (Get-Process -Id $PID).Path
Write-Host "Host: PowerShell $($PSVersionTable.PSVersion) ($($PSVersionTable.PSEdition)), $hostExe"

$suites = @(Get-ChildItem -LiteralPath $here -Filter 'test-*.ps1' -File | Sort-Object Name)
$regressionDir = Join-Path $here 'regression'
if (Test-Path -LiteralPath $regressionDir) {
    $suites += @(Get-ChildItem -LiteralPath $regressionDir -Filter 'test-*.ps1' -File | Sort-Object Name)
}

if ($suites.Count -eq 0) {
    Write-Host "No PowerShell suites found."
    exit 1
}

$failed = @()
foreach ($suite in $suites) {
    Write-Host ""
    Write-Host "--- $($suite.Name) ---"
    & $hostExe -NoProfile -ExecutionPolicy Bypass -File $suite.FullName
    if ($LASTEXITCODE -ne 0) { $failed += $suite.Name }
}

Write-Host ""
Write-Host "================================"
Write-Host "PowerShell suites: $($suites.Count - $failed.Count) passed, $($failed.Count) failed."
foreach ($name in $failed) { Write-Host "  failed: $name" }
Write-Host "================================"
if ($failed.Count -gt 0) { exit 1 }
exit 0
