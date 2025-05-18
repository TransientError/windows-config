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

$solutionPackagerPath = 'C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.CrmSdk.CoreTools.9.1.0.92\content\bin\coretools\SolutionPackager.exe'
if (Test-Path($solutionPackagerPath)) {
  Set-Alias -Name SolutionPackager -Value $solutionPackagerPath
}

Set-Alias -Name devenv -Value 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell'
Set-Alias -Name trash -Value "$env:USERPROFILE\utils\windows-config\scripts\trash.ps1"
function config { git --git-dir=$env:USERPROFILE\utils\windows-config\.git --work-tree=$env:USERPROFILE $args}
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
