atom:
  cask.installed

{% for package in ['vim-mode', 'vim-mode-zz', 'vim-surround',
                   'atom-vim-colon-command-on-command-pallete', 'ex-mode',
                   'nerd-treeview', 'cpp-refactor', 'language-cpp14',
                   'build-tools', 'build-tools-make', 'build-cmake',
                   'language-cmake', 'autocomplete-cmake',
                   'formatter-clangformat',
                   'solarized-dark-ui', 'github-issues',
                   'formatter', 'atom-format',
                   'symbols-tree-view'] %}
atom {{package}}:
  cmd.run:
    - name: apm install {{package}}
    - creates: {{grains['userhome']}}/.atom/packages/{{package}}
{% endfor %}

