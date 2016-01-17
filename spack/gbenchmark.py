from spack import *

class Gbenchmark(Package):
    """A microbenchmark support library"""

    homepage = "https://github.com/google/benchmark"
    url      = "https://github.com/google/benchmark/archive/v1.0.0.tar.gz"

    version('1.0.0', '4f778985dce02d2e63262e6f388a24b595254a93')
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
