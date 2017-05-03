spack:
  add_to_zprofile: True
{% if grains['os'] == "MacOS" %}
  compilers_file: salt://files/spack/compilers.yaml
{% endif %}
  external_packages: salt://files/spack/packages.yaml
  repos:
      UCL-RITS: UCL-RITS/spack_packages

  directory: {{grains['userhome']}}/spack
  default_config_location: site
  # config_dir: {{grains['userhome']}}/.spack
  # repo_prefix: {{grains['userhome']}}/.spack_repos

compiler: clang
python: python3
