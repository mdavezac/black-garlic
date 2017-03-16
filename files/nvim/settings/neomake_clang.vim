let gcc_compiler_flags=[]
let clang_compiler_flags=[]
for i in split($CMAKE_PREFIX_PATH, ':')
  for suffix in ["include", "include/eigen3"]
    if isdirectory(i . "/" . suffix)
      let gcc_compiler_flags+=["-I" . i . "/" . suffix]
      let clang_compiler_flags+=["-isystem" . i . "/" . suffix]
    endif
  endfor
endfor
for i in split($CMAKE_INCLUDE_PATH, ';')
  if isdirectory(i)
    let gcc_compiler_flags+=["-I" . i]
    let clang_compiler_flags+=["-I" . i]
  endif
endfor

if filereadable($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
  let gcc_compiler_flags+=readfile($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
  let clang_compiler_flags+=readfile($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
endif

if !empty(finddir("build", $CURRENT_FUN_WITH_DIR))
  let g:neomake_cpp_clang_cwd=$CURRENT_FUN_WITH_DIR . "/build"
  let g:neomake_cpp_clang_args=clang_compiler_flags + ['-Weverything']
  let g:neomake_cpp_gcc_cwd=$CURRENT_FUN_WITH_DIR . "/build"
  let g:neomake_cpp_gcc_args=gcc_compiler_flags
  let g:neomake_cpp_enabled_makers = ['clang']
end
if !empty(findfile("compile_commands.json", $CURRENT_FUN_WITH_DIR . "/build"))
  let g:neomake_cpp_clangtidy_exe="/usr/local/Cellar/llvm/4.0.0/bin/clang-tidy"
  let g:neomake_cpp_clangtidy_args=['-p', $CURRENT_FUN_WITH_DIR . "/build"]
end
