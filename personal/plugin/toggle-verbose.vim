function! ToggleVerbose()
  if !&verbose
    let file=fnamemodify('~/.vim/messages.log', ':p')
    if filereadable(file)
      call delete(file)
    endif
    silent execute 'set verbosefile=' . file
    set verbose=10
    echom 'Verbose on, see ' . file
  else
    set verbose=0
    set verbosefile=
    echom 'Verbose off'
  endif
endfunction

command! ToggleVerbose call ToggleVerbose()
