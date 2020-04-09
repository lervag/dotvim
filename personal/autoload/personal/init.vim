function! personal#init#cursor() abort " {{{1
  " Set terminal cursor
  if !has('nvim')
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\e]12;3\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\e]12;14\x7\<Esc>\\"
    else
      let &t_SI = "\e[6 q\e]12;3\x7"
      let &t_EI = "\e[2 q\e]12;14\x7"
      silent !echo -ne "\e[2 q\e]12;14\x7"
      autocmd vimrc_autocommands VimLeave *
            \ silent !echo -ne "\e[2 q\e]112\x7"
    endif
  endif

  " Set gui cursor
  set guicursor=a:block
  set guicursor+=n:Cursor
  set guicursor+=o-c:iCursor
  set guicursor+=v:vCursor
  set guicursor+=i-ci-sm:ver30-iCursor
  set guicursor+=r-cr:hor20-rCursor
  set guicursor+=a:blinkon0
endfunction

" }}}1
function! personal#init#statusline() abort " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter   * call personal#statusline#refresh()
    autocmd FileType,VimResized             * call personal#statusline#refresh()
    autocmd BufHidden,BufWinLeave,BufUnload * call personal#statusline#refresh()
  augroup END
endfunction

" }}}1
function! personal#init#tabline() " {{{1
  set tabline=%!personal#tabline#get_tabline()
endfunction

" }}}1

function! personal#init#go_to_last_known_position() abort " {{{1
  if line("'\"") <= 0 || line("'\"") > line('$')
    return
  endif

  normal! g`"
  if &foldlevel == 0
    normal! zMzvzz
  endif
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

  highlight illuminatedWord cterm=underline gui=underline

  highlight link semshiUnresolved Normal
  highlight link semshiBuiltin Function
  highlight semshiImported        ctermfg=black
  highlight semshiGlobal          ctermfg=magenta
  highlight semshiParameter       ctermfg=101
  highlight semshiParameterUnused ctermfg=100
  highlight semshiFree            ctermfg=darkmagenta
  highlight semshiAttribute       ctermfg=lightblue
  highlight semshiSelected        cterm=underline
endfunction

" }}}1
function! personal#init#toggle_diff() abort " {{{1
  if v:option_new
    set nocursorline
  else
    set cursorline
  endif
endfunction

" }}}1
