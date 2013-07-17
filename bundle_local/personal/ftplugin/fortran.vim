"
" Personal settings for fortran files
" Author: Karl Yngve Lervåg
"

" Only load file once
if exists('b:did_ft_fortran') | finish | endif
let b:did_ft_fortran = 1

" Options
setlocal foldmethod=syntax

" Mappings
map <silent> [[ ?^\s*\(end\s*\)\@!\zs\(function\\|subroutine\)<CR>
map <silent> ][ /^\s*\(end\s*\)\@!\zs\(function\\|subroutine\)<CR>
map <silent> [] ?^\s*\zs\(end\s*\)\(function\\|subroutine\)<CR>
map <silent> ]] /^\s*\zs\(end\s*\)\(function\\|subroutine\)<CR>

" Some kind of bug makes matchpairs not work as expected, thus we must define
" patterns for the matchit plugin ourselves.
if !exists("b:match_words")
  let s:notend = '\%(\<end\s\+\)\@<!'
  let s:notselect = '\%(\<select\s\+\)\@<!'
  let s:notelse = '\%(\<end\s\+\|\<else\s\+\)\@<!'
  let s:notprocedure = '\%(\s\+procedure\>\)\@!'
  let b:match_ignorecase = 1
  let b:match_words =
    \ '\<select\s*case\>:' . s:notselect. '\<case\>:\<end\s*select\>,' .
    \ s:notelse . '\<if\s*(.\+)\s*then\>:' .
    \ '\<else\s*\%(if\s*(.\+)\s*then\)\=\>:\<end\s*if\>,'.
    \ 'do\s\+\(\d\+\):\%(^\s*\)\@<=\1\s,'.
    \ s:notend . '\<do\>:\<end\s*do\>,'.
    \ s:notelse . '\<where\>:\<elsewhere\>:\<end\s*where\>,'.
    \ s:notend . '\<type\s*[^(]:\<end\s*type\>,'.
    \ s:notend . '\<interface\>:\<end\s*interface\>,'.
    \ s:notend . '\<subroutine\>:\<end\s*subroutine\>,'.
    \ s:notend . '\<function\>:\<end\s*function\>,'.
    \ s:notend . '\<module\>' . s:notprocedure . ':\<end\s*module\>,'.
    \ s:notend . '\<program\>:\<end\s*program\>,'.
    \ '(:),[:],(\/:\/)'
endif

function! SyntaxClean()
  " Change tabs to space
  retab

  " Remove space at end of lines
  %s/\s\+$//ge

  " Add/Remove some space
  %s/\(\w\|)\)::/\1 ::/ge
  %s/if(/if (/ge
  %s/type (/type(/ge

  " Change from .eq. to == (and similar)
  %s/\.eq\./==/ge
  %s/\.ne\./\/=/ge
  %s/\.lt\./</ge
  %s/\.gt\./>/ge
  %s/\.le\./<=/ge
  %s/\.ge\./>=/ge
  %s/\.ge\./>=/ge

  " Change case to lowercase
  %s/\<\(INTEGER\|REAL\|LOGICAL\|CHARACTER\|TYPE\|DIMENSION\)\>/\L\1/ge
  %s/\<\(FUNCTION\|SUBROUTINE\|USE\|ONLY\|IMPLICIT NONE\)\>/\L\1/ge
  %s/\<\(WRITE\|PRINT\|IF\|RETURN\|SELECT\|CASE\|FORMAT\)\>/\L\1/ge
  %s/\<\(READWRITE\|CALL\|END\|KIND\|INTENT\|IN\|OUT\|INOUT\)\>/\L\1/ge
  %s/\<\(DO\|READ\|BACKSPACE\|NOT\|LEN\|POINTER\|INTERFACE\)\>/\L\1/ge
  %s/\<\(OPEN\|UNIT\|FILE\|STATUS\|REPLACE\|FORMATTED\|FORM\)\>/\L\1/ge
  %s/\<\(PARAMETER\|ACTION\|OPTIONAL\|PRESENT\)\>/\L\1/ge
  %s/\<\(RECURSIVE\|INQUIRE\|EXIST\|THEN\|NAMELIST\|TARGET\)\>/\L\1/ge
  %s/\<\(MODULE\|PROGRAM\|CPU_TIME\|DOUBLE\|PRECISION\)\>/\L\1/ge
  %s/\<\(IOSTAT\|PRIVATE\|NULLIFY\|STOP\|OLD\|EXIT\)\>/\L\1/ge
  %s/\<\(ELSEIF\|ELSE\|MIN\|MINVAL\|MAXVAL\|WHILE\)\>/\L\1/ge
  %s/\<\(MAX\|AND\|OR\|CLOSE\|SYSTEM\|TRUE\|FALSE\|ABS\|ANY\)\>/\L\1/ge
  %s/\<\(MODULO\|POSITION\|NML\|APPEND\)\>/\L\1/ge
  %s/\<\(DE\)\?ALLOCAT\(E\|ED\|ABLE\)\>/\L\0/ge
  %s/\<\(DEFAULT\|ASSOCIATED\|PRODUCT\|SUM\|RESULT\)\>/\L\1/ge
  %s/\<\(SAVE\|RANDOM_NUMBER\|NINT\|ELEMENTAL\|CONTAINS\)\>/\L\1/ge
  %s/\<\(SQRT\|SIZE\|TANH\|WHERE\|PUBLIC\|CONTINUE\|CYCLE\)\>/\L\1/ge
  %s/kind=R8/kind=r8/ge
  %s/_R8/_r8/ge
endfunction
