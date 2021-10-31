param([switch]$update = $false, [switch]$work = $false, [string[]]$programs = @())

function Test-Administrator {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-Capability {
    param([string]$capabilityName)

    if (Test-Administrator) {
        $capability = Get-WindowsCapability -Online | Where-Object Name -Like "$capabilityName*"
        return $capability.State -eq "Installed"
    } else {
        Write-Error "Can't test capability without admin, defaulting to true"
        return $true   
    }
}

function Install-If-Not-Installed {
    param(
        [string]$provides,
        [string]$providesPath,
        [string]$capability,
        [scriptblock]$installScript,
        [switch]$admin,
        [string]$program
    )

    if (($provides -and -not (Get-Command $provides -ErrorAction SilentlyContinue)) -or `
        ($providesPath -and -not (Test-Path $providesPath -ErrorAction SilentlyContinue)) -or `
        ($capability -and -not (Test-Capability $capability))) {
        if ($admin -and !(Test-Administrator)) {
            Write-Error "Can't install $program without admin"
            return
        }
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
            Write-Output "copying $sourcePath to $configPath..."
            Copy-Item $sourcePath $configPath -Force
        }
        elseif ($content) {
            Write-Output "writing $content to $configPath"
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

    if (Test-Administrator) {
        $driveRoot = $REGISTRY_ROOTS.$root
        if (!(Test-Path $driveRoot)) {
            Write-Output "Setting $root to $driveRoot"
            New-PSDrive -PSProvider registry -Root $root -Name $driveRoot
        }
        if ($update -or !(Test-Path -LiteralPath $key)) {
            Write-Output "Setting registry keys for $program context menu"
            New-Item $key -Value $value -Force
        }
        else {
            Write-Error "$program registry keys already set"
        }
    }
    else {
        Write-Output "Run as adminstrator to install $program context menu"
    }
}

Write-Output $programs
function Do-Program {
    param(
        [scriptblock]$block,
        [string]$program
    )
    if (($programs.Count -eq 0) -or ($programs -Contains $program)) {
        Write-Output "Installing $program"
        $block.Invoke()
        Write-Output "$program installed"
    }
}


$startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

Write-Output "Running with flags update=$update and work=$work..."

Do-Program -program "powershell" -block {
    Install-If-Not-Installed -program "powershell 7" -provides pwsh -installScript {
        scoop install pwsh
    }

    Update-Config-Or-Print-Error -sourcePath .\powershell\Microsoft.PowerShell_profile.ps1 -configPath $profile

    # Setup PSGallery if needed
    if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne "Trusted") {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted 
    }
}

Do-Program -program "scoop" -block {
    if ((Get-ExecutionPolicy).ToLower -ne "RemoteSigned") {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    }

    Install-If-Not-Installed -program scoop -provides scoop -installScript {
        Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
        scoop bucket add extras
        scoop config kiennq
    }
}

Do-Program -program "zlocation" -block {
    Install-If-Not-Installed -program zlocation -provides Invoke-ZLocation -installScript {
        Install-Module -Name ZLocation -Force
    }
}

Do-Program -program "starship" -block {
    Install-If-Not-Installed -program starship -provides starship -installScript {
        scoop install starship
    }

    Update-Config-Or-Print-Error -sourcePath .\starship\starship.toml -configPath  "$env:USERPROFILE\.config\starship.toml"
}

Do-Program -program "git" -block {
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

    Install-If-Not-Installed -program git -provides git -installScript {
        scoop install git
    }
}

Do-Program -program "komorebi" -block {
    Install-If-Not-Installed -program komorebi -provides komorebi -installScript {
        scoop bucket add komorebi https://github.com/LGUG2Z/komorebi-bucket
        scoop install komorebi
    }

    Update-Config-Or-Print-Error -sourcePath komorebi\komorebi.ahk -configPath $startup\komorebi.ahk
}

Do-Program -program "neovim" -block {
    Install-If-Not-Installed -program neovim -provides nvim -installScript {
        scoop install neovim
    }

    Update-Config-Or-Print-Error -content .\neovim\init.vim -configPath $env:USERPROFILE\AppData\Local\nvim\init.vim
}

Do-Program -program "neovide" -block {
    Install-If-Not-Installed -program neovide -provides neovide -installScript {
        scoop install neovide
    }


    Set-Registry -root HKEY_CLASSES_ROOT `
        -program neovide `
        -key HKCR:`*\shell\"Open With Neovide"\command `
        -value "$env:USERPROFILE\scoop\shims\neovide.exe `"%1`""
}

Do-Program -program "less" -block {
    Install-If-Not-Installed -program less -provides less -installScript {
        scoop install less
    }

    Set-Registry -root HKEY_CLASSES_ROOT `
        -program less `
        -key HKCR:`*\shell\"Open with less"\command `
        -value "$env:USERPROFILE\scoop\shims\less.exe `"%1`""
}

Do-Program -program "chrome" -block {
    Install-If-Not-Installed $
        -program chrome `
        -providesPath "C:\Program Files\Google\Chrome\Application\chrome.exe" `
        -installScript {
            scoop install googlechrome
        }
}

Do-Program -program "vscode" -block {
    Install-If-Not-Installed -provides code -program vscode -installScript {
        scoop install vscode
    }
}

Do-Program -program "windows-terminal" -block {
    Install-If-Not-Installed `
    -program "windows-terminal"
    -providesPath "$env:USERPROFILE\windows-store-shortcuts\Windows Terminal.lnk" `
    -installScript {
        scoop install windows-terminal
    }

    Update-Config-Or-Print-Error `
        -sourcePath windows-terminal\settings.json `
        -configPath $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
}

Do-Program -program "startup" -block {
    Update-Config-Or-Print-Error -sourcePath .\startup\startup.ahk -configPath $startup\startup.ahk
}

Do-Program -program "ssh" -block {
    Install-If-Not-Installed -capability "OpenSSH.Client" -admin -program "ssh" -installScript {
        Add-WindowsCapability -CapabilityName "OpenSSH.Client"
    }
    Install-If-Not-Installed -capability "OpenSSH.Server" -admin -program "ssh" -installScript {
        Add-WindowsCapability -CapabilityName "OpenSSH.Server"
        Set-Service -Name sshd -StartupType Automatic
    }
}