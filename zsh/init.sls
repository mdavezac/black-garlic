zsh:
  pkg.installed:
    - pkgs:
      - zsh
      - zsh-lovers

include:
  - zsh.powerfonts
  - zsh.prezto
  - zsh.iterm2

Integrate various brew apps to zsh:
  file.append:
    - name: {{grains['userhome']}}/.salted_zprofile
    - text: |
       sitefunc=/usr/local/share/zsh/site-function
       if [[ -d $sitefunc ]] &&  [[ -n "${fpath[(r)$sitefunc}" ]] ; then
           fpath=($sitefunc $fpath)
       fi
