" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/

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

  try
    return s:bt_{l:buftype}(l:bufnr, l:active, l:winnr)
  catch /E117: Unknown function/
  endtry

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

  return s:color( ' VIM', 'SLAlert', a:active) . stat
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
