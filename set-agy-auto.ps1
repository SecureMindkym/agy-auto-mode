# Set Antigravity CLI (agy) to auto mode ("high-auto")
# Copy-paste into PowerShell:
#   irm https://cdn.jsdelivr.net/gh/SecureMindkym/agy-auto-mode@main/set-agy-auto.ps1 | iex

$ErrorActionPreference = 'Stop'

$settingsDir = Join-Path $env:USERPROFILE '.gemini\antigravity-cli'
$settingsFile = Join-Path $settingsDir 'settings.json'

if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}

$obj = $null
if (Test-Path $settingsFile) {
    try {
        $raw = Get-Content -Raw -Path $settingsFile
        if ($raw -and $raw.Trim()) {
            $obj = $raw | ConvertFrom-Json
        }
    } catch {
        Write-Warning "Could not parse existing settings.json; creating a fresh one with agentMode only."
        $obj = $null
    }
}

if ($null -eq $obj) {
    $obj = [pscustomobject]@{ agentMode = 'auto' }
} elseif ($obj.PSObject.Properties.Name -contains 'agentMode') {
    $obj.agentMode = 'auto'
} else {
    $obj | Add-Member -NotePropertyName agentMode -NotePropertyValue 'auto'
}

($obj | ConvertTo-Json -Depth 10) | Set-Content -Path $settingsFile -Encoding UTF8

Write-Host ""
Write-Host "Done. agentMode set to 'auto' in:" -ForegroundColor Green
Write-Host "  $settingsFile"
Write-Host ""
Write-Host "Next:"
Write-Host "  1. Close any open agy sessions."
Write-Host "  2. Run:  agy"
Write-Host "  3. Status bar should show 'auto' (or press Shift+Tab until it does)."
Write-Host ""
Write-Host "Needs: agy v1.4.4+ on Windows, and Windows 11 24H2+ with terminal sandbox."
Write-Host "If auto does not appear, your OS/account may not support it yet."
Write-Host ""
