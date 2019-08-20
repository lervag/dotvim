function! personal#hg#wrapper(com) abort " {{{1
  execute a:com
  windo setlocal foldmethod=diff
  normal! gg]c
endfunction

" }}}1
function! personal#hg#abort() " {{{1
  if exists(':Hgrecordabort') == 2
    Hgrecordabort
  else
    bdelete lawrencium
  endif
  WinResize
  normal! zx
endfunction

" }}}1
