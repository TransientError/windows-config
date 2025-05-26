if (which carapace | is-not-empty) {
  $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
  mkdir ~/.cache/carapace
  carapace _carapace nushell | save -f ~/.cache/carapace/init.nu
}

if (which zoxide | is-not-empty) {
  zoxide init nushell | save -f ~/.zoxide.nu
}
