{{grains['userhome']}}/.hgrc:
  file.managed:
    - source: salt://files/hgrc
    - mode: 400
