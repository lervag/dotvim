function! personal#toggle_fontsize(mode) " {{{1
  "
  " Simple function to toggle the fontsize in gui vim
  "

  if a:mode ==# '+' && &guifont =~# '10$'
    let s:font_lines = &lines
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 14
    return
  elseif a:mode ==# '+' && &guifont =~# '14$'
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 18
    return
  elseif a:mode ==# '0' && &guifont !~# '4$'
    let s:font_lines = &lines
    set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 4
    set lines=9999
    return
  endif

  set guifont=Inconsolata-g\ for\ Powerline\ Medium\ 10
  let &lines = get(s:, 'font_lines', 50)
endfunction

" }}}1
