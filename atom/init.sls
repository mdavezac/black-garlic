atom:
  cask.installed

{% for package in ['vim-mode', 'vim-mode-zz', 'vim-surround',
                   'atom-vim-colon-command-on-command-pallete', 'ex-mode',
                   'nerd-treeview', 'cpp-refactor', 'language-cpp14',
                   'build-tools', 'formatter-clangformat',
                   'solarized-dark-ui', 'solarized-dark-syntax',
                   'github-issues'] %}
atom {{package}}:
  cmd.run:
    - name: apm install {{package}}
    - creates: {{grains['userhome']}}/.atom/packages/{{package}}
{% endfor %}

