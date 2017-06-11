include:
  - CondimentStation.spack

{% if grains['os'] != "MacOS" %}
{{grains['userhome']}}/.spack/linux/packages.yaml:
  file.managed:
    - source: salt://files/spack/mint_packages.yaml
    - makedirs: True
{% endif %}
