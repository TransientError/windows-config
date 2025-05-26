def --wrapped winget-install [...rest] {
  winget install ...$rest  
  ls ~\Desktop | each {
    echo $'Cleaning up ($in)'
    rm $in
  } | ignore
}

def --wrapped winget-upgrade [...rest] {
  winget upgrade ...$rest  
  ls ~\Desktop | each {
    echo $'Cleaning up ($in)'
    rm $in
  } | ignore
}
