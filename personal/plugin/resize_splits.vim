if exists('g:loaded_resizesplits')
    finish
endif
let g:loaded_resizesplits = 1

let s:save_cpo = &cpo
set cpo&vim

command! ResizeSplits call s:ResizeSplits()

augroup resize_splits
  autocmd!
  autocmd WinEnter,WinLeave * ResizeSplits
augroup END

nnoremap <silent> <c-w>o <c-w>o:ResizeSplits<cr>

" {{{1 Functions
function! s:ResizeSplits()
  if !empty($TMUX . $STY) | return | endif

  let l:column_width  = 82 + &foldcolumn
        \ + (&number         ? &numberwidth : 0)
        \ + (s:HasSignCols() ? 2            : 0)

  let l:total_height = 0
  let l:heights = map(filter(split(winrestcmd(),'|')[0:-1],
        \                  'v:val =~# ''^\d'''),
        \           'matchstr(v:val, ''\d\+$'')')
  for l:h in l:heights
    let l:total_height += l:h
  endfor

  let l:count = float2nr(ceil(l:total_height / (1.0*&lines)))
  let l:total_width = l:count*l:column_width

  if &columns != l:total_width
    silent execute 'set co=' . l:total_width
    silent execute 'wincmd ='
  endif
endfunction

function! s:HasSignCols()
  let save_more = &more
  set nomore
  redir => lines
  silent execute 'sign place'
  redir END
  let &more = save_more
  return len(split(lines,"\n")) > 1
endfunction

" }}}1

let &cpo = s:save_cpo
