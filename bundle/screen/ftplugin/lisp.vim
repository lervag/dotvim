function! s:ScreenShellListener()
  if g:ScreenShellActive
    nmap <silent> <C-c><C-c> mp$?^(<CR>v])<C-c><C-c>`p
    nmap <silent> <C-c><C-p> mp$?^(<CR>])mr?^;<CR>v`r<C-c><C-c>`p
    nmap <silent> <C-c><C-l>
          \ :call ScreenShellSend('(load "' . expand("%") . '")')<CR>
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

