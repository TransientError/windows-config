param (
  [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
  [string[]] $path
)

Add-Type -AssemblyName Microsoft.VisualBasic
[Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
