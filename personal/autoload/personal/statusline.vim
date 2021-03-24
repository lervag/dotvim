"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

function! personal#statusline#refresh() " {{{1
  for nr in range(1, winnr('$'))
    if !s:ignored(nr)
      call setwinvar(nr, '&statusline', '%!personal#statusline#main(' . nr . ')')
    endif
  endfor
endfunction

"}}}1
function! personal#statusline#main(winnr) " {{{1
  let l:winnr = winbufnr(a:winnr) == -1 ? 1 : a:winnr
  let l:active = l:winnr == winnr()
  let l:bufnr = winbufnr(l:winnr)
  let l:buftype = getbufvar(l:bufnr, '&buftype')
  let l:filetype = getbufvar(l:bufnr, '&filetype')

  " Try to call buffer type specific functions
  try
    return s:bt_{l:buftype}(l:bufnr, l:active, l:winnr)
  catch /E117: Unknown function/
  endtry

  " Try to call filetype specific functions
  try
    return s:{l:filetype}(l:bufnr, l:active, l:winnr)
  catch /E117: Unknown function/
  endtry

  " Handle vimspector buffers
  if bufname(l:bufnr) =~# '^vimspector\.'
    return s:vimspector(l:bufnr, l:active, l:winnr)
  endif

  return s:main(l:bufnr, l:active, l:winnr)
endfunction

" }}}1

function! s:main(bufnr, active, winnr) " {{{1
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

  " Previewwindows don't need more details
  if getwinvar(a:winnr, '&previewwindow')
    let stat .= s:color(' [preview]', 'SLAlert', a:active) . ' '
    return stat
  endif

  " Add column number if above textwidth
  let cn = virtcol('$') - 1
  if &textwidth > 0 && cn > &textwidth
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

" Buffer type functions
function! s:bt_help(bufnr, active, winnr) " {{{1
  return s:color(
        \ ' vimdoc: ' . fnamemodify(bufname(a:bufnr), ':t:r'),
        \ 'SLInfo', a:active)
endfunction

" }}}1
function! s:bt_quickfix(bufnr, active, winnr) " {{{1
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

" Filetype functions
function! s:tex(bufnr, active, winnr) " {{{1
  let l:stat = vimtex#compiler#is_running() > 0
        \ ? s:color('[latexmk running] ', 'SLInfo', a:active)
        \ : s:color('[latexmk stopped] ', 'SLAlert', a:active)

  let l:main = split(s:main(a:bufnr, a:active, a:winnr), '%=')

  return l:main[0] . '%=' . l:stat . '%=' . l:main[1]
endfunction

" }}}1
function! s:wiki(bufnr, active, winnr) " {{{1
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
function! s:fzf(bufnr, active, winnr) " {{{1
  return s:color(repeat('⋯', winwidth(0)), 'SLFZF', a:active)
endfunction

" }}}1
function! s:manpage(bufnr, active, winnr) " {{{1
  return s:color(' %<%f', 'SLHighlight', a:active)
endfunction

" }}}1

" Vimspector
function! s:vimspector(bufnr, active, winnr) " {{{1
  return
        \ ' %#' . (a:active ? 'SLHighlight' : 'Statusline') . '#'
        \ . substitute(
        \     bufname(a:bufnr), '^vimspector.', 'Vimspector: ', '')
        \ . '%*'
endfunction

" }}}1

" CtrlP statusline
function! personal#statusline#ctrlp(...) " {{{1
  let l:info = a:0 > 1
        \ ? a:4 . ' < %#SLHighlight#' . a:5 . '%* > ' . a:6
        \ : a:1

  return ' %#SLAlert#CtrlP%* -- '
        \ . l:info
        \ . '%=' . fnamemodify(getcwd(), ':~') . ' '
endfunction

" }}}1

" Utilities
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
