"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! statusline#init() " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter   * call statusline#refresh()
    autocmd FileType,VimResized             * call statusline#refresh()
    autocmd BufHidden,BufWinLeave,BufUnload * call statusline#refresh()
  augroup END

  highlight StatusLine   ctermfg=10 ctermbg=15  guifg=#657b83 guibg=#eee8d5
  highlight StatusLineNC ctermfg=10 ctermbg=8   guifg=#839496 guibg=#eee8d5
  highlight SLHighlight  ctermbg=10 ctermfg=220 guibg=#657b83 guifg=#ffe055
  highlight SLAlert      ctermbg=10 ctermfg=202 guibg=#657b83 guifg=#ff8888
endfunction

" }}}1
function! statusline#refresh() " {{{1
  for nr in range(1, winnr('$'))
    if !s:ignored(nr)
      call setwinvar(nr, '&statusline', '%!statusline#main(' . nr . ')')
    endif
  endfor
endfunction

"}}}1
function! statusline#main(winnr) " {{{1
  let l:winnr = winbufnr(a:winnr) == -1 ? 1 : a:winnr
  let l:active = l:winnr == winnr()
  let l:bufnr = winbufnr(l:winnr)
  let l:buftype = getbufvar(l:bufnr, '&buftype')
  let l:filetype = getbufvar(l:bufnr, '&filetype')

  if l:buftype ==# 'help'
    return s:help(l:bufnr, l:active)
  elseif l:buftype ==# 'quickfix'
    return s:quickfix(l:bufnr, l:active, a:winnr)
  elseif l:filetype ==# 'wiki'
    return s:wiki(l:bufnr, l:active)
  elseif l:filetype ==# 'man'
    return s:manpage(l:bufnr, l:active)
  else
    return s:main(l:bufnr, l:active)
  endif
endfunction

" }}}1

"
" Main statusline funcs
"
function! s:help(bufnr, active) " {{{1
  let l:name = bufname(a:bufnr)
  return s:color(' ' . fnamemodify(l:name, ':t:r') . ' %= HELP ',
        \ 'SLHighlight', a:active)
endfunction

" }}}1
function! s:quickfix(bufnr, active, winnr) " {{{1
  let l:nr = personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'nr',
        \})
  let l:last = personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'nr',
        \ 'val': '$',
        \})

  let text = ' ['
  let text .= personal#qf#is_loc(a:winnr) ? 'Loclist' : 'Quickfix'
  if l:last > 1
    let text .= ' ' . l:nr . '/' . l:last
  endif

  let text .= '] (' . personal#qf#length(a:winnr) . ') '

  let text .= personal#qf#get_prop({
        \ 'winnr': a:winnr,
        \ 'key': 'title',
        \})
  let stat  = s:color(text, 'SLHighlight', a:active)

  return stat
endfunction

" }}}1
function! s:wiki(bufnr, active) " {{{1
  let stat  = s:color(' wiki: ', 'SLAlert', a:active)
  let stat .= s:color(fnamemodify(bufname(a:bufnr), ':t:r'),
        \ 'SLHighlight', a:active)
  if get(get(b:, 'wiki', {}), 'in_diary', 0)
    let stat .= s:color(' (diary)', 'SLAlert', a:active)
  endif

  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''
  return stat
endfunction

" }}}1
function! s:main(bufnr, active) " {{{1
  let stat  = s:color(' %<%f', 'SLHighlight', a:active)
  let stat .= getbufvar(a:bufnr, '&modifiable')
        \ ? '' : s:color(' [Locked]', 'SLAlert', a:active)
  let stat .= getbufvar(a:bufnr, '&readonly')
        \ ? s:color(' [‼]', 'SLAlert', a:active) : ''
  let stat .= getbufvar(a:bufnr, '&modified')
        \ ? s:color(' [+]', 'SLAlert', a:active) : ''

  " Add linter message
  try
    let ale_counts = ale#statusline#Count(a:bufnr)
    let ale_status = map(filter([
          \ ['Errors: ', 'error'],
          \ ['Warnings: ', 'warning'],
          \ ['Infos: ', 'info'],
          \], 'ale_counts[v:val[1]] > 0'),
          \ 'v:val[0] . ale_counts[v:val[1]]')
    if !empty(ale_status)
      let stat .= s:color(' [' . join(ale_status, ', ') . ']',
            \ 'SLAlert', a:active)
    endif
  catch
  endtry

  " Change to right-hand side
  let stat .= '%='

  " Add column number if above textwidth
  let cn = virtcol('$') - 1
  if cn > &textwidth
    let stat .= s:color(
          \ printf('[%s > %s &tw] ', cn, &textwidth), 'SLAlert', a:active)
  endif

  try
    let stat .= FugitiveHead(12)
    let stat .= ' '
  catch
  endtry

  return stat
endfunction

" }}}1
function! s:manpage(bufnr, active) " {{{1
  return s:color(' %<%f', 'SLHighlight', a:active)
endfunction

" }}}1

"
" CtrlP statusline
"
function! statusline#ctrlp(...) " {{{1
  let l:info = a:0 > 1
        \ ? a:4 . ' < %#SLHighlight#' . a:5 . '%* > ' . a:6
        \ : a:1

  return ' %#SLAlert#CtrlP%* -- '
        \ . l:info
        \ . '%=' . fnamemodify(getcwd(), ':~') . ' '
endfunction

" }}}1

"
" Tabline
"
function! statusline#init_tabline() " {{{1
  set tabline=%!statusline#get_tabline()
  highlight TabLine
        \ cterm=none ctermbg=12 ctermfg=8
        \ gui=none guibg=#657b83 guifg=#eee8d5 guisp=#657b83
  highlight TabLineSel
        \ cterm=none ctermbg=12 ctermfg=15
        \ gui=none guibg=#657b83 guifg=#ffe055 guisp=#657b83
  highlight TabLineFill
        \ cterm=none ctermbg=12 ctermfg=8
        \ gui=none guibg=#657b83 guifg=#eee8d5 guisp=#657b83
endfunction

" }}}1
function! statusline#get_tabline() " {{{1
  let s = ' '
  for i in range(1, tabpagenr('$'))
    let s .= s:color('%{statusline#get_tablabel(' . i . ')} ',
          \ 'TabLineSel', i == tabpagenr())
  endfor

  return s
endfunction

" }}}1
function! statusline#get_tablabel(n) " {{{1
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)

  let name = bufname(buflist[winnr - 1])
  if name !=# ''
    let label = fnamemodify(name, ':t')
  else
    let type = getbufvar(buflist[winnr - 1], '&buftype')
    if type !=# ''
      let label = '[' . type . ']'
    else
      let label = '[No Name]'
    endif
  endif

  return printf('%1s %-15s', a:n, label)
endfunction

" }}}1

"
" Utilities
"
function! s:color(content, group, active) " {{{1
  if a:active
    return '%#' . a:group . '#' . a:content . '%*'
  else
    return a:content
  endif
endfunction

" }}}1
function! s:ignored(winnr) " {{{1
  let l:name = bufname(winbufnr(a:winnr))

  if l:name =~# '^\%(undotree\|diffpanel\)'
    return 1
  endif

  return 0
endfunction

" }}}1

