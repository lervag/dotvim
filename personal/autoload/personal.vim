function! personal#toggle_fontsize() " {{{1
  "
  " Simple function to toggle the fontsize in gui vim
  "
  if &guifont =~# '10$'
    let s:font_lines = &lines
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 14
  elseif &guifont =~# '14$'
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 18
  else
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 10
    let &lines = get(s:, 'font_lines', 50)
  endif
endfunction

" }}}1
