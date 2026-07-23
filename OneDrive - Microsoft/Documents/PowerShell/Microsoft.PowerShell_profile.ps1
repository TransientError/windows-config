# Scott's
# https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3?WT.mc_id=-blog-scottha

if ($env:COMPUTERNAME -notin @('CPC-wukev-VZQ8I')) {
  Invoke-Expression (&starship init powershell)
} else {
  oh-my-posh init powershell --config "$env:USERPROFILE\.spaceship.omp.json" | Invoke-Expression
}
$env:EDITOR = "nvim"

Set-PsReadlineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
  Get-Content (Get-PSReadlineoption).HistorySavePath | fzf | Invoke-expression
}
Set-PSReadLineKeyHandler -Chord Alt+RightArrow -Function SelectForwardWord
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

# Native arm64 dotnet (C:\Program Files\dotnet) is the default. The NuGet artifacts
# credential provider auths ADO feeds via the arm64 MSAL broker on its own defaults --
# no authority override needed. (Do NOT force authority to /common: under the arm64
# broker the ADO token-exchange grant is rejected with AADSTS9001023, which breaks
# `dotnet tool restore` / the Husky target.)


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
    <#
    .SYNOPSIS
        Clone a repo as bare + worktree under D:\work.
    .DESCRIPTION
        Sets up a bare-clone + worktree layout:
          <name>\
            <name>-git\   (bare clone)
            .git          (file pointing to <name>-git)
            <branch>\     (worktree for the default branch)

        By default <name> is derived from the URL (e.g. "KnowMe" from the repo URL).
        Pass -Name to override it (e.g. -Name km).
    .EXAMPLE
        gs https://dynamicscrm.visualstudio.com/OneCRM/_git/KnowMe
        # creates KnowMe\KnowMe-git, KnowMe\.git, and KnowMe\main

        gs https://dynamicscrm.visualstudio.com/OneCRM/_git/KnowMe -Name km
        # creates km\km-git, km\.git, and km\main

        gs https://github.com/org/repo.git km
        # positional shorthand — same as -Name km
    #>
    param(
        [Parameter(Position = 0)]
        [string]$RepoUrl,

        [Parameter(Position = 1)]
        [Alias("n")]
        [string]$Name,

        [Alias("h")]
        [switch]$Help
    )

    if ($Help -or -not $RepoUrl) {
        Write-Host @"
gs - Git Setup (bare clone + worktree)

Usage:
  gs <repo-url> [<name>]        Clone repo with optional custom directory name
  gs <repo-url> -Name <name>    Same, using named parameter
  gs -Help                      Show this help

Arguments:
  <repo-url>   Git remote URL (HTTPS or SSH)
  <name>       Custom directory name (default: derived from URL)

Examples:
  gs https://dynamicscrm.visualstudio.com/OneCRM/_git/KnowMe
      -> KnowMe\KnowMe-git + KnowMe\.git + KnowMe\main

  gs https://dynamicscrm.visualstudio.com/OneCRM/_git/KnowMe km
      -> km\km-git + km\.git + km\main

  gs https://github.com/org/my-repo.git -Name myrepo
      -> myrepo\myrepo-git + myrepo\.git + myrepo\main
"@ -ForegroundColor Cyan
        return
    }

    $repoName = if ($Name) { $Name } else { $RepoUrl -replace '.*[/:]([^/]+)(?:\.git)?/?$', '$1' }

    New-Item -ItemType Directory -Path $repoName
    git clone --bare $RepoUrl "$repoName\$repoName-git"
    
    # Create .git pointer file so tools recognize the parent as a repo root
    Set-Content -Path "$repoName\.git" -Value "gitdir: ./$repoName-git" -NoNewline
    
    # Configure fetch refspec for all branches
    git --git-dir="$repoName\$repoName-git" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git --git-dir="$repoName\$repoName-git" fetch origin
    
    $defaultBranch = git --git-dir="$repoName\$repoName-git" symbolic-ref refs/remotes/origin/HEAD | ForEach-Object { $_ -replace 'refs/remotes/origin/', '' }
    
    $normalizedBranch = $defaultBranch -replace '/', '-'
    
    git --git-dir="$repoName\$repoName-git" worktree add "$repoName\$normalizedBranch" $defaultBranch
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

function Pick-Reviewer {
    & "$env:USERPROFILE\OneDrive - Microsoft\Pick-Reviewer.ps1" @args
}

function sug {
  $prompt = $args -join ' '
  copilot --model "claude-sonnet-4.6" -p $prompt
}

function pr-worktree {
    param(
        [Parameter(Mandatory)]
        [string]$PrUrl,
        [string]$Name
    )

    # Extract PR ID from URL or use as-is if numeric
    $prId = if ($PrUrl -match '/pullrequest/(\d+)') { $Matches[1] } elseif ($PrUrl -match '^\d+$') { $PrUrl } else {
        Write-Host "Could not parse PR ID from: $PrUrl" -ForegroundColor Red; return
    }

    # Extract org/project/repo from URL for az CLI context
    $org = $null; $project = $null; $repo = $null
    if ($PrUrl -match 'dev\.azure\.com/([^/]+)/([^/]+)/_git/([^/]+)') {
        $org = "https://dev.azure.com/$($Matches[1])"; $project = $Matches[2]; $repo = $Matches[3]
    } elseif ($PrUrl -match '([^/]+)\.visualstudio\.com.*/([^/]+)/_git/([^/]+)') {
        $org = "https://dev.azure.com/$($Matches[1])"; $project = $Matches[2]; $repo = $Matches[3]
    }

    # Get PR source branch and title
    $azArgs = @("repos", "pr", "show", "--id", $prId, "--query", "[sourceRefName, title]", "-o", "tsv")
    if ($org) { $azArgs += @("--org", $org) }
    $prInfo = az @azArgs 2>$null
    if (-not $prInfo) {
        Write-Host "Failed to get PR #$prId details. Ensure 'az devops' is configured." -ForegroundColor Red; return
    }
    $lines = $prInfo -split "`n"
    $sourceRef = $lines[0].Trim()
    $prTitle = $lines[1].Trim()
    $branch = $sourceRef -replace '^refs/heads/', ''

    # Find the bare git dir — works from parent dir or inside a worktree
    $gitDir = $null
    # First check if we're inside a worktree already
    $commonDir = git rev-parse --git-common-dir 2>$null
    if ($LASTEXITCODE -eq 0 -and $commonDir) {
        $gitDir = (Resolve-Path $commonDir).Path
    }
    # Otherwise scan current directory for a *-git or *.git bare repo
    if (-not $gitDir) {
        $gitDir = Get-ChildItem -Path (Get-Location) -Directory | Where-Object {
            ($_.Name -match '[-.]git$') -and
            (git --git-dir=$_.FullName rev-parse --is-bare-repository 2>$null) -eq 'true'
        } | Select-Object -First 1 -ExpandProperty FullName
    }

    if (-not $gitDir) {
        Write-Host "No bare git repo found in current directory or parent worktree" -ForegroundColor Red; return
    }

    $worktreeRoot = Split-Path $gitDir -Parent

    # Determine worktree name from PR title
    $worktreeName = if ($Name) { $Name } else {
        $slug = $prTitle.ToLower() -replace '[^a-z0-9\s-]', '' -replace '\s+', '-' -replace '-+', '-' -replace '^-|-$', ''
        if ($slug.Length -gt 50) { $slug = $slug.Substring(0, 50) -replace '-$', '' }
        "pr-$prId-$slug"
    }
    $worktreePath = Join-Path $worktreeRoot $worktreeName

    if (Test-Path $worktreePath) {
        Write-Host "Worktree path '$worktreeName' already exists" -ForegroundColor Yellow; return
    }

    # Add branch refspec and fetch
    Write-Host "Fetching branch '$branch'..." -ForegroundColor Cyan
    git --git-dir=$gitDir config --add "remote.origin.fetch" "+refs/heads/$branch`:refs/remotes/origin/$branch"
    git --git-dir=$gitDir fetch origin $branch

    # Create worktree
    Write-Host "Creating worktree '$worktreeName' on branch '$branch'..." -ForegroundColor Cyan
    git --git-dir=$gitDir worktree add $worktreePath $branch

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Done! Worktree at: $worktreePath" -ForegroundColor Green
        Set-Location $worktreePath
    }
}

