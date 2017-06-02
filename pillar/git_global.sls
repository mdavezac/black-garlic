git_global:
  user.name: "Mayeul d'Avezac"
  user.email: mayeul@cryptalabs.com
  core.editor: nvim
  core.autoclrf: input
  core.excludesfile: {{grains['userhome']}}/.gitignore
  color.ui: true
  apply.whitespace: nowarn
  branch.autosetupmerge: true
  push.default: upstream
  advice.statusHints: false
  format.pretty: format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset
  credential.helper: osxkeychain
