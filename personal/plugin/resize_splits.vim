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
  let l:width = s:get_target_width()
  if l:width == &columns | return | endif

  if has('gui') || empty($TMUX . $STY)
    let &columns = l:width
  else
    let l:winid = systemlist('xdotool getactivewindow')[0]
    call system(printf('xdotool windowsize --usehints %s %d %d',
          \ l:winid, l:width, &lines+1))
    sleep 50m
  endif

  wincmd =
  redraw!
endfunction

" }}}1
function! s:get_target_width() " {{{1
  let l:column_width  = 80 + &foldcolumn
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
  return l:count*l:column_width
endfunction

" }}}1
function! s:has_sign_cols() " {{{1
  return len(split(execute('sign place'), "\n")) > 1
endfunction

" }}}1

let &cpoptions = s:save_cpoptions

" vim: fdm=marker sw=2
