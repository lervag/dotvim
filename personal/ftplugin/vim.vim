"
" Personal settings for vimscript files
" Author: Karl Yngve Lervåg
"

if exists('b:did_ft_vim') | finish | endif
let b:did_ft_vim = 1

if exists('ruby_fold') | unlet ruby_fold | endif

set foldmethod=marker
let g:vimsyn_folding = 'f'

" Mappings for working with plugins and vimscript files
nnoremap         <buffer> <leader>xx :Runtime %<cr>
xnoremap <silent><buffer> <leader>xx "vy:@v<cr>
