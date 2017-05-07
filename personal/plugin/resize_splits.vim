if exists('g:loaded_resizesplits')
  finish
endif
let g:loaded_resizesplits = 1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

command! ResizeSplits call s:resize_splits()
nnoremap <silent> <plug>(resize-splits) :ResizeSplits<cr>
nmap <silent> <leader>q <plug>(resize-splits)

function! s:resize_splits() " {{{1
  if !has('gui') && !empty($TMUX . $STY) | return | endif

  let l:column_width  = 82 + &foldcolumn
        \ + (&number           ? &numberwidth : 0)
        \ + (s:has_sign_cols() ? 2            : 0)

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

  redraw!
  redraw!
endfunction

" }}}1
function! s:has_sign_cols() " {{{1
  return len(split(execute('sign place'), "\n")) > 1
endfunction

" }}}1

let &cpoptions = s:save_cpoptions

" vim: fdm=marker sw=2
