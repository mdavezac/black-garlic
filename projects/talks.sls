{% set prefix = salt['funwith.prefix']('talks') %}
talks:
  funwith.present:
    - github: mdavezac/rsd-talks
  #   - footer: |
  #       setenv("VIRTUAL_ENV", "{{prefix}}")
  #       setenv("PYTHONHOME", "{{prefix}}")
  #       set_alias("pydoc", "python -m pydoc")
  #       prepend_path("PATH", pathJoin("{{prefix}}", "bin"))
  #
  #
  # virtualenv.managed:
  #   - name: {{prefix}}
  #   - python: python3
  #   - use_wheel: True
  #   - pip_upgrade: True
  #   - pip_pkgs:
  #       - pip
  #       - numpy
  #       - scipy
  #       - pytest
  #       - pandas
  #       - matplotlib
  #       - ipython[all]

  pkg.installed:
    - pkgs:
      - pandoc
      - graphviz
      - wget

{% for package in ['jekyll', 'redcarpet'] %}
{{package}}:
  gem.installed
{% endfor %}
