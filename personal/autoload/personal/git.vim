function! personal#git#fugitive_toggle()
  if buflisted(bufname('.git/index'))
    bd .git/index
  else
    try
      Gstatus
      normal gg
    catch /Vim.*E492/
      echo 'Sorry: Not in a Git repo.'
    endtry
  endif
endfunction

