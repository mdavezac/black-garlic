optimet:
  # file.managed:
  #   - name: /Users/mdavezac/.funwith/optimet.lua
  #   - source: salt://funwith/project.jinja.lua
  #   - template: jinja
  #   - context:
  #       homedir: prefix
  #       srcdir: None
  #       footer: None

  funwith.modulefile:
    - cwd: {{pillar['funwith']['workspaces']}}/src/optimet
