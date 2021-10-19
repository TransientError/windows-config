param([bool]$update = $false, [bool]$work = $false)

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
        [string]$content,
        [string]$configPath
    )
    
    if ($update -or -not (Test-Path $configPath)) {
        if ($sourcePath) {
            Copy-Item $sourcePath $configPath -Force
        }
        elseif ($content) {
            Out-File $content -FilePath $configPath -Encoding UTF8            
        }
        else {
            Write-Error "No source file or content specified"
        }
    }
    elseif (-not $update) {
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

# Git
$gitConfigUser = if ($work) {
    Get-Content -Path .\git\gitconfig.work -Encoding UTF8
}
else {
    ""
}

$gitConfigCommon = Get-Content -Path .\git\gitconfig.common -Encoding UTF8

Update-Config-Or-Print-Error -content "$gitConfigUser\n$gitConfigCommon" -configPath "$env:USERPROFILE\.gitconfig"

Install-If-Not-Installed -packageName git -installScript {
    scoop install git
}
