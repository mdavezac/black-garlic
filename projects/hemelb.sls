{% set prefix = salt['funwith.prefix']('hemelb') %}
{% set compiler = "gcc" %}
hemelb:
  funwith.present:
    - github: UCL-CCS/hemelb-dev
    - srcname: hemelb
    - footer: |
          setenv("CXXFLAGS", "-Wall -Wno-deprecated-register")
          setenv("TMP", "{{prefix}}/src/hemelb/build/tmp")
{% if compiler == "gcc" %}
          setenv("CC", "gcc-6")
          setenv("CXX", "g++-6")
{% elif compiler == "intel" %}
          setenv("CC", "icc")
          setenv("CXX", "icpc")
{% endif %}
    - spack:
        - GreatCMakeCookoff
        - boost %{{compiler}}
        - openmpi@1.10.2 %{{compiler}} -tm
        - hdf5 %{{compiler}} -fortran -cxx +mpi ^openmpi
        - gdb %{{compiler}}
        - metis %{{compiler}} +double
        - parmetis %{{compiler}} ^openmpi
        - Tinyxml %{{compiler}}
        - cppunit %{{compiler}}
        - CTemplate %{{compiler}}

    - vimrc:
        makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            let g:github_issues_max_pages=7
            let g:github_upstream_issues=1

    - ctags: True
    - cppconfig:
        cpp11: True
        source_includes:
          - Code
          - build
          - dependencies/include
        defines:
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

{{prefix}}/src/hemelb/build/tmp:
  file.directory

{{prefix}}/.vim/UltiSnips/cpp.snippets:
  file.managed:
    - makedirs: True
    - contents: |
        snippet CPPA "CPPUNIT_ASSERT" b
        CPPUNIT_ASSERT(${1:condition});
        endsnippet

        snippet CPP= "CPPUNIT_ASSERT_EQUAL" b
        CPPUNIT_ASSERT_EQUAL(${1:expected}, ${2:actual});
        endsnippet

        snippet CPPD= "CPPUNIT_ASSERT_DOUBLES_EQUAL" b
        CPPUNIT_ASSERT_DOUBLES_EQUAL(${1:expected}, ${2:actual}, ${3:1e-8});
        endsnippet

        snippet HC "HEMELB_CAPTURE" b
        HEMELB_CAPTURE(${1:expression});
        endsnippet
        snippet HC2 "HEMELB_CAPTURE(a, b)" b
        HEMELB_CAPTURE2(${1:expression}, ${2:expression});
        endsnippet
        snippet HC3 "HEMELB_CAPTURE(a, b, c)" b
        HEMELB_CAPTURE3(${1:expression}, ${2:expression}, ${3:expression});
        endsnippet
        snippet HC4 "HEMELB_CAPTURE(a, b, c, d)" b
        HEMELB_CAPTURE4(${1:expression}, ${2:expression}, ${3:expression}, ${4:expression});
        endsnippet
        snippet ns "namespace" b
        namespace ${1:NAME}
        {
          $0
        } // $1
        endsnippet
