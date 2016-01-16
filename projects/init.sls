include:
  - .hunter

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET

condiment_station:
  funwith.modulefile:
    - cwd: {{pillar['condiment_dir']}}

dotfiles project:
  funwith.modulefile:
    - name: dotfiles
    - cwd: {{pillar.get('dotdir', grains['userhome'] + "/.dotfiles")}}
