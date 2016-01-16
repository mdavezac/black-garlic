{% set prefix = pillar['funwith']['workspaces'] + "/hunter" %}
hunter:
  funwith.present:
    - github: mdavezac/hunter
    - email: mdavezac@gmail.com

cookoff:
  github.present:
    - name: UCL/GreatCMakeCookOff
    - target: {{prefix}}/src/cookoff
  file.directory:
    - name: {{prefix}}/src/cookoff/build
  cmd.run:
    - cwd: {{prefix}}/src/cookoff/build
    - name: |
        cmake -G Ninja -DCMAKE_INSTALL_PREFIX={{prefix}} ..
        ninja install
    - unless: test -e {{prefix}}/share/GreatCMakeCookOff
