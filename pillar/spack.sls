spack:
  add_to_zprofile: True
{% if grains['os'] == "MacOS" %}
  compilers_file: salt://files/spack/compilers.yaml
  external_packages: salt://files/spack/packages.yaml
{% endif %}
  repos:
      UCL-RITS: UCL-RITS/spack_packages

  directory: {{grains['userhome']}}/spack
  default_config_location: site

compiler: gcc
python: python3
