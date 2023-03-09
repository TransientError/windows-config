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
        Invoke-Command -ScriptBlock $installScript
    } else {
        if ($provides) {
            Write-Host "$provides is already installed"
            Write-Host (Get-Command $provides)
        } elseif ($providesPath) {
            Write-Host "$providesPath is already installed"
        } elseif ($capability) {
            Write-Host "$capability is already installed"
        }
    }
}

function Backup-File-And-Write {
    param(
        [string]$ext, 
        [ValidateSet($null, $true, $false)]
        [object] $exists,
        [string] $configPath,
        [scriptblock] $writeBlock
    )

    if ($null -eq $exists) {
        $exists = Test-Path $configPath -ErrorAction SilentlyContinue
    }

    if ($exists) {
        $backupPath = $configPath + "." + $ext
        Write-Output "Backing up $configPath to $backupPath"
        Move-Item -path $configPath -destination $backupPath -force
    }
    Invoke-Command -ScriptBlock $writeBlock
}


function Update-Config-Or-Print-Error {
    param(
        [string]$sourcePath,
        [string]$content,
        [Parameter(Mandatory = $true)]
        [string]$configPath
    )
    $sourcePathName = (split-path $configPath -Leaf)
    
    $configExists = Test-Path $configPath -ErrorAction SilentlyContinue
    if ($update -or -not $configExists) {
        Write-Output "Updating $sourcePathName..."

        if ($sourcePath) {
            Write-Output "copying $sourcePath to $configPath..."
            Backup-File-And-Write -ext "bck" -exists $configExists -configPath $configPath -writeBlock {
                New-Item -path $configPath -type file -force
                Copy-Item -path $sourcePath -destination $configPath -recurse -force
            }
        }
        elseif ($content) {
            Write-Output "writing $content to $configPath"
            Backup-File-And-Write -ext "bck" -exists $configExists -configPath $configPath -writeBlock {
                Out-File -InputObject $content -FilePath (New-Item -Path $configPath -force) -Encoding UTF8            
            }
        }
        else {
            Write-Error "No source file or content specified"
        }
    }
    elseif (-not $update) {
        Write-Error "$sourcePathName already exists at $configPath"
    }
}

function Recursive-Update-Config {
    param(
        [string]$sourcePath,
        [string]$targetPath
    )
    Push-Location $sourcePath
    foreach ($file in (Get-ChildItem -Recurse -Attributes !Directory)) {
        $relativeFile = Resolve-Path -path $file -Relative
        $targetFile = join-path -path $targetPath -childpath $relativeFile
        $targetDir = split-path -path $targetFile 
        if (-not (test-path $targetDir)) {
            mkdir $targetDir
        }
        Update-Config-Or-Print-Error -sourcePath $file -configPath $targetFile
    }
    Pop-Location
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
        [string]$program,
        [scriptblock]$block
    )
    if (($programs.Count -eq 0) -or ($programs -Contains $program)) {
        Write-Output "Checking $program"
        Invoke-Command -ScriptBlock $block
        Write-Output "$program installed"
    }
}


$startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

Write-Output "Running with flags update=$update and work=$work..."

Do-Program -program "scoop" -block {
    if ((Get-ExecutionPolicy) -ne "RemoteSigned") {
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    }

    Install-If-Not-Installed -program scoop -provides scoop -installScript {
        Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
        scoop bucket add extras
        scoop config shim kiennq
    }
}

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

Do-Program -program "starship" -block {
    Install-If-Not-Installed -program starship -provides starship -installScript {
        scoop install starship
    }

    Update-Config-Or-Print-Error -sourcePath .\starship\starship.toml -configPath  "$env:USERPROFILE\.config\starship.toml"
}

Do-Program -program "zoxide" -block {
    Install-If-Not-Installed -program zoxide -provides zoxide -installScript {
        scoop install zoxide
    }
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

    Update-Config-Or-Print-Error -sourcePath .\git\ignore -configPath "$env:USERPROFILE\gitignore_global"

    Install-If-Not-Installed -program git -provides git -installScript {
        scoop install git
    }
}

Do-Program -program "komorebi" -block {
    Install-If-Not-Installed -program komorebi -provides komorebi -installScript {
        scoop bucket add komorebi https://github.com/LGUG2Z/komorebi-bucket
        scoop install komorebi
    }

    Update-Config-Or-Print-Error -sourcePath komorebi\komorebi.ps1 -configPath $env:USERPROFILE\komorebi.ps1
}

Do-Program -program "neovim" -block {
    Install-If-Not-Installed -program neovim -provides nvim -installScript {
        scoop install neovim
	git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"
    }
    Recursive-Update-Config -sourcePath "neovim" -targetPath "$env:USERPROFILE\AppData\Local\nvim"
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
    Install-If-Not-Installed `
        -program chrome `
        -providesPath "C:\Program Files\Google\Chrome\Application\chrome.exe" `
        -installScript {
            scoop install googlechrome
        }
}

Do-Program -program "firefox" -block {
    Install-If-Not-Installed `
        -program firefox `
        -providesPath "C:\Program Files\Mozilla Firefox\firefox.exe" `
        -installScript {
            scoop install firefox
        }
}

Do-Program -program "vscode" -block {
    Install-If-Not-Installed -provides code -program vscode -installScript {
        scoop install vscode
    }
}

Do-Program -program "windows-terminal" -block {
    Install-If-Not-Installed `
    -program "windows-terminal" `
    -providesPath wt
    -installScript {
        if (Test-Administrator) {
            scoop install -g windows-terminal
        }
    }

    # Update-Config-Or-Print-Error `
    #     -sourcePath windows-terminal\settings.json `
    #     -configPath "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
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

Do-Program -program "whkd" -block {
  Install-If-Not-Installed -program "whkd" -providesPath whkd -installScript {
      scoop install whkd
  }

  Update-Config-Or-Print-Error -sourcePath whkd\whkdrc -configPath $env:USERPROFILE\.config\whkdrc
}

Do-Program -program "stylua" -block {
  Install-If-Not-Installed -program "stylua" -providesPath stylua -installScript {
    scoop install stylua
  }

  Update-Config-Or-Print-Error -sourcePath stylua\stylua.toml -configPath $env:USERPROFILE\.config\stylua.toml
}
