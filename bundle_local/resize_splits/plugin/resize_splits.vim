if exists('g:loaded_resizesplits') && g:loaded_resizesplits
    finish
endif
let g:loaded_resizesplits = 1
let s:save_cpo = &cpo
set cpo&vim

command! ResizeSplits call s:ResizeSplits()

augroup resize_splits
  autocmd!
  autocmd WinEnter,BufEnter     * let w:count = 1
  autocmd BufHidden,BufWinLeave * let w:count = 0
augroup END

nnoremap <silent> <c-w>r :ResizeSplits<cr>
nnoremap <silent> <c-w>o <c-w>o:ResizeSplits<cr>
nnoremap <silent> <c-w>c <c-w>c:ResizeSplits<cr>
nnoremap <silent> <c-w>v <c-w>v:ResizeSplits<cr>

" {{{1 ResizeSplits
function! s:ResizeSplits()
  let l:curwin = winnr()
  let l:x = getwinposx()
  let l:y = getwinposy()
  let l:colwidth = 82 + &foldcolumn
  if &number
    let l:colwidth += &numberwidth
  endif
  if s:HasSignCols()
    let l:colwidth += 2
  endif

  let l:totheight = 0
  windo   if getwinvar(winnr(), 'count') |
        \   let l:totheight += winheight(winnr()) |
        \ endif
  let l:count = float2nr(ceil(l:totheight / (1.0*&lines)))
  if l:count > 0
    let l:totwidth = l:count - 1 + l:count*l:colwidth
  else
    let l:totwidth = l:colwidth
  endif

  if &columns != l:totwidth
    silent! execute 'set co=' . l:totwidth
    silent! execute 'wincmd ='
    if has('gui_running')
      silent! execute 'winpos ' . l:x . ' ' . l:y
    endif
  endif
  silent! execute l:curwin . 'wincmd w'

  let w:count = 1
endfunction

" {{{1 Utility functions
function! s:HasSignCols()
  let save_more = &more
  set nomore
  redir => lines
  silent execute 'sign place'
  redir END
  let &more = save_more
  return len(split(lines,"\n")) > 1
endfunction

" {{{1 Finish
let &cpo = s:save_cpo
