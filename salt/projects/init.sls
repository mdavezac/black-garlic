include:
  - .hunter

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET

condiment_station::
  funwith.modulefile:
    - cwd: /Users/{{pillar['condiment_dir']}}

dotfiles project:
  funwith.modulefile:
    - name: dotfiles
    - cwd: /Users/{{grains['user']}}/.dotfiles
