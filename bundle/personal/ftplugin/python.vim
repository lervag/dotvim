"
" Personal settings for python files
"
" Last Update: 2012-10-18
" Author:      Karl Yngve Lervåg
"

"
" Only load file once
"
if exists('b:did_python') | finish | endif
let b:did_python = 1

setlocal sts=4
setlocal sw=4
setlocal expandtab
setlocal smarttab
setlocal smartindent
setlocal makeprg=python\ %
setlocal fdm=indent

function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <C-c><C-c> :. ScreenSend<CR>
    nmap <C-c><C-f> :?^\(def\\|class\)?,/^$/ ScreenSend<CR>
  else
    nmap <C-c><C-c> :ScreenShell ipython<CR>
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
