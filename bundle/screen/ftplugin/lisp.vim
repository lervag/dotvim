function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <C-c><C-c> ?^(<CR>v])<C-c><C-c><C-o>
    nmap <C-c><C-l> [(v])<C-c><C-c><C-o>
  else
    nmap <C-c><C-c> :ScreenShell clisp<CR>
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

