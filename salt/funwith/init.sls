funwith:
  pkg.installed:
    - taps: homebrew/science
    - name: lmod
    - require:
      - pkg: languages

{{pillar['funwith']['workspaces']}}:
  file.directory
{{pillar['funwith']['modulefiles']}}:
  file.directory
