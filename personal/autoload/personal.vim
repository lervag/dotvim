"
" Various personal stuff
"

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
function! personal#custom_colors() " {{{1
  "
  " Purpose: Define custom colors for various things
  "

  "
  " Standard Vim things
  "

  " Updated highlighting
  highlight clear
        \ MatchParen
        \ Search
        \ SpellBad
        \ SpellCap
        \ SpellRare
        \ SpellLocal

  highlight iCursor guibg=#b58900
  highlight rCursor guibg=#dc322f
  highlight vCursor guibg=#d33682

  highlight MatchParen cterm=bold           gui=bold           ctermfg=33  guifg=Blue
  highlight Search     cterm=bold,underline gui=bold,underline ctermfg=201 guifg=Magenta
  highlight SpellBad   cterm=bold           gui=bold           ctermfg=124 guifg=Red
  highlight SpellCap   cterm=bold           gui=bold           ctermfg=33  guifg=Blue
  highlight SpellRare  cterm=bold           gui=bold           ctermfg=104 guifg=Purple
  highlight SpellLocal cterm=bold           gui=bold           ctermfg=227 guifg=Green

  "
  " Plugins
  "

  highlight IncSearchMatch        cterm=bold,underline gui=bold,underline ctermfg=201 guifg=Magenta
  highlight IncSearchMatchReverse cterm=bold,underline gui=bold,underline ctermfg=127 guifg=LightMagenta
  highlight IncSearchOnCursor     cterm=bold,underline gui=bold,underline ctermfg=39  guifg=#00afff
  highlight IncSearchCursor       cterm=bold,underline gui=bold,underline ctermfg=39  guifg=#00afff
  highlight ctrlsfSelectedLine    cterm=bold           gui=bold           ctermfg=39  guifg=#00afff
  highlight OperatorSandwichBuns  cterm=bold           gui=bold           ctermfg=5   guifg=Magenta
endfunction

" }}}1
