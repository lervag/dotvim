"
" Personal settings for LaTeX files
" Author: Karl Yngve Lervåg
"

" Only load file once
if exists('b:did_ft_latex') | finish | endif
let b:did_ft_latex = 1

let g:Tex_BIBINPUTS = $HOME
setlocal smartindent

inoremap <silent><buffer> <m-i>           \item 
nnoremap <silent><buffer> <localleader>ls :call s:sync_view()<cr>

function! s:sync_view()
  silent execute "silent !okular --unique %:p:r"
        \ . ".pdf\\\#src:" . line(".") . "%:p &"
endfunction
