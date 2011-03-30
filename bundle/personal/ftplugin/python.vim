setlocal sts=4
setlocal sw=4
setlocal smarttab
setlocal smartindent
setlocal expandtab
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
