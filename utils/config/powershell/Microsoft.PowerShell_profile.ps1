# Scott's
# https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3?WT.mc_id=-blog-scottha

Invoke-Expression (&starship init powershell)
Set-PsReadlineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
  Get-Content (Get-PSReadlineoption).HistorySavePath | fzf | Invoke-expression
}
Set-PSReadLineKeyHandler -Chord Ctrl+Alt+Shift+f -Function SelectForwardWord
Set-PSReadLineKeyHandler -Chord Ctrl+Alt+Shift+a -Function SelectCommandArgument
Set-PSReadLineKeyHandler -Chord Ctrl+Alt+Shift+x -Function ViEditVisually


# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

$completionPredictorModulePath = "$env:USERPROFILE\utils\CompletionPredictor\bin\CompletionPredictor\CompletionPredictor.psd1"
if (Test-Path($completionPredictorModulePath)) {
  Import-Module $completionPredictorModulePath
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$env:startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
# for some app compatibility...
$env:home = $env:USERPROFILE
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"

# NuGet cache directories on D:
if (Test-Path "D:\") {
  $env:NUGET_PACKAGES = "D:\.nuget\packages"
  $env:NUGET_HTTP_CACHE_PATH = "D:\.nuget\v3-cache"
  $env:NUGET_PLUGINS_CACHE_PATH = "D:\.nuget\plugins-cache"
}

# Use x64 dotnet on ARM machines (credential provider has no ARM64 build)
if ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture -eq 'Arm64' -and (Test-Path "C:\Program Files\dotnet\x64\dotnet.exe")) {
  $env:DOTNET_ROOT = "C:\Program Files\dotnet\x64"
  $env:Path = "C:\Program Files\dotnet\x64;" + ($env:Path -replace [regex]::Escape("C:\Program Files\dotnet\x64;"), "")

  # Enable WAM for NuGet credential provider (replaces deprecated Windows Integrated Auth)
  $env:NUGET_CREDENTIALPROVIDER_MSAL_AUTHORITY = "https://login.microsoftonline.com/common"
  $env:NUGET_CREDENTIALPROVIDER_MSAL_FILECACHE_ENABLED = "true"
  $env:NUGET_CREDENTIALPROVIDER_FORCE_CANSHOWDIALOG_TO = "true"
}

$solutionPackagerPath = 'C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.CrmSdk.CoreTools.9.1.0.92\content\bin\coretools\SolutionPackager.exe'
if (Test-Path($solutionPackagerPath)) {
  Set-Alias -Name SolutionPackager -Value $solutionPackagerPath
}

Set-Alias -Name devenv -Value 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell'
Set-Alias -Name trash -Value "$env:USERPROFILE\utils\windows-config\scripts\trash.ps1"
function config { git --git-dir=$env:USERPROFILE\utils\windows-config\.git --work-tree=$env:USERPROFILE $args}
function lconfig { lazygit --git-dir=$env:USERPROFILE\utils\windows-config\.git --work-tree=$env:USERPROFILE }
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }
    Remove-Item -Path $tmp
}

Invoke-Expression (& { $hook = if ($PSVersionTable.PSVersion.Major -ge 6) { 'pwd' } else { 'prompt' } (zoxide init powershell --hook $hook | Out-String) })

if (-not $env:Path.EndsWith(";")) { $env:Path += ";" }
$env:Path += Join-String -Separator ";" -InputObject @(
  "${env:userprofile}/.dotnet/tools",
  "/Program Files/dotnet/",
  "${env:userprofile}/AppData/Roaming/Programs/Python/Python39/",
  "C:\Program Files\Microsoft\Azure Functions Core Tools",
  "C:\Program Files\GitHub CLI",
  "${env:ALLUSERSPROFILE}\chocolatey\bin",
  "C:\Program Files\nodejs\",
  "${env:appdata}\npm\"
)

# https://github.com/PowerShell/PowerShell/issues/7853
$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'

Import-Module posh-git

function winget-install {
    $preDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
        Get-ChildItem -Filter '*.lnk'
    
    # install WinGet
    winget install $args 

    $postDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
        Get-ChildItem -Filter '*.lnk'    

    # Cleaning up new unwhanted desktop icons
    Write-Host "Cleaning up WinGet created desktop icons..."
    $postDesktop | Where-Object FullName -notin $preDesktop.FullName | Foreach-Object {
        Remove-Item -LiteralPath $_.FullName
        Write-Host "Cleaned up $($_.Name)" -ForegroundColor DarkGray
    }
}

function winget-safe-update {
    & "$env:USERPROFILE\utils\config\scripts\winget-safe-update.ps1" @args
}

function winget-upgrade {
    $preDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
        Get-ChildItem -Filter '*.lnk'
    
    # Update WinGet
    winget upgrade $args

    $postDesktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
        Get-ChildItem -Filter '*.lnk'    

    # Cleaning up new unwhanted desktop icons
    Write-Host "Cleaning up WinGet created desktop icons..."
    $postDesktop | Where-Object FullName -notin $preDesktop.FullName | Foreach-Object {
        Remove-Item -LiteralPath $_.FullName
        Write-Host "Cleaned up $($_.Name)" -ForegroundColor DarkGray
    }
}

function gs {
    param(
        [string]$RepoUrl
    )
    
    # Extract repo name from URL
    $repoName = $RepoUrl -replace '.*[/:]([^/]+)(?:\.git)?/?$', '$1'
    
    New-Item -ItemType Directory -Path $repoName
    git clone --bare $RepoUrl "$repoName\$repoName.git"
    
    $defaultBranch = git --git-dir="$repoName\$repoName.git" symbolic-ref refs/remotes/origin/HEAD | ForEach-Object { $_ -replace 'refs/remotes/origin/', '' }
    
    $normalizedBranch = $defaultBranch -replace '/', '-'
    
    git --git-dir="$repoName\$repoName.git" worktree add "$repoName\$normalizedBranch" $defaultBranch
}

function gc {
    param(
        [string]$RepoPath
    )
    
    if ($RepoPath) {
        # Handle passed repo path
        $gitDir = "$RepoPath.git"
        Move-Item -Path $RepoPath -Destination $gitDir
        New-Item -ItemType Directory -Path $RepoPath
        Move-Item -Path "$gitDir\.git" -Destination "$RepoPath\$RepoPath.git"
        Set-Location -Path $RepoPath
        $currentBranch = git --git-dir="$RepoPath\$RepoPath.git" branch --show-current
        git --git-dir="$RepoPath\$RepoPath.git" config core.bare true
        git --git-dir="$RepoPath\$RepoPath.git" worktree add $currentBranch
    } else {
        # Handle current directory as repo
        $repoName = Split-Path -Leaf (Get-Location)
        $currentBranch = git branch --show-current
        Move-Item -Path ".git" -Destination "$repoName.git"
        git --git-dir="$repoName.git" config core.bare true
        git --git-dir="$repoName.git" worktree add $currentBranch
    }
}

function add-remote-branch {
    param(
        [string]$Remote,
        [string]$Branch
    )
    
    if (-not $Remote -or -not $Branch) {
        Write-Host "Usage: add-remote-branch <remote> <branch>"
        return
    }
    
    # Check if the remote branch exists
    $remoteBranches = git ls-remote --heads $Remote 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Could not connect to remote '$Remote'" -ForegroundColor Red
        return
    }
    
    $branchExists = $remoteBranches | Where-Object { $_ -match "refs/heads/$Branch$" }
    if (-not $branchExists) {
        Write-Host "Error: Branch '$Branch' does not exist on remote '$Remote'" -ForegroundColor Red
        return
    }
    
    Write-Host "Found branch '$Branch' on remote '$Remote', adding..." -ForegroundColor Green

    git config --add "remote.$Remote.fetch" "+refs/heads/$Branch`:refs/remotes/$Remote/$Branch"
    git fetch $Remote $Branch
}

function cleanup-remote-branches {
    param(
        [string]$Remote
    )

    $remotes = if ($Remote) { @($Remote) } else { @(git remote 2>$null) }
    if (-not $remotes) {
        Write-Host "No remotes found" -ForegroundColor Red
        return
    }

    $totalCleaned = 0
    foreach ($r in $remotes) {
        $fetchSpecs = @(git config --get-all "remote.$r.fetch" 2>$null)
        if (-not $fetchSpecs) { continue }

        $remoteBranches = git ls-remote --heads $r 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Could not connect to remote '$r', skipping" -ForegroundColor Yellow
            continue
        }

        $existingBranches = @($remoteBranches | ForEach-Object {
            if ($_ -match 'refs/heads/(.+)$') { $Matches[1] }
        })

        foreach ($spec in $fetchSpecs) {
            if ($spec -match '\*') { continue }
            if ($spec -match '\+?refs/heads/(.+):') {
                $branch = $Matches[1]
                if ($branch -notin $existingBranches) {
                    Write-Host "Removing stale refspec: $r/$branch" -ForegroundColor Yellow
                    git config --fixed-value --unset "remote.$r.fetch" $spec
                    $totalCleaned++
                }
            }
        }

        # Prune stale remote tracking refs
        git remote prune $r 2>$null
    }

    if ($totalCleaned -eq 0) {
        Write-Host "No stale branch refspecs found" -ForegroundColor Green
    } else {
        Write-Host "Cleaned up $totalCleaned stale refspec(s)" -ForegroundColor Green
    }
}

function scoop-safe-update {
    & "$env:USERPROFILE\utils\config\scripts\scoop-safe-update.ps1" @args
}

function nuget-auth {
    $token = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query accessToken -o tsv
    if (-not $token) { Write-Host "Failed to get token. Run 'az login' first." -ForegroundColor Red; return }
    $env:VSS_NUGET_EXTERNAL_FEED_ENDPOINTS = '{"endpointCredentials":[{"endpoint":"https://pkgs.dev.azure.com/dynamicscrm/OneCRM/_packaging/SXG-ICon-CRiBS/nuget/v3/index.json","username":"az","password":"' + $token + '"}]}'
    $env:Path = "C:\Program Files\dotnet\x64;" + ($env:Path -replace [regex]::Escape("C:\Program Files\dotnet\x64;"), "")
    $env:DOTNET_ROOT = "C:\Program Files\dotnet\x64"
    $env:HUSKY = "0"
    Write-Host "NuGet auth configured. Token expires in ~1 hour." -ForegroundColor Green
}
