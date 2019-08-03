" This is based on vim-slash by Junegunn Choi
" https://github.com/junegunn/vim-hlsearch

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

function! personal#search#wrap(seq, ...) " {{{1
  let l:opts = a:0 > 0 ? a:1 : {}

  if mode() ==# 'c' && stridx('/?', getcmdtype()) < 0
    return a:seq
  endif

  silent! autocmd! hlsearch
  set hlsearch

  let s:seq_after = get(l:opts, 'after', '')

  if get(l:opts, 'immobile')
    let s:winline = winline()
    let s:cur_line = line('.')
    return a:seq . "\<plug>(hl-trailer-return)"
  endif

  return a:seq . "\<plug>(hl-trailer-autocmd)"
endfunction

" }}}1
function! s:trailer_return() " {{{1
  let seq = ''

  if s:cur_line != line('.')
    let seq .= "\<plug>(hl-co)"
  endif

  return seq . "\<plug>(hl-trailer-autocmd)"
endfunction

" }}}1
function! s:trailer_autocmd() " {{{1
  augroup hlsearch
    autocmd!
    autocmd CursorMoved,CursorMovedI * set nohlsearch | autocmd! hlsearch
  augroup END

  let l:seq = foldclosed('.') != -1 ? 'zv' : ''

  if exists('s:winline')
    let l:sdiff = winline() - s:winline
    unlet s:winline
    if l:sdiff > 0
      let l:seq .= l:sdiff . "\<plug>(hl-ce)"
    elseif l:sdiff < 0
      let l:seq .= -l:sdiff . "\<plug>(hl-cy)"
    endif
  endif

  let l:seq .= s:seq_after
  " unlet s:seq_after

  return l:seq
endfunction

" }}}1

map <silent><expr> <plug>(hl-trailer-visual)  <sid>trailer_visual()
map <silent><expr> <plug>(hl-trailer-return)  <sid>trailer_return()
map <silent><expr> <plug>(hl-trailer-autocmd) <sid>trailer_autocmd()

" Ensure default maps are used
cnoremap <plug>(hl-cr) <cr>
noremap  <plug>(hl-co) <c-o>
noremap  <plug>(hl-ce) <c-e>
noremap  <plug>(hl-cy) <c-y>
