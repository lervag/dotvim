" This is based on vim-slash by Junegunn Choi
" https://github.com/junegunn/vim-hlsearch

function! personal#search#init() " {{{1
  augroup hlsearch
    autocmd!
    autocmd CursorMoved,CursorMovedI * call s:check_hlsearch()
  augroup END
endfunction

" }}}1

function! s:check_hlsearch() " {{{1
  if exists('s:search_motion')
    unlet! s:search_motion

    if foldclosed('.') != -1
      normal! zMzvzz
    else
      normal! zz
    endif

    if exists('s:winline')
      let l:sdiff = winline() - s:winline
      unlet s:winline
      if l:sdiff > 0
        execute 'normal!' l:sdiff . "\<c-e>"
      elseif l:sdiff < 0
        execute 'normal!' -l:sdiff . "\<c-y>"
      endif
    endif
  else
    set nohlsearch
  endif
endfunction

" }}}1
function! personal#search#wrap(seq, ...) " {{{1
  let l:opts = a:0 > 0 ? a:1 : {}

  if mode() ==# 'c' && stridx('/?', getcmdtype()) < 0
    return a:seq
  endif

  let s:search_motion = 1
  set hlsearch

  if get(l:opts, 'immobile')
    let s:winline = winline()
    let s:cur_line = line('.')
    return a:seq . "\<plug>(hl-trailer-return)"
  endif

  return a:seq
endfunction

" }}}1
function! personal#search#wrap_visual(search_cmd) abort " {{{1
  let s:search_cmd = a:search_cmd
  return "y\<plug>(hl-trailer-visual)"
endfunction

" }}}1


function! s:trailer_visual() " {{{1
  let seq = s:search_cmd . '\V'
  let seq .= substitute(escape(@", '\' . s:search_cmd), "\n", '\\n', 'g')
  let seq .= "\<plug>(hl-cr)"
  return personal#search#wrap(seq, {'immobile': 1})
endfunction

" }}}1
function! s:trailer_return() " {{{1
  if s:cur_line != line('.')
    return "\<plug>(hl-co)"
  endif

  return ''
endfunction

" }}}1

map <silent><expr> <plug>(hl-trailer-visual)  <sid>trailer_visual()
map <silent><expr> <plug>(hl-trailer-return)  <sid>trailer_return()

" Ensure default maps are used
cnoremap <plug>(hl-cr) <cr>
noremap  <plug>(hl-co) <c-o>
