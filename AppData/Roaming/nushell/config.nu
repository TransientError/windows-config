if (which starship | is-not-empty) {
  mkdir ($nu.data-dir | path join "vendor/autoload")
  starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

source ~/.cache/carapace/init.nu
source ~/.zoxide.nu

$env.startup = $'($env.AppData)\Microsoft\Windows\Start Menu\Programs\Startup'
$env.YAZI_FILE_ONE = $'($env.ProgramFiles)\Git\usr\bin\file.exe'

def --wrapped trash [...rest] {
  rm --trash ...$rest
}

def --wrapped win-config [...rest] {
  git --git-dir=$'($env.UserProfile\utils\windows-config\.git)' --work-tree=$'($env.UserProfile)' ...$rest
}
