# Set Antigravity CLI (agy) to auto mode ("high-auto")
# Copy-paste into PowerShell:
#   irm https://cdn.jsdelivr.net/gh/SecureMindkym/agy-auto-mode@main/set-agy-auto.ps1 | iex

$ErrorActionPreference = 'Stop'

$settingsDir = Join-Path $env:USERPROFILE '.gemini\antigravity-cli'
$settingsFile = Join-Path $settingsDir 'settings.json'

if (-not (Test-Path $settingsDir)) {
    New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
}

# Strip UTF-8 BOM if present (agy rejects \ufeff)
function Read-JsonNoBom([string]$path) {
    if (-not (Test-Path $path)) { return $null }
    $bytes = [System.IO.File]::ReadAllBytes($path)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $bytes = $bytes[3..($bytes.Length - 1)]
    }
    $raw = [System.Text.Encoding]::UTF8.GetString($bytes)
    if (-not $raw.Trim()) { return $null }
    try { return ($raw | ConvertFrom-Json) } catch { return $null }
}

$obj = Read-JsonNoBom $settingsFile
if ($null -eq $obj) {
    $obj = [pscustomobject]@{ agentMode = 'auto' }
} elseif ($obj.PSObject.Properties.Name -contains 'agentMode') {
    $obj.agentMode = 'auto'
} else {
    $obj | Add-Member -NotePropertyName agentMode -NotePropertyValue 'auto'
}

# Write UTF-8 without BOM (agy fails on \ufeff)
$json = $obj | ConvertTo-Json -Depth 10
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($settingsFile, $json + [Environment]::NewLine, $utf8NoBom)

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
