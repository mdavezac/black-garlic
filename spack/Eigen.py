from spack import *

class Eigen(Package):
    """A C++ template library for linear algebra"""

    homepage = "https://github.com/UCL/GreatCMakeCookOff"
    url      = "http://bitbucket.org/eigen/eigen/get/3.2.7.tar.bz2"

    version('3.2.7', '6e22013ada087bc8ac07bcc0805c3dbb55f8e544')
    version('3.1.4', 'a5cbe0a5676ea2105c8b0c4569c204bf58fc009a')
    version('3.0.6', 'a0e3f5a7f23ca085ee05bc5e8683009fe2e2cf4c')
    version('2.0.17', '461546be98b964d8d5d2adb0f1c31ba0e42efc38')
    variant("debug", default=False, description="Installs with debug options")

    def install(self, spec, prefix):
        options = []
        options.extend(std_cmake_args)
        if '+debug' in spec:
            options.append('-DCMAKE_BUILD_TYPE:STRING=Debug')
        else:
            options.append('-DCMAKE_BUILD_TYPE:STRING=Release')

        build_directory = join_path(self.stage.path, 'spack-build')
        source_directory = self.stage.source_path
        with working_dir(build_directory, create=True):
            cmake(source_directory, *options)
            make()
            make("install")

        # So we get a module out of it
        mkdirp(prefix.bin)
