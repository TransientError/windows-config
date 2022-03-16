# Scott's
# https://gist.github.com/shanselman/25f5550ad186189e0e68916c6d7f44c3?WT.mc_id=-blog-scottha

Invoke-Expression (&starship init powershell)
Set-PsReadlineOption -predictionsource history
Set-PsReadlineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
  Get-Content (Get-PSReadlineoption).HistorySavePath | fzf | Invoke-expression
}


# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$env:startup = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

$solutionPackagerPath = 'C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.CrmSdk.CoreTools.9.1.0.92\content\bin\coretools\SolutionPackager.exe'
if (Test-Path($solutionPackagerPath)) {
  Set-Alias -Name SolutionPackager -Value $solutionPackagerPath
}

Set-Alias -Name start-komorebi -Value 'C:\Users\wukevin\utils\komorebic-scripts\start-komorebic.ps1'

Invoke-Expression (& { $hook = if ($PSVersionTable.PSVersion.Major -ge 6) { 'pwd' } else { 'prompt' } (zoxide init powershell --hook $hook | Out-String) })

$env:Path += (
  ";${env:userprofile}/.dotnet/tools" +
  ";/Program Files/dotnet/" +
  ";${env:userprofile}/AppData/Local/Programs/Python/Python39/" +
  ";C:\Program Files\Microsoft\Azure Functions Core Tools" +
  ";C:\Program Files\GitHub CLI"
)

