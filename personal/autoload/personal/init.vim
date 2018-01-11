function! personal#init#go_to_last_known_position() abort " {{{1
  if line("'\"") < 0 || line("'\"") > line('$')
    return
  endif

  normal! g`"
  normal! zMzvzz
endfunction

" }}}1
function! personal#init#custom_colors() abort " {{{1
  " Purpose: Define custom colors for various things that are loaded through an
  "          autocmd after the ColorScheme event.

  " Standard Vim things
  " ---------------------------------------------------------------------------

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

  " Plugins
  " ---------------------------------------------------------------------------

  highlight ctrlsfSelectedLine    cterm=bold           gui=bold           ctermfg=39  guifg=#00afff
  highlight OperatorSandwichBuns  cterm=bold           gui=bold           ctermfg=5   guifg=Magenta

  highlight link ALEErrorLine ErrorMsg
  highlight link ALEWarningLine WarningMsg
  highlight link ALEInfoLine ModeMsg
endfunction

" }}}1
