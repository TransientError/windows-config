<#
.SYNOPSIS
    Update winget packages, filtering out updates less than a week old.
.DESCRIPTION
    Supply chain attack mitigation: queries GitHub API for microsoft/winget-pkgs
    commit dates. Only installs updates whose manifest commit is at least
    MinAgeDays old.
.PARAMETER MinAgeDays
    Minimum age in days for an update to be installed. Default: 7.
.PARAMETER DryRun
    Show what would be updated without actually updating.
.PARAMETER Force
    Bypass age filter and update everything (use with caution).
#>
[CmdletBinding()]
param(
    [int]$MinAgeDays = 7,
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# First-party publishers trusted by default — skip API date check
$TrustedPublishers = @(
    'Microsoft'
    'GitHub'
)

function Test-TrustedPublisher($packageId) {
    $publisher = ($packageId -split '\.', 2)[0]
    return $publisher -in $script:TrustedPublishers
}

function Get-ManifestCommitDate($packageId) {
    $parts = $packageId -split '\.', 2
    if ($parts.Count -lt 2) { return $null }
    $firstLetter = $parts[0].Substring(0, 1).ToLower()
    $path = "manifests/$firstLetter/$($parts[0])/$($parts[1])"

    try {
        # Use gh if authenticated, fall back to Invoke-RestMethod
        $useGh = $false
        try {
            $null = gh auth status 2>&1
            if ($LASTEXITCODE -eq 0) { $useGh = $true }
        } catch { }

        if ($useGh) {
            $json = gh api "repos/microsoft/winget-pkgs/commits?path=$path&per_page=1" 2>$null
            $response = $json | ConvertFrom-Json
        } else {
            $response = Invoke-RestMethod `
                -Uri "https://api.github.com/repos/microsoft/winget-pkgs/commits?path=$path&per_page=1" `
                -Headers @{ 'User-Agent' = 'winget-safe-update' }
        }

        if ($response -and $response.Count -gt 0) {
            return [DateTimeOffset]::Parse($response[0].commit.author.date)
        }
    } catch {
        Write-Warning "API error for '$packageId': $_"
    }
    return $null
}

Write-Host "Checking for winget upgrades..." -ForegroundColor Cyan
$rawOutput = winget upgrade --include-unknown 2>&1 | Out-String
$allLines = $rawOutput -split "`n"

# Find header separator to parse columns
$separatorIdx = $null
for ($i = 0; $i -lt $allLines.Count; $i++) {
    if ($allLines[$i] -match '^-{10,}') { $separatorIdx = $i; break }
}

if ($null -eq $separatorIdx) {
    Write-Host "No upgrades available." -ForegroundColor Green
    exit 0
}

# Parse column positions from header line (line before separator)
$headerLine = $allLines[$separatorIdx - 1]
$colNames = @("Name", "Id", "Version", "Available", "Source")
$colStarts = @()
foreach ($col in $colNames) {
    $idx = $headerLine.IndexOf($col)
    if ($idx -ge 0) { $colStarts += $idx }
}

if ($colStarts.Count -lt 4) {
    Write-Host "Could not parse winget output format." -ForegroundColor Red
    exit 1
}

function Get-Column($line, $colIndex) {
    $start = $colStarts[$colIndex]
    $end = if ($colIndex + 1 -lt $colStarts.Count) { $colStarts[$colIndex + 1] } else { $line.Length }
    if ($start -ge $line.Length) { return "" }
    $end = [math]::Min($end, $line.Length)
    return $line.Substring($start, $end - $start).Trim()
}

$dataLines = $allLines[($separatorIdx + 1)..($allLines.Count - 1)] |
    Where-Object { $_.Trim() -ne '' -and $_ -notmatch '^\d+ upgrades? available' }

if ($dataLines.Count -eq 0) {
    Write-Host "No upgrades available." -ForegroundColor Green
    exit 0
}

$updates = @()
$totalPackages = $dataLines.Count
$current = 0

foreach ($line in $dataLines) {
    $name = Get-Column $line 0
    $id = Get-Column $line 1
    $installed = Get-Column $line 2
    $available = Get-Column $line 3

    if (-not $id -or -not $available) { continue }

    $current++
    $trusted = Test-TrustedPublisher $id

    if (-not $trusted) {
        Write-Host "`r  Checking commit dates... ($current/$totalPackages)" -NoNewline -ForegroundColor DarkGray
        $commitDate = Get-ManifestCommitDate $id
        $ageDays = $null
        if ($commitDate) {
            $ageDays = [math]::Floor(([DateTimeOffset]::UtcNow - $commitDate).TotalDays)
        } else {
            Write-Warning "Could not determine commit date for '$id' — skipping as unsafe"
        }
    } else {
        $commitDate = $null
        $ageDays = $null
    }

    $updates += [PSCustomObject]@{
        Name       = $name
        Id         = $id
        Installed  = $installed
        Available  = $available
        CommitDate = if ($trusted) { "trusted" } elseif ($commitDate) { $commitDate.ToString("yyyy-MM-dd") } else { "unknown" }
        AgeDays    = $ageDays
        Trusted    = $trusted
        Safe       = if ($Force -or $trusted) { $true } elseif ($null -eq $ageDays) { $false } else { $ageDays -ge $MinAgeDays }
    }
}
Write-Host ""

if ($updates.Count -eq 0) {
    Write-Host "No updates found." -ForegroundColor Green
    exit 0
}

Write-Host "`nAvailable updates (min age: $MinAgeDays days):" -ForegroundColor Cyan
Write-Host ("{0,-22} {1,-35} {2,-14} {3,-14} {4,-12} {5,-6} {6}" -f "Name", "Id", "Installed", "Available", "Commit Date", "Age", "Status")
Write-Host ("{0,-22} {1,-35} {2,-14} {3,-14} {4,-12} {5,-6} {6}" -f "----", "--", "---------", "---------", "-----------", "---", "------")

foreach ($u in $updates) {
    $status = if ($u.Trusted) { "TRUSTED" } elseif ($u.Safe) { "SAFE" } else { "TOO NEW" }
    $color = if ($u.Safe) { "Green" } else { "Yellow" }
    $ageStr = if ($u.Trusted) { "-" } elseif ($null -ne $u.AgeDays) { "$($u.AgeDays)d" } else { "?" }
    Write-Host ("{0,-22} {1,-35} {2,-14} {3,-14} {4,-12} {5,-6} {6}" -f $u.Name, $u.Id, $u.Installed, $u.Available, $u.CommitDate, $ageStr, $status) -ForegroundColor $color
}

$safeUpdates = $updates | Where-Object { $_.Safe }
$skipped = $updates | Where-Object { -not $_.Safe }

# List untrusted publishers for awareness
$untrustedPublishers = $updates | Where-Object { -not $_.Trusted } |
    ForEach-Object { ($_.Id -split '\.', 2)[0] } | Sort-Object -Unique
if ($untrustedPublishers) {
    Write-Host "`nUntrusted publishers: $($untrustedPublishers -join ', ')" -ForegroundColor DarkYellow
    Write-Host "  To trust, add to `$TrustedPublishers in the script." -ForegroundColor DarkGray
}

if ($skipped.Count -gt 0) {
    Write-Host "`nSkipping $($skipped.Count) update(s) newer than $MinAgeDays days." -ForegroundColor Yellow
}

if ($safeUpdates.Count -eq 0) {
    Write-Host "No updates old enough to install." -ForegroundColor Yellow
    exit 0
}

if ($DryRun) {
    Write-Host "`n[DryRun] Would update: $($safeUpdates.Id -join ', ')" -ForegroundColor Magenta
    exit 0
}

# Snapshot desktop shortcuts before updates
$preDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
    Get-ChildItem -Filter '*.lnk' -ErrorAction SilentlyContinue

function Remove-NewDesktopShortcuts {
    $postDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
        Get-ChildItem -Filter '*.lnk' -ErrorAction SilentlyContinue
    $newShortcuts = $postDesktop | Where-Object FullName -notin $preDesktop.FullName
    if ($newShortcuts) {
        Write-Host "`nCleaning up new desktop shortcuts..." -ForegroundColor DarkGray
        $newShortcuts | ForEach-Object {
            Remove-Item -LiteralPath $_.FullName
            Write-Host "  Removed $($_.Name)" -ForegroundColor DarkGray
        }
    }
}

# Ensure shortcut cleanup runs even on Ctrl+C
try {
    [Console]::TreatControlCAsInput = $true

    Write-Host "`nInstalling $($safeUpdates.Count) safe update(s)..." -ForegroundColor Cyan
    foreach ($u in $safeUpdates) {
        # Check for Ctrl+C between packages
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            if ($key.Modifiers -band [ConsoleModifiers]::Control -and $key.Key -eq 'C') {
                Write-Host "`nCtrl+C detected — stopping updates." -ForegroundColor Yellow
                break
            }
        }
        Write-Host "`n>> Updating $($u.Name) ($($u.Installed) -> $($u.Available))..." -ForegroundColor Cyan
        winget upgrade --id $u.Id --accept-source-agreements --accept-package-agreements
    }
} finally {
    [Console]::TreatControlCAsInput = $false
    Remove-NewDesktopShortcuts
}

Write-Host "`nDone." -ForegroundColor Green
