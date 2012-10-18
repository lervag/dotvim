"
" Personal settings for lisp files
"
" Last Update: 2012-10-18
" Author:      Karl Yngve Lervåg
"

"
" Only load file once
"
if exists('b:did_lisp') | finish | endif
let b:did_lisp = 1

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

