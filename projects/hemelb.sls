hemelb:
  funwith.present:
    - github: UCL-CCS/hemelb-dev
    - srcname: hemelb
    - footer: |
          setenv("CXXFLAGS", "-Wall -Wno-deprecated-register")
          local tmpdir=pathJoin(srcdir, "build", "tmp")
          setenv("TMP", tmpdir)
    - spack:
      - GreatCMakeCookoff %clang
      - boost %clang
      - openmpi@1.10.2 %clang -tm
      - hdf5 %clang -fortran -cxx +mpi ^openmpi %clang
      - gdb %clang
      - metis %clang +double
      - parmetis %clang +double ^openmpi %clang
      - Tinyxml %clang
      - cppunit %clang
      - CTemplate %clang

    - vimrc:
        makeprg: "ninja\\ -C\\ $CURRENT_FUN_WITH_DIR/build/"
        footer: |
            let g:ycm_collect_identifiers_from_tags_files=1
            let g:github_issues_max_pages=7

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
