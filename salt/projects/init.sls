include:
  - .hunter

optimet:
  funwith.present:
    - github: OPTIMET/OPTIMET

pepper:
  funwith.modulefile:
    - cwd: /Users/{{grains['user']}}/.pepper

dotfiles project:
  funwith.modulefile:
    - name: dotfiles
    - cwd: /Users/{{grains['user']}}/.dotfiles
