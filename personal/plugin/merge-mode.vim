command! MergeMode :call s:setup_merge_mode()

function! s:setup_merge_mode() " {{{1
  if !&diff | return | endif

  " Create straightforward mappings
  nnoremap do <nop>
  nnoremap <silent> dp        :diffput 2<cr>
  nnoremap <silent> dol       :diffget 1<cr>
  nnoremap <silent> dor       :diffget 3<cr>
  nnoremap <silent> do1       :diffget 1<cr>
  nnoremap <silent> do3       :diffget 3<cr>
  nnoremap <silent> <leader>q :xa!<cr>

  " Add some more complex mapppings
  " let l:sid = matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\ze.*$')
  " execute 'nnoremap <silent> u :call ' . l:sid . 'undo()<cr>'

  " Set buffer options (local file)
  1wincmd w
  setlocal noswapfile
  setlocal nomodifiable
  nnoremap <buffer> ]] ]c
  nnoremap <buffer> [[ [c
  wincmd H

  " Set buffer options (remote file)
  3wincmd w
  setlocal noswapfile
  setlocal nomodifiable
  nnoremap <buffer> ]] ]c
  nnoremap <buffer> [[ [c
  wincmd L

  " Set buffer options (current)
  2wincmd w
  wincmd J
  nnoremap <buffer> ]] ]c
  nnoremap <buffer> [[ [c
  normal! 100[c
endfunction

" }}}1
function! s:undo() " {{{1
  if winnr() ==# 2
    normal! u
  else
    2wincmd w
    normal! u
    wincmd p
  endif
endfunction

" }}}1
