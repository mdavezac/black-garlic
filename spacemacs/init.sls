emacs:
  pkg.installed

syl20bnr/spacemacs:
  github.latest:
    - target: {{grains['userhome']}}/.emacs.d

{{grains['userhome']}}/.spacemacs:
  file.absent

{{grains['userhome']}}/.spacemacs.d/init.el:
  file.managed:
    - source: salt://spacemacs/init.el
    - makedirs: true

