param([switch] $extensions=$true)

if ($extensions) {
    $vsRootLegacy = "C:\Program Files (x86)\Microsoft Visual Studio\"
    $vsRoot = "C:\Program Files\Microsoft Visual Studio\"

    $installations = (Get-ChildItem $vsRootLegacy) + (Get-ChildItem $vsRoot)

    $versionsToExtensions = @{
        2019 = @("VsVim", "PeasyMotion", "ToggleComment", "Csharpier2019", "StyleCop");
        2022 = @("VsVim2022Preview", "PeasyMotion2022", "ToggleComment", "Csharpier2019", "StyleCop");
    };

    $extensionsToPublisher = @{
        "VsVim" = "JaredParMSFT";
        "VsVim2022Preview" = "JaredParMSFT";
        "Csharpier2019" = "csharpier";
        "PeasyMotion" = "maksim-vorobiev";
        "PeasyMotion2022" = "maksim-vorobiev";
        "ToggleComment" = "munyabe";
        "StyleCop" = "ChrisDahlberg";
    }

    function Build-Url($extension) {
        Write-Output "Getting download url for $extension"
        $webPage = (Invoke-WebRequest 
            -Uri "https://marketplace.visualstudio.com/items?itemName=$($extensionsToPublisher[$extension]).$extension") 

        return ($webPage.Links |
            Where-Object { $_.class -eq "install-button-container" } |
            Select-Object -ExpandProperty href)
    }

    foreach ($installation in $installations) {
        Write-Output "Installing extensions for ${installation.Basename}"

        $devenv = Join-Path $installation "Entreprise\Common7\IDE\devenv.exe" # only Entreprise for now
        Invoke-Expression -Command $devenv
        $extensions = $versionsToExtensions[$installation] # shadowing this variable, sorry I'm lazy
        foreach ($extension in $extensions) {
            $vsixPath = $extension.vsix
            if (!(Test-Path $vsixPath)) {
                $url = Build-Url $extension
                Write-Output "Downloading $extension from $url"
                Invoke-WebRequest -Uri $url -OutFile $vsixPath
            } else {
                Write-Output "Using existing $vsixPath"
            }
            Write-Output "Installing $extension"
            VSIXInstaller.exe /q $vsixPath
        }
    }
}

Write-Output "Installing vsvimrc"
$targetPath = Join-Path $env:USERPROFILE ".vsvimrc"
if (Test-Path $targetPath) {
    Write-Output "Found existing vsvimrc, backing up to vsvimrc.bak"
    Rename-Item $targetPath $targetPath.bak
}
Move-Item .vsvimrc $targetPath -Force
