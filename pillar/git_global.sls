git_global:
  user.name: "Mayeul d'Avezac"
  user.email: "2745737+mdavezac@users.noreply.github.com"
  core.editor: /usr/local/bin/nvim
  core.autoclrf: input
  core.excludesfile: {{grains['userhome']}}/.gitignore
  color.ui: true
  apply.whitespace: nowarn
  branch.autosetupmerge: true
  push.default: upstream
  advice.statusHints: false
  format.pretty: format:%C(blue)%ad%Creset %C(yellow)%h%C(green)%d%Creset %C(blue)%s %C(magenta) [%an]%Creset
  credential.helper: osxkeychain
  lfs.clean: git-lfs clean -- %f
  lfs.smudge: git-lfs smudge -- %f
  lfs.process: git-lfs filter-process
  lfs.required: true
