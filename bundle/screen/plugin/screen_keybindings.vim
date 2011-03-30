function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <C-c><C-c> <S-v>:ScreenSend<CR>
    vmap <C-c><C-c> :ScreenSend<CR>
    nmap <C-c><C-a> :ScreenSend<CR>
    nmap <C-c><C-q> :ScreenQuit<CR>
  else
    nmap <C-c><C-a> <Nop>
    vmap <C-c><C-c> <Nop>
    nmap <C-c><C-q> <Nop>
    nmap <C-c><C-c> :ScreenShell 
  endif
endfunction

call s:ScreenShellListener()
augroup ScreenShellEnter
  au USER * :call <SID>ScreenShellListener()
augroup END
augroup ScreenShellExit
  au USER * :call <SID>ScreenShellListener()
augroup END
