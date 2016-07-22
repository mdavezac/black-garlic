include:
  - CondimentStation.projects.condiment_station

{% from 'projects/fixtures.sls' import tmuxinator %}
{{tmuxinator('condiment_station', root=pillar['condiment_prefix'] + "/black-garlic", file="top.sls")}}
