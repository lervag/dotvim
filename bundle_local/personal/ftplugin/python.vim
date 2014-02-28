"
" Personal settings for python files
" Author: Lervåg
"

" Only load file once
if exists('b:did_ft_python') | finish | endif
let b:did_ft_python = 1

setlocal sts=4
setlocal sw=4
setlocal expandtab
setlocal smarttab
setlocal smartindent
setlocal makeprg=python\ %
setlocal fdm=indent
setlocal omnifunc=pythoncomplete#Complete

syn keyword pythonDecorator True None False self

function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <C-c><C-c> :. ScreenSend<CR>
    nmap <C-c><C-f> :?^\(def\\|class\)?,/^$/ ScreenSend<CR>
  else
    nmap <C-c><C-c> :ScreenShell ipython2<CR>
    nmap <C-c><C-f> <Nop>
  endif
endfunction

call s:ScreenShellListener()
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListener()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListener()
augroup END
