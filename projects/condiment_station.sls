{% from 'projects/fixtures.sls' import tmuxinator %}
condiment_station:
    funwith.modulefile:
        - cwd: {{pillar['condiment_dir']}}
        - prefix: {{pillar['condiment_dir']}}
        - virtualenv:
            name: {{pillar['condiment_dir']}}/salt-env

{{tmuxinator('condiment_station', root=pillar['condiment_dir'])}}
