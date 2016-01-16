include:
    - .hunter
    - .optimet

condiment_station:
    funwith.modulefile:
        - cwd: {{pillar['condiment_dir']}}
        - prefix: {{pillar['condiment_dir']}}
        - virtualenv: 
            name: {{pillar['condiment_dir']}}/salt-env

dotfiles project:
    funwith.modulefile:
        - name: dotfiles
        - cwd: {{pillar.get('dotdir', grains['userhome'] + "/.dotfiles")}}
