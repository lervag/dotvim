"
" Personal settings for vimscript files
" Author: Karl Yngve Lervåg
"

if exists('b:did_ft_vim') | finish | endif
let b:did_ft_vim = 1

if exists('ruby_fold') | unlet ruby_fold | endif

set foldmethod=marker
let g:vimsyn_folding = 'f'

"
" Mappings for working with plugins and vimscript files
"
nnoremap <buffer> <leader>xx :Runtime %<cr>
nnoremap <buffer> <leader>xl 0y$:<c-r>"<cr>
xnoremap <buffer> <leader>xx y:execute @"<cr>
nnoremap <buffer> <Leader>xe 0y$:echo <c-r>"<cr>
xnoremap <buffer> <Leader>xe y:execute 'echo '. @"<cr>

