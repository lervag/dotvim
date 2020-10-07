function! personal#git#fugitive_toggle() " {{{1
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    try
      Git
      normal gg
    catch /Vim.*E492/
      echo 'Sorry: Not in a Git repo.'
    endtry
  endif
endfunction

" }}}1
