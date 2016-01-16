from spack import *

class Greatcmakecookoff(Package):
    """To improve scalability for very large and massively parallel
       traces the Open Trace Format (OTF) is developed at ZIH as a
       successor format to the Vampir Trace Format (VTF3)."""

    homepage = "https://github.com/UCL/GreatCMakeCookOff"
    url      = "https://github.com/UCL/GreatCMakeCookOff.git"

    version('2.1.0', git=url, tag="v2.1.0")

    def install(self, spec, prefix):
        from os.path import join
        cmake("-Dtests=OFF", *std_cmake_args)
        make("install")
        # fakes out spack so it installs a module file
        mkdirp(join(prefix, 'bin'))
