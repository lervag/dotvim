" This is based on vim-slash by Junegunn Choi
" https://github.com/junegunn/vim-hlsearch

function! personal#search#init() " {{{1
  augroup hlsearch
    autocmd!
    autocmd CursorMoved,CursorMovedI * call s:check_hlsearch()
  augroup END
endfunction

" }}}1

function! personal#search#wrap(seq, ...) " {{{1
  let l:opts = a:0 > 0 ? a:1 : {}

  if mode() ==# 'c' && stridx('/?', getcmdtype()) < 0
    return a:seq
  endif

  echo ''
  set hlsearch
  let s:search_motion = 1 + get(s:, 'search_motion_visual')
  let s:search_motion_visual = 0

  if get(l:opts, 'immobile')
    let s:search_motion += 1
    let s:curpos = getcurpos()
    return a:seq . "\<plug>(hl-trailer-return)"
  endif

  return a:seq
endfunction

" }}}1
function! personal#search#wrap_visual(search_cmd) abort " {{{1
  let s:search_motion_visual = 1
  let s:search_cmd = a:search_cmd
  return "y\<plug>(hl-trailer-visual)"
endfunction

" }}}1


function! s:check_hlsearch() " {{{1
  if s:search_motion > 0
    let s:search_motion -= 1

    if s:search_motion == 0
      if foldclosed('.') != -1
        normal! zvzz
      else
        normal! zz
      endif
    endif
  else
    set nohlsearch
  endif
endfunction

let s:search_motion = 0

" }}}1
function! s:trailer_return() " {{{1
  echo ''
  return s:curpos != getcurpos() ? "''" : ''
endfunction

map <silent><expr> <plug>(hl-trailer-return) <sid>trailer_return()

" }}}1
function! s:trailer_visual() " {{{1
  let l:seq = s:search_cmd . '\V'
  let l:seq .= substitute(escape(@", '\' . s:search_cmd), "\n", '\\n', 'g')
  let l:seq .= "\<cr>"
  return personal#search#wrap(l:seq, {'immobile': 1})
endfunction

map <silent><expr> <plug>(hl-trailer-visual)  <sid>trailer_visual()

" }}}1
