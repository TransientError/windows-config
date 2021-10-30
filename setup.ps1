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

function Is-Administrator {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

$REGISTRY_ROOTS = @{
    HKEY_CLASSES_ROOT = "HKCR";
}
function Set-Registry {
    param(
        [string]$root,
        [string]$program,
        [string]$key,
        [string]$value
    )

    if (Is-Administrator) {
        $driveRoot = $REGISTRY_ROOTS.$root
        if (!(Test-Path $driveRoot)) {
            Write-Output "Setting $root to $driveRoot"
            New-PSDrive -PSProvider registry -Root $root -Name $driveRoot
        }
        if (!(Test-Path -LiteralPath $key)) {
            Write-Output "Setting registry keys for $program context menu"
            New-Item $key -Value $value -Force
        } else {
            Write-Error "$program registry keys already set"
        }
    } else {
        Write-Output "Run as adminstrator to install $program context menu"
    }
}


$startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

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
    scoop bucket add extras
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

# komorebi
Install-If-Not-Installed -provides komorebi -installScript {
  scoop bucket add komorebi https://github.com/LGUG2Z/komorebi-bucket
  scoop install komorebi
}

Update-Config-Or-Print-Error -content komorebi\komorebi.ahk -configPath $startup\komorebi.ahk

# neovim
Install-If-Not-Installed -provides nvim -installScript {
    scoop install neovim
}

Update-Config-Or-Print-Error -content .\neovim\init.vim -configPath $env:USERPROFILE\AppData\Local\nvim\init.vim

# neovide
Install-If-Not-Installed -provides neovide -installScript {
    scoop install neovide
}


Set-Registry -root HKEY_CLASSES_ROOT `
    -program neovide `
    -key HKCR:`*\shell\"Open With Neovide" `
    -value "$env:USERPROFILE\scoop\shims\less.exe"

# less
Install-If-Not-Installed -provides less -installScript {
    scoop install less
}

Set-Registry -root HKEY_CLASSES_ROOT `
    -program less `
    -key HKCR:`*\shell\"Open with less"\command -value "$env:USERPROFILE\scoop\shims\less.exe %1"
