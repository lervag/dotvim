"
" Statusline functions
"
" Inspiration:
" - https://github.com/blaenk/dots/blob/master/vim/.vimrc
" - http://www.blaenkdenum.com/posts/a-simpler-vim-statusline/
"

" For developing
let s:file = expand('<sfile>')
execute 'nnoremap <leader>as :so ' . s:file . '<cr>:call statusline#init()<cr>'
execute 'nnoremap <leader>ae :ed ' . s:file . '<cr>'

function! statusline#init() " {{{1
  augroup statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter   * call statusline#refresh()
    autocmd FileType,VimResized             * call statusline#refresh()
    autocmd BufHidden,BufWinLeave,BufUnload * call statusline#refresh()
  augroup END

  highlight SLHighlight ctermbg=14 ctermfg=2 guibg=#586e75 guifg=#ffe055
  highlight SLAlert     ctermbg=14 ctermfg=2 guibg=#586e75 guifg=#ffff22
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
  let l:name = bufname(l:bufnr)

  "
  " Alternative statuslines
  "
  if l:buftype ==# 'help'
    return s:color(' ' . fnamemodify(l:name, ':t:r') . ' %= HELP ',
          \ 'SLHighlight', l:active)
  endif

  " Left part
  let stat  = s:color(' %<%f', 'SLHighlight', l:active)
  let stat .= getbufvar(l:bufnr, '&modified')
        \ ? s:color(' +', 'SLAlert', l:active) : ''
  let stat .= getbufvar(l:bufnr, '&readonly')
        \ ? s:color(' ‼', 'SLAlert', l:active) : ''

  let stat .= '%='

  " Right part
  let stat .= fugitive#head(12)
  let stat .= ' '

  return stat
endfunction

" }}}1

"
" CtrlP statusline
"
function! statusline#ctrlp_main(focus, byfname, re, prv, cur, nxt, marked) " {{{1
  let stat  = ' ' . a:prv . ' → '
  let stat .= s:color(a:cur ==# 'mru files' ? 'mru' : a:cur, 'SLHighlight', 1)
  let stat .= ' → ' . a:nxt

  if a:cur =~# '^\%(files\|dir\|mixed\)'
    let stat .= ' ← '
    let stat .= s:color(fnamemodify(getcwd(), ':~'), 'SLAlert', 1)
  endif

  let stat .= '%='
  let stat .= s:color(' CtrlP ', 'SLHighlight', 1)

  return stat
endfunction

" }}}1
function! statusline#ctrlp_progress(length) " {{{1
  let stat  = s:color(' Loading ... (' . a:length . ')', 'SLHighlight', 1)
  let stat .= '%='
  let stat .= s:color(' CtrlP ', 'SLHighlight', 1)
  return stat
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

