"
" Personal settings for lisp files
" Author: Karl Yngve Lervåg
"

" Only load the file once
if exists('b:did_ft_lisp') | finish | endif
let b:did_ft_lisp = 1

setlocal foldmethod=marker foldmarker=(,) foldminlines=3
setlocal suffixesadd=.lisp,cl path=/usr/src/lisp/**
setlocal include=(:file\
setlocal lisp autoindent showmatch cpoptions-=mp
setlocal lispwords+=alet,alambda,dlambda,aif
setlocal iskeyword+=-

function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <silent> <C-c><C-c> mp$?^(<CR>v])<C-c><C-c>`p
    nmap <silent> <C-c><C-p> mp$?^(<CR>])mr?^;<CR>v`r<C-c><C-c>`p
    nmap <silent> <C-c><C-l>
          \ :call ScreenShellSend('(load "' . expand("%") . '")')<CR>
    nmap <silent> <C-c>0
          \ :call ScreenShellSend('0')<CR>
  else
    nmap <silent> <C-c><C-c> :ScreenShell sbcl<CR>
    nmap <C-c><C-l> <Nop>
  endif
endfunction

call s:ScreenShellListener()
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListener()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListener()
augroup END

