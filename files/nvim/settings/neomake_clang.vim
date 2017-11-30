let compiler_flags=[]
for i in split($CMAKE_PREFIX_PATH, ':')
  for suffix in ["include", "include/eigen3"]
    if isdirectory(i . "/" . suffix)
      let compiler_flags+=["-isystem" . i . "/" . suffix]
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
  let g:neomake_cpp_clang_maker = {
    \ 'cwd': $CURRENT_FUN_WITH_DIR . "/build",
    \ 'args': compiler_flags + ['-pedantic', '-Wall', '-Wextra', '-fsyntax-only']
    \ }
  let g:neomake_cpp_gcc_maker= {
    \ 'exe': '/usr/local/bin/g++-6',
    \ 'cwd': $CURRENT_FUN_WITH_DIR . "/build",
    \ 'args': compiler_flags + ['-pedantic', '-Wall', '-Wextra', '-fsyntax-only']
    \ }
end
if !empty(findfile("compile_commands.json", $CURRENT_FUN_WITH_DIR . "/build"))
  let g:neomake_cpp_clangtidy_maker = { 
    \ 'exe': "/usr/local/Cellar/llvm/5.0.0/bin/clang-tidy",
    \ 'args': ['-p', $CURRENT_FUN_WITH_DIR . "/build"]
    \ }
end
