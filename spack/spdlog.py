from spack import *

class Spdlog(Package):
    """Very fast, header only, C++ logging library"""

    homepage = "https://github.comg/abime/spdlog"
    url      = "https://github.com/google/benchmark/releases/tag/v1.0.0"

    version('dev', git='https://github.com/gabime/spdlog.git')
    variant("debug", default=False, description="Installs with debug options")

    def install(self, spec, prefix):
        # mkdirp(prefix.include)
        options = [u for u in std_cmake_args]
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
