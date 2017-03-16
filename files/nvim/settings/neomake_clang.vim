let compiler_flags=[]
for i in split($CMAKE_PREFIX_PATH, ':')
  for suffix in ["include", "include/eigen3"]
    if isdirectory(i . "/" . suffix)
      let compiler_flags+=["-I" . i . "/" . suffix]
    endif
  endfor
endfor
for i in split($CMAKE_INCLUDE_PATH, ';')
  if isdirectory(i)
    let compiler_flags+=["-I" . i]
  endif
endfor

if filereadable($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
  let compiler_flags+=readfile($CURRENT_FUN_WITH_HOMEDIR . "/.cppconfig")
endif

if !empty(finddir("build", $CURRENT_FUN_WITH_DIR))
    let g:neomake_cpp_clang_cwd=$CURRENT_FUN_WITH_DIR . "/build"
    let g:neomake_cpp_clang_args=compiler_flags + ['-Weverything', '-fpedantic']
    let g:neomake_cpp_gcc_cwd=$CURRENT_FUN_WITH_DIR . "/build"
    let g:neomake_cpp_gcc_args=compiler_flags
    let g:neomake_cpp_enabled_makers = ['clang', 'gcc', 'clangtidy']
    let g:neomake_cpp_clangtidy_exe="/usr/local/Cellar/llvm/3.9.1.reinstall/bin/clang-tidy"
    let g:neomake_cpp_clangtidy_args=filter(deepcopy(g:neomake_cpp_clang_args), 'v:val =~ "-I.*"')
end
