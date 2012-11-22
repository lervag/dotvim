"
" Personal settings for text files
"
" Last Update: 2012-11-22
" Author:      Karl Yngve Lervåg
"

"
" Only load file once
"
if exists('b:did_ft_text') | finish | endif
let b:did_ft_text = 1

"
" Define some settings
"
setlocal fdm=marker
