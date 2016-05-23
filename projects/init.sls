include:
  - .spack_packages
  - .condiment_station

dotfiles project:
    funwith.modulefile:
        - name: dotfiles
        - cwd: {{pillar.get('dotdir', grains['userhome'] + "/.dotfiles")}}
