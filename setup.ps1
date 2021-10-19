param([bool]$update = $false)

function Install-If-Not-Installed {
    param(
        [string]$packageName,
        [scriptblock]$installScript
    )

    if (-not (Get-Command $packageName -ErrorAction SilentlyContinue)) {
        $installScript.Invoke()
    }
}

function Update-Config-Or-Print-Error {
    param(
        [string]$sourcePath,
        [string]$configPath
    )
    
    if ($update -or -not (Test-Path $configPath)) {
        Copy-Item $sourcePath $configPath -Force
    } elseif (-not $update) {
        Write-Error "${(Get-Item $sourcePath).Basename} already exists at $configPath"
    }
}

# Powershell
Copy-Item -Path .\powershell\Microsoft.PowerShell_profile.ps1 -Destination $profile

# Setup PSGallery if needed
if ((Get-PSPRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Force
}

# Scoop
if ((Get-ExecutionPolicy).ToLower -ne "RemoteSigned") {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}

Install-If-Not-Installed -packageName scoop -installScript {
    Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
}

Install-If-Not-Installed -packageName ZLocation -installScript {
    Install-Module -Name ZLocation -Force
}

# starship
Install-If-Not-Installed -packageName starship -installScript {
    scoop install starship
}

Update-Config-Or-Print-Error -sourcePath .\starship\starship.toml -configPath  "$env:USERPROFILE\.config\starship.toml"
