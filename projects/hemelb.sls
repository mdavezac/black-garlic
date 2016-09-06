{% set project = sls.split('.')[-1] %}
{% set workspace = salt['funwith.workspace'](project) %}

{% from 'projects/fixtures.sls' import tmuxinator %}
{{tmuxinator(project, root="%s/src/%s" % (workspace, project))}}

include:
  - chilly-oil.projects.{{project}}

{{project}} ctags:
  ctags.run:
    - name: {{workspace}}/src/{{project}}

{{project}} vimrc:
  funwith.add_vimrc:
    - name: {{workspace}}
    - source_dir: {{workspace}}/src/{{project}}
    - makeprg: True
    - footer: |
        let g:github_issues_max_pages=7
        let g:github_upstream_issues=1

{{project}} cppconfig:
  funwith.add_cppconfig:
    - name: {{workspace}}
    - cpp11: True
    - source_dir: {{workspace}}/src/{{project}}
    - source_includes:
      - Code
      - build
      - dependencies/include
    - defines:
      - HEMELB_UNITTEST_INCLUDE="unittests/hemelb_unittests.h"
      - HAVE_ISNAN
      - HAVE_RUSAGE
      - HAVE_STD_ISNAN
      - HEMELB_CFG_ON_BSD
      - HEMELB_CFG_ON_OSX
      - HEMELB_COMPUTE_ARCHITECTURE=AMDBULLDOZER
      - HEMELB_INLET_BOUNDARY=NASHZEROTHORDERPRESSUREIOLET
      - HEMELB_KERNEL=LBGK
      - HEMELB_LATTICE=D3Q15
      - HEMELB_LOG_LEVEL=Info
      - HEMELB_OUTLET_BOUNDARY=NASHZEROTHORDERPRESSUREIOLET
      - HEMELB_READING_GROUP_SIZE=5
      - HEMELB_USE_BOOST
      - HEMELB_WALL_BOUNDARY=SIMPLEBOUNCEBACK
      - HEMELB_WALL_INLET_BOUNDARY=NASHZEROTHORDERPRESSURESBB
      - HEMELB_WALL_OUTLET_BOUNDARY=NASHZEROTHORDERPRESSURESBB
      - LINUX_SCANDIR
      - NO_STREAKLINES
      - TIXML_USE_STL
      - xdr_uint16_t=xdr_u_int16_t
      - xdr_uint32_t=xdr_u_int32_t
      - xdr_uint64_t=xdr_u_int64_t
