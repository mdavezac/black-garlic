atom:
  cask.installed

{% for package in ['vim-mode', 'vim-mode-zz', 'vim-surround',
                   'atom-vim-colon-command-on-command-pallete', 'ex-mode',
                   'nerd-treeview', 'cpp-refactor', 'language-cpp14',
                   'formatter-clangformat',
                   'solarized-dark-ui', 'github-issues',
                   'build-tools', 'build', 'build-cmake', 'build-make',
                   'linter', 'linter-clang', 'linter-gcc', 'linter-pyflakes'] %}
atom {{package}}:
  cmd.run:
    - name: apm install {{package}}
    - creates: {{grains['userhome']}}/.atom/packages/{{package}}
{% endfor %}

