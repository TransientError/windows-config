# To be used with task scheduler
$now = Get-Date
$offset = 30
$offsetAgo = $now.AddDays(-1 * $offset)
$paths = @('C:\Users\wukevin\OneDrive - Microsoft\Pictures\Screenshots')

foreach ($path in $paths) {
  foreach ($file in (Get-ChildItem $path)) {
    if ($file.LastWriteTime -lt $offsetAgo) {
      Write-Output "Deleting $file..."
      Remove-Item $file
    }
  }
}
