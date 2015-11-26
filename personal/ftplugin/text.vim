"
" Personal settings for text files
" Author: Karl Yngve Lervåg
"

" Only load file once
if exists('b:did_ft_text') | finish | endif
let b:did_ft_text = 1

setlocal fdm=marker
setlocal textwidth=79
setlocal formatoptions=tron1jl
