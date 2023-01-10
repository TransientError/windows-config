param([switch] $extensions = $true)

if ($extensions) {
    $vsRootLegacy = "C:\Program Files (x86)\Microsoft Visual Studio\"
    $vsRoot = "C:\Program Files\Microsoft Visual Studio\"

    $installations = (Get-ChildItem $vsRootLegacy) + (Get-ChildItem $vsRoot) | Where-Object BaseName -Match '\d{4}'

    $versionsToExtensions = @{
        "2019" = @(
            "VsVim",
            "PeasyMotion",
            "ToggleComment",
            "Csharpier2019",
            "StyleCop",
            "ProjectFilter1",
            "GitWebLinks",
            "Viasfora4.3");
        "2022" = @(
            "VsVim2022Preview", 
            "PeasyMotion2022", 
            "ToggleComment", 
            "Csharpier2019", 
            "StyleCop", 
            "ProjectFilter", 
            "GitWebLinksForVisualStudio",
            "copilotvs",
            "Viasfora",
            "MaterialTheme",
            "EditorGuidelinesPreview"
        );
    };

    $extensionsToPublisher = @{
        "VsVim"                      = "JaredParMSFT";
        "VsVim2022Preview"           = "JaredParMSFT";
        "Csharpier2019"              = "csharpier";
        "PeasyMotion"                = "maksim-vorobiev";
        "PeasyMotion2022"            = "maksim-vorobiev";
        "ToggleComment"              = "munyabe";
        "StyleCop"                   = "ChrisDahlberg";
        "ProjectFilter"              = "reduckted";
        "GitWebLinks"                = "reduckted";
        "GitWebLinksForVisualStudio" = "reduckted";
        "copilotvs"                  = "GitHub";
        "Viasfora"                   = "TomasRestrepo";
        "MaterialTheme"              = "Equinusocio.vsc-material-theme";
        "EditorGuidelinesPreview"    = "PaulHarrington";
    }

    $extensionsToUrl = @{
        "ProjectFilter1" = "https://github.com/reduckted/ProjectFilter/releases/download/1.1.1/ProjectFilter.vsix";
        "Viasfora4.3"    = "https://github.com/tomasr/viasfora/releases/download/v4.3/Viasfora.vsix";
    }
    
    $versionsToPath = @{
        "2019" = get-item("C:\Program Files (x86)\Microsoft Visual Studio\2019");
        "2022" = get-item("C:\Program Files\Microsoft Visual Studio\2022");
    }

    function Build-Url($extension) {
        Write-Output "Getting download url for $extension"
        $uri = "https://marketplace.visualstudio.com/items?itemName=$($extensionsToPublisher[$extension]).$extension"
        $webPage = (Invoke-WebRequest -Uri $uri) 

        return ($webPage.Links |
            Where-Object { $_.class -eq "install-button-container" } |
            Select-Object -ExpandProperty href)
    }

    foreach ($installation in $installations) {
        Write-Output "Installing extensions for ${installation}"

        $devenv = Join-Path $installation.FullName "Enterprise\Common7\Tools\Launch-VsDevShell.ps1" # only Entreprise for now
        Invoke-Expression -Command "`"$devenv`""
        $extensions = $versionsToExtensions[$installation.ToString()] # shadowing this variable, sorry I'm lazy
        foreach ($extension in $extensions) {
            $vsixPath = "$extension.vsix"
            if (!(Test-Path $vsixPath)) {
                $url = if ($extensionsToUrl[$extension]) {
                    $extensionsToUrl[$extension]
                }
                else {
                    Build-Url $extension
                }
                Write-Output "Downloading $extension from $url"
                Invoke-WebRequest -Uri $url -OutFile $vsixPath
            }
            else {
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
Copy-Item .vsvimrc $targetPath -Force
