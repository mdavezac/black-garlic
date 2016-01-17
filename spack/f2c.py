from spack import *

class F2c(Package):
    """Dev stuff for Fortran to C"""

    url      = "http://netlib.sandia.gov/f2c/libf2c.zip"
    homepage = "http://www.netlib.org/f2c/"

    version('2c', 'e4a93aeee80c33525ffc87a5f802c30a7e6d1ea4')

    def install(self, spec, prefix):
        filter_file(r'\tld', '\t/usr/bin/ld', 'makefile.u')
        make("-f", "makefile.u", "hadd")
        make("-f", "makefile.u", "f2c.h")
        make("-f", "makefile.u", "signal1.h")
        make("-f", "makefile.u", "sysdep1.h")
        make("-f", "makefile.u", "all")

        mkdirp(prefix.include)
        install('f2c.h', prefix.include)
        mkdirp(prefix.lib)
        install('libf2c.a', prefix.lib)
