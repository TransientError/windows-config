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

$solutionPackagerPath = 'C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.CrmSdk.CoreTools.9.1.0.92\content\bin\coretools\SolutionPackager.exe'
if (Test-Path($solutionPackagerPath)) {
  Set-Alias -Name SolutionPackager -Value $solutionPackagerPath
}

Set-Alias -Name devenv -Value 'C:\Program Files\Microsoft Visual Studio\2022\Enterprise\Common7\Tools\Launch-VsDevShell'
Set-Alias -Name trash -Value Remove-ItemSafely

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

<<<<<<< Updated upstream
# https://github.com/PowerShell/PowerShell/issues/7853
$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'
||||||| Stash base
=======
Import-Module posh-git
>>>>>>> Stashed changes
