from spack import *

class Eigen(Package):
    """A C++ template library for linear algebra"""

    homepage = "https://github.com/UCL/GreatCMakeCookOff"
    url      = "http://bitbucket.org/eigen/eigen/get/3.2.7.tar.bz2"

    version('3.3-beta1', '8d09de4b20a62e7a6154b500037885e43956f31a')
    version('3.2.7', '6e22013ada087bc8ac07bcc0805c3dbb55f8e544')
    version('3.1.4', 'a5cbe0a5676ea2105c8b0c4569c204bf58fc009a')
    version('3.0.6', 'a0e3f5a7f23ca085ee05bc5e8683009fe2e2cf4c')
    version('2.0.17', '461546be98b964d8d5d2adb0f1c31ba0e42efc38')

    def install(self, spec, prefix):
        from os.path import join
        cmake("-Dtests=OFF", *std_cmake_args)
        make("")
        make("install")
