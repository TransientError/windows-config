<#
.SYNOPSIS
    Update scoop packages, filtering out updates less than a week old.
.DESCRIPTION
    Supply chain attack mitigation: only install updates whose bucket
    commit is at least 7 days old. Gives time for community to spot
    compromised packages.
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
$scoopDir = if ($env:SCOOP) { $env:SCOOP } else { "$env:USERPROFILE\scoop" }

Write-Host "Updating scoop and buckets..." -ForegroundColor Cyan
scoop update

$statusLines = scoop status 2>&1 | Out-String | ForEach-Object { $_ -split "`n" }

# Find header separator line (----) to determine column positions
$separatorIdx = $null
for ($i = 0; $i -lt $statusLines.Count; $i++) {
    if ($statusLines[$i] -match '^-{3,}') { $separatorIdx = $i; break }
}

if ($null -eq $separatorIdx) {
    Write-Host "All packages up to date." -ForegroundColor Green
    exit 0
}

# Parse column boundaries from separator line
$sep = $statusLines[$separatorIdx]
$colStarts = @()
$inDash = $false
for ($i = 0; $i -lt $sep.Length; $i++) {
    if ($sep[$i] -eq '-' -and -not $inDash) { $colStarts += $i; $inDash = $true }
    elseif ($sep[$i] -ne '-') { $inDash = $false }
}

$dataLines = $statusLines[($separatorIdx + 1)..($statusLines.Count - 1)] | Where-Object { $_.Trim() -ne '' }

if ($dataLines.Count -eq 0) {
    Write-Host "All packages up to date." -ForegroundColor Green
    exit 0
}

function Get-Column($line, $colIndex) {
    $start = $colStarts[$colIndex]
    $end = if ($colIndex + 1 -lt $colStarts.Count) { $colStarts[$colIndex + 1] } else { $line.Length }
    if ($start -ge $line.Length) { return "" }
    $end = [math]::Min($end, $line.Length)
    return $line.Substring($start, $end - $start).Trim()
}

$updates = @()
foreach ($line in $dataLines) {
    $name = Get-Column $line 0
    $installed = Get-Column $line 1
    $latest = Get-Column $line 2
    if (-not $name -or -not $latest) { continue }

    # Resolve bucket from install.json
    $installJson = Join-Path $scoopDir "apps\$name\current\install.json"
    $bucket = "main"
    if (Test-Path $installJson) {
        $info = Get-Content $installJson -Raw | ConvertFrom-Json
        if ($info.bucket) { $bucket = $info.bucket }
    }

    # Get commit date of latest manifest change in bucket
    $bucketPath = Join-Path $scoopDir "buckets\$bucket"
    $manifestFile = "bucket/$name.json"
    $commitDateStr = git -C $bucketPath log -1 --format="%aI" -- $manifestFile 2>$null

    $commitDate = $null
    $ageDays = $null
    if ($commitDateStr) {
        $commitDate = [DateTimeOffset]::Parse($commitDateStr.Trim())
        $ageDays = [math]::Floor(([DateTimeOffset]::UtcNow - $commitDate).TotalDays)
    } else {
        Write-Warning "Could not determine commit date for '$name' in bucket '$bucket' — skipping as unsafe"
    }

    $updates += [PSCustomObject]@{
        Name        = $name
        Installed   = $installed
        Latest      = $latest
        Bucket      = $bucket
        CommitDate  = if ($commitDate) { $commitDate.ToString("yyyy-MM-dd") } else { "unknown" }
        AgeDays     = $ageDays
        Safe        = if ($Force) { $true } elseif ($null -eq $ageDays) { $false } else { $ageDays -ge $MinAgeDays }
    }
}

if ($updates.Count -eq 0) {
    Write-Host "No updates found." -ForegroundColor Green
    exit 0
}

# Display all updates with status
Write-Host "`nAvailable updates (min age: $MinAgeDays days):" -ForegroundColor Cyan
Write-Host ("{0,-20} {1,-15} {2,-15} {3,-12} {4,-8} {5}" -f "Name", "Installed", "Latest", "Commit Date", "Age", "Status")
Write-Host ("{0,-20} {1,-15} {2,-15} {3,-12} {4,-8} {5}" -f "----", "---------", "------", "-----------", "---", "------")

foreach ($u in $updates) {
    $status = if ($u.Safe) { "SAFE" } else { "TOO NEW" }
    $color = if ($u.Safe) { "Green" } else { "Yellow" }
    $ageStr = if ($null -ne $u.AgeDays) { "$($u.AgeDays)d" } else { "?" }
    Write-Host ("{0,-20} {1,-15} {2,-15} {3,-12} {4,-8} {5}" -f $u.Name, $u.Installed, $u.Latest, $u.CommitDate, $ageStr, $status) -ForegroundColor $color
}

$safeUpdates = $updates | Where-Object { $_.Safe }
$skipped = $updates | Where-Object { -not $_.Safe }

if ($skipped.Count -gt 0) {
    Write-Host "`nSkipping $($skipped.Count) update(s) newer than $MinAgeDays days." -ForegroundColor Yellow
}

if ($safeUpdates.Count -eq 0) {
    Write-Host "No updates old enough to install." -ForegroundColor Yellow
    exit 0
}

if ($DryRun) {
    Write-Host "`n[DryRun] Would update: $($safeUpdates.Name -join ', ')" -ForegroundColor Magenta
    exit 0
}

Write-Host "`nInstalling $($safeUpdates.Count) safe update(s)..." -ForegroundColor Cyan
foreach ($u in $safeUpdates) {
    Write-Host "`n>> Updating $($u.Name) ($($u.Installed) -> $($u.Latest))..." -ForegroundColor Cyan
    scoop update $u.Name
}

Write-Host "`nDone." -ForegroundColor Green
