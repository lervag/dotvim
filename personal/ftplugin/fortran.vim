"
" Personal settings for fortran files
" Author: Karl Yngve Lervåg
" BasedOn: Vim ftplugin version 0.49

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let s:cposet=&cpoptions
set cpoptions&vim

" Set syntax settings, see ft-fortran-syntax
let fortran_free_source=1
let fortran_dialect='f90'
let fortran_fold=1
let fortran_fold_conditionals=1
let fortran_do_enddo=1

" Options
setlocal textwidth=79
setlocal foldmethod=syntax
setlocal comments=:!
setlocal cms=!%s
setlocal expandtab
setlocal fo+=t
setlocal include=^\\c#\\=\\s*include\\s\\+
setlocal suffixesadd+=.f08,.f03,.f95,.f90,.for,.f,.F,.f77,.ftn,.fpp

" Mappings
map <silent> [[ ?^\s*\(end\s*\)\@!\zs\(function\\|subroutine\)<CR>
map <silent> ][ /^\s*\(end\s*\)\@!\zs\(function\\|subroutine\)<CR>
map <silent> [] ?^\s*\zs\(end\s*\)\(function\\|subroutine\)<CR>
map <silent> ]] /^\s*\zs\(end\s*\)\(function\\|subroutine\)<CR>
noremap  <silent> g! mzo!<Esc>80a-<Esc>80<bar>d$'zj
inoremap <silent> g! !<Esc>80a-<Esc>80<bar>d$o

" Some kind of bug makes matchpairs not work as expected, thus we must define
" patterns for the matchit plugin ourselves.
if !exists('b:match_words')
  let s:notend = '\%(\<end\s\+\)\@<!'
  let s:notselect = '\%(\<select\s\+\)\@<!'
  let s:notelse = '\%(\<end\s\+\|\<else\s\+\)\@<!'
  let s:notprocedure = '\%(\s\+procedure\>\)\@!'
  let b:match_ignorecase = 1
  let b:match_words =
    \ '(:),[:],(\/:\/),' .
    \ '\<select\s*case\>:' . s:notselect. '\<case\>:\<end\s*select\>,' .
    \ s:notelse . '\<if\s*(.\+)\s*then\>:' .
    \ '\<else\s*\%(if\s*(.\+)\s*then\)\=\>:\<end\s*if\>,'.
    \ 'do\s\+\(\d\+\):\%(^\s*\)\@<=\1\s,'.
    \ s:notend . '\<do\>:\<end\s*do\>,'.
    \ s:notelse . '\<where\>:\<elsewhere\>:\<end\s*where\>,'.
    \ s:notend . '\<type\s*[^(]:\<end\s*type\>,'.
    \ s:notend . '\<forall\>:\<end\s*forall\>,'.
    \ s:notend . '\<associate\>:\<end\s*associate\>,'.
    \ s:notend . '\<enum\>:\<end\s*enum\>,'.
    \ s:notend . '\<interface\>:\<end\s*interface\>,'.
    \ s:notend . '\<subroutine\>:\<end\s*subroutine\>,'.
    \ s:notend . '\<function\>:\<end\s*function\>,'.
    \ s:notend . '\<module\>' . s:notprocedure . ':\<end\s*module\>,'.
    \ s:notend . '\<program\>:\<end\s*program\>'
endif

let &cpoptions=s:cposet
unlet s:cposet
