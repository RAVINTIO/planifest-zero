# Assert helpers for PowerShell suites, the counterpart of assert.sh
# (0000036 ADR-002). Dot-source this file, call the asserts, then end the
# suite with Complete-Suite. Each suite runs in its own process, so the
# counters live in global scope. Works on Windows PowerShell 5.1 and
# PowerShell 7.

$global:AssertPass = 0
$global:AssertFail = 0

function Assert-Equal {
    param($Expected, $Actual, [string]$Message)
    if ("$Expected" -ceq "$Actual") {
        $global:AssertPass++
        Write-Host "  PASS: $Message"
    }
    else {
        $global:AssertFail++
        Write-Host "  FAIL: $Message"
        Write-Host "        expected: $Expected"
        Write-Host "        actual:   $Actual"
    }
}

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if ($Condition) {
        $global:AssertPass++
        Write-Host "  PASS: $Message"
    }
    else {
        $global:AssertFail++
        Write-Host "  FAIL: $Message"
    }
}

function Assert-Contains {
    param([string]$Needle, [string]$Haystack, [string]$Message)
    Assert-True ($Haystack.Contains($Needle)) $Message
}

function Complete-Suite {
    Write-Host ""
    Write-Host "Results: $global:AssertPass passed, $global:AssertFail failed"
    if ($global:AssertFail -gt 0 -or $global:AssertPass -eq 0) { exit 1 }
    exit 0
}
