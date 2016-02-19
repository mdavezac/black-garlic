{% set repo_dir = salt['spack.repo_path']('UCL-RITS') %}
spack_packages:
    funwith.modulefile:
        - cwd: {{repo_dir}}
        - prefix: {{repo_dir}}
