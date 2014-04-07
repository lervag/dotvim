function! ToggleDistractionFree()
  if (&foldcolumn != 12)
    let s:number = &number
    let s:numberwidth = &numberwidth
    let s:foldcolumn = &foldcolumn
    set number
    set numberwidth=10
    set foldcolumn=12
    highlight LineNr           guibg=#fdf6e3 guifg=#fdf6e3
    highlight CursorLineNr     guibg=#fdf6e3 guifg=#fdf6e3
    highlight NonText          guibg=#fdf6e3 guifg=#fdf6e3
    highlight VertSplit        guibg=#fdf6e3 guifg=#fdf6e3
    highlight FoldColumn       guibg=#fdf6e3 guifg=#fdf6e3
    call fontsize#inc()
    call fontsize#inc()
  else
    call fontsize#default()
    let &number = s:number
    let &numberwidth = s:numberwidth
    let &foldcolumn = s:foldcolumn
    colorscheme solarized
  endif
endfunction

map <F8> :call ToggleDistractionFree()<cr>
