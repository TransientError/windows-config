param([switch]$update = $false, [switch]$work = $false)

function Install-If-Not-Installed {
    param(
        [string]$provides,
        [scriptblock]$installScript
    )

    if (-not (Get-Command $provides -ErrorAction SilentlyContinue)) {
        $installScript.Invoke()
    }
}

function Update-Config-Or-Print-Error {
    param(
        [string]$sourcePath,
        [string]$content,
        [Parameter(Mandatory = $true)]
        [string]$configPath
    )
    $sourcePathName = (split-path $configPath -Leaf)
    
    if ($update -or -not (Test-Path $configPath)) {
        Write-Output "Updating $sourcePathName..."

        if ($sourcePath) {
            Copy-Item $sourcePath $configPath -Force
        }
        elseif ($content) {
            Out-File -InputObject $content -FilePath $configPath -Encoding UTF8            
        }
        else {
            Write-Error "No source file or content specified"
        }
    }
    elseif (-not $update) {
        Write-Error "$sourcePathName already exists at $configPath"
    }
}

Write-Output "Running with flags update=$update and work=$work..."

# Powershell
Update-Config-Or-Print-Error -sourcePath .\powershell\Microsoft.PowerShell_profile.ps1 -configPath $profile

# Setup PSGallery if needed
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
}

# Scoop
if ((Get-ExecutionPolicy).ToLower -ne "RemoteSigned") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}

Install-If-Not-Installed -provides scoop -installScript {
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}

Install-If-Not-Installed -provides Invoke-ZLocation -installScript {
    Install-Module -Name ZLocation -Force
}

# starship
Install-If-Not-Installed -provides starship -installScript {
    scoop install starship
}

Update-Config-Or-Print-Error -sourcePath .\starship\starship.toml -configPath  "$env:USERPROFILE\.config\starship.toml"

# Git
$gitConfigUser = if ($work) {
    Get-Content -Path .\git\gitconfig-work -Encoding UTF8
}
else {
    @()
}

$gitConfigCommon = Get-Content -Path .\git\gitconfig-common -Encoding UTF8

$gitConfigContent = $gitConfigUser + $gitConfigCommon

Update-Config-Or-Print-Error `
    -content ($gitConfigContent -join "`r`n") `
    -configPath "$env:USERPROFILE\.gitconfig"

Install-If-Not-Installed -provides git -installScript {
    scoop install git
}
